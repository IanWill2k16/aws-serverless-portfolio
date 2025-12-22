output "site_bucket_name" {
  value = module.s3_site.bucket_name
}

output "cloudfront_distribution_id" {
  value = module.cloudfront.distribution_id
}

output "api_url" {
  value = module.api_gateway.api_url
}