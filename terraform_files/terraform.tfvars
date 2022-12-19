# ------------------------------------------------------------
# Networking Settings
# ------------------------------------------------------------
aws_region = "ap-northeast-1"
vpc_cidr_block = "10.0.0.0/16"
prod1_subnet_az = "ap-northeast-1a"
prod1_subnet_cidr_block = "10.0.128.0/20"
prod1_public_subnet_cidr_block= "10.0.0.0/20"
prod1_db_subnet_cidr_block= "10.0.160.0/20"
prod2_subnet_az = "ap-northeast-1c"
prod2_subnet_cidr_block = "10.0.144.0/20"
prod2_public_subnet_cidr_block= "10.0.16.0/20"
prod2_db_subnet_cidr_block= "10.0.176.0/20"
# ------------------------------------------------------------
# EKS Cluster Settings
# ------------------------------------------------------------
cluster_name = "prod-cluster"
cluster_version = "1.22"
worker_group_name = "prod-worker-group-1"
worker_group_instance_type = [ "t3.medium" ]
autoscaling_group_min_size = 1
autoscaling_group_max_size = 4
autoscaling_group_desired_capacity = 1
# ------------------------------------------------------------
# Jenkins Settings
# ------------------------------------------------------------
jenkins_admin_user = "admin"
jenkins_admin_password = "test"