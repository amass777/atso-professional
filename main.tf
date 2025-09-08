# main.tf
# Point d'entrée de la configuration Terraform pour ATSO

# Définition du provider cloud (exemple avec AWS)
provider "aws" {
  region = var.aws_region
}

# Configuration du backend pour stocker l'état de l'infrastructure de manière sécurisée et partagée
terraform {
  backend "s3" {
    bucket         = "atso-terraform-state-bucket-unique" # REMPLACER par un nom de bucket S3 unique
    key            = "global/s3/terraform.tfstate"
    region         = "eu-west-3"
    encrypt        = true
    dynamodb_table = "atso-terraform-locks" # Table DynamoDB pour le verrouillage de l'état
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Appel des modules pour construire l'infrastructure
# Module pour le réseau (VPC, subnets, etc.)
module "network" {
  source = "./modules/network"
  project_name = var.project_name
}

# Module pour la base de données (PostgreSQL RDS)
module "database" {
  source = "./modules/database"
  project_name = var.project_name
  vpc_id = module.network.vpc_id
  private_subnets = module.network.private_subnets
}

# D'autres modules viendront ici (Kubernetes EKS, Cache ElastiCache, etc.)