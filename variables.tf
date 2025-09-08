# variables.tf

variable "aws_region" {
  description = "Région AWS pour le déploiement"
  type        = string
  default     = "eu-west-3"
}

variable "project_name" {
  description = "Nom du projet utilisé pour nommer les ressources"
  type        = string
  default     = "atso-enhanced"
}