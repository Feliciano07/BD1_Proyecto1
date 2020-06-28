/*
    1.	Mostrar el nombre, apellido y teléfono de todos los empleados y 
    la cantidad de pacientes atendidos por cada empleado ordenados de mayor a menor
*/

SELECT epl.nombre, epl.apellido, epl.telefono , COUNT(evl.id_eva_general) as pacientes_atendidos
FROM Empleado epl,
Evaluacion_General evl
where epl.id_empleado = evl.id_empleado
GROUP BY epl.nombre, epl.apellido, epl.telefono
ORDER BY pacientes_atendidos DESC;

/*
    2.	Mostrar el nombre, apellido, direccion y título de todos los empleados de sexo masculino 
    que atendieron a más de 3 pacientes en el año 2016
*/

SELECT epl.nombre, epl.apellido, epl.direccion, tl.descripcion, COUNT(evl.id_eva_general) as pacientes
FROM Empleado epl,
Evaluacion_General evl,
Titulo tl
WHERE epl.id_empleado=evl.id_empleado AND  
epl.id_genero = (SELECT id_genero FROM Genero ge WHERE ge.descripcion='M') AND 
epl.id_titulo = tl.id_titulo AND 
evl.fecha >= TO_DATE('01/01/2016','DD/MM/YYYY') AND evl.fecha <= TO_DATE('31/12/2016','DD/MM/YYYY')
GROUP BY epl.nombre, epl.apellido, epl.direccion, tl.descripcion
HAVING COUNT(evl.id_eva_general)>3;


/*
    3.	Mostrar el nombre y apellido de todos los pacientes que se están aplicando el 
    tratamiento "Tabaco en polvo" y que tuvieron el síntoma "Dolor de cabeza".
*/

SELECT pl.nombre, pl.apellido 
FROM Paciente pl,
Tratamiento_Paciente tp,
Sintoma_Paciente sp  
WHERE pl.id_paciente = tp.id_paciente AND 
tp.id_tratamiento= (
    SELECT tr.id_tratamiento 
    FROM Tratamiento tr
    WHERE tr.descripcion_tratamiento='Tabaco en polvo'
)
AND pl.id_paciente = sp.id_paciente AND 
sp.id_sintoma = (
    SELECT st.id_sintoma 
    FROM Sintoma st 
    WHERE st.descripcion_sintoma = 'Dolor de cabeza'
)

/*
    4.	Top 5 de pacientes que más tratamientos se han aplicado del 
    tratamiento “Antidepresivos”.  Mostrar nombre, apellido y la cantidad de tratamientos
*/


SELECT pt.nombre, pt.apellido, COUNT(tl.id_tratamiento) as cantidad_tratamientos
FROM Paciente pt,
Tratamiento_Paciente tp,
Tratamiento tl
WHERE pt.id_paciente=tp.id_paciente AND tp.id_tratamiento=tl.id_tratamiento AND 
tl.descripcion_tratamiento='Antidepresivos'
GROUP BY pt.nombre, pt.apellido
ORDER BY COUNT(tl.id_tratamiento) DESC 
FETCH NEXT 5 ROWS ONLY;

/*
5.	-Mostrar el nombre, apellido y dirección de todos los pacientes que se hayan 
-aplicado más de 3 tratamientos y 
-no hayan sido atendidos por un empleado.  
Debe mostrar la cantidad de tratamientos que se aplicó el 
paciente.  Ordenar los resultados de mayor a menor utilizando la cantidad de tratamientos
*/

SELECT pt.nombre, pt.apellido, pt.direccion, COUNT(tp.id_tratamiento_paciente) as cantidad_tratamientos
FROM Paciente pt,
Tratamiento_Paciente tp
WHERE tp.id_paciente=pt.id_paciente AND 
NOT EXISTS(
    SELECT null
    FROM Evaluacion_General evl
    where pt.id_paciente=evl.id_paciente
) 
GROUP BY pt.nombre, pt.apellido, pt.direccion
HAVING COUNT(tp.id_tratamiento_paciente)>3
ORDER BY COUNT(tp.id_tratamiento_paciente) DESC;


/*
6.	Mostrar el nombre del diagnóstico y la cantidad de síntomas a los que ha sido 
asignado donde el rango ha sido de 9. Ordene sus resultados de mayor a menor en base 
a la cantidad de síntomas
*/

SELECT dt.descripcion, COUNT(st.id_sintoma) as numero_sintomas
FROM Diagnostico_Sintoma sd
INNER JOIN
Sintoma st 
ON sd.id_sintoma=st.id_sintoma
INNER JOIN 
Diagnostico dt 
ON sd.id_diagnostico=dt.id_diagnostico
WHERE sd.rango=9
GROUP BY dt.descripcion
ORDER BY COUNT(st.id_sintoma) DESC;

/*
7.	Mostrar el nombre, apellido y dirección de todos los pacientes que 
presentaron un síntoma que al que le fue asignado un diagnóstico con un 
rango mayor a 5.  Debe mostrar los resultados en orden alfabético tomando 
en cuenta el nombre y apellido del paciente
*/*****************************************

SELECT pt.nombre, pt.apellido, pt.direccion
FROM Paciente pt,
Sintoma_Paciente sp,
Sintoma st,
diagnostico_sintoma ds 
WHERE pt.id_paciente=sp.id_paciente  AND sp.id_sintoma=st.id_sintoma
AND st.id_sintoma=ds.id_sintoma AND ds.rango > 5
GROUP BY pt.id_paciente, pt.nombre, pt.apellido, pt.direccion
ORDER BY pt.nombre ASC, pt.apellido ASC;

/*
8.	Mostrar el nombre, apellido y fecha de nacimiento de todos los empleados de sexo femenino 
cuya dirección es “1475 Dryden Crossing” y hayan atendido por lo menos a 2 pacientes.  
Mostrar la cantidad de pacientes atendidos por el empleado y ordénelos de mayor a menor

*/

SELECT epl.nombre, epl.apellido, epl.fecha_nacimiento, COUNT(evl.id_eva_general) as pacientes_atendidos
FROM Empleado epl,
Evaluacion_General evl
WHERE 
epl.id_genero=(
    SELECT gr.id_genero 
    FROM Genero gr 
    WHERE gr.descripcion='F'
) AND 
epl.direccion LIKE '%1475 Dryden Crossing%' AND 
epl.id_empleado = evl.id_empleado
GROUP BY epl.nombre, epl.apellido, epl.fecha_nacimiento
HAVING COUNT(evl.id_eva_general)>=2
ORDER BY COUNT(evl.id_eva_general) DESC

/*
9.	Mostrar el porcentaje de pacientes que ha atendido cada empleado a 
partir del año 2017 y mostrarlos de mayor a menor en base al porcentaje calculado
*/

    SELECT epl.nombre, epl.apellido, COUNT(evl.id_eva_general)/(
        SELECT COUNT( evl.id_eva_general)
        FROM evaluacion_general
    )*100 as porcentaje

    FROM Empleado epl,
    Evaluacion_General evl 
    WHERE epl.id_empleado=evl.id_empleado AND 
    evl.fecha >= TO_DATE('01/01/2017','DD/MM/YYYY')
    GROUP BY epl.nombre, epl.apellido
    ORDER BY COUNT(evl.id_eva_general) DESC;

    /*
        SELECT epl.nombre, epl.apellido, COUNT(evl.id_eva_general)/(
            SELECT COUNT( DISTINCT epl.id_empleado)
            FROM Empleado epl,
            Evaluacion_General evl 
            WHERE epl.id_empleado=evl.id_empleado AND 
            evl.fecha >= TO_DATE('01/01/2017','DD/MM/YYYY')   
        )*100 as porcentaje

        FROM Empleado epl,
        Evaluacion_General evl 
        WHERE epl.id_empleado=evl.id_empleado AND 
        evl.fecha >= TO_DATE('01/01/2017','DD/MM/YYYY')
        GROUP BY epl.nombre, epl.apellido
        ORDER BY COUNT(evl.id_eva_general) DESC;
    */



/*
10.	Mostrar el porcentaje del título de empleado más común de la siguiente manera: 
nombre del título, porcentaje de empleados que tienen ese título.  Debe ordenar los 
resultados en base al porcentaje de mayor a menor

*/

SELECT tl.descripcion, COUNT(epl.id_empleado)/(
    SELECT COUNT(DISTINCT epl.id_empleado)
    FROM Empleado epl
    where epl.id_titulo is not null 
)*100 as porcentaje_titulo

FROM Titulo tl,
Empleado epl 
WHERE tl.id_titulo=epl.id_titulo
GROUP BY tl.descripcion
ORDER BY COUNT(epl.id_empleado) DESC


/*
    Mostrar el año y mes (de la fecha de evaluación) junto con el nombre y apellido 
    de los pacientes que más tratamientos se han aplicado y los que menos. (Todo en una sola consulta).  
    Nota: debe tomar como cantidad mínima 1 tratamiento.
*/

    SELECT extract( year from evl.fecha) as año, extract(month from evl.fecha) as mes , datos.*
FROM(
        SELECT pt.id_paciente, pt.nombre, pt.apellido, COUNT(tp.fecha) as numero_tratamiento
        FROM 
        Paciente pt,
        Tratamiento_Paciente tp
        WHERE pt.id_paciente = tp.id_paciente
        GROUP BY pt.id_paciente, pt.nombre, pt.apellido
        HAVING COUNT(tp.fecha)= 
        (
            SELECT  MAX(COUNT(tp.fecha))
            FROM 
            Paciente pt,
            Tratamiento_Paciente tp
            WHERE pt.id_paciente = tp.id_paciente
            GROUP BY pt.id_paciente
        ) OR COUNT(tp.fecha)= 
        (
              SELECT  MIN(COUNT(tp.fecha))
            FROM 
            Paciente pt,
            Tratamiento_Paciente tp
            WHERE pt.id_paciente = tp.id_paciente
            GROUP BY pt.id_paciente
        )
) datos,
Evaluacion_General evl
WHERE datos.id_paciente=evl.id_paciente
ORDER BY numero_tratamiento DESC, datos.nombre

       /* 
        SELECT  pt.nombre, pt.apellido, COUNT(tp.fecha)
            FROM 
            Paciente pt,
            Tratamiento_Paciente tp
            WHERE pt.id_paciente = tp.id_paciente
            GROUP BY pt.nombre, pt.apellido
            HAVING COUNT(tp.fecha)= 
            (
                SELECT  MAX(COUNT(tp.fecha))
                FROM 
                Paciente pt,
                Tratamiento_Paciente tp
                WHERE pt.id_paciente = tp.id_paciente
                GROUP BY pt.id_paciente
            ) OR COUNT(tp.fecha)= 
            (
                SELECT  MIN(COUNT(tp.fecha))
                FROM 
                Paciente pt,
                Tratamiento_Paciente tp
                WHERE pt.id_paciente = tp.id_paciente
                GROUP BY pt.id_paciente
            )
        */





