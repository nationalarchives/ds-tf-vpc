variable "account" {}
variable "environment" {}
variable "owner" {}
variable "created_by" {}

variable "vpc_id" {}
variable "vpc_cidr" {}

variable "public_cidrs" {}
variable "private_cidrs" {}
variable "private_db_cidrs" {}

variable "public_subnet_ids" {}
variable "private_subnet_ids" {}
variable "private_db_subnet_ids" {}

variable "everyone" {}
variable "intersite_vpc" {}

variable "kew_ssis_server" {}
variable "kew_lobapp_network" {}
variable "kew_developer_network" {}
variable "kew_app_network" {}

variable "priv_to_pub" {}
variable "http_vpc" {}