# tf-aws-iam-instance-profile

Creates an IAM Instance Profile with selected permissions.

## Terraform version compatibility

| Module version    | Terraform version |
|-------------------|-------------------|
| 4.x.x             | 0.12.x            |
| 3.x.x and earlier | 0.11.x            |

Upgrading from 0.11.x and earlier to 0.12.x should be seamless.  You can simply update the `ref` in your `source` to point to a version greater than `4.0.0`.

When first applied in 0.12.x, some policies may update due to the slight difference in format that occurs when moving from inline JSON to `aws_iam_policy_document`, however the policy permissions granted remain the same.

## Usage

```
module "iam_profile_backend" {
  source = "git::https://gitlab.com/claranet-pcp/terraform/aws/tf-aws-iam-instance-profile.git?ref=v4.0.0"

  name = "${var.envtype}-backend"

  codecommit_gitpull       = "1"
  codecommit_gitpull_repos = ["cool-app", "even-cooler-app"]
  cw_readonly              = "1"
  ec2_attach               = "1"
  ec2_describe             = "1"
  kms_decrypt              = "1"
  kms_decrypt_arns         = [aws_kms_key.puppet.arn]
  kms_encrypt              = "1"
  kms_encrypt_arns         = [aws_kms_key.puppet.arn]
  r53_update               = "1"
  s3_read_buckets          = ["my-bucket-1", "my-bucket-2"]
  s3_readonly              = "1"
  s3_write                 = "1"
  s3_write_buckets         = ["my-writable-bucket", "another-writable-bucket"]
  sqs_allowall             = "1"
}
```

## Variables

The following variables are used for overall control of the module:

| Name      | Description                           | Type   | Default | Required |
|-----------|---------------------------------------|:------:|:-------:|:--------:|
| `name`    | Prefix for the profile and role names | String | _Empty_ | Yes      |
| `enabled` | Whether or not to create resources    | String | `1`     | No       |

The `enabled` flag remains in this module to ease upgrades from 0.11.x to 0.12.x.  For projects using 0.12.x, it may be worth considering using a `count` on the module inclusion instead, which is a feature added in 0.12.x.

The following variables toggle policies on and off.  These can be set to `1` or `0` (or `true` and `false` may also be used).  They all default to `0` and none are explicitly required to be specified when calling the module.  Exact policies set by each variable can be checked in the relevant file.

| Name                             | Permissions granted                                                               | File               |
|----------------------------------|-----------------------------------------------------------------------------------|--------------------|
| `ads_domain_join`                | Join an Active Directory Service domain                                           | `ads.tf`           |
| `autoscaling_describe`           | Describe Auto Scaling resources                                                   | `autoscaling.tf`   |
| `autoscaling_suspend_resume`     | Suspend and resume Auto Scaling processes                                         | `autoscaling.tf`   |
| `autoscaling_terminate_instance` | Terminate an instance in an Auto Scaling group                                    | `autoscaling.tf`   |
| `autoscaling_update`             | Update an Auto Scaling Group's properties                                         | `autoscaling.tf`   |
| `codecommit_gitpull`             | Pull from a CodeCommit repository (requires `codecommit_gitpull_repos`)           | `codecommit.tf`    |
| `codecommit_gitpush`             | Push to a CodeCommit repository (requires `codecommit_gitpush_repos`)             | `codecommit.tf`    |
| `cw_logs_update`                 | Update CloudWatch log streams                                                     | `cloudwatch.tf`    |
| `cw_readonly`                    | Get* and List* permissions for CloudWatch                                         | `cloudwatch.tf`    |
| `cw_update`                      | Put* permissions for CloudWatch                                                   | `cloudwatch.tf`    |
| `ec2_attach`                     | Attach* permissions for EC2 (EBS, ENI, etc)                                       | `ec2.tf`           |
| `ec2_describe`                   | Describe* for all EC2 resources                                                   | `ec2.tf`           |
| `ec2_ebs_attach`                 | Attach EBS volumes to EC2 instances                                               | `ec2.tf`           |
| `ec2_eni_attach`                 | Attach ENIs to EC2 instances                                                      | `ec2.tf`           |
| `ec2_write_tags`                 | Create tags on EC2 resources                                                      | `ec2.tf`           |
| `elasticache_readonly`           | Describe and list tags for ElastiCache resources                                  | `elasticache.tf`   |
| `es_allowall`                    | Full access to AWS ElasticSearch Service                                          | `elasticsearch.tf` |
| `es_write`                       | HTTP DELETE, GET, HEAD, POST and PUT to ElasticSearch domains                     | `elasticsearch.tf` |
| `firehose_streams`               | PutRecord and PutRecordBatch for Firehose (requires `firehose_stream_arns`)       | `firehose.tf`      |
| `kinesis_streams`                | Read/Write access to Kinesis Streams                                              | `kinesis.tf`       |
| `kms_decrypt`                    | Decrypt using given KMS key(s) (requires `kms_decrypt_arns`)                      | `kms.tf`           |
| `kms_encrypt`                    | Encrypt using given KMS key(s) (requires `kms_encrypt_arns`)                      | `kms.tf`           |
| `packer_access`                  | Permissions for Packer builds per https://www.packer.io/docs/builders/amazon.html | `packer.tf`        |
| `r53_update`                     | Get, list and change Route53 record sets                                          | `r53.tf`           |
| `rds_readonly`                   | Describe and list RDS resources                                                   | `rds.tf`           |
| `redshift_read`                  | Read-only access to Redshift resources                                            | `redshift.tf`      |
| `s3_readonly`                    | Read access to given S3 buckets (requires `s3_read_buckets`)                      | `s3.tf`            |
| `s3_write`                       | Write access to given S3 buckets (requires `s3_write_buckets`)                    | `s3.tf`            |
| `s3_writeonly`                   | Write-only (no read) access to given S3 buckets (requires `s3_writeonly_buckets`) | `s3.tf`            |
| `sns_allowall`                   | Full access to SNS                                                                | `sns.tf`           |
| `sqs_allowall`                   | Full access to SQS                                                                | `sqs.tf`           |
| `ssm_get_params`                 | GetParameter for given SSM Parameters (requires `ssm_get_params_names`)           | `ssm.tf`           |
| `ssm_managed`                    | Permissions required for managing an instance in SSM.  See note below.            | `ssm.tf`           |
| `ssm_session_manager`            | Access to SSM Session Manager                                                     | `ssm.tf`           |
| `sts_assumerole`                 | Allow the instance to assume IAM roles listed in sts_assumeroles                  | `sts.tf`           |
| `sts_assumeroles`                | List of IAM role ARNs to allow the instance to assume.                            | `sts.tf`           |
| `transcribe_fullaccess`          | Full access to Transcribe                                                         | `transcribe.tf`    |

Note that for `ssm_managed`, if you want to send output to an S3 bucket you will also need to explicitly allow write access to that bucket using `s3_write` and `s3_write_buckets`.

The following are only required in certain circumstances:

| Name                       | Required when                        | Type            | Description                                                                |
|----------------------------|--------------------------------------|:---------------:|----------------------------------------------------------------------------|
| `codecommit_gitpull_repos` | `codecommit_gitpull` = `1` or `true` | List of Strings | List of CodeCommit Repository names to allow pull access                   |
| `codecommit_gitpush_repos` | `codecommit_gitpush` = `1` or `true` | List of Strings | List of CodeCommit Repository names to allow push access                   |
| `firehose_stream_arns`     | `firehose_streams` = `1` or `true`   | List of Strings | List of Firehose Stream ARNs to allow access to                            |
| `kms_decrypt_arns`         | `kms_decrypt` = `1` or `true`        | String          | Comma-delimited list of KMS Keys to allow decryption with                  |
| `kms_encrypt_arns`         | `kms_encrypt` = `1` or `true`        | String          | Comma-delimited list of KMS Keys to allow encryption with                  |
| `s3_read_buckets`          | `s3_readonly` = `1` or `true`        | List of Strings | List of S3 bucket names (not ARNs) to allow read access to                 |
| `s3_write_buckets`         | `s3_write` = `1` or `true`           | List of Strings | List of S3 bucket names (not ARNs) to allow write access to                |
| `s3_writeonly_buckets`     | `s3_writeonly` = `1` or `true`       | List of Strings | List of S3 bucket names (not ARNs) to allow write-only (no read) access to |
| `ssm_get_params_names`     | `ssm_get_params` = `1` or `true`     | List of Strings | List of SSM Parameter names to allow read access to                        |
| `sts_assumeroles`          | sts_assumerole = `1` or `true`     | List of Strings | List of IAM role ARNs to allow the instance to assume.                        |
