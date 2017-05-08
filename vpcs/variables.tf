#
# --- AWS Region to be used ---
#
variable "aws_region" {
  description   = "The AWS region to create things in"
  default       = "eu-west-1"
}

#
# --- AZs to use in the VPC ---
#
variable "NumberOfAZs" {
  description   = "Number of Availability Zones to use in the VPC (1, 2, 3 or 4) consistent with the region selected"
  default       = "3"
}

#
# --- Enable NAT Gateway ---
#
variable "nat_gateway_enabled" {
  description   = "set to 1 to create nat gateway instances for private subnets"
  default       = "1"
}

#
# --- Enable Additional Private Subnets ---
#
variable "AdditionalPrivateSubnets" {
  description   = "set to 1 to create additional private subnets with dedicated network ACLs"
  default       = "1"
}

#
# --- Parameters for VPC ---
#
variable "VPCCIDR" {
  description   = "The CIDR block you want the VPC to cover"
  default       = "10.0.0.0/16"
}

variable "VPCCIDR_PublicSubnet" {
  description   = "The CIDR block for Public Subnets"
  default       = "10.0.128.0/18"
}

variable "VPCCIDR_PrivateSubnet" {
  description   = "The CIDR block for Private Subnets"
  default       = "10.0.0.0/17"
}

variable "VPCCIDR_PrivateSubnetDatabase" {
  description   = "The CIDR block for Additional Private Subnets"
  default       = "10.0.192.0/19"
}

variable "VPCTag" {
  description   = "A mapping of tags for the VPC"
  default       = "VPC"
}

variable "EnableDnsSupport" {
  description   = "Specifies whether DNS resolution is supported for the VPC (true or false)"
  default       = "true"
}

variable "EnableDnsHostnames" {
  description   = "Specifies whether the instances launched in the VPC get DNS hostnames (true or false)"
  default       = "true"
}

variable "InstanceTenancy" {
  description   = "The allowed tenancy of instances launched into the VPC (default, dedicated or host)"
  default       = "default"
}
