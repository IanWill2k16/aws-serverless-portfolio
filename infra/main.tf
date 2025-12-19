locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "s3_site" {
  source      = "./modules/s3_site"
  bucket_name = "${local.name_prefix}-site-${data.aws_caller_identity.current.account_id}"
}

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = "${local.name_prefix}-visits"
}

# module "iam" {
#   source      = "./modules/iam"
#   name_prefix = local.name_prefix
# }

module "lambda" {
  source          = "./modules/lambda"
  name_prefix     = local.name_prefix
  table_name  = module.dynamodb.table_name
  table_arn   = module.dynamodb.table_arn
}

# module "api_gateway" {
#   source      = "./modules/api_gateway"
#   name_prefix = local.name_prefix
#   lambda_arn  = module.lambda.arn
# }

module "acm" {
  source      = "./modules/acm"
  domain_name = var.domain_name
}

module "cloudfront" {
  source                = "./modules/cloudfront"
  name_prefix           = local.name_prefix
  domain_name           = var.domain_name
  bucket_name           = module.s3_site.bucket_name
  bucket_arn            = module.s3_site.bucket_arn
  s3_bucket_domain_name = module.s3_site.bucket_domain_name
  acm_certificate_arn   = module.acm.certificate_arn

  depends_on = [
    module.acm
  ]
}
