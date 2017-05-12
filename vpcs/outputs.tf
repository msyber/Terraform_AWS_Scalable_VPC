#
# --- Outputs ---
#

# VPC logical ID
output "VPC.id" {
  value = "${aws_vpc.VPC.id}"
}

# VPC CIDR, the set of IP addresses for the VPC
output "VPC.cidrblock" {
  value = "${aws_vpc.VPC.cidr_block}"
}
