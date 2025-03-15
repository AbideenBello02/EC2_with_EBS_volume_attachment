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

provider "null" {

}

resource "aws_instance" "Terra_deployed_1" {
  ami                    = "ami-08b5b3a93ed654d19"
  instance_type          = "t2.micro"
  key_name               = "EC2-keys"
  vpc_security_group_ids = ["sg-0d395624af0613ac3"]
  subnet_id              = "subnet-0bca6832a84e65099"
  availability_zone      = "us-east-1a"

  user_data = <<-EOF
    #!/bin/bash
    sudo yum install -y amazon-efs-utils
    mkdir -p /mnt/efs
    mount -t efs ${aws_efs_file_system.first-efs.id}:/ /mnt/efs
    echo "${aws_efs_file_system.first-efs.id}:/ /mnt/efs efs defaults,_netdev 0 0" >> /etc/fstab
  EOF

  tags = {
    Name = var.EC2_TAG
  }

}


resource "null_resource" "MY-AMI" {
  provisioner "local-exec" {
    command = "aws ec2 create-image --instance-id i-09d9e1ec8968b8382 --name 'my_ami_image' --no-reboot"

  }
}

resource "aws_ebs_volume" "my-ec2-volume" {
  availability_zone = "us-east-1a"
  type              = "gp3"
  size              = 20
  throughput        = 500
}

resource "aws_volume_attachment" "ec2-2nd-volume" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.my-ec2-volume.id
  instance_id = aws_instance.Terra_deployed_1.id
}

### EFS FILE SYSTEM ###
resource "aws_efs_file_system" "first-efs" {
  performance_mode = "generalPurpose"
  encrypted        = false

}
// EFS SUBNET MOUNT

resource "aws_efs_mount_target" "name" {
  file_system_id  = aws_efs_file_system.first-efs.id
  subnet_id       = "subnet-0bca6832a84e65099"
  security_groups = ["sg-0d395624af0613ac3"]

}


/*
### Mounting EFS to already created INSTANCE ###

resource "null_resource" "mount_efs" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("EC2-keys.pem")
    host        = aws_instance.Terra_deployed_1.public_ip
  }


  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y amazon-efs-utils",
      "sudo mkdir -p /mnt/efs",
      "sudo mount -t efs ${aws_efs_file_system.first-efs.id}:/ /mnt/efs",
      "echo '${aws_efs_file_system.first-efs.id}:/ /mnt/efs efs defaults,_netdev 0 0' | sudo tee -a /etc/fstab"
    ]
  }
}
*/


resource "aws_instance" "my-instance-2" {
  ami                    = var.my_ami
  instance_type          = aws_instance.Terra_deployed_1.instance_type
  subnet_id              = aws_instance.Terra_deployed_1.subnet_id
  vpc_security_group_ids = aws_instance.Terra_deployed_1.vpc_security_group_ids
  key_name               = aws_instance.Terra_deployed_1.key_name

}

