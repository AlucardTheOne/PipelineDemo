provider "aws" {
  region = var.region
}

resource "aws_instance" "demo" {
  ami           = "ami-02ec57994fa0fae21"
  instance_type = "t3.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.demo_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              docker run -d -p 80:8080 ${var.image}
              EOF

  tags = {
    Name = "jenkins-demo"
  }
}

variable "region" {
  default = "eu-north-1"
}

variable "image" {
  default = "alucardtheone/demo-app"
}
resource "aws_security_group" "demo_sg" {
  name        = "jenkins-demo-sg"
  description = "Allow HTTP from anywhere"

  ingress {
    from_port   = 80
    to_port     = 80
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