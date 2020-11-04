# Create a Cloudwatch Log Group for VPC flow logs
resource "aws_cloudwatch_log_group" "flow_logs" {
  name = "${title(var.environment)}_VPC_Flowlog"

  tags = {
    environment = var.environment
    Terraform   = "True"
    Owner       = "auto-modernise"
    CreatedBy   = "steven.hirschorn@nationalarchives.gov.uk"
  }
}

# Create an IAM role granting access to flow logs
resource "aws_iam_role" "flow_logs_role" {
  name = "flow_logs_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    environment = var.environment
    Terraform   = "True"
    Owner       = "auto-modernise"
    CreatedBy   = "steven.hirschorn@nationalarchives.gov.uk"
  }
}

# Assign a policy to the role
resource "aws_iam_role_policy" "flow_logs_policy" {
  name = "${var.environment}_flow_logs_policy"
  role = aws_iam_role.flow_logs_role.id

  policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}