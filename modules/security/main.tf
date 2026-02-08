############################################
# ALB Security Group
############################################

resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "Allow HTTP inbound"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound to anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

############################################
# EC2 Security Group (Private Instance)
############################################

resource "aws_security_group" "ec2" {
  name        = "strapi-ec2-sg"
  description = "Allow ALB and SSH access"
  vpc_id      = var.vpc_id

  ##########################################
  # Strapi Access — Only from ALB
  ##########################################
  ingress {
    description     = "Strapi from ALB"
    from_port       = var.strapi_port
    to_port         = var.strapi_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ##########################################
  # SSH Access (Choose ONE option)
  ##########################################

  # Option A — Lab/Open Access
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Option B — Secure (replace with your IP)
  # ingress {
  #   description = "SSH access"
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["YOUR-IP/32"]
  # }

  ##########################################
  # Outbound Internet (via NAT)
  ##########################################
  egress {
    description = "Outbound to Internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "strapi-ec2-sg"
  }
}
