provider "kubernetes" {
  host                   = data.aws_eks_cluster.myapp-cluster.endpoint
  token                  = data.aws_eks_cluster_auth.myapp_cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp-cluster.certificate_authority.0.data)
}

data "aws_eks_cluster" "myapp-cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "myapp_cluster" {
  name = module.eks.cluster_id
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.17.2"

  cluster_name    = "myapp-eks-cluster"
  cluster_version = "1.28"

  subnet_ids = module.myapp-vpc.private_subnets
  vpc_id     = module.myapp-vpc.vpc_id

  # for connecting from local terminal using "kubectl"
  cluster_endpoint_public_access = true

  tags = {
    environment = "development"
    application = "myapp"
  }

  eks_managed_node_groups = {
    dev = {
      min_size     = 1
      max_size     = 3
      desired_size = 3

      instance_types = ["t2.small"]
    }
  }
}
