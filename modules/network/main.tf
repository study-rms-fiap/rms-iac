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
  # create_igw             = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
    // isso só funciona porque tenho um unico cluster.
    // caso fossem varios cluster, teria de mudar para array e executar um for
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = 1
    "kubernetes.io/cluster/${var.cluster_name}" = "share"
  }

  tags = {
    Name = "rms"
  }
}

# ##### GATEWAY

# resource "aws_internet_gateway" "gw" {
#   vpc_id = module.vpc.vpc_id
# }

# resource "aws_route_table" "second_rt" {
#   vpc_id = module.vpc.vpc_id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gw.id
#   }
# }

# resource "aws_route_table_association" "public_subnet_asso" {
#   count          = length(module.vpc.public_subnets_cidr_blocks)
#   subnet_id      = element(module.vpc.public_subnets[*], count.index)
#   route_table_id = aws_route_table.second_rt.id
# }

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