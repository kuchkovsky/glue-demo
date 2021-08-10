resource "aws_glue_workflow" "glue_demo_workflow" {
  name = "${var.project_name}-workflow"
}

resource "aws_glue_trigger" "glue_demo_optimized_prefix_cleanup_job_trigger" {
  name          = "${aws_glue_job.optimized_prefix_cleanup_job.name}-trigger"
  type          = "ON_DEMAND"
  workflow_name = aws_glue_workflow.glue_demo_workflow.name

  actions {
    job_name = aws_glue_job.optimized_prefix_cleanup_job.name
  }
}

resource "aws_glue_trigger" "glue_demo_iris_avro_convert_job_trigger" {
  name          = "${aws_glue_job.iris_avro_convert_job.name}-trigger"
  type          = "CONDITIONAL"
  workflow_name = aws_glue_workflow.glue_demo_workflow.name

  predicate {
    conditions {
      job_name = aws_glue_job.optimized_prefix_cleanup_job.name
      state    = "SUCCEEDED"
    }
  }

  actions {
    job_name = aws_glue_job.iris_avro_convert_job.name
  }
}

resource "aws_glue_trigger" "glue_demo_iris_optimized_crawler_trigger" {
  name          = "${aws_glue_crawler.iris_optimized_crawler.name}-trigger"
  type          = "CONDITIONAL"
  workflow_name = aws_glue_workflow.glue_demo_workflow.name

  predicate {
    conditions {
      job_name = aws_glue_job.iris_avro_convert_job.name
      state    = "SUCCEEDED"
    }
  }

  actions {
    crawler_name = aws_glue_crawler.iris_optimized_crawler.name
  }
}

resource "aws_glue_trigger" "glue_demo_augmented_prefix_cleanup_job_trigger" {
  name          = "${aws_glue_job.augmented_prefix_cleanup_job.name}-trigger"
  type          = "CONDITIONAL"
  workflow_name = aws_glue_workflow.glue_demo_workflow.name

  predicate {
    conditions {
      crawler_name = aws_glue_crawler.iris_optimized_crawler.name
      crawl_state  = "SUCCEEDED"
    }
  }

  actions {
    job_name = aws_glue_job.augmented_prefix_cleanup_job.name
  }
}

resource "aws_glue_trigger" "glue_demo_iris_augmentation_job_trigger" {
  name          = "${aws_glue_job.iris_augmentation_job.name}-trigger"
  type          = "CONDITIONAL"
  workflow_name = aws_glue_workflow.glue_demo_workflow.name

  predicate {
    conditions {
      job_name = aws_glue_job.augmented_prefix_cleanup_job.name
      state    = "SUCCEEDED"
    }
  }

  actions {
    job_name = aws_glue_job.iris_augmentation_job.name
  }
}

resource "aws_glue_trigger" "glue_demo_iris_augmented_crawler_trigger" {
  name          = "${aws_glue_crawler.iris_augmented_crawler.name}-trigger"
  type          = "CONDITIONAL"
  workflow_name = aws_glue_workflow.glue_demo_workflow.name

  predicate {
    conditions {
      job_name = aws_glue_job.iris_augmentation_job.name
      state    = "SUCCEEDED"
    }
  }

  actions {
    crawler_name = aws_glue_crawler.iris_augmented_crawler.name
  }
}
