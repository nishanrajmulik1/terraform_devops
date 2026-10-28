output "server_public_ip" {
  description = "The public IP of the newly created server"
  value       = aws_instance.my_first_server.*.public_ip
  sensitive   = true
}

output "server_private_ip" {
  description = "The private IP of the newly created server"
  value       = aws_instance.my_first_server.*.private_ip
}

output "server_public_dns" {
  description = "The public DNS of the newly created server"
  value       = aws_instance.my_first_server.*.public_dns
}