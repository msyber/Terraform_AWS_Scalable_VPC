#
# --- Outputs ---
#

# VPC logical ID
output "1.VPC_Logical_ID" {
  value = "${module.VPC.VPC.id}"
}

# VPC CIDR Block
output "2.VPC_CIDR_Block" {
  value = "${module.VPC.VPC_cidrblock}"
}

# Public Subnets IDs
output "3.Subnet_Public_IDs" {
  value = ["${module.VPC.Public_Subnet_IDs}"]
}

# Public Subnets CIDR Block
output "4.Subnet_Public_CIDR" {
  value = ["${module.VPC.Public_Subnet_CIDR}"]
}

# Private Application Subnets IDs
output "5.Subnet_Private_Application_IDs" {
  value = ["${module.VPC.Private_Application_Subnet_IDs}"]
}

# Private Application Subnets CIDR Block
output "6.Subnet_Private_Application_CIDR" {
  value = ["${module.VPC.Private_Application_Subnet_CIDR}"]
}

# Private Database Subnets IDs
output "7.Subnet_Private_Database_IDs" {
  value = ["${module.VPC.Private_Database_Subnet_IDs}"]
}

# Private Database Subnets CIDR Block
output "8.Subnet_Private_Database_CIDR" {
  value = ["${module.VPC.Private_Database_Subnet_CIDR}"]
}
