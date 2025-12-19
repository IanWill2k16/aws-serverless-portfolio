variable "domain_name" {
  type        = string
  description = "Custom domain for CloudFront distribution"
}

variable "tags" {
  type    = map(string)
  default = {}
}