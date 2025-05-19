# **ETL para la carga de *`datasets`* de transferencias de *`vehiculos`* en Argentina**

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![Apache Superset](https://img.shields.io/badge/Apache_Superset-FF5733?style=for-the-badge&logo=apache-superset&logoColor=white)
![pgAdmin](https://img.shields.io/badge/pgAdmin-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Argentina](https://img.shields.io/badge/Argentina-74ACDF?style=for-the-badge&logo=flag&logoColor=white)


## **Descarga de Datasets**

Los datasets utilizados en este proyecto pueden descargarse desde el portal oficial de datos abiertos del gobierno de Argentina:  
[https://datos.gob.ar/dataset](https://datos.gob.ar/dataset)

Este portal proporciona información pública en formatos reutilizables, incluyendo datos relacionados con transferencias de vehiculos en Argentina.

## **Resumen del Tutorial**

Este tutorial guía al usuario a través de los pasos necesarios para desplegar una infraestructura ETL utilizando Docker, PostgreSQL, Apache Superset y pgAdmin. Se incluyen instrucciones detalladas para:

1. Levantar los servicios con Docker.
2. Configurar la conexión a la base de datos en Apache Superset
3. Ejecutar consultas SQL para analizar los datos de casos de transferencias.

## **Palabras Clave**

- Docker
- PostgreSQL
- Apache Superset
- pgAdmin
- ETL
- Visualización de Datos

## **Mantenido Por**

**GRUPO12**

## **Descargo de Responsabilidad**

El código proporcionado se ofrece "tal cual", sin garantía de ningún tipo, expresa o implícita. En ningún caso los autores o titulares de derechos de autor serán responsables de cualquier reclamo, daño u otra responsabilidad.


## **Descripción del Proyecto**

Este proyecto implementa un proceso ETL (Extract, Transform, Load) para la carga y análisis de datos relacionados con transferencias de vehiculos en Argentina. Utiliza herramientas modernas como Docker, PostgreSQL, Apache Superset y pgAdmin para facilitar la gestión, análisis y visualización de datos.

El objetivo principal es proporcionar una solución escalable y reproducible para analizar datos de transferencias de vehiculos por registros secional, departamento y provincia, permitiendo la creación de tableros interactivos.

## **Características Principales**

- **Infraestructura Contenerizada:** Uso de Docker para simplificar la configuración y despliegue.
- **Base de Datos Relacional:** PostgreSQL para almacenar y gestionar los datos.
- **Visualización de Datos:** Apache Superset para crear gráficos y tableros interactivos.
- **Gestión de Base de Datos:** pgAdmin para administrar y consultar la base de datos.

## **Requisitos Previos**

Antes de comenzar, asegúrate de tener instalados los siguientes componentes:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- Navegador web para acceder a Apache Superset y pgAdmin.

## **Servicios Definidos en Docker Compose**

El archivo `docker-compose.yml` define los siguientes servicios:

1. **Base de Datos (PostgreSQL):**
   - Imagen: `postgres:alpine`
   - Puertos: `5432:5432`
   - Volúmenes:
     - `postgres-db:/var/lib/postgresql/data` (almacenamiento persistente de datos)
     - `./scripts:/docker-entrypoint-initdb.d` (scripts de inicialización)
     - `./datos:/datos` (directorio para datos adicionales)
   - Variables de entorno:
     - Configuradas en el archivo `.env.db`
   - Healthcheck:
     - Comando: `pg_isready`
     - Intervalo: 10 segundos
     - Retries: 5

2. **Apache Superset:**
   - Imagen: `apache/superset:4.0.0`
   - Puertos: `8088:8088`
   - Dependencias:
     - Depende del servicio `db` y espera a que esté saludable.
   - Variables de entorno:
     - Configuradas en el archivo `.env.db`

3. **pgAdmin:**
   - Imagen: `dpage/pgadmin4`
   - Puertos: `5050:80`
   - Dependencias:
     - Depende del servicio `db` y espera a que esté saludable.
   - Variables de entorno:
     - Configuradas en el archivo `.env.db`

## **Instrucciones de Configuración**

1. **Clonar el repositorio:**
   ```sh
   git clone <URL_DEL_REPOSITORIO>
   cd postgres-etl
   ```

2. **Configurar el archivo `.env.db`:**
   Crea un archivo `.env.db` en la raíz del proyecto con las siguientes variables de entorno:
   ```env
    #Definimos cada variable
    DATABASE_HOST=db
    DATABASE_PORT=5432
    DATABASE_NAME=postgres
    DATABASE_USER=postgres
    DATABASE_PASSWORD=postgres
    POSTGRES_INITDB_ARGS="--auth-host=scram-sha-256 --auth-local=trust"
    # Configuracion para inicializar postgres
    POSTGRES_PASSWORD=${DATABASE_PASSWORD}
    PGUSER=${DATABASE_USER}
    # Configuracion para inicializar pgadmin
    PGADMIN_DEFAULT_EMAIL=postgres@postgresql.com
    PGADMIN_DEFAULT_PASSWORD=${DATABASE_PASSWORD}
    # Configuracion para inicializar superset
    SUPERSET_SECRET_KEY=your_secret_key_here
   ```

3. **Levantar los servicios:**
   Ejecuta los siguientes comandos para iniciar los contenedores:
   ```sh
   docker compose up -d
   . init.sh
   ```

4. **Acceso a las herramientas:**
   - **Apache Superset:** [http://localhost:8088/](http://localhost:8088/)  
     Credenciales predeterminadas: ***`admin/admin`***
   - **pgAdmin:** [http://localhost:5050/](http://localhost:5050/)  
     Configura la conexión a PostgreSQL utilizando las credenciales definidas en el archivo `.env.db`.

## **Uso del Proyecto**

### **1. Configuración de la Base de Datos**

Accede a Apache Superset y crea una conexión a la base de datos PostgreSQL en la sección ***`Settings`***. Asegúrate de que la conexión sea exitosa antes de proceder.

### **2. Consultas SQL**

#### **Consulta 1:Muestra cuantas transferencias de vehiculos ocurrieron agrupando por registro seccional y anio del vehiculo **
```sql
SELECT
    registro_seccional.descripcion AS registro_seccional_descripcion,
    automotor.automotor_anio_modelo,
    COUNT(*) AS cantidad
FROM
    transferencia
    INNER JOIN automotor ON transferencia.automotor_id = automotor.id
    INNER JOIN registro_seccional ON automotor.registro_seccional_id = registro_seccional.id
GROUP BY
    registro_seccional.descripcion,
    automotor.automotor_anio_modelo;
```

#### **Consulta 2:Cuenta la cantidad de transferencias por fecha del trámite y origen del automotor (nacional, importado, etc.), y ordena los resultados por fecha descendente (más reciente primero).**
```sql
SELECT
    automotor.tramite_fecha,
    automotor.automotor_origen,
    COUNT(*) AS cantidad
FROM
    transferencia
    INNER JOIN automotor ON transferencia.automotor_id = automotor.id
GROUP BY
    automotor.tramite_fecha,
    automotor.automotor_origen
ORDER BY
    automotor.tramite_fecha DESC;
```

#### **Consulta 3: Agrupa y cuenta la cantidad de transferencias por código y descripción del tipo de automotor y descripción del modelo del automotor**
```sql
SELECT
    tipo_automotor.codigo AS automotor_tipo_codigo,
    tipo_automotor.descripcion AS automotor_tipo_descripcion,
    automotor.modelo_descripcion AS automotor_modelo_descripcion,
    COUNT(*) AS cantidad
FROM
    transferencia
    INNER JOIN automotor ON transferencia.automotor_id = automotor.id
    INNER JOIN tipo_automotor ON automotor.tipo_automotor_id = tipo_automotor.id
GROUP BY
    tipo_automotor.codigo,
    tipo_automotor.descripcion,
    automotor.modelo_descripcion;
```

## **Estructura del Proyecto**

```
postgres-etl-transferencias/
├── docker-compose.yml       # Configuración de Docker Compose
├── init.sh                  # Script de inicialización
├── datos/                   # Carpeta para almacenar datasets
├── consultas_sql/           # Consultas SQL predefinidas
└── README.md                # Documentación del proyecto
```
