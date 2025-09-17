terraform {
  backend "s3" {
    bucket  = "ruby-dev-tfstatefile"
    key     = "state/terraform.tfstate"
    region  = "ca-central-1"
    encrypt = true
    # Optional: Enable state locking with DynamoDB
    # dynamodb_table = "your-dynamodb-lock-table" 
  }
}
