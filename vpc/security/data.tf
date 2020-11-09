data "terraform_remote_state" "vpc" {
    backend = "s3"

    config = {
        bucket  = "tna-ds-terraform"
        key     = var.network_key
        region  = "eu-west-2"
        profile = "terraform"
    }
}
