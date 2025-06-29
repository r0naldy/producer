provider "aws" {
  region = var.aws_region
}

# -----------------------------
# Buckets S3: CSV y JSON limpio
# -----------------------------
resource "aws_s3_bucket" "csv_bucket" {
  bucket        = var.bucket_csv_name
  force_destroy = true
}

resource "aws_s3_bucket" "json_bucket" {
  bucket        = var.bucket_json_name
  force_destroy = true
}

# -----------------------------
# Rol IAM para Lambda
# -----------------------------
resource "aws_iam_role" "lambda_role" {
  name = var.lambda_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_s3_access" {
  name = "lambda-s3-access"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"],
        Resource = [
          aws_s3_bucket.csv_bucket.arn,
          "${aws_s3_bucket.csv_bucket.arn}/*",
          aws_s3_bucket.json_bucket.arn,
          "${aws_s3_bucket.json_bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# -----------------------------
# Código de Lambda desde ZIP
# -----------------------------
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_code"
  output_path = "${path.module}/lambda_function_payload.zip"
}

resource "aws_lambda_function" "lambda_cleaner" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.10"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)
  timeout          = 10
}

# -----------------------------
# Permitir que S3 invoque Lambda
# -----------------------------
resource "aws_lambda_permission" "allow_s3_invocation" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_cleaner.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.csv_bucket.arn
}

# -----------------------------
# Notificación S3 → Lambda
# -----------------------------
resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = aws_s3_bucket.csv_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_cleaner.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = ""
    filter_suffix       = ".csv"
  }

  depends_on = [aws_lambda_permission.allow_s3_invocation]
}
