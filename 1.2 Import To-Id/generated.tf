# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "bucket-for-terra-auto"
resource "aws_s3_bucket" "bucket" {
  bucket              = "bucket-for-terra-auto"
  bucket_prefix       = null
  force_destroy       = null
  object_lock_enabled = false
  tags = {
    terra-auto = "test"
  }
  tags_all = {
    terra-auto = "test"
  }
}
