def handler(event, context):
    print("Evento recibido:", event)
    return {
        "statusCode": 200,
        "body": "Lambda lista para limpieza."
    }
