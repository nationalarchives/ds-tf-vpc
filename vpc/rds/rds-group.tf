
#DB Subnet Group for launching RDS instances
resource "aws_db_subnet_group" "db_subnet_group" {
    name = "db_subnet_group_${var.environment}"

    subnet_ids = [ for entry in var.private_db_subnet_ids : entry ]

    tags = {
        Account     = var.account
        Environment = var.environment
        Name        = "db-subnet-group-${var.environment}"
        Terraform   = "true"
        Owner       = var.owner
        CreatedBy   = var.created_by
    }
}
