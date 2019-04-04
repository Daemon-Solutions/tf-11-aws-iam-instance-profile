# tf-aws-iam-instance-profile

Creating IAM instance profile

## Usage

```
module "iam_profile_jenkins" {
  source = "../modules/tf-aws-iam-instance-profile"

  name = "${var.envtype}_iam_profile_jenkins"

  autoscaling_describe           = "0"
  autoscaling_suspend_resume     = "0"
  autoscaling_terminate_instance = "0"
  autoscaling_update             = "0"
  codecommit_gitpull             = "1"
  codecommit_gitpull_repos       = ["cool-app", "even-cooler-app"]
  cw_readonly                    = "1"
  ec2_attach                     = "1"
  ec2_describe                   = "1"
  ec2_ebs_attach                 = "0"
  ec2_eni_attach                 = "0"
  ec2_write_tags                 = "0"
  ec2_assign_private_ip          = "0"
  ecr_readonly                   = "0"
  ecr_write                      = "0"
  ecr_allowall                   = "0"
  elasticache_readonly           = "0"
  es_allowall                    = "0"
  es_write                       = "0"
  firehose_stream_arns           = []
  firehose_streams               = "0"
  kinesis_streams                = "0"
  kms_decrypt                    = "1"
  kms_decrypt_arns               = "${aws_kms_key.puppet.arn}"
  kms_encrypt                    = "1"
  kms_encrypt_arns               = "${aws_kms_key.puppet.arn}"
  packer_access                  = "0"
  r53_update                     = "1"
  rds_readonly                   = "0"
  redshift_read                  = "0"
  s3_read_buckets                = ["my-bucket-1", "my-bucket-2"]
  s3_readonly                    = "1"
  s3_write                       = "1"
  s3_write_buckets               = ["tmc-nonprod-repo", "tmc-prod-repo"]
  sns_allowall                   = "0"
  sqs_allowall                   = "0"
  sts_assumerole                 = "0"
}
```

## Variables

Most variables are toggle between `0` and `1` and are used to exclude/include permissions in the resulting instance profile.

* `autoscaling_describe`
* `autoscaling_suspend_resume`
* `autoscaling_terminate_instance`
* `autoscaling_update`
* `codecommit_gitpull`
* `codecommit_gitpush`
* `cw_logs_update`
* `cw_readonly`
* `cw_update`
* `ec2_attach`
* `ec2_describe`
* `ec2_ebs_attach`
* `ec2_eni_attach`
* `ec2_write_tags`
* `ecr_readonly`
* `ecr_write`
* `ecr_allowall`
* `elasticache_readonly`
* `es_allowall`
* `es_write`
* `firehose_streams`
* `kinesis_streams`
* `kms_decrypt`
* `kms_encrypt`
* `packer_access`
* `r53_update`
* `rds_readonly`
* `redshift_read`
* `sns_allowall`
* `sqs_allowall`
* `ssm_get_params`
* `ssm_managed` - If you want to send output to s3 bucket you also need to explicitly allow write access to that bucket using `s3_write_buckets`
* `ssmparameter_allowall`
* `ssm_session_manager`
* `sts_assumerole`

With exception of

* `codecommit_gitpull_repos` - List of CodeCommit repositories, requires `codecommit_gitpull = 1`
* `codecommit_gitpush_repos` - List of CodeCommit repositories, requires `codecommit_gitpush = 1`
* `firehose_stream_arns` - List of Firehose Stream ARNs, requires `firehose_streams = 1`
* `kms_decrypt_arns` - KMS keys ARNs, coma-delimited string, requires `kms_decrypt = 1`
* `kms_encrypt_arns` - KMS keys ARNs, coma-delimited string, requires `kms_encrypt = 1`
* `name` - The name of profile
* `s3_read_buckets` - List of S3 buckets names
* `s3_write_buckets` - List of S3 buckets names
* `ssm_get_params_names` - List of SSM parameter names

Special use-case variabes:
* `enabled` - It is set to 1 (Enabled) by default.  To disable the resource, set `enabled = 0`
