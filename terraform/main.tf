module "vpc"{
    source = "./modules/vpc"
    cidr_block = "10.0.0.0/16"

}
module "public-subnet" {
    source = "./modules/subnet"
    vpc_id = module.vpc.vpc_id
    subnet_cidr = "10.0.4.0/24"
    availability_zone = "eu-central-1a"
    
}

module "private-subnet" {
    source = "./modules/subnet"
    vpc_id = module.vpc.vpc_id
    subnet_cidr = "10.0.5.0/24"
    availability_zone = "eu-central-1b"
}

module "eks" {
    source = "./modules/eks"
    eks_name = "eks_nodejs"
    eks_vpc_config = {
      subnet_ids = [module.public-subnet.subnet_id, module.private-subnet.subnet_id]
    }
    capacity_type = "SPOT"
   eks_role_arn = "arn:aws:iam::659690157935:role/eksClusterRole"
   node_subnet_ids = [module.public-subnet.subnet_id, module.private-subnet.subnet_id]
}