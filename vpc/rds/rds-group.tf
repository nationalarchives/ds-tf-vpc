
#DB Subnet Group for launching RDS instances
resource "aws_db_subnet_group" "db_subnet_group" {
    name = "db_subnet_group_${var.environment}"

    subnet_ids = var.private_db_subnet_ids

    tags = {
        Account     = var.account
        Environment = var.environment
        Name        = "db-subnet-group-${var.environment}"
        Terraform   = "true"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}
