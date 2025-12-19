variable "domain_name" {
  type        = string
  description = "Custom domain for CloudFront distribution"
}

variable "s3_bucket_domain_name" {
  type        = string
  description = "S3 bucket regional domain name"
}

variable "name_prefix" {
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "acm_certificate_arn" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "bucket_arn" {
  type = string
}