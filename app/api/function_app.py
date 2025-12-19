import azure.functions as func
from azure.data.tables import TableServiceClient
from azure.core.credentials import AzureNamedKeyCredential
from azure.core.exceptions import ResourceNotFoundError
import json
import os

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

@app.function_name(name="visit")
@app.route(route="visit", methods=["GET"])
def visit(req: func.HttpRequest) -> func.HttpResponse:
    count = increment_counter()
    return func.HttpResponse(
        json.dumps({"count": count}),
        mimetype="application/json"
    )

def get_table_client():
    account = os.environ["COSMOS_ACCOUNT_NAME"]
    table = os.environ["COSMOS_TABLE_NAME"]
    key = os.environ["COSMOS_PRIMARY_KEY"]

    credential = AzureNamedKeyCredential(account, key)

    endpoint = f"https://{account}.table.cosmos.azure.com"
    service = TableServiceClient(endpoint=endpoint, credential=credential)
    return service.get_table_client(table)

def increment_counter():
    table = get_table_client()

    pk = "visits"
    rk = "global"

    try:
        entity = table.get_entity(pk, rk)
        entity["count"] += 1
        table.update_entity(entity)
    except ResourceNotFoundError:
        entity = {
            "PartitionKey": pk,
            "RowKey": rk,
            "count": 1
        }
        table.create_entity(entity)

    return entity["count"]
