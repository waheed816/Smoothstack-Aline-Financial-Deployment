#create s3 bucket
resource "aws_s3_bucket" "s3_bucket_mm" {

    bucket = "s3-bucket-mm"
    versioning {
      enabled = true
    }

    server_side_encryption_configuration {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm =  "AES256"
        }
      }
    }
}


#create dynamoDB for state locking
resource "aws_dynamodb_table" "terraform_eks_state_lock_mm" {
    name = "terraform_eks_state_lock_mm"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }

}
