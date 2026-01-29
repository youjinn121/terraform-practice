output "db_address" {
  value       = module.mysql.address
  description = "The address of the database"
}
output "db_security_group_id" {
  value       = aws_security_group.db_sg.id
  description = "The ID of the DB security group"
}