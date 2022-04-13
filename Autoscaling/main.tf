terraform {
  backend "s3" {
    bucket = "terraform-storage-11042022"
    key    = "Autoscaling.tfstate"
    region = "us-west-2"
  }
}

data "terraform_remote_state" "Networking" {
  backend = "s3"
  config = {
    bucket = "terraform-storage-11042022"
    key    = "env://${terraform.workspace}/Networking.tfstate"
    region = "us-west-2"
  }
}

resource "aws_launch_configuration" "backend" {
  name_prefix   = "${terraform.workspace}-backend-"
  image_id      = "ami-00ee4df451840fa9d" #Linux CentOS AMI
  key_name      = "PAI"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "backend" {
  vpc_zone_identifier  = data.terraform_remote_state.Networking.outputs.private_subnets
  name                 = "${terraform.workspace}-backend-asg"
  launch_configuration = aws_launch_configuration.backend.name
  min_size             = 1
  max_size             = 2
  load_balancers       = [aws_elb.backend.name]
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                   = "Environment"
    value                 = "${terraform.workspace}-backend-instance"
    propagate_at_launch = true
  }
  tag {
    key                   = "Terraform"
    value                 = "true"
    propagate_at_launch = true
  }
  
}

resource "aws_elb" "backend" {
  name               = "${terraform.workspace}-backend-elb"
  availability_zones = data.terraform_remote_state.Networking.outputs.azs

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    "Terraform" = "true"
    "Environment" = "${terraform.workspace}"
  }
}
