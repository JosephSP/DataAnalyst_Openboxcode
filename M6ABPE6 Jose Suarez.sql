-- Alumno: Jose Suarez
-- Modulo 6: ABP 6

---- Ejercicio  1----

-- a)  La  primera  función que crearemos, será  generar  un  listado de  venta de los productos. 
--     Una función que reciba como parámetro el código del producto, y devuelva las unidades vendidas totales. 
CREATE OR REPLACE FUNCTION listado_venta(id_producto INT)
RETURNS INT AS $$
DECLARE
     total_vendido INT;
BEGIN
    SELECT sum(cantidad) INTO total_vendido
    FROM detalle
    WHERE  codigo_producto = id_producto;
    
    RETURN total_vendido;
END;
$$ LANGUAGE plpgsql;

SELECT listado_venta(111);

 
-- b)  Ahora haremos algo parecido, crearemos una función que reciba como parámetro  una  boleta, 
--     y  nos  devuelva  el  nombre  de  la  persona  a  la que pertenece, la fecha, y su subtotal, iva y total.


CREATE OR REPLACE FUNCTION datos_boleta(id_boleta INT)
RETURNS TABLE (nombre VARCHAR, fecha DATE, subtotal BIGINT, iva NUMERIC, total NUMERIC) AS $$
BEGIN
	RETURN QUERY
    SELECT 
		cli.nombre, 
		cli.fecha, 
		tot.subtotal, 
		tot.subtotal * 0.19 AS iva, 
		tot.subtotal * 1.19 as total
	FROM
		(SELECT 
			d.numero_boleta,
			sum((SELECT p.precio * d.cantidad FROM productos p WHERE p.codigo = d.codigo_producto)) AS subtotal
		FROM detalle d 
		group by d.numero_boleta) AS tot
	LEFT JOIN
		(SELECT b.numero, c.nombre, b.fecha
		FROM boletas b
		LEFT JOIN clientes c ON b.rut_cliente = c.rut) AS cli
	ON tot.numero_boleta = cli.numero
	WHERE tot.numero_boleta = id_boleta;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM datos_boleta(1);




