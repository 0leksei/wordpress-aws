##################
# Specify Terraform outputs
##################
output "bastion_ip" {
    value   = aws_eip.bastion.public_ip
}

output "web_ip" {
    value   = aws_eip.web.public_ip
}

output "db_private_ip" {
    value   = aws_instance.db.private_ip
}