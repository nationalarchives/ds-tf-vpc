# Create a Cloudwatch Log Group for VPC flow logs
resource "aws_cloudwatch_log_group" "flow_logs" {
    name = "${title(var.environment)}_vpc_flowlog"

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

    assume_role_policy = file("flow-logs-role-policy.json")

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

    policy = file("flow-logs-policy.json")
}
