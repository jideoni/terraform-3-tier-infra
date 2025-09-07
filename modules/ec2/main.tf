#app instance
resource "aws_instance" "app" {
  ami           = var.amazon_linux_2023_ami
  instance_type = var.instance_type_web_and_app

  iam_instance_profile   = var.instance_profile
  vpc_security_group_ids = [var.app_security_group_id]
  subnet_id              = var.subnet_app

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = var.key_arn
  }

  user_data = file("${path.module}/userdataapp.sh")

  tags = {
    Name        = "${var.app_tier}-template-update"
    Environment = var.infra_env
  }
}

#web instance
resource "aws_instance" "web" {
  ami           = var.amazon_linux_2023_ami
  instance_type = var.instance_type_web_and_app

  iam_instance_profile   = var.instance_profile
  vpc_security_group_ids = [var.web_security_group_id]
  subnet_id              = var.subnet_web

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = var.key_arn
  }

  user_data = file("${path.module}/userdataweb.sh")

  tags = {
    Name        = "${var.web_tier}-template-update"
    Environment = var.infra_env
  }
}

#app ami
resource "aws_ami_from_instance" "app_instance_ami" {
  name               = "${var.infra_env}-app AMI"
  source_instance_id = aws_instance.app.id

  tags = {
    Name        = "${var.infra_env}-app AMI"
    Environment = var.infra_env
  }
}

#web ami
resource "aws_ami_from_instance" "web_instance_ami" {
  name               = "${var.infra_env}-web AMI"
  source_instance_id = aws_instance.web.id

  tags = {
    Name        = "${var.infra_env}-web AMI"
    Environment = var.infra_env
  }
}

#app launch template
resource "aws_launch_template" "app_template" {
  name = var.app_template_name

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_options {
    core_count       = 1
    threads_per_core = 2
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = true
  disable_api_termination = true

  ebs_optimized = true

  iam_instance_profile {
    name = var.instance_profile
  }

  image_id = aws_ami_from_instance.app_instance_ami.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = var.instance_type_web_and_app

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [var.app_security_group_id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.infra_env}-${var.app_tier}"
      Environment = var.infra_env
    }
  }
  user_data = filebase64("${path.module}/userdataapp.sh")
}

#web launch template
resource "aws_launch_template" "web_template" {
  name = var.web_template_name

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_options {
    core_count       = 1
    threads_per_core = 2
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = true
  disable_api_termination = true

  ebs_optimized = true

  iam_instance_profile {
    name = var.instance_profile
  }

  image_id = aws_ami_from_instance.web_instance_ami.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = var.instance_type_web_and_app

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [var.web_security_group_id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.infra_env}-${var.web_tier}"
      Environment = var.infra_env
    }
  }
  user_data = filebase64("${path.module}/userdataweb.sh")
}

#App Target group
resource "aws_lb_target_group" "app_instance_tg" {
  name        = "app-tg"
  port        = 4000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

  tags = {
    Name        = "${var.infra_env}-app-tg"
    Environment = var.infra_env
  }
}

#Web Target group
resource "aws_lb_target_group" "web_instance_tg" {
  name        = "web-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

  tags = {
    Name        = "${var.infra_env}-app-tg"
    Environment = var.infra_env
  }
}

#app alb
resource "aws_lb" "internal_lb" {
  name                       = "alb-internal"
  internal                   = true
  load_balancer_type         = "application"
  drop_invalid_header_fields = true

  security_groups = [var.int_lb_security_group_id]
  subnets         = toset(var.all_app_subnets)

  enable_deletion_protection = false

  tags = {
    Name        = "${var.infra_env}-internal-alb"
    Environment = var.infra_env
  }
}

#web alb
resource "aws_lb" "external_lb" {
  name = "alb-external"
  #tfsec:ignore:aws-elb-alb-not-public
  internal                   = false #internet facing
  load_balancer_type         = "application"
  drop_invalid_header_fields = true

  security_groups = [var.ext_lb_security_group_id]
  subnets         = toset(var.all_web_subnets)

  enable_deletion_protection = false

  tags = {
    Name        = "${var.infra_env}-external-alb"
    Environment = var.infra_env
  }
}

#app tg attachment
resource "aws_lb_target_group_attachment" "int_lb_target_group_attachment" {
  target_group_arn = aws_lb_target_group.app_instance_tg.arn

  target_id = aws_instance.app.id
  port      = 4000
}

#web tg attachment
resource "aws_lb_target_group_attachment" "ext_lb_target_group_attachment" {
  target_group_arn = aws_lb_target_group.web_instance_tg.arn

  target_id = aws_instance.web.id
  port      = 80
}

#app alb listener
#tfsec:ignore:AWS004
resource "aws_lb_listener" "internal_lb_listener" {
  load_balancer_arn = aws_lb.internal_lb.arn
  port              = "4000"
  protocol          = "HTTP"
  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.app_instance_tg.arn
        weight = 100
      }
    }
  }
}

#web alb listener
#tfsec:ignore:AWS004
resource "aws_lb_listener" "external_lb_listener" {
  load_balancer_arn = aws_lb.external_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.web_instance_tg.arn
        weight = 100
      }
    }
  }
}

#app Auto Scaling group
resource "aws_autoscaling_group" "app_asg" {
  vpc_zone_identifier       = var.all_app_subnets
  name                      = "${var.app_tier}-${var.infra_env}-asg"
  health_check_grace_period = 300
  desired_capacity          = var.desired_number
  max_size                  = var.max_number
  min_size                  = var.min_number

  target_group_arns = [aws_lb_target_group.app_instance_tg.arn]

  launch_template {
    id      = aws_launch_template.app_template.id
    version = "$Latest"
  }
}

#web Auto Scaling group
resource "aws_autoscaling_group" "web_asg" {
  vpc_zone_identifier       = var.all_web_subnets
  name                      = "${var.web_tier}-${var.infra_env}-asg"
  health_check_grace_period = 300
  desired_capacity          = var.desired_number
  max_size                  = var.max_number
  min_size                  = var.min_number

  target_group_arns = [aws_lb_target_group.web_instance_tg.arn]

  launch_template {
    id      = aws_launch_template.web_template.id
    version = "$Latest"
  }
}

#app auto scaling policy
resource "aws_autoscaling_policy" "app_asg_scaling_policy" {
  autoscaling_group_name    = aws_autoscaling_group.app_asg.name
  name                      = "${var.app_tier}-asg-policy"
  policy_type               = var.target_tracking_policy
  estimated_instance_warmup = 30

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}

#web auto scaling policy
resource "aws_autoscaling_policy" "web_asg_scaling_policy" {
  autoscaling_group_name    = aws_autoscaling_group.web_asg.name
  name                      = "${var.web_tier}-asg-policy"
  policy_type               = var.target_tracking_policy
  estimated_instance_warmup = 30

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}

#app autoscaling notification
resource "aws_autoscaling_notification" "app_asg_notifications" {
  group_names = [
    aws_autoscaling_group.app_asg.name
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
  topic_arn = var.app_topic_arn
}

#web autoscaling notification
resource "aws_autoscaling_notification" "web_asg_notifications" {
  group_names = [
    aws_autoscaling_group.web_asg.name
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
  topic_arn = var.web_topic_arn
}
