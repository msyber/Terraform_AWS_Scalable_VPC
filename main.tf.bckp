#
# --- Specify the provider and access details ---
#
provider "aws" {
  region                = "${var.aws_region}"
}

#
# --- Creates 1 to 4 AZs with public and private subnets and optional NAT Gateway ---
#
module "VPC" {
	source			          = "./vpcs"
	VPCCIDR               = "${var.VPCCIDR}"
	VPCCIDR_PublicSubnet  = "${var.VPCCIDR_PublicSubnet}"
  VPCCIDR_PrivateSubnet = "${var.VPCCIDR_PrivateSubnet}"
	VPCTag                = "${var.VPCTag}"
	EnableDnsSupport      = "${var.EnableDnsSupport}"
	EnableDnsHostnames    = "${var.EnableDnsHostnames}"
	InstanceTenancy       = "${var.InstanceTenancy}"
	NumberOfAZs           = "${var.NumberOfAZs}"
	nat_gateway_enabled   = "${var.nat_gateway_enabled}"
}
