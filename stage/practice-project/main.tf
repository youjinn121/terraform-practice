module "vpc"{
    source = "terraform-aws-modules/vpc/aws"
    version = "5.21.0"
    name = "my-vpc"
    cidr = "10.0.0.0/16"
    azs = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c","ap-northeast-2d"]
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

    enable_nat_gateway = true
    single_nat_gateway = true

    tags = {
    ManagedBy = "Terraform"
    Environment = "dev"
  }
    public_subnet_tags = {
      "kubernetes.io/role/elb" = "1"
    }
    private_subnet_tags = {
      "kubernetes.io/role/internal-elb" = "1"
    }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31"

  cluster_name    = "mycluster"
  cluster_version = "1.31"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  node_security_group_additional_rules = {
    ingress_allow_http = {
      description      = "Allow HTTP from internet"
      protocol         = "tcp"
      from_port        = 80
      to_port          = 80
      type             = "ingress"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }
  eks_managed_node_groups = {
    example = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.medium"]

      min_size     = 2
      max_size     = 3
      desired_size = 2
    }
  }

  enable_cluster_creator_admin_permissions = true
}

module "mysql" {
    source = "../../modules/data-stores/mysql"
    eks_node_sg_id = module.eks.node_security_group_id
    db_username           = var.db_username
    db_password           = var.db_password
    vpc_security_group_id = aws_security_group.db_sg.id
    private_subnet_ids = module.vpc.private_subnets
}

# kubectl 연동을 위한 출력값 설정
output "cluster_name" {
  value = module.eks.cluster_name
}

resource "aws_security_group" "db_sg" {
    name = "practice-db-sg"
    vpc_id = module.vpc.vpc_id

    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [module.eks.node_security_group_id]
    }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}

