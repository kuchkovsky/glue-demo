from awsglue.utils import getResolvedOptions
import sys
import boto3

args = getResolvedOptions(sys.argv, ['bucket_name', 'prefix_name'])

s3 = boto3.resource("s3")
bucket = s3.Bucket(args["bucket_name"])
bucket.objects.filter(Prefix=f"data/{args['prefix_name']}/").delete()
