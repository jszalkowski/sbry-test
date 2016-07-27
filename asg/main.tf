resource "aws_autoscaling_group" "app" {
  vpc_zone_identifier = ["${var.private_subnets_id}"]
  name = "${var.project}-${var.environment}-${var.lc_name}"
  max_size = "${var.amax}"
  min_size = "${var.amin}"
  force_delete = true
  launch_configuration = "${var.lc_name}"
  desired_capacity = "${var.adesired}"
tag {
    key = "Name"
    value= "${var.project}-${var.environment}"
    propagate_at_launch = "true"
}
tag {
key = "Project"
    value = "${var.project}"
    propagate_at_launch = "true"
}
tag {
key = "Environment"
    value = "${var.environment}"
    propagate_at_launch = "true"
}
tag {
	key =    "Owner" 
    value = "${var.owner}"
    propagate_at_launch = "true"
}
tag {
    key = "CostCentre"
    value = "${var.costcentre}"
    propagate_at_launch = "true"
  }
tag {
    key = "role"
    value = "${var.role_app}"
    propagate_at_launch = "true"
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name = "${var.project}-${var.environment}-scale_up"
  scaling_adjustment = 2
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.app.name}"
}


resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name = "${var.project}-${var.environment}-high-asg-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "80"
  insufficient_data_actions = []
  dimensions {
      AutoScalingGroupName = "${aws_autoscaling_group.app.name}"
  }
  alarm_description = "EC2 CPU Utilization"
  alarm_actions = ["${aws_autoscaling_policy.scale_up.arn}"]
}

resource "aws_autoscaling_policy" "scale_down" {
  name = "${var.project}-${var.environment}-scale_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 600
  autoscaling_group_name = "${aws_autoscaling_group.app.name}"
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name = "${var.project}-${var.environment}-low-asg-cpu"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "5"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "30"
  insufficient_data_actions = []
  dimensions {
      AutoScalingGroupName = "${aws_autoscaling_group.app.name}"
  }
  alarm_description = "EC2 CPU Utilization"
  alarm_actions = ["${aws_autoscaling_policy.scale_down.arn}"]
}

