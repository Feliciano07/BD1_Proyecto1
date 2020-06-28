
DROP TABLE Temporal;

CREATE TABLE temporal(
	NOMBRE_EMPLEADO VARCHAR2(50),
	APELLIDO_EMPLEADO VARCHAR2(50),
	DIRECCION_EMPLEADO VARCHAR2(50),
	TELEFONO_EMPLEADO VARCHAR2(50),
	GENERO_EMPLEADO VARCHAR2(50),
	FECHA_NACIMIENTO_EMPLEADO VARCHAR2(50),
	TITULO_EMPLEADO VARCHAR2(50),
	NOMBRE_PACIENTE VARCHAR2(50),
	APELLIDO_PACIENTE VARCHAR2(50),
	DIRECCION_PACIENTE VARCHAR2(50),
	TELEFONO_PACIENTE VARCHAR2(50),
	GENERO_PACIENTE VARCHAR2(50),
	FECHA_NACIMIENTO_PACIENTE VARCHAR2(50),
	ALTURA VARCHAR2(50),
	PESO VARCHAR2(50),
	FECHA_EVALUACION VARCHAR2(50),
	SINTOMA_DEL_PACIENTE VARCHAR2(50),
	DIAGNOSTICO_DEL_SINTOMA VARCHAR2(50),
	RANGO VARCHAR2(50),
	FECHA_TRATAMIENTO VARCHAR2(50),
	TRATAMIENTO_APLICADO VARCHAR2(50)
);

-- CONSULTA para obtener todos los tratamientos e insertarlo en la tabla tratamientos

	INSERT INTO Tratamiento(descripcion_tratamiento)
	SELECT DISTINCT TRATAMIENTO_APLICADO from temporal
	WHERE TRATAMIENTO_APLICADO IS NOT NULL;
--

-- CONSULTA PARA OBTENER TODOS LOS SINTOMAS INGRESADOS e inserccion en el modelo
	INSERT INTO Sintoma(descripcion_sintoma)
	SELECT DISTINCT SINTOMA_DEL_PACIENTE FROM TEMPORAL 
	WHERE SINTOMA_DEL_PACIENTE IS NOT NULL;

--

-- CONSULTA PARA OBTENER TODOS LOS DIAGNOSTICOS CONOCIDOS e inserccion en el modelo
	INSERT INTO Diagnostico(descripcion)
	SELECT DISTINCT DIAGNOSTICO_DEL_SINTOMA FROM TEMPORAL
	WHERE DIAGNOSTICO_DEL_SINTOMA IS NOT NULL;

--	


-- CONSULTA PARA OBTENER LOS TITULOS REGISTRADOS e inserccion en el modelo
	INSERT INTO Titulo(descripcion)
	SELECT DISTINCT TITULO_EMPLEADO FROM TEMPORAL
	WHERE TITULO_EMPLEADO IS NOT NULL;

--

-- CONSULTA PARA INGRESAR LOS GENEROS E INSERCCION EN EL MODELO

	INSERT INTO Genero(id_genero,descripcion) VALUES(1,'M');
	INSERT INTO Genero(id_genero,descripcion) VALUES(2,'F');

--	


-- CONSULTA PARA OBTENER A LOS EMPLEADOS 
	INSERT INTO Empleado(nombre,apellido,direccion,telefono,fecha_nacimiento,id_genero,id_titulo)
	SELECT DISTINCT NOMBRE_EMPLEADO, APELLIDO_EMPLEADO, DIRECCION_EMPLEADO,TELEFONO_EMPLEADO,
	TO_DATE(FECHA_NACIMIENTO_EMPLEADO,'DD/MM/YYYY'),
	(SELECT id_genero FROM Genero WHERE Genero.descripcion=Temporal.GENERO_EMPLEADO and ROWNUM=1),
	(SELECT id_titulo FROM Titulo WHERE Titulo.descripcion=Temporal.TITULO_EMPLEADO and ROWNUM=1)
	FROM Temporal
	WHERE NOMBRE_EMPLEADO IS NOT NULL and APELLIDO_EMPLEADO IS NOT NULL;

-- 

-- CONSULTA PARA A LOS PACIENTES 

	INSERT INTO Paciente(nombre, apellido, direccion, telefono, fecha_nacimiento, altura, peso, id_genero)

	SELECT DISTINCT NOMBRE_PACIENTE, APELLIDO_PACIENTE, DIRECCION_PACIENTE, TELEFONO_PACIENTE,
	TO_DATE(FECHA_NACIMIENTO_PACIENTE,'DD/MM/YYYY'), TO_NUMBER(Temporal.ALTURA, '9.99'), TO_NUMBER(Temporal.PESO, '9G999D99'),
	(SELECT id_genero FROM Genero WHERE Genero.descripcion=Temporal.GENERO_PACIENTE and ROWNUM=1)
	FROM TEMPORAL
	WHERE NOMBRE_PACIENTE IS NOT NULL and APELLIDO_PACIENTE IS NOT NULL;
    

--

-- CONSULTA PARA LLENAR LA TABLA DE EVALUACION_GENERAL

	INSERT INTO Evaluacion_General(fecha, id_empleado, id_paciente)

	SELECT fecha, emple, pacien
	FROM (
		SELECT DISTINCT Temporal.fecha_evaluacion as fecha,
		Empleado.id_empleado as emple, 
		Paciente.id_paciente as pacien
		from Temporal 
		INNER JOIN
		Paciente 
		ON temporal.nombre_paciente=paciente.nombre and temporal.apellido_paciente=paciente.apellido
		INNER JOIN 
		Empleado
		ON temporal.nombre_empleado= empleado.nombre and temporal.apellido_empleado=empleado.apellido
		WHERE FECHA_EVALUACION IS NOT NULL and nombre_empleado IS NOT NULL
	);


--

-- CONSULTA PARA LLenar la tabla de diagnostico_individual
	INSERT INTO Diagnostico_Sintoma(rango, id_diagnostico, id_sintoma)

	SELECT  tem_rango, tem_diagnostico, tem_sintoma
	FROM(
		SELECT DISTINCT 
		te.rango as tem_rango,
		dg.id_diagnostico as tem_diagnostico,
		st.id_sintoma as tem_sintoma
		FROM Temporal te
		INNER JOIN 
		Diagnostico dg 
		on te.DIAGNOSTICO_DEL_SINTOMA=dg.descripcion
		INNER JOIN 
		Sintoma st
		on te.SINTOMA_DEL_PACIENTE=st.descripcion_sintoma
		WHERE te.diagnostico_del_sintoma IS NOT NULL AND te.sintoma_del_paciente IS NOT NULL AND te.rango IS NOT NULL
	);


-- 


-- CONSULTA PARA SABER LOS SINTOMAS QUE TENIDO LOS PACIENTES 

	INSERT INTO Sintoma_Paciente(id_sintoma, id_paciente)

	SELECT tem_sintoma, tem_paciente
	FROM(
		SELECT DISTINCT
		st.id_sintoma as tem_sintoma,
		pt.id_paciente as tem_paciente
		FROM Temporal te 
		INNER JOIN 
		Sintoma st 
		ON te.SINTOMA_DEL_PACIENTE=st.descripcion_sintoma
		INNER JOIN 
		Paciente pt 
		ON te.NOMBRE_PACIENTE=pt.nombre AND te.APELLIDO_PACIENTE=pt.apellido
		where te.SINTOMA_DEL_PACIENTE is not null AND te.NOMBRE_PACIENTE is not null AND te.APELLIDO_PACIENTE is not null
	);



-- consulta para llenar los tratamientos de los pacientes
	INSERT INTO tratamiento_paciente(fecha, id_paciente, id_tratamiento)

	SELECT tem_fecha, tem_paciente, tem_tratamiento
	FROM(
		SELECT DISTINCT
		te.FECHA_TRATAMIENTO as tem_fecha,
		pt.id_paciente as tem_paciente,
		tr.id_tratamiento as tem_tratamiento
		FROM temporal te 
		INNER JOIN 
		Paciente pt 
		ON te.nombre_paciente=pt.nombre AND te.apellido_paciente = pt.apellido
		INNER JOIN 
		Tratamiento tr
		ON te.TRATAMIENTO_APLICADO=tr.descripcion_tratamiento
		WHERE te.nombre_paciente IS NOT NULL AND 
		te.fecha_tratamiento is not null and te.tratamiento_aplicado is not null
	);

-----------------------



-- CONTEO DE REGISTROS EN CADA TABLA 

select count(*) as numero_diagnostico from diagnostico;

select count(*) as numero_sintoma from sintoma;

select count(*) as numero_tratamiento from tratamiento;

select count(*) as numero_genero from genero;

select count(*) as numero_titulo from titulo;

select count(*) as numero_empleado from empleado;

select count(*) as numero_paciente from paciente;

select count(*) as numero_evaluacion_general from evaluacion_general;

select count(*) as numero_sintoma_paciente from sintoma_paciente;

select count(*) as numero_diagnostico_del_sintoma from diagnostico_sintoma;

select count(*) as numero_tratamiento_paciente from tratamiento_paciente;

