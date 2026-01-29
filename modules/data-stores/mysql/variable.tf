variable "db_username" {
    type = string
    sensitive = true
}
variable "db_password" {
    type = string
    sensitive =  true
}
variable "vpc_security_group_id" {
    type = string 
}
variable "private_subnet_ids" {
    type = list(string) 
}
variable "eks_node_sg_id"{
    type = string
}