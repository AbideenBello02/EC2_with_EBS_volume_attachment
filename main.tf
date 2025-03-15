terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.90.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "null" {}

# IAM role and instance profile for instances
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the AmazonEC2ReadOnlyAccess policy to the role
resource "aws_iam_role_policy_attachment" "ec2_role_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

# Create an instance profile for the role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

# Create a primary EC2 instance
resource "aws_instance" "primary_instance" {
  ami                    = "ami-08b5b3a93ed654d19"
  instance_type          = "t2.micro"
  key_name               = "EC2-keys"
  vpc_security_group_ids = ["sg-0d395624af0613ac3"]
  subnet_id              = "subnet-0bca6832a84e65099"
  availability_zone      = "us-east-1a"
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name

  tags = {
    Name = var.EC2_TAG
  }
}

# Create an EFS file system
resource "aws_ebs_volume" "primary_volume" {
  availability_zone = "us-east-1a"
  type              = "gp3"
  size              = 20
  throughput        = 500
  encrypted         = true
}

# Attach the volume to the instance
resource "aws_volume_attachment" "primary_volume_attachment" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.primary_volume.id
  instance_id = aws_instance.primary_instance.id
}

# Create a secondary instance using the AMI created from the primary instance
resource "null_resource" "create_ami" {
  provisioner "local-exec" {
    command = "aws ec2 create-image --instance-id ${aws_instance.primary_instance.id} --name 'primary_instance_ami' --no-reboot"
  }
}

resource "aws_instance" "secondary_instance" {
  ami                    = var.my_ami
  instance_type          = aws_instance.primary_instance.instance_type
  subnet_id              = aws_instance.primary_instance.subnet_id
  vpc_security_group_ids = aws_instance.primary_instance.vpc_security_group_ids
  key_name               = aws_instance.primary_instance.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name

  tags = {
    Name = "Secondary-instance"
  }
}