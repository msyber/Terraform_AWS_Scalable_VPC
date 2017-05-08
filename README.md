Modular, scalable virtual networking foundation with Amazon VPC

# Terraform_AWS_Scalable_VPC

This Terraform template deploys an Amazon Virtual Private Cloud (Amazon VPC) according to AWS best practices and guidelines.

The template divides the Amazon VPC address space in a predictable manner across multiple Availability Zones consistent with the AWS Region selected, and deploys optional NAT gateways.

The Amazon VPC architecture includes public, private Application subnets and private Database subnets. It includes dedicated custom Network access control lists (ACL) from the Amazon VPC per Public subnets and Private Database subnets.
