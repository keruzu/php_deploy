data "aws_iam_policy_document" "codedeploy-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com", "ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ssm-agent-policy" {
  statement {
    effect = "Allow"
    actions = ["s3:Get*", "s3:List*"]

    resources = ["*"]
  }
}


resource "aws_iam_role" "codedeploy-role" {
  name               = "codedeploy-role"
  assume_role_policy = data.aws_iam_policy_document.codedeploy-assume-role.json

  inline_policy {
    name   = "localpolicies"
    policy = data.aws_iam_policy_document.ssm-agent-policy.json
  }
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.codedeploy-role.name
}
