output "EC2-instance-1_arn" {
  description = "my first ecc2 instance id"
  value       = aws_instance.Terra_deployed_1.arn

}
output "EC2-instance-1_id" {
  description = "my first ecc2 instance id"
  value       = aws_instance.Terra_deployed_1.id
}


output "EC2-instance-1_az" {
  description = "my first ecc2 instance id"
  value       = aws_instance.Terra_deployed_1.availability_zone

}

output "EC2-instance-1_volume" {
  description = "my first ecc2 instance id"
  value       = aws_instance.Terra_deployed_1.public_ip
}

output "First_volume_arn" {
  value = aws_ebs_volume.my-ec2-volume.arn

}

output "First_volume_az" {
  value = aws_ebs_volume.my-ec2-volume.availability_zone

}
output "First_volume_id" {
  value = aws_ebs_volume.my-ec2-volume.id

}


output "Second_volume_id" {
  value = aws_volume_attachment.ec2-2nd-volume.id
}

output "first-efs_id" {
  value = aws_efs_file_system.first-efs.id
}

output "my_ami_image" {
  value = null_resource.MY-AMI.id
}