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

output "server_url" {
  description = "The URL of the newly created server"
  value       = "http://${aws_instance.my_first_server[0].public_ip}"
}