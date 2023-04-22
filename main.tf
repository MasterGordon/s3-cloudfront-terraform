provider "aws" {
  region = "eu-central-1"
}

variable "bucket_name" {
  description = "Name of S3 bucket"
}

module "file-storage" {
  source      = "git::https://github.com/tomfa/terraform.git//files"
  bucket_name = var.bucket_name
  aws_region  = "eu-central-1"
  acl         = "public-read"
}

module "user" {
  source        = "git::https://github.com/tomfa/terraform.git//user"
  bucket_names  = [var.bucket_name]
  iam_user_name = "${var.bucket_name}-user"
}

output "BUCKET_NAME" {
  value       = module.file-storage.BUCKET_NAME
  description = "Use this to configure CI for automatic deployment"
}
output "AWS_ACCESS_KEY_ID" {
  sensitive   = true
  value       = module.user.AWS_ACCESS_KEY_ID
  description = "Use this key for CI to configure automatic deploys. It will only have access to these new resources."
}
output "AWS_SECRET_ACCESS_KEY" {
  sensitive   = true
  value       = module.user.AWS_SECRET_ACCESS_KEY
  description = "Use secret key for CI to configure automatic deploys."
}
