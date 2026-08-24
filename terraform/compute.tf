data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter { name = "name" values = ["al2023-ami-2023*-x86_64"] }
}

resource "aws_iam_role" "app" {
  name = "p31-app-role"
  assume_role_policy = jsonencode({ Version = "2012-10-17", Statement = [{ Effect = "Allow", Principal = { Service = "ec2.amazonaws.com" }, Action = "sts:AssumeRole" }] })
}

resource "aws_iam_instance_profile" "app" { name = "p31-app-profile" role = aws_iam_role.app.name }

resource "aws_launch_template" "app" {
  name_prefix   = "p31-app-"
  image_id      = data.aws_ami.al2023.id
  instance_type = var.app_instance_type
  iam_instance_profile { name = aws_iam_instance_profile.app.name }
  vpc_security_group_ids = [aws_security_group.app.id]
  user_data = base64encode(file("${path.module}/userdata.sh"))
  metadata_options { http_endpoint = "enabled" http_tokens = "required" }
  block_device_mappings { device_name = "/dev/xvda" ebs { encrypted = true volume_size = 20 volume_type = "gp3" delete_on_termination = true } }
}

resource "aws_autoscaling_group" "app" {
  min_size         = var.app_min_size
  max_size         = var.app_max_size
  desired_capacity = var.app_desired_size
  vpc_zone_identifier = aws_subnet.app[*].id
  target_group_arns = [aws_lb_target_group.app.arn]
  health_check_type = "ELB"
  launch_template { id = aws_launch_template.app.id version = "$Latest" }
  tag { key = "Name" value = "p31-app" propagate_at_launch = true }
}
