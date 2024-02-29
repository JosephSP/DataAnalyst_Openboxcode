-- Alumno: Jose Suarez
-- Modulo 6: ABP 4

---- Ejercicio  1----
  
-- a)  Usando subquerys, obtenga el valor total de los productos vendidos en la tabla detalle (cantidad *precio). 
SELECT 
	d.codigo_producto, 
	sum(d.cantidad) AS unidades_vendidas, 
	(SELECT p.precio FROM productos p WHERE p.codigo = d.codigo_producto) AS precio_producto,
	(SELECT p.precio * sum(d.cantidad) FROM productos p WHERE p.codigo = d.codigo_producto) AS total_vendido
FROM detalle d 
group by d.codigo_producto order by d.codigo_producto asc;

-- b)  Usando el cálculo anterior, agrupe los datos para mostrar el total por boleta. 
SELECT 
	d.numero_boleta,
	sum((SELECT p.precio * d.cantidad FROM productos p WHERE p.codigo = d.codigo_producto)) AS total_vendido
FROM detalle d 
group by d.numero_boleta order by d.numero_boleta asc;

-- c)  Qué  productos  están  por  encima  del  precio  promedio  de  todos  los productos. 
SELECT * FROM productos WHERE precio > (SELECT avg(precio) FROM productos)

-- d)  Crear  una  lista  que  traiga  el  número  de  boleta,  y  la  cantidad  de productos distintos comprados. 
SELECT
    numero AS numero_boleta,
    (SELECT COUNT(DISTINCT codigo_producto) FROM detalle d WHERE d.numero_boleta = b.numero) AS cantidad_productos_distintos
FROM boletas b;

-- e)  Crear  una  lista  que  traiga  el  número  de  boleta,  y  la  cantidad  de unidades compradas (entre todos los productos de la boleta). 
SELECT
    numero AS numero_boleta,
    (SELECT sum(cantidad) FROM detalle d WHERE d.numero_boleta = b.numero) AS cantidad_unidades_productos
FROM boletas b;

-- f) Crear una consulta que cree una lista de los usuarios que nunca han comprado. 
SELECT * FROM clientes c WHERE c.rut NOT IN (SELECT rut_cliente FROM boletas);
 
-- g)  Listar  los  productos,  su  precio,  y  la  cantidad  vendida  si  no  se  ha vendido, agregue un 0.
SELECT 
	*,
	CASE
		WHEN (SELECT SUM(d.cantidad) FROM detalle d WHERE d.codigo_producto = p.codigo) IS NULL THEN 0
		ELSE (SELECT SUM(d.cantidad) FROM detalle d WHERE d.codigo_producto = p.codigo) 
	END AS cantidad_vendida
FROM productos p ;
