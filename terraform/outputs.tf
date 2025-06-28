output "bucket_csv_name" {
  description = "Nombre del bucket donde se suben los CSV"
  value       = aws_s3_bucket.csv_bucket.bucket
}

output "bucket_json_name" {
  description = "Nombre del bucket donde se guardan los JSON limpios"
  value       = aws_s3_bucket.json_bucket.bucket
}

output "lambda_function_name" {
  description = "Nombre de la función Lambda"
  value       = aws_lambda_function.lambda_cleaner.function_name
}

output "lambda_function_arn" {
  description = "ARN de la función Lambda"
  value       = aws_lambda_function.lambda_cleaner.arn
}