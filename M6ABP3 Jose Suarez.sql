-- Alumno: Jose Suarez
-- Modulo 6: ABP 3

---- Ejercicio 1 ----

-- a)  Crear una lista de clientes, que contenga el nombre del cliente y su dirección. 
SELECT nombre, direccion FROM clientes;
 
-- b)  Buscar todos los productos cuyo precio sea superior a 1000. 

SELECT * FROM productos WHERE precio > 1000;

-- c)  Filtrar la lista de clientes para que no muestre clientes que no tengan email. 
SELECT * FROM clientes WHERE email is NOT NULL;

-- d)  Crear una lista con las boletas emitidas la segunda quincena de noviembre. 
SELECT * FROM boletas WHERE fecha >= '2023-11-15';

-- e)  ¿Cuál es el número total de clientes registrados? 
SELECT count(*) FROM clientes;

-- f) ¿Cuál es el producto más caro? ¿Cuál el más barato? 
SELECT max(precio) FROM productos;
SELECT min(precio) FROM productos;

-- g)  ¿Cuál es el promedio de unidades vendidas por boleta? 
SELECT numero_boleta, avg(cantidad) FROM detalle 
GROUP BY numero_boleta order by numero_boleta asc;
 
-- h)  ¿Cuantas Boletas han sido emitidas para cada usuario?
SELECT rut_cliente, count(rut_cliente) FROM boletas GROUP BY rut_cliente;

-- i) Seleccionar los productos (código y nombre) cuyo nombre NO contenga la letra 'o'. 
SELECT codigo, nombre FROM productos WHERE nombre NOT LIKE '%o%';
 
-- j) Seleccionar los números y fecha de las boletas que sean pares.
SELECT numero, fecha FROM boletas WHERE numero % 2 = 0;
