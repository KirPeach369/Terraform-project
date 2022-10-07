resource "aws_instance" "my_server" {
  
  ami = "ami-05ff5eaef6149df49"
  instance_type = "t2.micro"
  key_name = "key_kirikise"
  subnet_id  = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.allow_traffic.id]

  user_data = <<EOF
#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y
sudo systemctl enable nginx
sudo systemctl start nginx
sudo yum -y install git
EOF
}

resource "aws_key_pair" "key_kirikise" {
  key_name   = "key_kirikise"
  public_key = "you key"
}

resource "aws_security_group" "allow_traffic" {
  
  vpc_id = aws_vpc.main.id
    
  name        = "allow_traffic"
  description = "Allow HTTP/HTTPS inbound traffic"
  
  ingress {
    description = "HTTPS from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["80.89.75.126/32"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}