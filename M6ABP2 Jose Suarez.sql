-- Alumno: Jose Suarez
-- Modulo 6: ABP 2

---- Ejercicio 1 ----
-- 1.a) Crear las tablas segun diagrama

-- Primero creamos la base de datos
CREATE DATABASE supermercadoabp2;

-- Luego generamos las 4 tablas contenedoras con sus columnas correspondientes y los tipos de datos que almacenaran

CREATE TABLE clientes (
    rut VARCHAR(20) PRIMARY KEY NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    direccion VARCHAR(255),
    comuna VARCHAR(50),
    fecha_nacimiento DATE CHECK (fecha_nacimiento > '1900-01-01'),
    telefono INT
);

CREATE TABLE boletas (
    numero INT PRIMARY KEY NOT NULL,
    fecha DATE CHECK (fecha > '1900-01-01'),
	rut_cliente VARCHAR(20) NOT NULL,
    CONSTRAINT rut_cliente FOREIGN KEY (rut_cliente) REFERENCES clientes(rut)
);

CREATE TABLE productos (
    codigo INT PRIMARY KEY NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    precio INT NOT NULL
);

CREATE TABLE detalle (
	numero_boleta INT NOT NULL,
    CONSTRAINT numero_boleta
        FOREIGN KEY (numero_boleta) 
            REFERENCES boletas(numero),
	codigo_producto INT NOT NULL,
    CONSTRAINT codigo_producto
        FOREIGN KEY (codigo_producto) 
            REFERENCES productos(codigo),
    cantidad INT NOT NULL,
	PRIMARY KEY (numero_boleta, codigo_producto)
);

-- 1.b) importar datos desde CSV's

-- Para poder copiar los datos desde el CSV es necesario crear una tabla temporal que contenga las mismas columnas que el CSV
CREATE TEMPORARY TABLE temp_clientes (
    rut VARCHAR(20),
    nombre VARCHAR(255),
    direccion VARCHAR(255),
    comuna VARCHAR(50),
    fecha_nacimiento DATE,
    telefono INT,
    email VARCHAR(255) -- Include email column
);

-- Importamos el Archivo a la tabla temporal
COPY temp_clientes FROM 'N:\Joseph\Mat estudio\Analisis de datos OPENBOX CODE\modulo 6\clientes.csv' 
WITH (FORMAT CSV, HEADER, DELIMITER ',', ENCODING 'latin1');

-- insertamos las columnas de interes desde la tabla temporal a la tabla clientes
INSERT INTO clientes (rut, nombre, direccion, comuna, fecha_nacimiento, telefono)
SELECT rut, nombre, direccion, comuna, fecha_nacimiento, telefono
FROM temp_clientes;

-- Botamos la tabla temporal
DROP TABLE temp_clientes;


-- Copiamos el resto de datos de los otros CSV's que no tienen columnas extras
COPY boletas FROM 'N:\Joseph\Mat estudio\Analisis de datos OPENBOX CODE\modulo 6\boletas.csv' 
WITH (FORMAT CSV, HEADER, DELIMITER ',', ENCODING 'latin1');

COPY productos FROM 'N:\Joseph\Mat estudio\Analisis de datos OPENBOX CODE\modulo 6\productos.csv' 
WITH (FORMAT CSV, HEADER, DELIMITER ',', ENCODING 'latin1');

COPY detalle FROM 'N:\Joseph\Mat estudio\Analisis de datos OPENBOX CODE\modulo 6\detalle.csv' 
WITH (FORMAT CSV, HEADER, DELIMITER ',', ENCODING 'latin1');


SELECT * FROM clientes;


---- Ejercicio 2 ----

-- -- 2.a) crear DB prueba
-- CREATE DATABASE prueba;

-- -- 2.b) crear Tablas
-- CREATE TABLE JOBS (
--     JOB_ID VARCHAR(10) PRIMARY KEY NOT NULL,
--     JOB_TITLE VARCHAR(35) NOT NULL,
--     MIN_SALARY NUMERIC(6),
--     MAX_SALARY NUMERIC(6),
-- );

-- CREATE TABLE EMPLOYEES (
--     EMPLOYEES_ID NUMERIC(6) PRIMARY KEY NOT NULL,
--     FIRST_NAME VARCHAR(20),
--     LAST_NAME VARCHAR(25) NOT NULL,
--     EMAIL VARCHAR(25) NOT NULL,
--     PHONE_NUMBER VARCHAR(20),
--     HIRE_DATE timestamp NOT NULL,
--     JOB_ID VARCHAR(10) NOT NULL,
--     SALARY NUMERIC(8,2),
--     COMMISSION_PTC NUMERIC(2,2),
--     CONSTRAINT FK_JOBS
--         FOREIGN KEY (JOB_ID) 
--             REFERENCES jobs(JOB_ID),
--     MANAGER_ID NUMERIC(6),
--     CONSTRAINT FK_MANAGER
--         FOREIGN KEY (MANAGER_ID) 
--             REFERENCES EMPLOYEES(EMPLOYEES_ID),
--     DEPARTMENT_ID NUMERIC(6),
--     CONSTRAINT FK_MANAGER
--         FOREIGN KEY (DEPARTMENT_ID) 
--             REFERENCES EMPLOYEES(DEPARTMENT_ID),
--     BEN_ID NUMERIC(2)
-- );



-- CREATE TABLE JOB_HISTORY (
--     EMPLOYEES_ID NUMERIC(6) NOT NULL,
--     CONSTRAINT FK_JOBS
--         FOREIGN KEY (EMPLOYEES_ID) 
--             REFERENCES EMPLOYEES(EMPLOYEES_ID),
--     job_history VARCHAR(10) NOT NULL,
--     CONSTRAINT FK_JOBS
--         FOREIGN KEY (job_history) 
--             REFERENCES jobs(JOB_ID),
    
    
-- );