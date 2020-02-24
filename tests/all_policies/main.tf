# This test creates an IAM profile with all policies attached
# with the exception of chargeable resources, which should be
# tested separately.

resource "random_id" "name" {
  byte_length = 5
  prefix      = "all-policies-test-"
}

module "test_instance_profile" {
  source  = "../../"
  name    = random_id.name.hex
  enabled = true

  ads_domain_join                = true
  autoscaling_describe           = true
  autoscaling_suspend_resume     = true
  autoscaling_terminate_instance = true
  autoscaling_update             = true
  cw_logs_update                 = true
  cw_readonly                    = true
  cw_update                      = true
  ec2_assign_private_ip          = true
  ec2_attach                     = true
  ec2_describe                   = true
  ec2_ebs_attach                 = true
  ec2_eni_attach                 = true
  ec2_write_tags                 = true
  elasticache_readonly           = true
  es_allowall                    = true
  es_write                       = true
  kinesis_streams                = true
  packer_access                  = true
  r53_update                     = true
  rds_readonly                   = true
  redshift_read                  = true
  sqs_allowall                   = true
  sns_allowall                   = true
  ssm_managed                    = true
  ssm_session_manager            = true
  ssmparameter_allowall          = true
  sts_assumerole                 = true
  transcribe_fullaccess          = true

  s3_readonly = true
  s3_read_buckets = [
    aws_s3_bucket.test_bucket_1.bucket,
    aws_s3_bucket.test_bucket_2.bucket,
  ]

  s3_write = true
  s3_write_buckets = [
    aws_s3_bucket.test_bucket_1.bucket,
    aws_s3_bucket.test_bucket_2.bucket,
  ]

  s3_writeonly = true
  s3_writeonly_buckets = [
    aws_s3_bucket.test_bucket_1.bucket,
    aws_s3_bucket.test_bucket_2.bucket,
  ]

  ssm_get_params       = true
  ssm_get_params_names = ["*"]

  aws_policies = [
    "AmazonEC2ReadOnlyAccess",
    "AmazonRDSReadOnlyAccess",
  ]
}

resource "aws_s3_bucket" "test_bucket_1" {
  bucket = "${random_id.name.hex}-bucket-1"
}

resource "aws_s3_bucket" "test_bucket_2" {
  bucket = "${random_id.name.hex}-bucket-2"
}
