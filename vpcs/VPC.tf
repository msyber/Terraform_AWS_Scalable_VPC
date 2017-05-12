#
# --- Specify the provider and access details ---
#
provider "aws" {
  region                 = "${var.aws_region}"
}


#
# --- Create a VPC ---
#

# VPC Parameters
resource "aws_vpc" "VPC" {
  cidr_block             = "${var.VPCCIDR}"
  instance_tenancy       = "${var.InstanceTenancy}"
  enable_dns_support     = "${var.EnableDnsSupport}"
  enable_dns_hostnames   = "${var.EnableDnsHostnames}"
  tags {
      Name               = "${var.VPCTag}"
  }
}

# Create an internet gateway to give public subnet access to the outside world
resource "aws_internet_gateway" "InternetGateway" {
  vpc_id                 = "${aws_vpc.VPC.id}"
  tags {
    Name                 = "Internet Gateway"
    Network              = "Public"
  }
}

# Get the list of availability AvailabilityZones of the selected AWS Region
data "aws_availability_zones" "available" {}


#
# --- Create Public Subnet ---
#

# Create Public Subnet
resource "aws_subnet" "PublicSubnet" {
  count                  = "${var.NumberOfAZs}"
  vpc_id                 = "${aws_vpc.VPC.id}"
  availability_zone      = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block             = "${cidrsubnet("${var.VPCCIDR_PublicSubnet}", 2, count.index)}"
  tags {
    Name                 = "Public_${data.aws_availability_zones.available.names[count.index]}"
    Network              = "Public"
  }
}

# Create Public Subnets route table
resource "aws_route_table" "PublicSubnetRouteTable" {
  vpc_id                 = "${aws_vpc.VPC.id}"
  tags {
    Name                 = "Public route table"
    Network              = "Public"
  }
  route {
    cidr_block           = "0.0.0.0/0"
    gateway_id           = "${aws_internet_gateway.InternetGateway.id}"
  }
}

# Associate Public Subnet to route table
resource "aws_route_table_association" "RouteAssocPublicSubnet" {
  count                  = "${var.NumberOfAZs}"
  subnet_id              = "${element(aws_subnet.PublicSubnet.*.id, count.index)}"
  route_table_id         = "${aws_route_table.PublicSubnetRouteTable.id}"
}


#
# --- Create NAT Gateway ---
#

# Create EIP for NAT Gateway
resource "aws_eip" "NatGatewayEIP" {
  depends_on             = ["aws_internet_gateway.InternetGateway"]
  count                  = "${var.NumberOfAZs * var.nat_gateway_enabled}"
  vpc                    = true
}

# Create Nat Gateway
resource "aws_nat_gateway" "NatGateway" {
  depends_on             = ["aws_internet_gateway.InternetGateway"]
  count                  = "${var.NumberOfAZs * var.nat_gateway_enabled}"
  allocation_id          = "${element(aws_eip.NatGatewayEIP.*.id, count.index)}"
  subnet_id              = "${element(aws_subnet.PublicSubnet.*.id, count.index)}"
}


#
# --- Create Private Subnet (e.g.: Application Subnet) ---
#

# Create private subnet
resource "aws_subnet" "PrivateSubnet" {
  count                  = "${var.NumberOfAZs}"
  vpc_id                 = "${aws_vpc.VPC.id}"
  availability_zone      = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block             = "${cidrsubnet("${var.VPCCIDR_PrivateSubnet}", 2, count.index)}"
  tags {
    Name                 = "Private_application_${data.aws_availability_zones.available.names[count.index]}"
    Network              = "Private_Application_Subnets"
  }
}

# Create dedicated route tables if NAT Gateway enabled
resource "aws_route_table" "PrivateSubnetRouteTable" {
  count                  = "${var.NumberOfAZs * var.nat_gateway_enabled}"
  vpc_id                 = "${aws_vpc.VPC.id}"
  tags {
    Name                 = "Private_route_${data.aws_availability_zones.available.names[count.index]}"
    Network              = "Private_Application_Subnets"
  }
}

# Create dedicated route to Internet if NAT Gateway enabled
resource "aws_route" "PrivateRoute" {
  count                  = "${var.NumberOfAZs * var.nat_gateway_enabled}"
  route_table_id         = "${element(aws_route_table.PrivateSubnetRouteTable.*.id, count.index)}"
  nat_gateway_id         = "${element(aws_nat_gateway.NatGateway.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"

}

# Associates subnets with route tables
resource "aws_route_table_association" "PrivateSubnetRouteTableAssociation" {
  count                  = "${var.NumberOfAZs * var.nat_gateway_enabled}"
  route_table_id         = "${element(aws_route_table.PrivateSubnetRouteTable.*.id, count.index)}"
  subnet_id              = "${element(aws_subnet.PrivateSubnet.*.id, count.index)}"
}


#
# --- Create Additional Private Subnet (e.g.: Database Subnet) ---
#

# Create private subnet
resource "aws_subnet" "PrivateSubnetDatabase" {
  count                  = "${var.NumberOfAZs}"
  vpc_id                 = "${aws_vpc.VPC.id}"
  availability_zone      = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block             = "${cidrsubnet("${var.VPCCIDR_PrivateSubnetDatabase}", 2, count.index)}"
  tags {
    Name                 = "Private_database_${data.aws_availability_zones.available.names[count.index]}"
    Network              = "Private_Database_Subnets"
  }
}


#
# --- Outputs ---
#

# Public Subnets ids
data "aws_subnet_ids" "public_subnets" {
  vpc_id = "${aws_vpc.VPC.id}"
  tags {
    Network = "Public"
  }
}
output "o_Public_Subnet_IDs" {
  value = ["${data.aws_subnet_ids.public_subnets.*.ids}"]
}

## Private_Application_Subnets ids
#data "aws_subnet_ids" "private_application_subnets" {
#  vpc_id = "${aws_vpc.VPC.id}"
#  tags {
#    Network = "Private_Application_Subnets"
#  }
#}
#output "o_Private_Application_Subnet_IDs" {
#  value = ["${data.aws_subnet_ids.private_application_subnets.*.ids}"]
#}

## Private_Database_Subnets ids
#data "aws_subnet_ids" "private_database_subnets" {
#  vpc_id = "${aws_vpc.VPC.id}"
#  tags {
#    Network = "Private_Database_Subnets"
#  }
#}
#output "o_Private_Database_Subnet_IDs" {
#  value = ["${data.aws_subnet_ids.private_database_subnets.*.ids}"]
#}
