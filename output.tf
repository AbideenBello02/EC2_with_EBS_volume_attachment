output "EC2-primary_instance_arn" {
  description = "ec2 instance arn"
  value       = aws_instance.primary_instance.arn

}
output "primary_instance_id" {
  description = "ec2 instance id"
  value       = aws_instance.primary_instance.id

}

output "primary_instance_az" {
  description = "ec2 instance az"
  value       = aws_instance.primary_instance.availability_zone

}
output "primary_volume_id" {
  description = "Attached EBS volune id"
  value       = aws_ebs_volume.primary_volume.id

}

output "primary_volume_arn" {
  value = aws_ebs_volume.primary_volume.arn
}

output "my_ami_image" {
  value = null_resource.create_ami.id
}