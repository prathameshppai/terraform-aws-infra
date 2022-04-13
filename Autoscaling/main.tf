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
  name_prefix   = "backend-"
  image_id      = "ami-00ee4df451840fa9d" #Linux CentOS AMI
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "backend" {
  name                 = "backend-asg"
  launch_configuration = aws_launch_configuration.backend.name
  min_size             = 1
  max_size             = 2
  load_balancers       = aws_elb.backend
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "backend" {
  name               = "backend-elb"
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 8000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
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
    Name = "foobar-terraform-elb"
  }
}
