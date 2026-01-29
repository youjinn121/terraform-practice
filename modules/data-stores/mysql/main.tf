terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws"{
    region = "ap-northeast-2"
}

resource "aws_db_instance" "example" {
 identifier_prefix = "terraform"
 engine = "mysql"
 engine_version = "8.0"
 allocated_storage = 10
 instance_class = "db.t3.micro"
 skip_final_snapshot = true
 db_name = "example_database"

 username = var.db_username
 password = var.db_password

 vpc_security_group_ids = [var.eks_node_sg_id]
 db_subnet_group_name = aws_db_subnet_group.default.name

 provisioner "local-exec" {
    command = "mysql -h${split(":", self.endpoint)[0]} -u${self.username} -p${self.password} ${self.db_name} < create_db_webtest.sql"
    
    environment = {
      MYSQL_PWD = self.password
    }
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "practice-db-subnet-group"
  subnet_ids = var.private_subnet_ids
}

