from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.utils import getResolvedOptions
import sys

args = getResolvedOptions(sys.argv, ['bucket_name'])

glueContext = GlueContext(SparkContext.getOrCreate())

iris_dyf = glueContext.create_dynamic_frame.from_options(
    connection_type="s3",
    connection_options={"paths": [f"s3://{args['bucket_name']}/data/iris_raw"]},
    format="csv",
    format_options={"withHeader": True}
)

glueContext.write_dynamic_frame.from_options(
    frame=iris_dyf,
    connection_options={"path": f"s3://{args['bucket_name']}/data/iris_optimized"},
    connection_type="s3",
    format="avro"
)
