module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.36.0"

  cluster_name = "eks_cluster"
  cluster_version = "1.30"

  subnet_ids = module.eks-vpc.private_subnets
  vpc_id = module.eks-vpc.vpc_id

  cluster_endpoint_public_access  = true 
  tags = {
    environment = "dev"
    application = "face-crop"
  }

# using the nodegroups for the worker nodes



  eks_managed_node_groups = {
    eks-nodegroup = {
      ami_type       = var.ami_id
      instance_types = ["t2.micro"]

      min_size     = 2
      max_size     = 3
      desired_size = 2

      subnet_ids = module.eks-vpc.private_subnets
    }
  }





}
