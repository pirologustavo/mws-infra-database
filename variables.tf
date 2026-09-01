variable "aws_region" {
  description = "Região da AWS"
  default     = "us-east-1"
}

variable "db_username" {
  description = "Usuário master do banco"
  default     = "admin"
}

variable "db_password" {
  description = "Senha master do banco"
  sensitive   = true
}