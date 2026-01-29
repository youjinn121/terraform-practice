provider "aws"{
    region = "ap-northeast-2"
}

terraform {
 backend "s3" {
 # Replace this with your bucket name!
 bucket = "dbwls-cjwave"
 key = "stage/data-stores/mysql/terraform.tfstate"
 region = "ap-northeast-2"
 # Replace this with your DynamoDB table name!
 dynamodb_table = "terraform-locks"
 encrypt = true
 }
}

resource "aws_db_instance" "example" {
 identifier_prefix = "terraform"
 engine = "mysql"
 engine_version = "5.7"
 allocated_storage = 10
 instance_class = "db.t3.micro"
 skip_final_snapshot = true
 db_name = "example_database"
 username = var.db_username
 password = var.db_password
}

variable "db_username" {
 description = "The username for the database"
 type = string
 sensitive = true
}

variable "db_password" {
 description = "The password for the database"
 type = string
 sensitive = true
}