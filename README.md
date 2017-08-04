# tf-aws-iam-instance-profile

Creating IAM instance profile

## Usage

```
module "iam_profile_jenkins" {
  source = "../modules/tf-aws-iam-instance-profile"

  name = "${var.envtype}_iam_profile_jenkins"

  ec2_describe                   = "1"
  ec2_attach                     = "1"
  s3_read_buckets                = ["my-bucket-1", "my-bucket-2"]
  rds_readonly                   = "0"
  r53_update                     = "1"
  cw_readonly                    = "1"
  redshift_read                  = "0"
  sqs_allowall                   = "0"
  sns_allowall                   = "0"
  s3_write_buckets               = ["tmc-nonprod-repo", "tmc-prod-repo"]
  kms_decrypt                    = "1"
  kms_decrypt_arns               = "${aws_kms_key.puppet.arn}"
  elasticache_readonly           = "0"
  packer_access                  = "0"
  ec2_ebs_attach                 = "0"
  ec2_eni_attach                 = "0"
  kinesis_streams                = "0"
  es_allowall                    = "0"
  sts_assumerole                 = "0"
  firehose_streams               = "0"
  autoscaling_describe           = "0"
  autoscaling_update             = "0"
  autoscaling_suspend_resume     = "0"
  autoscaling_terminate_instance = "0"
  ec2_write_tags                 = "0"
}
```

## Variables

Most variables are toggle between `0` and `1` and are used to exclude/include permissions in the resulting instance profile.

* `ec2_describe`
* `ec2_attach`
* `rds_readonly`
* `cw_readonly`
* `cw_update`
* `cw_logs_update`
* `r53_update`
* `redshift_read`
* `sns_allowall`
* `sqs_allowall`
* `ssm_managed` - If you want to send output to s3 bucket you also need to explicitly allow write access to that bucket using `s3_write_buckets`
* `ssmparameter_allowall`
* `kms_decrypt`
* `elasticache_readonly`
* `packer_access`
* `ec2_ebs_attach`
* `ec2_eni_attach`
* `kinesis_streams`
* `es_allowall`
* `sts_assumerole`
* `firehose_streams`
* `autoscaling_describe`
* `autoscaling_update`
* `autoscaling_suspend_resume`
* `autoscaling_terminate_instance`
* `ec2_write_tags`

With exception of

* `name` - The name of profile
* `s3_read_buckets` - List of S3 buckets names
* `s3_write_buckets` - List of S3 buckets names
* `kms_decrypt_arns` - KMS keys ARNs, coma-delimited string, requires `kms_decrypt = 1`
