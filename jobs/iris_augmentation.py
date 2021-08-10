from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.utils import getResolvedOptions
from awsglue.dynamicframe import DynamicFrame
import sys

args = getResolvedOptions(sys.argv, ['bucket_name', 'db_name', 'table_name'])

glueContext = GlueContext(SparkContext.getOrCreate())

iris_df = glueContext.create_dynamic_frame.from_catalog(
    database=args["db_name"],
    table_name=args["table_name"]
).toDF()

augmented_iris_df = iris_df.withColumn(
    "sepal_area", iris_df.sepal_width * iris_df.sepal_length
).withColumn(
    "petal_area", iris_df.petal_width * iris_df.petal_length
)

glueContext.write_dynamic_frame.from_options(
    frame=DynamicFrame.fromDF(augmented_iris_df, glueContext, 'iris_augmented').coalesce(1),
    connection_options={"path": f"s3://{args['bucket_name']}/data/iris_augmented"},
    connection_type="s3",
    format="parquet"
)
