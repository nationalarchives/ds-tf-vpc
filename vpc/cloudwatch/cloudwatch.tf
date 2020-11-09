# ------------------------------------------------------------------------------
# cloudwatch and flow logs
# create a Cloudwatch Log Group for VPC flow logs
# ------------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "flow_logs" {
    name = "${var.environment}-vpc-flowlog"

    tags = {
        Account     = var.account
        Environment = var.environment
        Terraform   = "True"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}

# Create an IAM role granting access to flow logs
resource "aws_iam_role" "flow_logs_role" {
    name = "flow-logs-role"

    assume_role_policy = file("${path.module}/flow-logs-role-policy.json")

    tags = {
        Account     = var.account
        Environment = var.environment
        Terraform   = "True"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}

# Assign a policy to the role
resource "aws_iam_role_policy" "flow_logs_policy" {
    name = "${var.environment}-flow-logs-policy"
    role = aws_iam_role.flow_logs_role.id

    policy = file("${path.module}/flow-logs-policy.json")
}
