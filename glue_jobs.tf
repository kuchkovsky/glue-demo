resource "aws_glue_job" "optimized_prefix_cleanup_job" {
  name         = "${var.project_name}-optimized-prefix-cleanup-job"
  role_arn     = aws_iam_role.glue_service_role.arn
  glue_version = "1.0"
  max_capacity = 0.0625

  command {
    script_location = "s3://${aws_s3_bucket.glue_bucket.bucket}/${local.prefix_cleanup_job_path}"
    name            = "pythonshell"
    python_version  = 3
  }

  default_arguments = {
    "--bucket_name" = local.bucket_name,
    "--prefix_name" = local.iris_optimized
  }
}

resource "aws_glue_job" "iris_avro_convert_job" {
  name         = "${var.project_name}-iris-avro-convert-job"
  role_arn     = aws_iam_role.glue_service_role.arn
  glue_version = "1.0"

  command {
    script_location = "s3://${aws_s3_bucket.glue_bucket.bucket}/${local.iris_convert_job_path}"
    python_version  = 3
  }

  default_arguments = {
    "--bucket_name" = local.bucket_name
  }
}

resource "aws_glue_job" "augmented_prefix_cleanup_job" {
  name         = "${var.project_name}-augmented-prefix-cleanup-job"
  role_arn     = aws_iam_role.glue_service_role.arn
  glue_version = "1.0"
  max_capacity = 0.0625

  command {
    script_location = "s3://${aws_s3_bucket.glue_bucket.bucket}/${local.prefix_cleanup_job_path}"
    name            = "pythonshell"
    python_version  = 3
  }

  default_arguments = {
    "--bucket_name" = local.bucket_name,
    "--prefix_name" = local.iris_augmented
  }
}

resource "aws_glue_job" "iris_augmentation_job" {
  name         = "${var.project_name}-iris-augmentation-job"
  role_arn     = aws_iam_role.glue_service_role.arn
  glue_version = "1.0"

  command {
    script_location = "s3://${aws_s3_bucket.glue_bucket.bucket}/${local.iris_augmentation_job_path}"
    python_version  = 3
  }

  default_arguments = {
    "--bucket_name" = local.bucket_name,
    "--db_name"     = var.project_name,
    "--table_name"  = local.iris_optimized
  }
}
