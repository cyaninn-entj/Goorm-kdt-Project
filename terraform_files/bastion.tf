module "bastion1" {
  source = "Guimove/bastion/aws"
  bucket_name = "bastion-lkj-${random_string.suffix.result}" 
  region = var.aws_region 
  vpc_id = aws_vpc.prod-vpc.id 
  is_lb_private = false # If TRUE the load balancer scheme will be "internal" else "internet-facing"
  bastion_host_key_pair = ""
  create_dns_record = false # Choose if you want to create a record name for the bastion (LB). If true 'hosted_zone_id' and 'bastion_record_name' are mandatory
#   hosted_zone_id = ""
#   bastion_record_name = "bastion.my.hosted.zone.name."
  bastion_iam_policy_name = "myBastionHostPolicy"
  elb_subnets = [
    aws_subnet.prod-subnet-public1.id,
    aws_subnet.prod-subnet-public2.id
  ]
  auto_scaling_group_subnets = [
    aws_subnet.prod-subnet-public1.id,
    aws_subnet.prod-subnet-public2.id
  ]
  tags = {
    "name" = "my_bastion_name1",
    "description" = "my_bastion_description"
  }
}

resource "random_string" "suffix" {
  length  = 8
  upper = false
  special = false
}
