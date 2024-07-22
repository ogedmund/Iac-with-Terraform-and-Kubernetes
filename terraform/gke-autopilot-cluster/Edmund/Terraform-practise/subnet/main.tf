resource "aws_subnet" "private" {
   vpc_id = data.terraform_remote_state.vpc.output
   cidr_block = var.cidr_block

   tags = {
     "Name" ="${var.env}-private"                   #"dev-private"
   }
}


data "terraform_remote_state" "vpc" {           #link folderto vpc
    backend = "local"
    config = {
      path = "../vpc/terraform.tfstate"
    }
}

