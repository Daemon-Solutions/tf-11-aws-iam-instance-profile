# tf-aws-iam-instance-profile

Creating IAM instance profile

## Usage

```
module "iam_profile_jenkins" {
  source = "../modules/tf-aws-iam-instance-profile"

  name = "${var.envtype}_iam_profile_jenkins"

  ec2_describe                   = "1"
  ec2_attach                     = "1"
  s3_readonly                    = "1"
  rds_readonly                   = "0"
  r53_update                     = "1"
  cw_readonly                    = "1"
  redshift_read                  = "0"
  sqs_allowall                   = "0"
  sns_allowall                   = "0"
  s3_write_buckets               = "tmc-nonprod-repo,tmc-prod-repo"
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
* `s3_readonly`
* `rds_readonly`
* `cw_readonly`
* `cw_update`
* `r53_update`
* `redshift_read`
* `sns_allowall`
* `sqs_allowall`
* `ssm_managed`
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
* `s3_write_buckets` - S3 buckets names, coma-delimited string
* `kms_decrypt_arns` - KMS keys ARNs, coma-delimited string, requires `kms_decrypt = 1`

