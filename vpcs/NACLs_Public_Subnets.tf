#
# --- Network ACL Rules for the Public Subnets ---
#

# Public Subnets ids
data "aws_subnet_ids" "public_subnets_ids" {
  vpc_id = "${aws_vpc.VPC.id}"
  tags {
    Network = "Public"
  }
}

# Create Network ACL for Public Subnets
resource "aws_network_acl" "NACLs_Public_Subnet" {
  depends_on     = ["aws_subnet.PublicSubnet"]
  vpc_id         = "${aws_vpc.VPC.id}"
  subnet_ids     = ["${data.aws_subnet_ids.public_subnets_ids.ids}"]
  tags {
    Name = "NACLs_Public_Subnet"
  }
  lifecycle {
  	create_before_destroy     = true
  }

  # Allows inbound HTTP traffic from any IPv4 address
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  # Allows inbound HTTPS traffic from any IPv4 address
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  # Allows inbound SSH traffic from your home network (over the Internet gateway)
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  # Allows inbound RDP traffic from your home network (over the Internet gateway)
  ingress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 3389
    to_port    = 3389
  }

  # Allows inbound return traffic from requests originating in the subnet
  ingress {
    protocol   = "tcp"
    rule_no    = 140
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # Allows outbound HTTP traffic from the subnet to the Internet
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  # Allows outbound HTTPS traffic from the subnet to the Internet
  egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  # Allows outbound SSH access to instances in your private subnets
  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "${var.VPCCIDR}"
    from_port  = 22
    to_port    = 22
  }

  # Allows outbound RDP access to instances in your private subnets
  egress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "${var.VPCCIDR}"
    from_port  = 3389
    to_port    = 3389
  }

  # Allows outbound responses to clients on the Internet
  egress {
    protocol   = "tcp"
    rule_no    = 140
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

}
