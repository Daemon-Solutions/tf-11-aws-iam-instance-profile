variable "name" { }
variable "ec2_describe" { default = "1" }
variable "ec2_attach" { default = "0" }
variable "s3_readonly" { default = "1" }
variable "rds_readonly" { default = "0" }
variable "cw_readonly" { default = "0" }
variable "cw_update" { default = "0" }
variable "r53_update" { default = "0" }
