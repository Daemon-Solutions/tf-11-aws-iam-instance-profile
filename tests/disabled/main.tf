# This test should not create any resources as the enabled flag is set to false.

module "test_instance_profile" {
  source  = "../../"
  name    = "disabled-profile"
  enabled = false

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

  ssm_get_params       = true
  ssm_get_params_names = ["*"]

  aws_policies = [
    "AmazonEC2ReadOnlyAccess",
    "AmazonRDSReadOnlyAccess",
  ]
}
