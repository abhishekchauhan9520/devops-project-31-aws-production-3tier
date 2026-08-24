variable "aws_region" { type = string default = "ap-south-1" }
variable "vpc_cidr" { type = string default = "10.31.0.0/16" }
variable "availability_zones" { type = list(string) default = ["ap-south-1a", "ap-south-1b"] }
variable "public_subnet_cidrs" { type = list(string) default = ["10.31.1.0/24", "10.31.2.0/24"] }
variable "app_subnet_cidrs" { type = list(string) default = ["10.31.11.0/24", "10.31.12.0/24"] }
variable "db_subnet_cidrs" { type = list(string) default = ["10.31.21.0/24", "10.31.22.0/24"] }
variable "app_instance_type" { type = string default = "t3.micro" }
variable "app_min_size" { type = number default = 2 }
variable "app_max_size" { type = number default = 4 }
variable "app_desired_size" { type = number default = 2 }
variable "db_instance_class" { type = string default = "db.t4g.micro" }
variable "db_name" { type = string default = "appdb" }
variable "db_username" { type = string default = "appuser" }
variable "db_password" { type = string sensitive = true validation { condition = length(var.db_password) >= 16 error_message = "db_password must be at least 16 characters." } }
variable "tags" { type = map(string) default = { Project = "devops-project-31-aws-production-3tier", ManagedBy = "terraform" } }
