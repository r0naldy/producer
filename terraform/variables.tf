variable "aws_region" {
  description = "Región de AWS a usar"
  type        = string
  default     = "us-east-1"
}

variable "bucket_csv_name" {
  description = "Nombre del bucket donde se suben los CSV"
  type        = string
  default     = "bucket-data-2"
}

variable "bucket_json_name" {
  description = "Nombre del bucket donde se guardan los JSON limpios"
  type        = string
  default     = "bucket-json-clear"
}

variable "lambda_function_name" {
  description = "Nombre de la función Lambda para limpieza"
  type        = string
  default     = "generador_de_archivos_limpios"
}

variable "lambda_role_name" {
  description = "Nombre del rol IAM usado por Lambda"
  type        = string
  default     = "lambda-s3-role"
}
