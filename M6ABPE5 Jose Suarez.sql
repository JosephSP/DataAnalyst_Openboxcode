-- Alumno: Jose Suarez
-- Modulo 6: ABP 5

---- Ejercicio  1----
 
-- a)  Para la tabla de detalle, obtener la lista de productos vendido por boleta, pero esta vez mostrar el nombre del producto y el monto vendido del producto. 
SELECT d.numero_boleta, d.codigo_producto, d.cantidad, p.nombre, p.precio
FROM detalle d 
LEFT JOIN boletas b ON d.numero_boleta = b.numero 
LEFT JOIN productos p ON d.codigo_producto = p.codigo;

-- b)  Crear una lista de usuarios, y agregar la cantidad de dinero gastado en compras. Si no ha comprado nunca, se le debe agregar un 0. 
SELECT c.nombre, COALESCE(SUM(p.precio * d.cantidad), 0)
FROM detalle d 
LEFT JOIN boletas b ON d.numero_boleta = b.numero 
LEFT JOIN productos p ON d.codigo_producto = p.codigo
RIGHT JOIN clientes c ON c.rut = b.rut_cliente
GROUP BY c.nombre;
 
-- c)  Crear la lista de Boletas, y agregar el nombre del cliente a quien le pertenece. Usar número, fecha, nombre cliente, email cliente. Si el cliente no tiene email, remplazarlo por “Sin información”. 
SELECT b.numero, b.fecha, c.nombre, 
	CASE 
		WHEN c.email IS NULL THEN 'Sin Informacion' 
		ELSE c.email
	END
FROM clientes c 
RIGHT JOIN boletas b ON c.rut = b.rut_cliente;