locals {
  bucket_name                = "${var.user_prefix}-${var.project_name}"
  iris_optimized             = "iris_optimized"
  iris_augmented             = "iris_augmented"
  jobs_dir                   = "jobs"
  iris_convert_job_path      = "${local.jobs_dir}/iris_avro_convert.py"
  prefix_cleanup_job_path    = "${local.jobs_dir}/prefix_cleanup.py"
  iris_augmentation_job_path = "${local.jobs_dir}/iris_augmentation.py"
}
