variable "name" {
  description = "The name prefix for the IAM role and instance profile"
  type        = "string"
}

/* EC2 Role Policies */
variable "ec2_describe" {
  description = "Bit indicating whether to create a role policy for access to the ec2_describe API"
  type        = "string"
  default     = "1"
}

variable "ec2_attach" {
  description = "Bit indicating whether to create a role policy to allow Attach* access to instances"
  type        = "string"
  default     = "0"
}

variable "ec2_ebs_attach" {
  description = "Bit indicating whether to create a role policy to allow attaching Elastic Block Store volumes to instances, also grants DescribeVolume"
  type        = "string"
  default     = "0"
}

variable "ec2_eni_attach" {
  description = "Bit indicating whether to create a role policy to allow attaching Elastic Network Interfaces to instances, also grants Describe interfaces and Describe/Modify attributes"
  type        = "string"
  default     = "0"
}

variable "autoscaling_describe" {
  description = "Bit indicating whether to create a role policy to allow the Describe permission on Autoscaling Groups"
  type        = "string"
  default     = "0"
}

variable "autoscaling_update" {
  description = "Bit indicating whether to create a role policy to allow the Update permission on Autoscaling Groups"
  type        = "string"
  default     = "0"
}

variable "autoscaling_suspend_resume" {
  description = "Bit indicating whether to create a role policy to allow Suspend/Resume on Autoscaling Groups"
  type        = "string"
  default     = "0"
}

variable "autoscaling_terminate_instance" {
  description = "Bit indicating whether to create a role policy to allow termination of Autoscaled instances"
  type        = "string"
  default     = "0"
}

variable "ec2_write_tags" {
  description = "Bit indicating whether to create a role policy to allow write of ec2 tags"
  type        = "string"
  default     = "0"
}

/* S3 Role Policies */
variable "s3_readonly" {
  description = "Bit indicating whether to create a role policy to allow List/Get objects in a bucket"
  type        = "string"
  default     = "0"
}

variable "s3_read_buckets" {
  description = "A list of s3 buckets to create read role policies on"
  type        = "list"
  default     = []
}

variable "s3_write" {
  description = "Bit indicating whether to create a role policy to allow full access to a bucket"
  type        = "string"
  default     = "0"
}

variable "s3_write_buckets" {
  description = "A list of s3 buckets to create write role policies on"
  type        = "list"
  default     = []
}

/* CloudWatch policies */
variable "cw_readonly" {
  description = "Bit indicating whether to create a role policy to allow List/Get permissions on a Cloudwatch service"
  type        = "string"
  default     = "0"
}

variable "cw_update" {
  description = "Bit indicating whether to create a role policy to allow Put permissions on a Cloudwatch service"
  type        = "string"
  default     = "0"
}

variable "cw_logs_update" {
  description = "Bit indicating whether to create a role policy to allow log update permissions on a Cloudwatch service"
  type        = "string"
  default     = "0"
}

/* Route 53 policies */
variable "r53_update" {
  description = "Bit indicating whether to create a role policy to allow update of r53 zones"
  type        = "string"
  default     = "0"
}

/* Key Management Service policies */
variable "kms_decrypt" {
  description = "Bit indicating whether to create a role policy to allow decryption using KMS"
  type        = "string"
  default     = "0"
}

variable "kms_decrypt_arns" {
  description = "Comma seperated list of KMS key ARNs that can be used for decryption"
  type        = "string"
  default     = ""
}

variable "kms_encrypt" {
  description = "Bit indicating whether to create a role policy to allow encryption using KMS"
  type        = "string"
  default     = "0"
}

variable "kms_encrypt_arns" {
  description = "Comma seperated list of KMS key ARNs that can be used for encryption"
  type        = "string"
  default     = ""
}

/* Kinesis/Firehose policies */
variable "kinesis_streams" {
  description = "Bit indicating whether to create a role policy to allow Get/Put/Describe access to Kinesis Streams"
  type        = "string"
  default     = "0"
}

variable "firehose_streams" {
  description = "Bit indicating whether to create a role policy to allow sending to Firehose Streams"
  type        = "string"
  default     = "0"
}

variable "firehose_stream_arns" {
  description = "List of Firehose Stream ARNs to be allowed"
  type        = "list"
  default     = []
}

/* System Manager policies */
variable "ssm_get_params" {
  description = "Bit indicating whether to create a role policy to allow getting SSM parameters"
  type        = "string"
  default     = "0"
}

variable "ssm_get_params_names" {
  description = "List of SSM parameter names to be allowed"
  type        = "list"
  default     = []
}

variable "ssm_managed" {
  description = "Bit indicating whether to create a role policy to allow SSM management"
  type        = "string"
  default     = "0"
}

variable "ssmparameter_allowall" {
  description = "Bit indicating whether to create a role policy to allow SSM parameter management"
  type        = "string"
  default     = "0"
}

/* Redshift policies */
variable "redshift_read" {
  description = "Bit indicating whether to create a role policy to allow read access to Redshift, and assocated ec2/CloudWatch access"
  type        = "string"
  default     = "0"
}

/* Simple Notification Service policies */
variable "sns_allowall" {
  description = "Bit indicating whether to create a role policy to allow full access to SNS"
  type        = "string"
  default     = "0"
}

/* Simple Queue Service policies */
variable "sqs_allowall" {
  description = "Bit indicating whether to create a role policy to allow full access to SQS"
  type        = "string"
  default     = "0"
}

/* ElastiCache Service policies */
variable "elasticache_readonly" {
  description = "Bit indicating whether to create a role policy to allow read permissions on an ElastiCache service"
  type        = "string"
  default     = "0"
}

/* Hashicorp Packer policies */
variable "packer_access" {
  description = "Bit indicating whether to create a role policy to allow access for Hashicorp Packer"
  type        = "string"
  default     = "0"
}

/* Elasticsearch policies */
variable "es_allowall" {
  description = "Bit indicating whether to create a role policy to allow full access to Elasticsearch"
  type        = "string"
  default     = "0"
}

variable "es_write" {
  description = "Bit indicating whether to create a role policy to allow write access to Elasticsearch"
  type        = "string"
  default     = "0"
}

/* Security Token Service policies */
variable "sts_assumerole" {
  description = "Bit indicating whether to create a role policy to allow assume access to the Security Token Service"
  type        = "string"
  default     = "0"
}

/* Relational Database Service policies */
variable "rds_readonly" {
  description = "Bit indicating whether to create a role policy to allow read access to the a Relational Database Service"
  type        = "string"
  default     = "0"
}

/* Provides full access to the Transcribe service */
variable "transcribe_fullaccess" {
  description = "Bit indicating whether to create a role policy to allow full access to the Transcribe Service"
  type        = "string"
  default     = "0"
}

variable "aws_policies" {
  description = "A list of AWS policies to attach, e.g. AmazonMachineLearningFullAccess"
  type        = "list"
  default     = []
}
