resource "aws_glue_catalog_database" "glue_demo_db" {
  name = var.project_name
}

resource "aws_glue_crawler" "iris_optimized_crawler" {
  database_name = aws_glue_catalog_database.glue_demo_db.name
  name          = "${local.iris_optimized}-crawler"
  role          = aws_iam_role.glue_service_role.arn

  s3_target {
    path = "s3://${aws_s3_bucket.glue_bucket.bucket}/data/${local.iris_optimized}"
  }
}

resource "aws_glue_crawler" "iris_augmented_crawler" {
  database_name = aws_glue_catalog_database.glue_demo_db.name
  name          = "${local.iris_augmented}-crawler"
  role          = aws_iam_role.glue_service_role.arn

  s3_target {
    path = "s3://${aws_s3_bucket.glue_bucket.bucket}/data/${local.iris_augmented}"
  }
}
