terraform {
  backend "s3" {
    bucket       = "cloudportfolio-tfstate"
    key          = "terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true
    encrypt      = true
  }
}
