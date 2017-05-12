#
# --- Outputs ---
#

# VPC logical ID
output "VPC.id" {
  value = "${aws_vpc.VPC.id}"
}

# VPC CIDR
output "VPC.cidrblock" {
  value = "${aws_vpc.VPC.cidr_block}"
}

# Public Subnets ids and CIDR
output "Public_Subnet_IDs" {
  value = ["${data.aws_subnet_ids.public_subnets_ids.*.ids}"]
}

# Public Subnets CIDR
data "aws_subnet" "public_subnets_id" {
  count = "${length(data.aws_subnet_ids.public_subnets_ids.ids)}"
  id = "${data.aws_subnet_ids.public_subnets_ids.ids[count.index]}"
}
output "subnet_cidr_blocks" {
  value = ["${data.aws_subnet.public_subnets_id.*.cidr_block}"]
}
