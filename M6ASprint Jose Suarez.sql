-- Alumno: Jose Suarez
-- Modulo 6: Sprint


-- 1. Crear  la  base  de  datos  y  su  estructura  con  los  datos  anteriormente 
-- descritos. 

CREATE DATABASE disquería;


CREATE TABLE Generos (
    id INT PRIMARY KEY NOT NULL,
	nombre VARCHAR(100)
);

CREATE TABLE Autores (
	id INT PRIMARY KEY NOT NULL,
	nombre VARCHAR(100),
	fecha_formacion DATE,
	id_genero INT NOT NULL,
	CONSTRAINT FK_id_genero
		FOREIGN KEY (id_genero) REFERENCES Generos(id)
);

CREATE TABLE Discos (
	id INT PRIMARY KEY NOT NULL,
	nombre VARCHAR(100),
	duracion INT,
	id_genero INT NOT NULL,
	id_autor INT NOT NULL,
	CONSTRAINT FK_id_genero FOREIGN KEY (id_genero) REFERENCES Generos(id),
	CONSTRAINT FK_id_autor FOREIGN KEY (id_autor) REFERENCES Autores(id)
);

CREATE TABLE Formatos (
	id INT PRIMARY KEY NOT NULL,
	nombre VARCHAR(100)
);

CREATE TABLE Productos (
	codigo INT PRIMARY KEY NOT NULL,
	id_disco INT,
	id_formato INT,
	precio INT,
	stock INT,
	CONSTRAINT FK_id_disco FOREIGN KEY (id_disco) REFERENCES Discos(id),
	CONSTRAINT FK_id_formato FOREIGN KEY (id_formato) REFERENCES Formatos(id)
);

-- 2. A partir de los archivos .csv entregados en conjunto con la evaluación, 
-- INSERTAR los datos para cada tabla (1 archivo por tabla). 

COPY Generos FROM 'N:\Joseph\Mat estudio\Analisis de datos OPENBOX CODE\modulo 6\sesion 21\Generos.csv' WITH (FORMAT CSV, HEADER, DELIMITER ',', ENCODING 'latin1');
COPY Autores FROM 'N:\Joseph\Mat estudio\Analisis de datos OPENBOX CODE\modulo 6\sesion 21\Autores.csv' WITH (FORMAT CSV, HEADER, DELIMITER ',', ENCODING 'latin1');
COPY Discos FROM 'N:\Joseph\Mat estudio\Analisis de datos OPENBOX CODE\modulo 6\sesion 21\Discos.csv' WITH (FORMAT CSV, HEADER, DELIMITER ',', ENCODING 'latin1');
COPY Formatos FROM 'N:\Joseph\Mat estudio\Analisis de datos OPENBOX CODE\modulo 6\sesion 21\Formatos.csv' WITH (FORMAT CSV, HEADER, DELIMITER ',', ENCODING 'latin1');
COPY Productos FROM 'N:\Joseph\Mat estudio\Analisis de datos OPENBOX CODE\modulo 6\sesion 21\Productos.csv' WITH (FORMAT CSV, HEADER, DELIMITER ',', ENCODING 'latin1');


-- 3. Revisar los datos de cada tabla mediante un SELECT *

SELECT * FROM Generos;
SELECT * FROM Autores;
SELECT * FROM Discos;
SELECT * FROM Productos;
SELECT * FROM Formatos;

-- 4. Existe un disco repetido en la tabla “Discos”. Crear una Query para 
-- detectarlo. Cuál es?
SELECT nombre FROM Discos GROUP BY nombre HAVING COUNT(*) >1;

-- 5. Ahora  que  sabemos  qué  disco  está  repetido,  cómo  sabremos  cual 
-- eliminar? Crear una Query para analizar este punto. 
SELECT MAX(id) FROM Discos WHERE nombre = (SELECT nombre FROM Discos GROUP BY nombre HAVING COUNT(*) >1);

-- 6. Según el análisis de la pregunta anterior, elimine el disco repetido. 
DELETE FROM Discos WHERE id = (SELECT MAX(id) FROM Discos WHERE nombre = (SELECT nombre FROM Discos GROUP BY nombre HAVING COUNT(*) >1));
SELECT * FROM Discos;

-- 7. ¿Cuantos discos hay? 
SELECT COUNT(*) FROM Discos;

-- 8. Cree una lista de artistas, y entregue la cantidad de discos de cada uno. 
SELECT A.nombre, COUNT(D.*) AS numero_de_discos
FROM Autores A
LEFT JOIN Discos D ON A.id = D.id_autor
GROUP BY A.nombre
ORDER BY numero_de_discos DESC;

-- 9. Crear  una  lista  de  géneros,  indicando  la  cantidad  de  discos  que 
-- pertenecen  a  cada  uno.  Si  hay  géneros  que  no  tienen  discos,  debe 
-- aparecer un 0.
SELECT G.nombre, COUNT(D.*) AS numero_de_discos
FROM Generos G
LEFT JOIN Discos D ON G.id = D.id_genero
GROUP BY G.nombre
ORDER BY numero_de_discos DESC;

-- 10. Indique  cuantos  discos  distintos  hay  en  bodega  (sin  importar  el 
-- formato). 
SELECT d.nombre, tmp.total FROM
(SELECT id_disco, SUM(stock) AS total FROM Productos GROUP BY id_disco ORDER BY id_disco) tmp
LEFT JOIN discos d ON tmp.id_disco = d.id;

-- 11. ¿Cual es, en promedio, el formato más caro? 
SELECT f.nombre, tmp.promedio_precio FROM
(SELECT id_formato, AVG(precio) AS promedio_precio 
FROM Productos GROUP BY id_formato 
ORDER BY promedio_precio DESC LIMIT 1) tmp
LEFT JOIN formatos f ON tmp.id_formato = f.id;

-- 12. Indique cual es el disco más caro que esté en formato vinilo y que sea 
-- de rock. 
SELECT 
	D.nombre, 
	P.precio, 
	F.nombre AS nombre_formato, 
	G.nombre AS nombre_genero 
FROM Productos P
LEFT JOIN Discos D ON P.id_disco = D.id
LEFT JOIN Formatos F ON P.id_formato = F.id
LEFT JOIN Generos G ON D.id_genero = G.id
WHERE 
	F.nombre = 'Vinilo' AND
	G.nombre = 'Rock'
ORDER BY P.precio DESC LIMIT 1
;


-- 13. Crear una lista de cada producto, indicando el nombre, el género, el 
-- artista, el formato, el precio y el stock. Ordenado de más caro a más 
-- barato y por formato. 
SELECT 
	D.nombre AS nombre_disco,
	G.nombre AS nombre_genero,
	A.nombre AS nombre_artista,
	F.nombre AS nombre_formato, 
	P.precio, 
	P.stock
FROM Productos P
LEFT JOIN Discos D ON P.id_disco = D.id
LEFT JOIN Formatos F ON P.id_formato = F.id
LEFT JOIN Generos G ON D.id_genero = G.id
LEFT JOIN Autores A ON D.id_autor = A.id
ORDER BY P.precio DESC, F.nombre;

-- 14. ¿Cuál es el disco que más se repite en los productos?
SELECT D.nombre, tmp.repeticiones_producto
FROM
(SELECT id_disco, COUNT(id_disco) AS repeticiones_producto 
FROM Productos GROUP BY id_disco 
ORDER BY repeticiones_producto DESC LIMIT 1) AS tmp
LEFT JOIN Discos D ON tmp.id_disco = D.id;

-- 15. Indique  cuales  son  los  artistas  que  se  formaron  en  los  años  80  y 
-- cuanto  suman  sus  productos  en  bodega.  ¿Cuál  es  el  que  más  dinero 
-- valen sus productos almacenados? 
SELECT 
	A.nombre AS nombre_artista,
	COALESCE(SUM(P.precio * P.stock), 0) AS total_ventas
FROM
(SELECT * FROM Autores 
 WHERE fecha_formacion >= '1980-01-01' AND fecha_formacion < '1990-01-01') A
LEFT JOIN Discos D ON A.id = D.id_autor
LEFT JOIN Productos P ON D.id = P.id_disco
GROUP BY A.nombre ORDER BY total_ventas DESC
;

-- El que tiene mas dinero en nuestra bodega es:
SELECT 
	A.nombre AS nombre_artista,
	COALESCE(SUM(P.precio * P.stock), 0) AS total_ventas
FROM
(SELECT * FROM Autores 
 WHERE fecha_formacion >= '1980-01-01' AND fecha_formacion < '1990-01-01') A
LEFT JOIN Discos D ON A.id = D.id_autor
LEFT JOIN Productos P ON D.id = P.id_disco
GROUP BY A.nombre ORDER BY total_ventas DESC LIMIT 1
;

-- 16. ¿Cuál  es el  valor  de  toda  la  bodega, sin  considerar  el  dinero  de  los 
-- productos digitales? 
SELECT SUM(precio * stock) FROM Productos WHERE id_formato != (SELECT id FROM formatos WHERE nombre = 'Digital');

-- 17. Un ladrón entró a la bodega y se llevó todos los cd de red hot chili 
-- peppers y guns n roses del estante. ¿Cuánto dinero perdió el negocio? 
SELECT SUM(P.precio * P.stock) AS total_robado FROM Productos P
LEFT JOIN Discos D ON P.id_disco = D.id
WHERE D.id_autor IN (SELECT id FROM Autores WHERE nombre = 'Guns N Roses' OR nombre = 'Red Hot Chili Peppers')

-- 18. Se  está  pensando  en  comprar  más  material  para  la  bodega  y  así 
-- diversificar la colección. ¿De qué géneros musicales debería 
-- comprarse? Al mismo tiempo, se quiere liquidar stock. ¿Qué productos 
-- debería liquidarse?

-- Para diversificar se recomienda comprar todos los generos que no tienen stock
SELECT 
	G.nombre AS nombre_genero,
	COALESCE(SUM(P.stock), 0) AS stock
FROM Generos G
LEFT JOIN Discos D ON D.id_genero = G.id
LEFT JOIN 
	(SELECT id_disco, sum(stock) AS stock 
	 FROM productos GROUP BY id_disco) P 
ON P.id_disco = D.id
GROUP BY nombre_genero
HAVING COALESCE(SUM(P.stock), 0) = 0;

-- Se recomienda liquidar los 3 productos con mas stock en el inventario
SELECT 
	D.nombre AS nombre_disco,
	SUM(P.stock) AS stock
FROM
(SELECT id_disco, sum(stock) AS stock FROM productos GROUP BY id_disco) p
LEFT JOIN Discos D ON P.id_disco = D.id
LEFT JOIN Generos G ON D.id_genero = G.id
GROUP BY nombre_disco
ORDER BY stock DESC LIMIT 3;
