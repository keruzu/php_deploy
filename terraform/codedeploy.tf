

resource "aws_codedeploy_app" "demo-app" {
  name = "demo-app"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "demo" {
  app_name           = aws_codedeploy_app.demo-app.name
  deployment_group_name = "demo-deployment-group"
  service_role_arn    = aws_iam_role.codedeploy-role.arn

  ec2_tag_set {
    ec2_tag_filter {
      type  = "KEY_AND_VALUE"
      key   = "Name"
      value = "app"
    }
  }

  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type = "IN_PLACE"
  }

  alarm_configuration {
    enabled = false
  }

  auto_rollback_configuration {
    enabled = false
  }
}
