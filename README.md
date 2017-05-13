## Terraform_AWS_Scalable_VPC
> version 0.1

This Terraform template deploys an Amazon Virtual Private Cloud (Amazon VPC) according to AWS best practices and guidelines.

The template divides the Amazon VPC address space in a predictable manner across multiple Availability Zones consistent with the AWS Region selected, and deploys optional NAT gateways.

The Amazon VPC architecture includes public, private Application subnets and private Database subnets. It includes dedicated custom Network access control lists (NACL) from the Amazon VPC per Public subnets and Private Database subnets.

![Scalable VPC with 2 AZs](https://github.com/msyber/Terraform_AWS_Scalable_VPC/blob/master/Scalable_VPC.png)
