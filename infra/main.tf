locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "s3_site" {
  source      = "./modules/s3_site"
  name_prefix = local.name_prefix
}

module "dynamodb" {
  source      = "./modules/dynamodb"
  name_prefix = local.name_prefix
}

module "iam" {
  source      = "./modules/iam"
  name_prefix = local.name_prefix
}

module "lambda" {
  source          = "./modules/lambda"
  name_prefix     = local.name_prefix
  role_arn        = module.iam.lambda_role_arn
  dynamodb_table  = module.dynamodb.table_name
}

module "api_gateway" {
  source      = "./modules/api_gateway"
  name_prefix = local.name_prefix
  lambda_arn  = module.lambda.arn
}

module "cloudfront" {
  source          = "./modules/cloudfront"
  name_prefix     = local.name_prefix
  domain_name     = var.domain_name
  s3_bucket_name  = module.s3_site.bucket_name
  api_domain_name = module.api_gateway.invoke_url
}

module "github_oidc" {
  source      = "./modules/github_oidc"
  github_org  = "IanWill2k16"
  github_repo = "aws-serverless-portfolio"
}
