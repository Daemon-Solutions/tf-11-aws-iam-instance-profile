# tf-aws-iam-instance-profile

Creates an IAM Instance Profile with selected permissions.
This is a special version for wincheater to support some customizations 

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
| `list_aws_arns`          | Special Exception for Windcheater  Assume Roles List                                                         | ` main.tf`    |

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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.default_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ads_domain_join](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.autoscaling_describe](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.autoscaling_suspend_resume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.autoscaling_terminate_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.autoscaling_update](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.cloudwatch_logs_update](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.cloudwatch_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.cloudwatch_update](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.codecommit_gitpull](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.codecommit_gitpush](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ec2_assign_private_ip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ec2_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ec2_describe](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ec2_ebs_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ec2_eni_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ec2_write_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ecr_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ecs_update](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.elasticache_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.es_allowall](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.es_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.firehose_streams](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.kinesis_streams](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.kms_decrypt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.kms_encrypt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.packer_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.r53_update](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.rds_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.redshift_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.s3_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.s3_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.s3_writeonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.secrets_manager_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.sns_allowall](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.sqs_allowall](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ssm_get_params](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ssm_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ssm_session_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.sts_assumerole](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.transcribe_fullaccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.aws_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ads_domain_join](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.autoscaling_describe](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.autoscaling_suspend_resume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.autoscaling_terminate_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.autoscaling_update](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudwatch_logs_update](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudwatch_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudwatch_update](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.codecommit_gitpull](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.codecommit_gitpush](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.default_role_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ec2_assign_private_ip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ec2_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ec2_describe](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ec2_ebs_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ec2_eni_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ec2_write_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_update](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.elasticache_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.es_allowall](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.es_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.firehose_streams](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kinesis_streams](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_decrypt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_encrypt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.packer_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.r53_update](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.rds_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.readonly_ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.recover_volume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.redshift_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_writeonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.secrets_manager_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sns_allowall](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sqs_allowall](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ssm_get_params](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ssm_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ssm_session_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sts_assumerole](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.transcribe_fullaccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ads_domain_join"></a> [ads\_domain\_join](#input\_ads\_domain\_join) | Bit indicating whether to create a role policy to allow AWS Directory Service Domain Join | `string` | `"0"` | no |
| <a name="input_autoscaling_describe"></a> [autoscaling\_describe](#input\_autoscaling\_describe) | Bit indicating whether to create a role policy to allow the Describe permission on Autoscaling Groups | `string` | `"0"` | no |
| <a name="input_autoscaling_suspend_resume"></a> [autoscaling\_suspend\_resume](#input\_autoscaling\_suspend\_resume) | Bit indicating whether to create a role policy to allow Suspend/Resume on Autoscaling Groups | `string` | `"0"` | no |
| <a name="input_autoscaling_terminate_instance"></a> [autoscaling\_terminate\_instance](#input\_autoscaling\_terminate\_instance) | Bit indicating whether to create a role policy to allow termination of Autoscaled instances | `string` | `"0"` | no |
| <a name="input_autoscaling_update"></a> [autoscaling\_update](#input\_autoscaling\_update) | Bit indicating whether to create a role policy to allow the Update permission on Autoscaling Groups | `string` | `"0"` | no |
| <a name="input_aws_policies"></a> [aws\_policies](#input\_aws\_policies) | A list of AWS policies to attach, e.g. AmazonMachineLearningFullAccess | `list(string)` | `[]` | no |
| <a name="input_codecommit_gitpull"></a> [codecommit\_gitpull](#input\_codecommit\_gitpull) | Bit indicating whether to create a role policy to allow read access to a CodeCommit repository | `string` | `"0"` | no |
| <a name="input_codecommit_gitpull_repos"></a> [codecommit\_gitpull\_repos](#input\_codecommit\_gitpull\_repos) | A list of CodeCommit repositories names to create GitPull role policies on | `list(string)` | `[]` | no |
| <a name="input_codecommit_gitpush"></a> [codecommit\_gitpush](#input\_codecommit\_gitpush) | Bit indicating whether to create a role policy to allow write access to a CodeCommit repository | `string` | `"0"` | no |
| <a name="input_codecommit_gitpush_repos"></a> [codecommit\_gitpush\_repos](#input\_codecommit\_gitpush\_repos) | A list of CodeCommit repositories names to create GitPush role policies on | `list(string)` | `[]` | no |
| <a name="input_cw_logs_update"></a> [cw\_logs\_update](#input\_cw\_logs\_update) | Bit indicating whether to create a role policy to allow log update permissions on a Cloudwatch service | `string` | `"0"` | no |
| <a name="input_cw_readonly"></a> [cw\_readonly](#input\_cw\_readonly) | Bit indicating whether to create a role policy to allow List/Get permissions on a Cloudwatch service | `string` | `"0"` | no |
| <a name="input_cw_update"></a> [cw\_update](#input\_cw\_update) | Bit indicating whether to create a role policy to allow Put permissions on a Cloudwatch service | `string` | `"0"` | no |
| <a name="input_ec2_assign_private_ip"></a> [ec2\_assign\_private\_ip](#input\_ec2\_assign\_private\_ip) | Bit indicating whether to create a role policy to allow the assigning of an additional private IP address | `string` | `"0"` | no |
| <a name="input_ec2_attach"></a> [ec2\_attach](#input\_ec2\_attach) | Bit indicating whether to create a role policy to allow Attach* access to instances | `string` | `"0"` | no |
| <a name="input_ec2_describe"></a> [ec2\_describe](#input\_ec2\_describe) | Bit indicating whether to create a role policy for access to the ec2\_describe API | `string` | `"1"` | no |
| <a name="input_ec2_ebs_attach"></a> [ec2\_ebs\_attach](#input\_ec2\_ebs\_attach) | Bit indicating whether to create a role policy to allow attaching Elastic Block Store volumes to instances, also grants DescribeVolume | `string` | `"0"` | no |
| <a name="input_ec2_eni_attach"></a> [ec2\_eni\_attach](#input\_ec2\_eni\_attach) | Bit indicating whether to create a role policy to allow attaching Elastic Network Interfaces to instances, also grants Describe interfaces and Describe/Modify attributes | `string` | `"0"` | no |
| <a name="input_ec2_write_tags"></a> [ec2\_write\_tags](#input\_ec2\_write\_tags) | Bit indicating whether to create a role policy to allow write of ec2 tags | `string` | `"0"` | no |
| <a name="input_ecr_readonly"></a> [ecr\_readonly](#input\_ecr\_readonly) | Bit indicating whether to create a role policy to allow Listobjects in ECR | `string` | `"0"` | no |
| <a name="input_ecs_update"></a> [ecs\_update](#input\_ecs\_update) | Bit indicating whether to create a role policy for update ECS | `string` | `"0"` | no |
| <a name="input_elasticache_readonly"></a> [elasticache\_readonly](#input\_elasticache\_readonly) | Bit indicating whether to create a role policy to allow read permissions on an ElastiCache service | `string` | `"0"` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Enable or disable the resources. | `string` | `"1"` | no |
| <a name="input_es_allowall"></a> [es\_allowall](#input\_es\_allowall) | Bit indicating whether to create a role policy to allow full access to Elasticsearch | `string` | `"0"` | no |
| <a name="input_es_write"></a> [es\_write](#input\_es\_write) | Bit indicating whether to create a role policy to allow write access to Elasticsearch | `string` | `"0"` | no |
| <a name="input_firehose_stream_arns"></a> [firehose\_stream\_arns](#input\_firehose\_stream\_arns) | List of Firehose Stream ARNs to be allowed | `list(string)` | `[]` | no |
| <a name="input_firehose_streams"></a> [firehose\_streams](#input\_firehose\_streams) | Bit indicating whether to create a role policy to allow sending to Firehose Streams | `string` | `"0"` | no |
| <a name="input_kinesis_streams"></a> [kinesis\_streams](#input\_kinesis\_streams) | Bit indicating whether to create a role policy to allow Get/Put/Describe access to Kinesis Streams | `string` | `"0"` | no |
| <a name="input_kms_decrypt"></a> [kms\_decrypt](#input\_kms\_decrypt) | Bit indicating whether to create a role policy to allow decryption using KMS | `string` | `"0"` | no |
| <a name="input_kms_decrypt_arns"></a> [kms\_decrypt\_arns](#input\_kms\_decrypt\_arns) | Comma seperated list of KMS key ARNs that can be used for decryption | `string` | `""` | no |
| <a name="input_kms_encrypt"></a> [kms\_encrypt](#input\_kms\_encrypt) | Bit indicating whether to create a role policy to allow encryption using KMS | `string` | `"0"` | no |
| <a name="input_kms_encrypt_arns"></a> [kms\_encrypt\_arns](#input\_kms\_encrypt\_arns) | Comma seperated list of KMS key ARNs that can be used for encryption | `string` | `""` | no |
| <a name="input_list_aws_arns"></a> [list\_aws\_arns](#input\_list\_aws\_arns) | A list of Assume AWS type ARNs | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | The name prefix for the IAM role and instance profile | `string` | n/a | yes |
| <a name="input_packer_access"></a> [packer\_access](#input\_packer\_access) | Bit indicating whether to create a role policy to allow access for Hashicorp Packer | `string` | `"0"` | no |
| <a name="input_r53_update"></a> [r53\_update](#input\_r53\_update) | Bit indicating whether to create a role policy to allow update of r53 zones | `string` | `"0"` | no |
| <a name="input_rds_readonly"></a> [rds\_readonly](#input\_rds\_readonly) | Bit indicating whether to create a role policy to allow read access to the a Relational Database Service | `string` | `"0"` | no |
| <a name="input_read_ecr_list"></a> [read\_ecr\_list](#input\_read\_ecr\_list) | A list of ECR resources create read role policies on | `list(string)` | `[]` | no |
| <a name="input_recover_volume"></a> [recover\_volume](#input\_recover\_volume) | Recover Volume from EBS Snapshot and attach or detach volume | `string` | `"0"` | no |
| <a name="input_redshift_read"></a> [redshift\_read](#input\_redshift\_read) | Bit indicating whether to create a role policy to allow read access to Redshift, and assocated ec2/CloudWatch access | `string` | `"0"` | no |
| <a name="input_s3_read_buckets"></a> [s3\_read\_buckets](#input\_s3\_read\_buckets) | A list of s3 buckets to create read role policies on | `list(string)` | `[]` | no |
| <a name="input_s3_readonly"></a> [s3\_readonly](#input\_s3\_readonly) | Bit indicating whether to create a role policy to allow List/Get objects in a bucket | `string` | `"0"` | no |
| <a name="input_s3_readonly_name"></a> [s3\_readonly\_name](#input\_s3\_readonly\_name) | s3 readonly policy name | `string` | `"s3_readonly"` | no |
| <a name="input_s3_write"></a> [s3\_write](#input\_s3\_write) | Bit indicating whether to create a role policy to allow full access to a bucket | `string` | `"0"` | no |
| <a name="input_s3_write_buckets"></a> [s3\_write\_buckets](#input\_s3\_write\_buckets) | A list of s3 buckets to create write role policies on | `list(string)` | `[]` | no |
| <a name="input_s3_write_name"></a> [s3\_write\_name](#input\_s3\_write\_name) | s3 write policy name | `string` | `"s3_write"` | no |
| <a name="input_s3_writeonly"></a> [s3\_writeonly](#input\_s3\_writeonly) | Bit indicating whether to create a role policy to allow write only access to a bucket | `string` | `"0"` | no |
| <a name="input_s3_writeonly_buckets"></a> [s3\_writeonly\_buckets](#input\_s3\_writeonly\_buckets) | A list of s3 buckets to create write only role policies on | `list(string)` | `[]` | no |
| <a name="input_s3_writeonly_name"></a> [s3\_writeonly\_name](#input\_s3\_writeonly\_name) | s3 writeonly policy name | `string` | `"s3_writeonly"` | no |
| <a name="input_secrets_manager_read"></a> [secrets\_manager\_read](#input\_secrets\_manager\_read) | Bit indicating whether to create a role policy for access to the secrets\_manager\_read API | `string` | `"0"` | no |
| <a name="input_secrets_manager_read_list"></a> [secrets\_manager\_read\_list](#input\_secrets\_manager\_read\_list) | A List of Secrets Manager resources | `list(string)` | `[]` | no |
| <a name="input_sns_allowall"></a> [sns\_allowall](#input\_sns\_allowall) | Bit indicating whether to create a role policy to allow full access to SNS | `string` | `"0"` | no |
| <a name="input_sqs_allowall"></a> [sqs\_allowall](#input\_sqs\_allowall) | Bit indicating whether to create a role policy to allow full access to SQS | `string` | `"0"` | no |
| <a name="input_ssm_get_params"></a> [ssm\_get\_params](#input\_ssm\_get\_params) | Bit indicating whether to create a role policy to allow getting SSM parameters | `string` | `"0"` | no |
| <a name="input_ssm_get_params_names"></a> [ssm\_get\_params\_names](#input\_ssm\_get\_params\_names) | List of SSM parameter names to be allowed | `list(string)` | `[]` | no |
| <a name="input_ssm_managed"></a> [ssm\_managed](#input\_ssm\_managed) | Bit indicating whether to create a role policy to allow SSM management | `string` | `"0"` | no |
| <a name="input_ssm_session_manager"></a> [ssm\_session\_manager](#input\_ssm\_session\_manager) | Bit indicating whether to create a role policy to allow SSM Session Manager. Enabling this will also enable SSM management policy. | `string` | `"0"` | no |
| <a name="input_sts_assumerole"></a> [sts\_assumerole](#input\_sts\_assumerole) | Bit indicating whether to create a role policy to allow assume access to the Security Token Service | `string` | `"0"` | no |
| <a name="input_sts_assumeroles"></a> [sts\_assumeroles](#input\_sts\_assumeroles) | List of IAM role ARNs that the instance should be allowed to assume. | `list(string)` | `[]` | no |
| <a name="input_transcribe_fullaccess"></a> [transcribe\_fullaccess](#input\_transcribe\_fullaccess) | Bit indicating whether to create a role policy to allow full access to the Transcribe Service | `string` | `"0"` | no |
| <a name="input_update_ecs_list"></a> [update\_ecs\_list](#input\_update\_ecs\_list) | A List of ECS resources | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_profile_arn"></a> [profile\_arn](#output\_profile\_arn) | n/a |
| <a name="output_profile_id"></a> [profile\_id](#output\_profile\_id) | n/a |
| <a name="output_profile_name"></a> [profile\_name](#output\_profile\_name) | n/a |
| <a name="output_profile_path"></a> [profile\_path](#output\_profile\_path) | n/a |
| <a name="output_profile_role"></a> [profile\_role](#output\_profile\_role) | n/a |
| <a name="output_profile_unique_id"></a> [profile\_unique\_id](#output\_profile\_unique\_id) | n/a |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | n/a |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | n/a |
<!-- END_TF_DOCS -->