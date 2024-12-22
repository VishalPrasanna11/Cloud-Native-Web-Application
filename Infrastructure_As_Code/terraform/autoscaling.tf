resource "aws_autoscaling_group" "webapp_asg" {
  name                = "CSYE6225-WebApp-ASG"
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity
  force_delete        = true
  default_cooldown    = 60
  vpc_zone_identifier = [for s in aws_subnet.public_subnet : s.id]

  tag {
    key                 = "Name"
    value               = "WebApp ASG Instance"
    propagate_at_launch = true
  }

  launch_template {
    id      = aws_launch_template.csye6225_asg.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.web_app_target_group.arn]
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "csye6225-asg-scale_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
}



resource "aws_autoscaling_policy" "scale_down" {
  name                   = "csye6225-asg-scale_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
}

# Create CloudWatch Alarms for Scaling Policies
resource "aws_cloudwatch_metric_alarm" "scale_up" {
  alarm_name          = "scale_up_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = var.scaleup_threshold
  alarm_description   = "Alarm when CPU exceeds 10%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_name          = "scale_down_alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = var.scaledown_threshold
  alarm_description   = "Alarm when CPU is below 7%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_down.arn]
}