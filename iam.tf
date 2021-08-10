resource "aws_iam_role" "glue_service_role" {
  name               = "${var.project_name}-service-role"
  assume_role_policy = file("${path.module}/policies/glue/glue_trust_relationship.json")
}

resource "aws_iam_role_policy" "glue_bucket_rw_policy" {
  name = "${var.project_name}-bucket-rw-policy"
  role = aws_iam_role.glue_service_role.name
  policy = templatefile("${path.module}/policies/s3/s3_rw.json.tpl", {
    bucket_arn = aws_s3_bucket.glue_bucket.arn
  })
}

resource "aws_iam_role_policy" "glue_cloudwatch_write_policy" {
  name   = "${var.project_name}-cloudwatch-write-policy"
  role   = aws_iam_role.glue_service_role.name
  policy = file("${path.module}/policies/cloudwatch/cloudwatch_write.json")
}

resource "aws_iam_role_policy" "glue_full_access_policy" {
  name   = "${var.project_name}-glue-full-access-policy"
  role   = aws_iam_role.glue_service_role.name
  policy = file("${path.module}/policies/glue/glue_full_access.json")
}
