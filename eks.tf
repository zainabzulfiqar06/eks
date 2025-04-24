module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.36.0"

  cluster_name = "eks_cluster"
  cluster_version = "1.30"

  subnet_ids = module.eks-vpc.private_subnets
  vpc_id = module.eks-vpc.vpc_id


  



  tags = {
    environment = "dev"
    application = "face-crop"
  }

# using the nodegroups for the worker nodes



  eks_managed_node_groups = {
    eks-nodegroup = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t2.micro"]

      min_size     = 2
      max_size     = 3
      desired_size = 2

      subnet_ids = module.eks-vpc.private_subnets
    }
  }



# using self managed ec3 instances( nodes )

#  self_managed_node_groups = {
#   worker-group-1 = {
#     name                 = "worker-group-1"   # Must be at least 3 characters
#     instance_type        = "t2.micro"
#     asg_desired_capacity = 3
#   }
#  }

}