# upload.py
import boto3
import sys
import os

BUCKET_NAME = "bucket-data-2"

if len(sys.argv) < 2:
    print("Uso: python upload.py ruta\\al\\archivo.csv  o  ./archivo.csv")
    sys.exit(1)

file_path = sys.argv[1]

if not os.path.isfile(file_path):
    print(f"❌ Archivo no encontrado: {file_path}")
    sys.exit(1)

file_name = os.path.basename(file_path)

# Inicializar cliente S3
s3 = boto3.client("s3")

try:
    s3.upload_file(file_path, BUCKET_NAME, file_name)
    print(f"✅ Archivo '{file_name}' subido correctamente a S3 bucket '{BUCKET_NAME}'")
except Exception as e:
    print(f"❌ Error al subir archivo: {e}")
