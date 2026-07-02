#key pair (login)

resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}
# vpc & security group

resource "aws_default_vpc" "default" {

}


resource "aws_security_group" "my_security_group" {
  name        = "automate-sg"
  description = "this will add a Tf generated security group"
  vpc_id      = aws_default_vpc.default.id # interpolation

  # inbound rule
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow ssh"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow http"
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow http"
  }
  # outbound rule   
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all outbound traffic"
  }
  # tags
  tags = {
    Name = "automate-sg"
  }

}
# ec2 instance

resource "aws_instance" "my_instance" {
  for_each = tomap({
    "tws-junoon-automate-micro" = "t3.micro"
    "tws-junoon-automate-small" = "t3.small"
  })
  # metaa argument
  depends_on = [aws_security_group.my_security_group, aws_key_pair.my_key]
  
  key_name        = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.my_security_group.name]
  instance_type   = each.value
  ami             = var.ec2_ami_id
  user_data       = file("install_nginx.sh")

  root_block_device {
    volume_size = var.ec2_root-storage_size
    volume_type = "gp3"
  }
  tags = {
    Name = each.key
  }
}


