#
# --- Outputs ---
#

# VPC logical ID
output "VPC.id" {
  value = "${aws_vpc.VPC.id}"
}

# VPC CIDR
output "VPC_cidrblock" {
  value = "${aws_vpc.VPC.cidr_block}"
}

# Public Subnets ids
data "aws_subnet_ids" "publicsubnetsids" {
  vpc_id = "${aws_vpc.VPC.id}"
  tags {
    Network = "Public"
  }
}
output "Public_Subnet_IDs" {
  value = ["${data.aws_subnet_ids.publicsubnetsids.*.ids}"]
}

# Public Subnets CIDR Block
data "aws_subnet" "publicsubnetcidr"{
  count = "${length(data.aws_subnet_ids.publicsubnetsids.ids)}"
  id    = "${data.aws_subnet_ids.publicsubnetsids.ids[count.index]}"
}
output "Public_Subnet_CIDR" {
  value = ["${data.aws_subnet.publicsubnetcidr.*.cidr_block}"]
}

# Private Application Subnets ids
data "aws_subnet_ids" "privateapplicationsubnetsids" {
  vpc_id = "${aws_vpc.VPC.id}"
  tags {
    Network = "Private_Application_Subnets"
  }
}
output "Private_Application_Subnet_IDs" {
  value = ["${data.aws_subnet_ids.privateapplicationsubnetsids.*.ids}"]
}

# Private Application Subnets CIDR Block
data "aws_subnet" "privateapplicationsubnetcidr"{
  count = "${length(data.aws_subnet_ids.privateapplicationsubnetsids.ids)}"
  id    = "${data.aws_subnet_ids.privateapplicationsubnetsids.ids[count.index]}"
}
output "Private_Application_Subnet_CIDR" {
  value = ["${data.aws_subnet.privateapplicationsubnetcidr.*.cidr_block}"]
}

# Private Database Subnets ids
data "aws_subnet_ids" "privatedatabasesubnetsids" {
  vpc_id = "${aws_vpc.VPC.id}"
  tags {
    Network = "Private_Database_Subnets"
  }
}
output "Private_Database_Subnet_IDs" {
  value = ["${data.aws_subnet_ids.privatedatabasesubnetsids.*.ids}"]
}

# Private Database Subnets CIDR Block
data "aws_subnet" "privatedatabasesubnetcidr"{
  count = "${length(data.aws_subnet_ids.privatedatabasesubnetsids.ids)}"
  id    = "${data.aws_subnet_ids.privatedatabasesubnetsids.ids[count.index]}"
}
output "Private_Database_Subnet_CIDR" {
  value = ["${data.aws_subnet.privatedatabasesubnetcidr.*.cidr_block}"]
}
