module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "rms-vpc"

  cidr = "10.0.0.0/16"
  azs  = ["us-east-1a", "us-east-1b", "us-east-1c"]

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  enable_dns_hostnames   = true
  enable_dns_support     = true
  one_nat_gateway_per_az = false

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = {
    Name = "rms"
  }
}

# ##### GATEWAY

# resource "aws_internet_gateway" "rms" {
#   vpc_id = module.vpc.vpc_id

#   tags = {
#       Name = "rms-vpc-internetgateway"
#   }
# }

# resource "aws_route_table" "rms-public" {
#   vpc_id = module.vpc.vpc_id

#   tags = {
#       Name = "rms-vpc-routetable-public"
#   }
# }

# ## Public Route Table rules
# resource "aws_route" "rms-public" {
#   route_table_id         = aws_route_table.rms-public.id
#   gateway_id             = aws_internet_gateway.rms.id
#   destination_cidr_block = "0.0.0.0/0"t
# }

# ## Public Route table associations
# resource "aws_route_table_association" "rms-public" {
#   count = length(module.vpc.public_subnets)

#   subnet_id      = module.vpc.public_subnets[count.index].id
#   route_table_id = aws_route_table.rms-public.id
# }