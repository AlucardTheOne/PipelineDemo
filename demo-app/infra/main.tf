provider "aws" {
  region = var.region
}

resource "aws_instance" "demo" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

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
  default = "us-east-1"
}

variable "image" {
  default = "yourdockeruser/demo-app"
}
