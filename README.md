# 🧼 Automatización de Limpieza de Archivos CSV con AWS Lambda y S3
```
## 📌 Objetivo

Mi objetivo en este proyecto fue automatizar el proceso de limpieza de archivos CSV utilizando servicios nativos de AWS como S3, Lambda y Terraform, integrando además GitHub Actions para una infraestructura reproducible y continua.

## 🚀 Arquitectura Implementada
```
```
mermaid
graph TD
  A[Subida CSV a S3 (bucket-data-2)] --> B[Lambda: generador_de_archivos_limpios]
  B --> C[Limpieza y conversión CSV a JSON]
  C --> D[Almacenamiento en bucket-json-clear]
  D --> E[Disponible para consulta desde EC2/API]

```
```

## ⚙️ Servicios Utilizados

| Servicio       | Descripción                                                                           |
| -------------- | ------------------------------------------------------------------------------------- |
| S3             | Almacena archivos originales (bucket-data-2) y los datos limpios (bucket-json-clear). |
| Lambda         | Función `generador_de_archivos_limpios` encargada de procesar los archivos.           |
| IAM            | Permisos específicos para que Lambda pueda leer/escribir en ambos buckets.            |
| Terraform      | Infraestructura como código para desplegar todo automáticamente.                      |
| GitHub Actions | Automatiza el despliegue al hacer push en el repositorio.                             |

## 🧪 Flujo de Trabajo

1. Subo un archivo CSV al bucket `bucket-data-2`
2. S3 detecta automáticamente el nuevo archivo y dispara un evento
3. Se ejecuta la Lambda `generador_de_archivos_limpios`
4. La función descarga, limpia y transforma el CSV a JSON
5. El JSON limpio se guarda en el bucket `bucket-json-clear`

## 📁 Estructura del Proyecto

```plaintext
.
├── terraform/
│   ├── main.tf            # Infraestructura S3, Lambda, IAM
│   ├── variables.tf       # Variables reutilizables
│   ├── outputs.tf         # Valores de salida útiles
│   ├── lambda_code/       # Submódulo con el código Lambda
│   │   └── index.py       # Lógica de limpieza
├── .github/
│   └── workflows/
│       └── deploy.yml     # GitHub Actions: despliegue automático con Terraform
├── upload.py              # Script local para subir archivos CSV a S3
└── README.md              # Este documento
```
```
## 🧼 Funcionalidad de Limpieza (Lambda)

La función Lambda `index.py` detecta y corrige automáticamente errores comunes en los CSV:

- ✅ Columnas vacías
- ✅ Correos mal formateados
- ✅ Campos duplicados
- ✅ Fechas inválidas
- ✅ Conversión de tipos de datos (números como texto, etc.)

→ El resultado se transforma en JSON limpio y estructurado.

## 🤝 Submódulo Git

El código Lambda se encuentra en un repositorio separado, vinculado como submódulo:

```bash
git submodule add https://github.com/r0naldy/lambda-limpieza.git terraform/lambda_code
```
```
Esto permite mantener separado el código de infraestructura del código de aplicación, pero gestionarlos juntos en el mismo proyecto.

## 📦 Despliegue Automático

Cada vez que hago un push a la rama `main`, se ejecuta el archivo:

```yaml
.github/workflows/deploy.yml
```
```
Este flujo lanza automáticamente Terraform para:

- ✅ Crear/actualizar los buckets S3
- ✅ Desplegar o actualizar la Lambda
- ✅ Configurar los triggers de S3

## 📝 Conclusión

Este proyecto demuestra cómo con herramientas como Terraform, AWS Lambda y S3 puedo construir un sistema serverless, limpio y escalable para transformar datos automáticamente desde una carga simple a través de la nube.

> ✅ Todo queda automatizado: desde el `git push` hasta el procesamiento completo de los archivos cargados en S3.
