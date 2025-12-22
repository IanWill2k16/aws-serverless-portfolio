resource "aws_iam_role" "lambda_exec" {
  name = "${var.name_prefix}-lambda-exec"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "lambda_logs" {
  name = "${var.name_prefix}-lambda-logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "arn:aws:logs:*:*:*"
    }]
  })
}

resource "aws_iam_policy" "lambda_ddb" {
  name = "${var.name_prefix}-lambda-ddb"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["dynamodb:UpdateItem"]
      Resource = var.table_arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_logs.arn
}

resource "aws_iam_role_policy_attachment" "ddb" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_ddb.arn
}

data "archive_file" "visit_lambda" {
  type        = "zip"
  source_file = "${path.module}/../../../app/api/handler.py"
  output_path = "${path.module}/visit_lambda.zip"
}

resource "aws_lambda_function" "visit" {
  function_name = "${var.name_prefix}-visit"
  runtime       = "python3.11"
  handler       = "handler.handler"
  role          = aws_iam_role.lambda_exec.arn

  filename         = data.archive_file.visit_lambda.output_path
  source_code_hash = data.archive_file.visit_lambda.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = var.table_name
    }
  }
}
