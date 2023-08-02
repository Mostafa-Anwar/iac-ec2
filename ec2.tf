
### Get latest Amazon-Linux-2 AMI
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Use the default VPC ID without explicitly declaring aws_vpc resource
data "aws_vpc" "default" {
  default = true
}


### Create SG in the default VPC
resource "aws_security_group" "jenkins_sg" {
  name_prefix = var.security_group
  
  vpc_id = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Custom Port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


### Create and bootstrap a jenkins host in us-east-2
resource "aws_instance" "this" {
  ami                         = data.aws_ami.amazon-linux-2.id
  instance_type               = var.jenkins_instance_type
  key_name                    = var.key_pair
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]

  tags = {
    Name        = var.bastion_name_tag
    Project     = var.project_name_tag
    Environment = var.environment_tag
  }
}

# Output the public IP address of the created EC2 instance
output "public_ip" {
  value = aws_instance.this.public_ip
}