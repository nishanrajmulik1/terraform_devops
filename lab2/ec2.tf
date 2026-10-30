resource "aws_security_group" "dynamic_security_group" {
  name        = "dynamic_allow_ssh_http"
  description = "dynamic_Allow SSH and HTTP inbound traffic"
  vpc_id      = "vpc-054b134a87bfa05d9" #vpc-054b134a87bfa05d9

#inbound traffic - enable 22,80 - outbound traffic - allow all
dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      description = "Allow inbound traffic on port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

#outbound traffic - allow all
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_key_pair" "terraform_key_pair" {
  key_name   = "terraform_key_pair"
  public_key = file("/home/student/.ssh/id_rsa.pub")
}




# 2. Define the Resource
resource "aws_instance" "my_first_server" {
  count           = 2
  ami             = var.ami # Note: This is an Ubuntu AMI for ap-southeast-2. AMIs are region-specific!
  instance_type   = var.instance_type
  key_name        = aws_key_pair.terraform_key_pair.key_name
  security_groups = [aws_security_group.dynamic_security_group.name]
  user_data = file("scripts/install.sh")

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }


# userdata - setup-webserver.sh
  tags = {
    Name = "${local.name_prefix}-${var.instance_name}"
    env  = "non-prod"
  }
}


