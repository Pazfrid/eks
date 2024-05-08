# Create a DynamoDB table for state locking
# resource "aws_dynamodb_table" "terraform_locks" {
#   name           = "eks-terraform-locks" # Replace with your desired table name
#   billing_mode   = "PAY_PER_REQUEST"
#   hash_key       = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }

# Create an S3 bucket for storing Terraform state
# resource "aws_s3_bucket" "terraform_state_bucket" {
#   bucket = "eks-terraform-state-bucket-01" # Replace with your desired bucket name

#   # Optional: Enable versioning for the bucket
#   versioning {
#     enabled = true
#   }
# }

# Configure the Terraform backend
terraform {
  backend "s3" {
    bucket         = "eks-terraform-state-bucket-01"
    key            = "terraform.tfstate"
    dynamodb_table = "eks-terraform-locks"
    region = "us-east-1"
    # role_arn     = "arn:aws:iam::161230102637:role/role-eks-jenkins-terrafrom"
  }
}