terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.50.0"
    }
  }
}

provider "aws" {
  region = var.region
}


//----------NETWORK--------------//
module "network" {
  source = "./modules/network"

  region       = var.region
  cluster_name = var.cluster_name
}
//----------DB--------------//
module "database" {
  source = "./modules/database"

  public_subnets = module.network.public_subnets
  vpc_id         = module.network.vpc_id
}

//----------EKS--------------//
module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  vpc_id          = module.network.vpc_id
  public_subnets  = module.network.public_subnets
  private_subnets = module.network.private_subnets

}

//----------ECR--------------//
module "ecr-order" {
  source = "./modules/ecr"

  repository_name = "api-order"
  region          = var.region
}

module "ecr-payment" {
  source          = "./modules/ecr"
  repository_name = "api-payment"

  region = var.region
}

module "ecr-production" {
  source = "./modules/ecr"

  repository_name = "api-production"
  region          = var.region
}

//---------Gateway/ELB-----//

module "gateway" {
  source = "./modules/gateway"

  vpc_id          = module.network.vpc_id
  private_subnets = module.network.private_subnets
}