/*
Ejercicio 1.1 Editar el fichero pp.sql en el directorio de trabajo, debe contener las instrucciones:
CREATE TABLE prueba2(
cad1 char(8),
num int);
a continuación ejecutar el fichero. Mediante esta sentencia hemos creado una tabla vacía
llamada prueba2 con dos atributos, cad1 y num. Para comprobarlo, es necesario consultar el
catálogo de la base de datos o ejecutar un comando describe, como veremos a continuación
*/

CREATE TABLE prueba2(
cad1 char(8),
num int);

/*
Ejercicio 1.2 Ver la descripción de las tablas prueba1, prueba2.
*/

DESCRIBE prueba1;
DESCRIBE prueba2;

/*
Ejercicio 1.3 Buscar la lista completa de los tipos de datos que ofrece Oracle® (Data types).
Para ello debe consultarse el apartado correspondiente del manual de referencia de SQL de
Oracle® [5].
*/

+

/*
Ejercicio 1.5 Borrar la tabla prueba1 y comprobar las tablas que quedan.
*/

DROP TABLE prueba1;
SELECT table_name FROM ALL_TABLES;

/*
Ejercicio 1.6 Modifica el esquema de la tabla plantilla añadiendo un nuevo atributo llamado
fechabaja de tipo date. 
*/

ALTER TABLE plantilla
ADD fechabaja date;

/*
Ejercicio 1.7 Comprobar que se ha cambiado correctamente el esquema de la tabla Ventas.
La descripción de la tabla debe contener los siguientes campos:
Name Null? Type
------------------------------- -------- ----
CODPRO NOT NULL CHAR(3)
CODPIE NOT NULL CHAR(3)
CODPJ NOT NULL CHAR(3)
CANTIDAD NUMBER(4)
*/

ALTER TABLE ventas
ADD fecha date;

/*
Ejercicio 1.8 Dado el esquema siguiente de la base de datos de una liga de baloncesto:
Equipos (codE, nombreE, localidad, entrenador, fecha_crea)
Jugadores (codJ, codE, nombreJ)
Encuentros(ELocal, EVisitante, fecha, PLocal,PVisitante)
Faltas (codJ, ELocal, EVisitante, num)
Se pide que se cree dicho esquema con las siguientes restricciones de diseño:
Equipos: No se debe permitir que ninguno de los atributos tome valor nulo, además, el
nombre del equipo ha de ser único.
Jugadores: No se debe permitir valor nulo ni en nombreJ, ni en el equipo al que pertenece.
Encuentros: Los encuentros se realizan entre equipos de la liga, cada uno de los atributos
ELocal y EVisitante es clave externa a la tabla Equipos. Los resultados PLocal y
PVisitante (tantos marcados por ELocal y por EVisitante, respectivamente) han
de ser positivos y tomar 0 como valor por defecto.
Faltas: Representan la cantidad de faltas personales cometidas por un jugador en el encuentro indicado. El conjunto de atributos formado por ELocal y EVisitante son clave externa a la tabla Encuentros y el atributo codJ es clave externa a la tabla Jugadores.
El número de faltas num estará comprendido entre 0 y 5, ambos incluidos y debe tomar 0 como valor por defecto.
*/
CREATE TABLE Equipos(
	codE NUMBER NOT NULL PRIMARY KEY,
	nombreE VARCHAR(10) NOT NULL UNIQUE,
	localidad VARCHAR(20) NOT NULL,
	entrenador VARCHAR(20) NOT NULL,
	fecha_crea DATE NOT NULL
);

CREATE TABLE Jugadores(
	codJ NUMBER PRIMARY KEY,
	codE NUMBER NOT NULL,
	nombreJ VARCHAR(20) NOT NULL,
	FOREIGN KEY (codE) REFERENCES Equipos(codE)
);

CREATE TABLE Encuentros(
	ELocal NUMBER DEFAULT 0 CHECK (ELocal>0) REFERENCES Equipos(codE),
	EVisitante NUMBER DEFAULT 0 CHECK (EVisitante>0) REFERENCES Equipos(codE),
	fecha DATE,
	PLocal NUMBER DEFAULT 0 CHECK (PLocal>0),
	PVisitante NUMBER DEFAULT 0 CHECK (PVisitante>0),
	PRIMARY KEY (ELocal, EVisitante)
);

CREATE TABLE Faltas(
	codJ NUMBER,
	ELocal NUMBER,
	EVisitante NUMBER,
	num NUMBER DEFAULT 0 CHECK (num >= 0 and num<=5),
	FOREIGN KEY (ELocal,EVisitante )REFERENCES Encuentros(ELocal, EVisitante),
	FOREIGN KEY (codJ) REFERENCES Jugadores(codJ)
);

/*
Ejercicio 2.1 Ejecuta la sentencia SELECT para mostrar el contenido de las tablas PRUEBA2
y PLANTILLA. Intenta mostrar solo algunos campos de las mismas.
*/

SELECT * FROM PRUEBA2;
SELECT * FROM PLANTILLA;
SELECT cad1 FROM PRUEBA2;
SELECT dni, nombre FROM PLANTILLA;

/*
Ejercicio 2.2 Ejecuta la sentencia UPDATE sobre la tabla plantilla y cambia el nombre del
trabajador con dni ’12345678’ a ’Luis’.
*/

UPDATE plantilla
SET nombre = 'Luis'
WHERE dni='12345678';

/* 
Ejercicio 2.3 Borra todas las tuplas de la tabla plantilla.
*/
DELETE FROM plantilla; --error: porque la tabla SERJEFE tiene REFERENCES a PLANTILLA
DELETE FROM serjefe; -- ok

/*
Ejercicio 2.4 A continuación vamos a tratar de insertar algunas tuplas nuevas en ventas.
Comprueba que se introducen correctamente y, en caso contrario, razona por qué da error.
*/
INSERT INTO ventas VALUES ('S3', 'P1', 'J1', 150, '24/12/05'); --ok
INSERT INTO ventas (codpro, codpj) VALUES ('S4', 'J2'); --error: hay una mas PRIMARY KEY - codpie
INSERT INTO ventas VALUES('S5','P3','J6',400,TO_DATE('25/12/00')); --error: no hay clave externa 'J6' en la tabla PROYECTO

/*
Ejercicio 2.5 Actualizar la fecha del proveedor S5 al año 2005
*/

UPDATE ventas
SET fecha = TO_DATE(2005,'YYYY')
WHERE codpro='S5';

/*
Ejercicio 2.6 Para mostrar la columna FECHA con un formato específico e imprimirla,
utilizar la siguiente sentencia:
*/

SELECT codpro,codpie,
TO_CHAR(fecha,'"Dia" day,dd/mm/yy') FROM ventas;
--donde el texto que se quiere incluir como parte de la fecha debe ir entre comillas dobles.

/*
Ejercicio 2.7 Preparar un archivo para la introducción de datos en las tablas Equipos,
Jugadores, Encuentros y Faltas de la base de datos sobre baloncestos creada en la sección
1.8, para que nos permitan realizar consultas con resultados significativos, conforme a los
siguientes criterios:
Que se inserten 4 equipos con 5 jugadores en cada uno.
Que se inserten 10 encuentros (no se ha terminado la liga).
Que se inserten los resultados de esos encuentros dejando un único equipo invicto.
*/

INSERT INTO Equipos VALUES ('E1','Equipo 1','Madrid','Jose', TO_DATE('02/04/1995','dd/mm/yyyy'));
INSERT INTO Equipos VALUES ('E2','Equipo 2','Granada','Francisko', TO_DATE('13/11/2001','dd/mm/yyyy'));
INSERT INTO Equipos VALUES ('E3','Equipo 3','Barcelona','Nikolas', TO_DATE('08/02/1991','dd/mm/yyyy'));
INSERT INTO Equipos VALUES ('E4','Equipo 4','Cadiz','Miguel', TO_DATE('09/08/2008','dd/mm/yyyy'));

INSERT INTO jugadores VALUES ('J1','E1','Pepe')
INSERT INTO jugadores VALUES ('J2','E1','Juan')
INSERT INTO jugadores VALUES ('J3','E1','Evaristo')

INSERT INTO jugadores VALUES ('J4','E2','Torcuato')
INSERT INTO jugadores VALUES ('J5','E2','Baldomero')
INSERT INTO jugadores VALUES ('J6','E2','Ermenegildo')

INSERT INTO jugadores VALUES ('J7','E3','Mariano')
INSERT INTO jugadores VALUES ('J8','E3','Andres')
INSERT INTO jugadores VALUES ('J9','E3','Antonio')

INSERT INTO jugadores VALUES ('J10','E4','Ana')
INSERT INTO jugadores VALUES ('J11','E4','Bob')
INSERT INTO jugadores VALUES ('J12','E4','Casl')

/*
Ejercicio 3.1 Comprueba el resultado de la proyección. ¿Es este conforme a lo que se obtiene
en el AR? 
*/

SELECT DISTINCT ciudad FROM proyecto;

/*
Ejercicio 3.2 Muestra los suministros realizados (tan solo los códigos de los componentes
de una venta). ¿Es necesario utilizar DISTINCT?
*/

SELECT DISTINCT codpro, codpie FROM ventas;
--Es necesario utilizar DISTINCT por que hay suministros que realizan diferentes piezas en el mismo proyecto

/*
Ejercicio 3.3 Muestra las piezas de Madrid que son grises o rojas. 
*/

SELECT codpie, nompie 
FROM opc.pieza
WHERE ciudad = 'Madrid' AND (UPPER(color)='GRIS' OR UPPER(color)='ROJO');

/*
Ejercicio 3.4 Encontrar todos los suministros cuya cantidad está entre 200 y 300, ambos
inclusive. 
*/

SELECT DISTINCT codpro 
FROM opc.ventas
WHERE cantidad>=200 AND cantidad <= 300;

/* 
Ejercicio 3.5 Mostrar las piezas que contengan la palabra tornillo con la t en
mayúscula o en minúscula.
*/

SELECT codpie, nompie 
FROM opc.pieza
WHERE nompie LIKE '%tornillo%' OR nompie LIKE '%Tornillo%';
 
/*
Ejercicio 3.6 Comprueba que no devuelve ninguna. Pero SÍ que hay!!!. Prueba a usar
la función upper() comparando con ’VENTAS’ o la función lower() comparando con
’ventas’.
*/

SELECT table_name
FROM ALL_TABLES
WHERE TABLE_NAME like '%ventas'; -- no devuelve nada

SELECT table_name
FROM ALL_TABLES
WHERE UPPER(TABLE_NAME) like '%VENTAS';

SELECT table_name
FROM ALL_TABLES
WHERE LOWER(TABLE_NAME) like '%ventas';

/*
Ejercicio 3.7 Resolver la consulta del ejemplo 3.8 utilizando el operador ∩.
*/

SELECT codpj 
FROM proyecto
INTERSECT (
	SELECT codpj FROM ventas WHERE (codpro = 'S1')
		MINUS
	SELECT codpj FROM ventas WHERE (codpro !='S1')
);

/* 
Ejercicio 3.8 Encontrar los códigos de aquellos proyectos a los que sólo abastece ’S1’.
*/
(SELECT codpj FROM ventas WHERE (codpro = 'S1') )
MINUS
(SELECT codpj FROM ventas WHERE (codpro !='S1'));

/*
Ejercicio 3.9 Mostrar todas las ciudades de la base de datos. Utilizar UNION
*/

SELECT ciudad FROM pieza
	UNION
SELECT ciudad FROM proveedor
	UNION 
SELECT ciudad FROM proyecto;

/*
Ejercicio 3.10 Mostrar todas las ciudades de la base de datos. Utilizar UNION ALL.
*/

SELECT ciudad FROM pieza
	UNION ALL
SELECT ciudad FROM proveedor
	UNION ALL 
SELECT ciudad FROM proyecto;

/* 
Ejercicio 3.11 Comprueba cuántas tuplas resultan del producto cartesiano aplicado a ventas
y proveedor
*/

SELECT * FROM ventas, proveedor;

/* 
Ejercicio 3.12 Mostrar las ternas que son de la misma ciudad pero que hayan realizado
alguna venta.
*/

(SELECT codpro, codpie, codpj
FROM proyecto, pieza, proveedor
WHERE proveedor.ciudad = pieza.ciudad
AND pieza.ciudad = projecto.ciudad)
	INTERSECT
(SELECT codpro, codpie, codpj
FROM ventas);

/* 
Ejercicio 3.13 Encontrar parejas de proveedores que no viven en la misma ciudad
*/

SELECT *
FROM proveedor P1, proveedor P2
WHERE (P1.ciudad != P2.ciudad)
AND (P1.codpro != P2.codpro);

/* 
Ejercicio 3.14 Encuentra las piezas con máximo peso.
*/

SELECT *
FROM pieza
WHERE peso = ( SELECT MAX(peso) FROM pieza);

/*  
Ejercicio 3.15 Mostrar las piezas vendidas por los proveedores de Madrid.
*/

SELECT DISTINCT codpie 
FROM opc.ventas v
NATURAL JOIN  (SELECT * FROM opc.proveedor p WHERE p.ciudad = 'Madrid');

/* 
Ejercicio 3.16 Encuentra la ciudad y los códigos de las piezas suministradas a cualquier
proyecto por un proveedor que está en la misma ciudad donde está el proyecto.
*/

SELECT pieza.ciudad, pieza.codpie  
FROM pieza, ventas, proyecto, proveedor
WHERE proveedor.ciudad = proyecto.ciudad
AND ventas.codpro = proveedor.codpro
AND ventas.codpj = proyecto.codpj
AND ventas.codpie = pieza.codpie;

/* 
Ejercicio 3.17 Comprobar la salida de la consulta anterior sin la cláusula ORDER BY.
*/

SELECT nompro
FROM proveedor
ORDER BY nompro;

SELECT nompro
FROM proveedor;

/* 
Ejercicio 3.18 Listar las ventas ordenadas por cantidad, si algunas ventas coinciden en la
cantidad se ordenan en función de la fecha de manera descendente. 
*/

SELECT * FROM ventas
ORDER BY ciudad, fecha DESC;

/* 
Ejercicio 3.19 Mostrar las piezas vendidas por los proveedores de Madrid. (Fragmentando
la consulta con ayuda del operador IN.) Compara la solución con la del ejercicio 3.15.
*/

SELECT DISTINCT codpie 
FROM ventas
WHERE codpro IN (
SELECT codpro FROM proveedor
WHERE ciudad='Madrid'); 


/*
Ejercicio 3.20 Encuentra los proyectos que están en una ciudad donde se fabrica alguna pieza.
*/ 

SELECT codpj FROM proyecto
WHERE ciudad IN (
SELECT ciudad FROM pieza);

/* 
Ejercicio 3.21 Encuentra los códigos de aquellos proyectos que no utilizan ninguna pieza
roja que esté suministrada por un proveedor de Londres. 
*/

SELECT DISTINCT codpj
FROM opc.ventas
NATURAL JOIN 
(
SELECT * 
FROM opc.proveedor
WHERE UPPER(ciudad)='LONDRES'
)
WHERE codpie NOT IN (
SELECT codpie
FROM opc.pieza
WHERE UPPER(color) = 'ROJO'
);

/*
Ejercicio 3.22 Muestra el código de las piezas cuyo peso es mayor que el peso de cualquier
’tornillo’. 
*/

SELECT codpie
FROM opc.pieza
WHERE peso > ANY
(
SELECT peso
FROM opc.pieza
WHERE UPPER(nompie) = 'TORNILLO'
);
--O:
SELECT p1.codpie
FROM pieza p1, pieza p2
WHERE p1.peso > p2.peso and p2.nompie = 'Tornillo';

/* 
Ejercicio 3.23 Encuentra las piezas con peso máximo. Compara esta solución con la obtenida
en el ejercicio 3.14 
*/

SELECT *
FROM pieza
WHERE peso >= ALL
(
SELECT peso 
FROM pieza
);

/* 
Ejercicio 3.24 Encontrar los códigos de las piezas suministradas a todos los proyectos
localizados en Londres.
*/

SELECT codpie
FROM opc.pieza
WHERE NOT EXISTS (
					SELECT codpj 
					FROM opc.proyecto
					WHERE ciudad = 'Londres'
						MINUS
					SELECT codpj
					FROM opc.ventas
					WHERE opc.ventas.codpie = opc.pieza.codpie
				);
				
/* 
Ejercicio 3.25 Encontrar aquellos proveedores que envían piezas procedentes de todas las
ciudades donde hay un proyecto.
*/

SELECT p.codpro
FROM opc.proveedor p
WHERE NOT EXISTS (
					SELECT DISTINCT ciudad
					FROM opc.proyecto
						MINUS
					SELECT DISTINCT ciudad
					FROM opc.ventas v
					NATURAL JOIN opc.pieza
					WHERE v.codpro = p.codpro
				);
				
SELECT p.codpro
FROM opc.proveedor p
WHERE NOT EXISTS (
					SELECT DISTINCT pj.ciudad
					FROM opc.proyecto pj
					WHERE NOT EXISTS (
											SELECT DISTINCT ciudad
											FROM opc.ventas v
											NATURAL JOIN opc.pieza
											WHERE v.codpro = p.codpro
											AND v.codpj = pj.codpj
										)
				);

					
/*
Ejercicio 3.26 Encontrar el número de envíos con más de 1000 unidades
*/

SELECT COUNT (*) 
FROM opc.ventas
WHERE cantidad > 1000;

/*
Ejercicio 3.27 Mostrar el máximo peso
*/

SELECT MAX(peso)
FROM opc.pieza;

/*
Ejercicio 3.28 Mostrar el código de la pieza de máximo peso. Compara esta solución con las
correspondientes de los ejercicios 3.14 y 3.23. 
*/

SELECT codpie
FROM opc.pieza
WHERE peso = (
				SELECT MAX(peso)
				FROM opc.pieza
				);

/*
Ejercicio 3.29 Comprueba si la siguiente sentencia resuelve el ejercicio anterior
*/
--no funciona
SELECT codpie, MAX(peso)
FROM pieza;

/*
Ejercicio 3.30 Muestra los códigos de proveedores que han hecho más de 3 envíos diferentes.
*/

SELECT p.codpro
FROM opc.proveedor p
WHERE 3 < (
			SELECT COUNT(*) 
			FROM opc.ventas v
			WHERE v.codpro = p.codpro
			);
			
--SIN SUBCONSULTA

SELECT v.codpro
FROM opc.ventas v
GROUP BY v.codpro
HAVING COUNT(*) > 3;

/*
Ejercicio 3.31 Mostrar la media de las cantidades vendidas por cada código de pieza junto
con su nombre. 
*/

SELECT p.nompie, s.AverageCantidad
FROM opc.pieza p
NATURAL JOIN (
                SELECT codpie, AVG(cantidad) AverageCantidad
                FROM opc.ventas
                GROUP BY codpie
            ) s;
			
/*
Ejercicio 3.32 Encontrar la cantidad media de ventas de la pieza ’P1’ realizadas por cada
proveedor. 
*/

SELECT codpro, AVG(cantidad)
FROM opc.ventas
GROUP BY codpro
HAVING codpie = 'P1';

/* 
Ejercicio 3.33 Encontrar la cantidad total de cada pieza enviada a cada proyecto. 
*/

SELECT codpj,codpie, SUM(cantidad)
FROM opc.ventas
GROUP BY codpie,codpj
ORDER BY codpj,codpie;

/*
Ejercicio 3.34 Comprueba si es correcta la solución anterior. 
*/

SELECT v.codpro, v.codpj, j.nompj, AVG(v.cantidad)
FROM ventas v, proyecto j
WHERE v.codpj=j.codpj
GROUP BY v.codpj, j.nompj, v.codpro;
--en clase
SELECT codpro , AVG(total)
FROM (
	SELECT codpro, SUM(cantidad) total
	FROM ventas
	GROUP BY codpro codpj
	)
GROUP BY codpro
ORDER BY codpro;

/*
Ejercicio 3.35 Mostrar los nombres de proveedores tales que el total de sus ventas superen
la cantidad de 1000 unidades. 
*/

SELECT v.codpro, p.nompro, SUM(v.cantidad)
FROM opc.ventas v, opc.proveedor p
WHERE v.codpro = p.codpro
GROUP BY p.nompro, v.codpro
HAVING SUM(v.cantidad) > 1000;
--en clase
SELECT codpro, nompro
FROM (ventas NATURAL JOIN proveedor)
GROUP BY codpro, nompro
HAVING SUM(cantidad) > 1000;

/*
Ejercicio 3.36 Mostrar la pieza que más se ha vendido en total. 
*/

SELECT codpie, SUM(cantidad)
FROM opc.ventas
GROUP BY codpie
HAVING SUM(cantidad) = (SELECT MAX(SUM(v.cantidad))
                        FROM opc.ventas v
                        GROUP BY v.codpie);
/*						
Ejercicio 3.37 Comprueba que no funciona correctamente si las comparaciones de fechas se
hacen con cadenas. 
*/

--NO FUNCIONA:						

SELECT * FROM ventas
WHERE fecha BETWEEN TO_DATE('01/01/2002','DD/MM/YYYY') AND
TO_DATE('31/12/2004','DD/MM/YYYY');

--FUNCIONA:

SELECT * FROM opc.ventas
WHERE TO_DATE(fecha,'DD.MM.YY') BETWEEN TO_DATE('01.01.2002','DD.MM.YY') AND
TO_DATE('31.12.2004','DD.MM.YY');

/*
Ejercicio 3.38 Encontrar la cantidad media de piezas suministradas cada mes. 
*/

SELECT TO_CHAR(fecha,'MM'), AVG(cantidad)
FROM opc.ventas
GROUP BY TO_CHAR(fecha,'MM');

/*
Ejercicio 3.39 ¿ Cuál es el nombre de la vista que tienes que consultar y qué campos te
pueden interesar?
*/

/*
Ejercicio 3.40 Muestra las tablas ventas a las que tienes acceso de consulta junto con el
nombre del propietario y su número de identificación en el sistema.
*/
SELECT a.owner, u.user_id, a.table_name              
FROM all_catalog a, all_users u
WHERE UPPER(TABLE_NAME)='VENTAS'
AND a.owner = u.username;

/*
Ejercicio 3.41 Muestra todos tus objetos creados en el sistema. ¿Hay algo más que tablas?
*/

SELECT *
FROM user_objects;

/*
Ejercicio 3.42 Mostrar los códigos de aquellos proveedores que hayan superado las ventas
totales realizadas por el proveedor ’S1’.
*/

SELECT codpro, COUNT(*)
FROM opc.ventas
GROUP BY codpro
HAVING COUNT(*) > (
                            SELECT COUNT(*)
                            FROM opc.ventas
                            WHERE codpro = 'S1'
                        );

/*
Ejercicio 3.43 Mostrar los mejores proveedores, entendiéndose como los que tienen mayores
cantidades totales. 
*/

SELECT codpro, SUM(cantidad)
FROM opc.ventas
GROUP BY codpro
HAVING SUM(cantidad) = (
                            SELECT MAX(SUM(cantidad))
                            FROM opc.ventas
                            GROUP BY codpro
                        );
						
/*
Ejercicio 3.44 Mostrar los proveedores que venden piezas a todas las ciudades de los
proyectos a los que suministra ’S3’, sin incluirlo. 
*/

SELECT DISTINCT v.codpro
FROM opc.ventas v
NATURAL JOIN opc.proyecto p
WHERE p.ciudad IN (
					SELECT DISTINCT p.ciudad
					FROM opc.ventas v, opc.proyecto p
					WHERE v.codpj = p.codpj
					AND v.codpro = 'S3'
				  )
AND v.codpro != 'S3';

/*
Ejercicio 3.45 Encontrar aquellos proveedores que hayan hecho al menos diez pedidos.
*/

SELECT codpro, COUNT(*)
FROM opc.ventas
GROUP BY codpro
HAVING COUNT(*) >= 10;

/*
Ejercicio 3.46 Encontrar aquellos proveedores que venden todas las piezas suministradas
por S1. 
*/

SELECT p.codpro
FROM opc.proveedor p
WHERE NOT EXISTS (
                    SELECT DISTINCT codpie
                    FROM opc.ventas
                    WHERE codpro = 'S1'
                        MINUS
                    SELECT DISTINCT codpie
                    FROM opc.ventas v
                    WHERE p.codpro = v.codpro                    
                );
				
/*
Ejercicio 3.47 Encontrar la cantidad total de piezas que ha vendido cada proveedor que
cumple la condición de vender todas las piezas suministradas por S1.
*/

SELECT p.codpro, SUM(cantidad)
FROM opc.proveedor p
WHERE NOT EXISTS (
                    SELECT DISTINCT codpie
                    FROM opc.ventas
                    WHERE codpro = 'S1'
                        MINUS
                    SELECT DISTINCT codpie
                    FROM opc.ventas v
                    WHERE p.codpro = v.codpro                    
                )
GROUP BY(p.codpro);

/*
Ejercicio 3.48 Encontrar qué proyectos están suministrados por todos lo proveedores que
suministran la pieza P3.
*/

SELECT pj.codpj
FROM opc.proyecto pj
WHERE NOT EXISTS (
					SELECT DISTINCT v.codpro
					FROM opc.ventas v
					WHERE v.codpie='P3'
						MINUS
					SELECT DISTINCT codpro
					FROM opc.ventas v
					WHERE v.codpj = pj.codpj
				);

/*
Ejercicio 3.49 Encontrar la cantidad media de piezas suministrada a aquellos proveedores
que venden la pieza P3.
*/

SELECT AVG(v.cantidad)
FROM opc.ventas v
WHERE v.codpie ='P3';

/*
Ejercicio 3.50 Queremos saber los nombres de tus índices y sobre qué tablas están montados,
indica además su propietario. 
*/

SELECT index_name, table_name, table_owner 
FROM user_indexes; 

/*
Ejercicio 3.51 Implementar el comando DESCRIBE para tu tabla ventas a través de una
consulta a las vistas del catálogo
*/

DESCRIBE ventas;

SELECT column_name,nullable,data_type,data_length 
FROM USER_TAB_COLUMNS 
WHERE table_name='VENTAS';


/*
Ejercicio 3.52 Mostrar para cada proveedor la media de productos suministrados cada año
*/

SELECT codpro, AVG(cantidad), to_char(fecha, 'yyyy')
FROM ventas
GROUP BY codpro, to_char(fecha, 'yyyy')
ORDER BY codpro, to_char(fecha, 'yyyy');

/*
Ejercicio 3.53 Encontrar todos los proveedores que venden una pieza roja.
*/

SELECT DISTINCT v.codpro
FROM opc.ventas v
NATURAL JOIN opc.pieza p
WHERE UPPER(p.color) = 'ROJO';

/*
Ejercicio 3.54 Encontrar todos los proveedores que venden todas las piezas rojas.
*/

SELECT p.codpro
FROM opc.proveedor p
WHERE NOT EXISTS (
                    SELECT pz.codpie
                    FROM opc.pieza pz
                    WHERE UPPER(pz.color) = 'ROJO'
                        MINUS
                    SELECT v.codpie
                    FROM opc.ventas v
                    WHERE v.codpro = p.codpro
                    );
/*
Ejercicio 3.55 Encontrar todos los proveedores tales que todas las piezas que venden son rojas.
*/

SELECT codpro
FROM ventas
INTERSECT
(
	SELECT codpro
	FROM proveedor
		MINUS
	SELECT codpro
	FROM ventas
	NATURAL JOIN pieza
	WHERE LOWER(color) <> 'rojo'
);

/*
Ejercicio 3.56 Encontrar el nombre de aquellos proveedores que venden más de una pieza
roja.
*/

SELECT codpro, COUNT(*)
FROM (
    SELECT *
    FROM opc.ventas
    NATURAL JOIN opc.pieza
    WHERE LOWER(color) = 'ROJO'
    )
GROUP BY codpro
HAVING COUNT(*)>1;

/*
Ejercicio 3.57 Encontrar todos los proveedores que vendiendo todas las piezas rojas cumplen
la condición de que todas sus ventas son de más de 10 unidades. 
*/

SELECT p.codpro
FROM opc.proveedor p
WHERE NOT EXISTS (
                    SELECT pz.codpie
                    FROM opc.pieza pz
                    WHERE UPPER(pz.color) = 'ROJO'
                        MINUS
                    SELECT v.codpie
                    FROM opc.ventas v
                    WHERE v.codpro = p.codpro
                    )
INTERSECT
(
	SELECT codpro
	FROM opc.ventas
	GROUP BY codpro
	HAVING  MIN(cantidad) >10
);

/*
Ejercicio 3.58 Coloca el status igual a 1 a aquellos proveedores que solo suministran la pieza P1.
*/

UPDATE proveedor
SET status = '1'
WHERE codpro IN (
	SELECT  DISTINCT codpro  
	FROM ventas 
	WHERE (codpie='P1')
		MINUS
	SELECT DISTINCT codpro  
	FROM ventas 
	WHERE (codpie<>'P1')
);

/*
Ejercicio 3.59 Encuentra, de entre las piezas que no se han vendido en septiembre de 2009,
las ciudades de aquéllas que se han vendido en mayor cantidad durante Agosto de ese mismo
año.
*/

CREATE VIEW PieNoSept2009 AS
SELECT * FROM pieza 
WHERE codpie IN
(SELECT codpie FROM pieza
MINUS
SELECT codpie FROM ventas 
WHERE to_char(fecha,'mm-yyyy')='09-2009');

CREATE VIEW VentasAgos2009 AS 
SELECT * FROM ventas
WHERE to_char(fecha,'mm-yyyy')='08-2009';

SELECT ciudad from PieNoSept2009 p, VentasAgos2009 v
WHERE p.codpie=v.codpie
GROUP BY p.codpie, ciudad
HAVING SUM(cantidad)=(
		SELECT max(sum(cantidad)) 
		FROM VentasAgos2009
		WHERE codpie IN (
				SELECT codpie 
				FROM PieNoSept2009
				)
		GROUP BY codpie
		);

/*
Ejercicio 3.60 Muestra la información disponible acerca de los encuentros de liga.
*/
SELECT *
FROM Encuentros;

/*
Ejercicio 3.61 Muestra los nombres de los equipos y de los jugadores jugadores ordenados
alfabéticamente. 
*/

SELECT DISTINCT nompro
FROM opc.proveedor
ORDER BY nompro;

SELECT DISTINCT nompie
FROM opc.pieza
ORDER BY nompie;

/*
Ejercicio 3.62 Muestra los jugadores que no tienen ninguna falta.
*/

SELECT codJ
FROM Jugadores
	MINUS
SELECT codJ
FROM Alineaciones;

/*
Ejercicio 3.63 Muestra los compañeros de equipo del jugador que tiene por código x
(codJ=’x’) y donde x es uno elegido por ti. 
*/

SELECT codJ
FROM Jugadores
WHERE codE = (
	SELECT codE
	FROM Jugadores
	WHERE codJ = 'Juan'
);

/*
Ejercicio 3.64 Muestra los jugadores y la localidad donde juegan (la de sus equipos).
*/

SELECT j.codJ, e.localidad
FROM Jugadores j
NATURAL JOIN Equipos e;

/*
Ejercicio 3.65 Muestra todos los encuentros posibles de la liga.
*/

SELECT ELocal,EVisitante
FROM Encuentros
WHERE ELocal,EVisitante IN (
	SELECT ELocal,EVisitante
	FROM Alineaciones
);

/*
Ejercicio 3.71 Muestra los encuentros que tienen lugar en la misma localidad.
*/



/*
Ejercicio 3.72 Para cada equipo muestra cantidad de encuentros que ha disputado como
local.
*/

SELECT ELocal, COUNT(*)
FROM Encuentros
GROUP BY ELocal;

/*
Ejercicio 3.73 Muestra los encuentros en los que se alcanzó mayor diferencia. 
*/

SELECT *
FROM Encuentros
WHERE ABS((PLocal-PVisitante)) = (
	SELECT MAX(ABS(PLocal-PVisitante))
	FROM Encuentros
);

/*
Ejercicio 3.76 Muestra la cantidad de victorias de cada equipo, jugando como local o como visitante.
*/

/*
Ejercicio 3.77 Muestra el equipo con mayor número de victorias.
*/

/*
Ejercicio 4.1 Crear una vista con los proveedores de Londres. ¿Qué sucede si insertamos
en dicha vista la tupla (’S7’,’Jose Suarez’,3,’Granada’)?. (Buscar en [5] la cláusula
WITH CHECK OPTION ). 
*/
---Crear una vista con los proveedores de Londres:
CREATE VIEW ProveedoresLondres AS
    SELECT codpro, nompro, status, ciudad FROM opc.proveedor
    WHERE ciudad='Londres';
---Insertar en dicha vista la tupla (’S7’,’Jose Suarez’,3,’Granada’):
INSERT INTO ProveedoresLondres
VALUES('S7','Jose Suarez',3,'Granada'); ---1 row inserted.
---Insertar en dicha vista la tupla (’S7’,’Jose Suarez’,3,’Granada’) WITH CHECK OPTION:
CREATE VIEW ProveedoresLondres AS
    SELECT codpro, nompro, status, ciudad FROM opc.proveedor
    WHERE ciudad='Londres'
    WITH CHECK OPTION;
INSERT INTO ProveedoresLondres
VALUES('S7','Jose Suarez',3,'Granada'); ---solamente podemos ingresar proveedor de Londres

/*
Ejercicio 4.2 Crear una vista con los nombres de los proveedores y sus ciudades. Inserta
sobre ella una fila y explica cuál es el problema que se plantea. ¿Habría problemas de
actualización? 
*/
CREATE VIEW ProveedoresNombresCiudades AS
    SELECT nompro, ciudad FROM opc.proveedor;
	
INSERT INTO ProveedoresNombresCiudades
VALUES('Ana','Madrid');
/*
No podemos insertar.
El problema: hay que añadir clave primaria en la vista.
*/

/*
Ejercicio 4.3 Crear una vista donde aparezcan el código de proveedor, el nombre de proveedor y el código del proyecto tales que la pieza sumistrada sea gris. Sobre esta vista realiza
alguna consulta y enumera todos los motivos por los que sería imposible realizar una inserción.
*/
--Crear una vista
CREATE VIEW piezagris AS
    SELECT v.codpro, pr.nompro, v.codpj
    FROM opc.ventas v,opc.proveedor pr,opc.pieza pz
    WHERE v.codpro = pr.codpro AND 
    v.codpie = pz.codpie AND 
    pz.color = 'Gris';

/*
Ejercicio 5.1 Ver la descripción de la vista del catálogo USER_TABLES.
*/


/*
Ejercicio 6.1 Rellena las tablas proveedor2 y ventas2 con los datos de sus homólogas originales.
*/

/*
1) Resolver sobre el esquema de proveedores, piezas, proyectos y ventas, las siguientes
consultas con SQL:
*/

/* 
a) Proveedor que tiene el mayor número de ventas de la pieza P1 en el último
año (puede ser más de uno).
*/

CREATE VIEW prov (codpro, summa) AS
    SELECT codpro, SUM(cantidad) AS summa
    FROM opc.ventas
    WHERE EXTRACT(YEAR FROM fecha) = (
        SELECT MAX(EXTRACT(YEAR FROM fecha))
        FROM opc.ventas
    )
    AND codpie = 'P1'
    GROUP BY codpro;
	
SELECT codpro 
FROM prov
WHERE summa = (
    SELECT MAX(summa)
    FROM prov);

/*
b. Piezas de color blanco que aparecen en, al menos, tres envíos con proveedores
diferentes.
*/

SELECT DISTINCT codpie
FROM (SELECT * 
        FROM opc.ventas
        NATURAL JOIN opc.pieza
        WHERE color = 'Blanco'
        ) x
WHERE 3 <= (
    SELECT COUNT(*)
    FROM opc.ventas v
    WHERE x.codpie  = v.codpie
    AND x.codpro != v.codpro
);

/*
c. Proyectos en los que los suministros en el año 2000 tienen una cantidad media
superior a 150.
*/

SELECT codpj
FROM opc.ventas
WHERE EXTRACT(YEAR FROM fecha) ='2000'
GROUP BY codpj
HAVING AVG(cantidad) > 150;

/*
d. Proveedores con el número más alto de suministros a proyectos de Londres
realizados durante el mes de enero de 2000.
*/

CREATE VIEW provnum (codpro, numpro) AS
    SELECT codpro, COUNT(*) as numpro
    FROM (
        SELECT *
        FROM opc.ventas
        NATURAL JOIN opc.proyecto
        WHERE TO_DATE(fecha,'DD.MM.YY') BETWEEN TO_DATE('01.01.2000','DD.MM.YY') AND
        TO_DATE('31.01.2000','DD.MM.YY')
        AND ciudad = 'Londres'
    )
    GROUP BY codpro;

SELECT codpro 
FROM provnum
WHERE numpro = (
    SELECT MAX(numpro)
    FROM provnum);
	
/*
e. Proveedores que han suministrado al menos tres piezas distintas a cada
proyecto.
*/
	
/*
f. Piezas que aparecen en un único suministro durante el año 2010.
*/	
	
SELECT DISTINCT v1.codpie 
FROM opc.ventas v1
WHERE NOT EXISTS (
    SELECT * FROM opc.ventas v2
    WHERE v1.codpie = v2.codpie AND v1.codpro <> v2.codpro
)
AND EXTRACT(YEAR FROM fecha) ='2010'; 

/*
g. Piezas cuyo último suministro fue realizado en marzo de 2010.
*/

SELECT DISTINCT v1.codpie 
FROM opc.ventas v1
WHERE TO_DATE(fecha,'DD.MM.YY')  BETWEEN TO_DATE('01.03.2010','DD.MM.YY')
AND TO_DATE('31.03.2010','DD.MM.YY')
    MINUS
SELECT DISTINCT v1.codpie 
FROM opc.ventas v1
WHERE TO_DATE(fecha,'DD.MM.YY') > TO_DATE('31.03.2010','DD.MM.YY')

/*
i. Proyectos que solo tienen un proveedor con varios suministros en el último año.
*/

CREATE VIEW ventasUltimoAno (codpro, codpi, codpj, cantidad, fecha) AS
    SELECT *
    FROM opc.ventas v1
    WHERE EXTRACT(YEAR FROM fecha) =(
            SELECT MAX(EXTRACT(YEAR FROM fecha))
            FROM opc.ventas
            );
        
SELECT DISTINCT codpj
FROM ventasUltimoAno
    MINUS
SELECT v1.codpj
FROM ventasUltimoAno v1, ventasUltimoAno v2
WHERE v1.codpj=v2.codpj AND v1.codpro!=v2.codpro;

/*
j. Piezas de color rojo que han sido suministradas al menos dos veces cada año
(considerando solo los años en los que se han producido envíos en la BD).
*/

SELECT codpie
FROM opc.ventas  
NATURAL JOIN (SELECT * FROM opc.pieza WHERE color='Blanco')
GROUP BY EXTRACT(YEAR from fecha), codpie
HAVING COUNT(*) >= 2;

/*
2) Considere cada uno de los esquemas de los ejercicios de la relación de consultas (sin
considerar el de los suministros). Para cada uno de ellos:
*/

/*
Considerando el esquema de bases de datos de la liga de baloncesto creado en el apartado
1.8:
*/

Encuentra todos los 

/*
a. Proponga y resuelva una consulta original de división simple.
*/

/*
b. Proponga y resuelva una consulta original de división que imponga
restricciones a los candidatos.
*/

/*
c. Proponga y resuelva una consulta original de división que imponga
restricciones en el divisor.
*/

/*
d. Proponga y resuelva una consulta original de división que imponga
restricciones sobre la forma de relacionarse con los elementos del divisor.
*/