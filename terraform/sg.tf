# bastion security group
resource "aws_security_group" "bastion_security" {
  name        = "ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.weplat-vpc.id # 내가 생성한 VPC

  ingress {
    description = "SSH from VPC"
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
  tags = {
    Name = "weplat-bastion-sg"
  }
}

# jenkins security group
resource "aws_security_group" "jenkins_security" {
  name        = "jenkins"
  description = "Allow ALL traffic"
  vpc_id      = aws_vpc.weplat-vpc.id # 내가 생성한 VPC

  ingress {
    description = "ALL traffic from VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "weplat-jenkins-sg"
  }
}

# k8s-mgnt port : 22 
# source open : bestion의 security group
resource "aws_security_group" "mgnt_security" {
  name        = "mgnt"
  description = "Allow ssh traffic"
  vpc_id      = aws_vpc.weplat-vpc.id # 내가 생성한 VPC

  ingress {
    description = "ALL ssh from Bestion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_security.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "weplat-mgnt-sg"
  }
}
