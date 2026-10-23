
# AWS Key Pair Login
resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("${path.module}/terra-key-ec2.pub")
}

# Default VPC
resource "aws_default_vpc" "default" {}

# Security Group
resource "aws_security_group" "my_security_group" {
  name        = "automate-sg"
  description = "Terraform generated security group"
  vpc_id      = aws_default_vpc.default.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  # Application
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Application port 8000"
  }

  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound traffic"
  }

  tags = {
    Name = "automate-sg"
  }
}

# Create Two EC2 Instances
resource "aws_instance" "my_instance" {
  for_each = tomap({
    first_terraform_automate_micro  = "t3.micro"
    first_terraform_automate_small  = "t3.small"
    first_terraform_automate_medium = "t3.small"
  })

  depends_on = [aws_security_group.my_security_group, aws_key_pair.my_key]

  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  instance_type = each.value
  ami           = var.ec2_ami_id
  user_data     = file("${path.module}/install_Nginx.sh")

  root_block_device {
    volume_size = var.env == "prod" ? 20 : var.ec2_default_root_staorage_size
    volume_type = "gp3"
  }

  tags = {
    Name = each.key
  }
}

resource "aws_instance" "my_new_instance" {
  ami           = "ami-0080f2c6aa4e378b7"
  instance_type = "t3.micro"
}