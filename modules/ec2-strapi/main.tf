############################################
# Get Latest Amazon Linux 2 AMI
############################################

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

############################################
# Key Pair (Auto create from local .pub)
############################################

resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = file("${path.module}/../../terraform-key.pub")
}

############################################
# EC2 Instance (Private Subnet)
############################################

resource "aws_instance" "strapi" {

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = aws_key_pair.this.key_name
  vpc_security_group_ids = [var.security_group_id]

  ####################################
  # USER DATA
  ####################################
  user_data = file("${path.module}/user_data.sh")

  ####################################
  # ROOT DISK SIZE (IMPORTANT)
  ####################################
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  ####################################
  # TAGS
  ####################################
  tags = {
    Name = "${var.environment}-strapi"
  }

  ####################################
  # DEPENDENCY ON NAT GATEWAY
  ####################################
  depends_on = [
    aws_key_pair.this,
    var.nat_dependency
  ]
}
