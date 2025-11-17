variable "vpc_id" {}
variable "private_subnets" { type = list(string) }
variable "alb_target_group_arn" {}
variable "alb_sg_id" {}
variable "instance_type" {}
variable "scale_up_threshold" {}
variable "scale_down_threshold" {}

