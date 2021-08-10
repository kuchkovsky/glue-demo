resource "aws_s3_bucket" "glue_bucket" {
  bucket = local.bucket_name
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_object" "input_file" {
  bucket = aws_s3_bucket.glue_bucket.id
  key    = "data/iris_raw/${var.input_file}"
  acl    = "private"
  source = "resources/${var.input_file}"
  etag   = filemd5("resources/${var.input_file}")
}

resource "aws_s3_bucket_object" "prefix_cleanup_job" {
  bucket = aws_s3_bucket.glue_bucket.id
  key    = local.prefix_cleanup_job_path
  acl    = "private"
  source = local.prefix_cleanup_job_path
  etag   = filemd5(local.prefix_cleanup_job_path)
}

resource "aws_s3_bucket_object" "iris_avro_convert_job" {
  bucket = aws_s3_bucket.glue_bucket.id
  key    = local.iris_convert_job_path
  acl    = "private"
  source = local.iris_convert_job_path
  etag   = filemd5(local.iris_convert_job_path)
}

resource "aws_s3_bucket_object" "iris_augmentation_job" {
  bucket = aws_s3_bucket.glue_bucket.id
  key    = local.iris_augmentation_job_path
  acl    = "private"
  source = local.iris_augmentation_job_path
  etag   = filemd5(local.iris_augmentation_job_path)
}
