resource "aws_iam_role" "cloudwatch_role_mm" {
  name               = "cloudwatch-role-mm"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_agent_assume_role_policy.json
}

data "aws_iam_policy_document" "cloudwatch_agent_assume_role_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    #   identifiers = [module.eks.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.eks.url}:sub"
      values   = ["system:serviceaccount:amazon-cloudwatch:cloudwatch-agent"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_attach_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.cloudwatch_role_mm.name
}

resource "aws_eks_addon" "cloudwatch_observability" {
  cluster_name             = aws_eks_cluster.eks-cluster-mm.name
  addon_name               = "amazon-cloudwatch-observability"
  service_account_role_arn = aws_iam_role.cloudwatch_role_mm.arn
}


resource "aws_cloudwatch_metric_alarm" "rds_low_memory_alarm_mm" {
  alarm_name          = "RDSLowMemoryAlarmMM"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = 300  # 5 minutes
  statistic           = "Average"
  threshold           = 1073741824  # 1 GB in bytes
  alarm_description   = "Alarm when RDS instance freeable memory is below 1GB (approx. 10% of total memory for many instance types)."
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.rds_alarm_topic.arn]
  ok_actions          = [aws_sns_topic.rds_alarm_topic.arn]
  insufficient_data_actions = []

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.alineDBmm.identifier
  }

  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "rds_connection_alarm_mm" {
  alarm_name          = "RDSConnectionAlarmMM"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 180 #3 minutes
  statistic           = "Sum"
  threshold           = 1  # Trigger when at least one connection is made
  alarm_description   = "Alarm when someone connects to the RDS instance."
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.rds_alarm_topic.arn]
  ok_actions          = [aws_sns_topic.rds_alarm_topic.arn]
  insufficient_data_actions = []

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.alineDBmm.identifier
  }

  treat_missing_data = "notBreaching"
}


resource "aws_sns_topic" "rds_alarm_topic" {
  name = "rds_alarm_topic"
}

resource "aws_sns_topic_subscription" "rds_alarm_topic_subscription" {
  topic_arn = aws_sns_topic.rds_alarm_topic.arn
  protocol  = "email"
  endpoint  = "mehedi.meem@smoothstack.com"
}
