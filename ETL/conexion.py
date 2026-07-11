import os
from pathlib import Path

import psycopg
from dotenv import load_dotenv


# Obtiene la carpeta principal del proyecto.
RUTA_PROYECTO = Path(__file__).resolve().parents[1]

# Busca el archivo .env en la raíz del proyecto.
RUTA_ENV = RUTA_PROYECTO / ".env"

# Carga las variables del archivo .env.
load_dotenv(RUTA_ENV)


def obtener_configuracion() -> dict:
    """
    Lee y valida la configuración necesaria para conectarse
    a PostgreSQL.
    """
    variables_requeridas = [
        "DB_HOST",
        "DB_PORT",
        "DB_NAME",
        "DB_USER",
        "DB_PASSWORD",
        "SOURCE_SCHEMA",
        "DW_SCHEMA",
    ]

    faltantes = [
        variable
        for variable in variables_requeridas
        if not os.getenv(variable)
    ]

    if faltantes:
        raise ValueError(
            "Faltan variables en el archivo .env: "
            + ", ".join(faltantes)
        )

    return {
        "host": os.getenv("DB_HOST"),
        "port": int(os.getenv("DB_PORT", "5432")),
        "dbname": os.getenv("DB_NAME"),
        "user": os.getenv("DB_USER"),
        "password": os.getenv("DB_PASSWORD"),
    }


def obtener_conexion() -> psycopg.Connection:
    """
    Crea y devuelve una conexión con PostgreSQL.
    """
    configuracion = obtener_configuracion()
    return psycopg.connect(**configuracion)


def probar_conexion() -> None:
    """
    Verifica la conexión y confirma que los dos esquemas
    del proyecto existen.
    """
    esquema_fuente = os.getenv("SOURCE_SCHEMA")
    esquema_dw = os.getenv("DW_SCHEMA")

    consulta_esquemas = """
        SELECT schema_name
        FROM information_schema.schemata
        WHERE schema_name IN (%s, %s)
        ORDER BY schema_name;
    """

    with obtener_conexion() as conexion:
        with conexion.cursor() as cursor:
            cursor.execute(
                "SELECT current_database(), current_user;"
            )
            base_datos, usuario = cursor.fetchone()

            cursor.execute(
                consulta_esquemas,
                (esquema_fuente, esquema_dw),
            )
            esquemas = [
                fila[0]
                for fila in cursor.fetchall()
            ]

    print("Conexión realizada correctamente.")
    print(f"Base de datos: {base_datos}")
    print(f"Usuario: {usuario}")
    print("Esquemas encontrados:")

    for esquema in esquemas:
        print(f"- {esquema}")

    esquemas_esperados = {
        esquema_fuente,
        esquema_dw,
    }

    if set(esquemas) != esquemas_esperados:
        raise RuntimeError(
            "La conexión funciona, pero no se encontraron "
            "todos los esquemas esperados."
        )


if __name__ == "__main__":
    try:
        probar_conexion()

    except Exception as error:
        print("No fue posible completar la prueba de conexión.")
        print(f"Detalle: {error}")
        raise SystemExit(1)