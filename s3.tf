resource "aws_s3_bucket" "mySourceBucket" {
  bucket = "my-source-bucket-76sdf700"
}

resource "aws_s3_bucket_ownership_controls" "bucketOwnerControls" {
  bucket = aws_s3_bucket.mySourceBucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "accessBlock" {
  bucket = aws_s3_bucket.mySourceBucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

}

resource "aws_s3_bucket_acl" "bucketAcl" {
  bucket = aws_s3_bucket.mySourceBucket.id
  acl    = "public-read"
  depends_on = [
    aws_s3_bucket_ownership_controls.bucketOwnerControls,
    aws_s3_bucket_public_access_block.accessBlock
  ]
}

resource "aws_s3_bucket_versioning" "bucketVersioning" {
  bucket = aws_s3_bucket.mySourceBucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "file_upload" {
  bucket = aws_s3_bucket.mySourceBucket.id
  key    = "mywebapp.zip"
  source = "${path.module}/mywebapp_1.0/mywebapp.zip"
}