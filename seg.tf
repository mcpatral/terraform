resource "aws_security_group" "Load-balancer" {
  name        = "Elb-sg"
  description = "security group for load balancer"

  ingress {
    description = "Allow internet traffic to port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow secure internet traffic"
    from_port   = 443
    to_port     = 443
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
    env  = "Dev"
    team = "config management"
  }
}
resource "aws_security_group" "Bastion" {
  name        = "bation-host-sg"
  description = "security group for Bastion Host"

  ingress {
    description = "Allow ssh traffic to my webserver"
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
    env  = "Dev"
    team = "config management"
  }
}
resource "aws_security_group" "App-server" {
  name        = "app-server sg"
  description = "security group for app-server sg"

  ingress {
    description     = "Allow ssh traffic to my app-server"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.Bastion.id]
  }
  ingress {
    description     = "Allow ssh traffic to my app-server"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.Bastion.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    env  = "Dev"
    team = "config management"
  }
}
resource "aws_security_group" "Database-sg" {
  name        = "database-sg"
  description = "security group for app-server sg"

  ingress {
    description     = "Allow ssh traffic to my Database"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.App-server.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    env  = "Dev"
    team = "config management"
  }
}