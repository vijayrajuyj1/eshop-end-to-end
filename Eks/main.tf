module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vijay-vpc"
  cidr = var.vpc

  azs             = data.aws_availability_zones.azs.names
  private_subnets = var.private_subnet1
  public_subnets  = var.public_subnet2
  
  enable_nat_gateway = true
  enable_vpn_gateway = true
  enable_dns_hostnames = true
  
  tags ={
    "kubernetes.io/cluster/vijay-cluster"="shared"
  }
  
  private_subnet_tags={
    "kubernetes.io/cluster/vijay-cluster"="shared"
    "kubernetes.io/role/elb"= "1"

  }

  public_subnet_tags={
    "kubernetes.io/cluster/vijay-cluster"="shared"
    "kubernetes.io/role/elb"= "1"
  }

}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = "vijay-cluster"
  cluster_version = "1.31"

  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_type = "t2.micro"
      associate_public_ip_address = false
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
