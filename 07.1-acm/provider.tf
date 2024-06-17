terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.48.0"
        }
    }

    backend "s3" {
        bucket = "my-s3-for-tfstate-lock"
        key = "expense-dev-acm"        # This will the name of the tfstate file in S3 bucket.
        region = "us-east-1"
        dynamodb_table = "TFSTATE_LOCK"

    }
}

# Provide authentication here.
provider "aws" {
    region = "us-east-1"
}