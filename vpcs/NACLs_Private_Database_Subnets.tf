#
# --- Network ACL Rules for the Private Database Subnets ---
#

# Private Database Subnets ids
data "aws_subnet_ids" "private_database_subnets_ids" {
  vpc_id = "${aws_vpc.VPC.id}"
  tags {
    Network = "Private_Database_Subnets"
  }
}

# Create Network ACL for Private Database Subnets
resource "aws_network_acl" "NACLs_Private_Database_Subnet" {
  depends_on     = ["aws_subnet.PrivateSubnetDatabase"]
  vpc_id         = "${aws_vpc.VPC.id}"
  subnet_ids     = ["${data.aws_subnet_ids.private_database_subnets_ids.ids}"]
  tags {
    Name = "NACLs_Private_Database_Subnet"
  }
  lifecycle {
  	create_before_destroy     = true
  }

  # Allows inbound SSH traffic from an SSH bastion in the public subnet
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.VPCCIDR_PublicSubnet}"
    from_port  = 22
    to_port    = 22
  }

  # Allows inbound RDP traffic from the Microsoft Terminal Services gateway in the public subnet
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "${var.VPCCIDR_PublicSubnet}"
    from_port  = 3389
    to_port    = 3389
  }

  # Allows web servers in the application subnet to read and write to MS SQL servers in the private database subnet
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "${var.VPCCIDR_PrivateSubnet}"
    from_port  = 1433
    to_port    = 1433
  }

  # Allows web servers in the application subnet to read and write to MySQL servers in the private database subnet
  ingress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "${var.VPCCIDR_PrivateSubnet}"
    from_port  = 3306
    to_port    = 3306
  }

  # Allows web servers in the application subnet to read and write to PostgreSQL servers in the private database subnet
  ingress {
    protocol   = "tcp"
    rule_no    = 140
    action     = "allow"
    cidr_block = "${var.VPCCIDR_PrivateSubnet}"
    from_port  = 5432
    to_port    = 5432
  }

  # Allows outbound responses to clients on VPC CIDR block
  egress {
    protocol   = "tcp"
    rule_no    = 150
    action     = "allow"
    cidr_block = "${var.VPCCIDR}"
    from_port  = 1024
    to_port    = 65535
  }
}
