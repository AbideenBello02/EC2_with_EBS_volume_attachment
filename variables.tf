variable "EC2_TAG" {
  description = "instance tag name"
  type        = string
  default     = "Primary-instance(EC2_EBS_lab)"
}

variable "instance_id" {
  type    = string
  default = "i-09d9e1ec8968b8382"
}

variable "my_ami" {
  description = "AMI ID for the secondary instance"
  default = "ami-0250b891f2d1b2d84"

}








/*  VARIABLE IS SIMILAR TO USING PARAMETER IN AWS CLOUDFORMATION
Parameters:
  EnvironmentName: 
    Description: An environment name that is prefixed to resource names
    Type: String

  VpcCIDR:
    Description: Please enter the IP range (CIDR notation) for this VPC
    Type: String
    Default: 10.0.0.0/16

  PublicSubnet1CIDR:
    Description: Please enter the IP range (CIDR notation) for the public subnet in the first Availability Zone
    Type: String
    Default: 10.0.1.0/24

  PublicSubnet2CIDR:
    Description: Please enter the IP range (CIDR notation) for the public subnet in the second Availability Zone
    Type: String
    Default: 10.0.2.0/24

  PrivateSubnet1CIDR:
    Description: Please enter the IP range (CIDR notation) for the private subnet in the first Availability Zone
    Type: String
    Default: 10.0.3.0/24

  PrivateSubnet2CIDR:
    Description: Please enter the IP range (CIDR notation) for the private subnet in the second Availability Zone
    Type: String
    Default: 10.0.4.0/24

    */
    