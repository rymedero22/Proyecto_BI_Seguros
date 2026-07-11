# Proyecto BI - Seguros Alta Vista

## Integrantes

- Daniela Silva
- Samuel Velásquez
- Rosxana Medero

## Herramientas

- PostgreSQL
- pgAdmin 4
- Python
- Power BI Desktop

## Estructura

- `sql`: scripts para crear y poblar la base de datos.
- `etl`: procesos ETL desarrollados en Python.
- `datos`: archivos fuente externos, si se requieren.
- `power_bi`: dashboard final del proyecto.

## Ejecución

### 1. Crear el entorno virtual

Desde la carpeta principal del proyecto:

```powershell
py -m venv .venv
.\.venv\Scripts\Activate.ps1
```

Si PowerShell bloquea la activación:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\.venv\Scripts\Activate.ps1
```

### 2. Instalar las dependencias

```powershell
python -m pip install -r requirements.txt
```

### 3. Crear la base de datos

En pgAdmin 4 crear una base de datos con:

```text
Nombre: seguros_bi
Propietario: postgres
```

### 4. Ejecutar los scripts SQL

Abrir el Query Tool de la base `seguros_bi` y ejecutar los archivos de la carpeta `sql` en este orden:

```text
01_crear_esquemas.sql
02_crear_modelo_transaccional.sql
03_crear_datawarehouse.sql
04_insertar_datos_prueba.sql
```

Los esquemas utilizados son:

- `seguro_g29969634`: modelo transaccional.
- `seguro_dw_g29969634`: Data Warehouse.

### 5. Configurar la conexión

Copiar el archivo `.env.example` y renombrar la copia como `.env`:

```powershell
Copy-Item .env.example .env
```

Luego colocar la contraseña local de PostgreSQL en:

```env
DB_PASSWORD="CONTRASENA_LOCAL"
```

### 6. Probar la conexión

```powershell
python etl/conexion.py
```

La prueba debe confirmar la conexión con la base `seguros_bi` y mostrar los dos esquemas del proyecto.
