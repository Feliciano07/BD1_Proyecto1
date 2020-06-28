
-- Eliminacion de Tablas al Inicio ********************************************


DROP TABLE diagnostico CASCADE CONSTRAINTS;

DROP TABLE diagnostico_sintoma CASCADE CONSTRAINTS;

DROP TABLE empleado CASCADE CONSTRAINTS;

DROP TABLE evaluacion_general CASCADE CONSTRAINTS;

DROP TABLE genero CASCADE CONSTRAINTS;

DROP TABLE paciente CASCADE CONSTRAINTS;

DROP TABLE sintoma CASCADE CONSTRAINTS;

DROP TABLE titulo CASCADE CONSTRAINTS;

DROP TABLE tratamiento CASCADE CONSTRAINTS;

DROP TABLE tratamiento_paciente CASCADE CONSTRAINTS;

DROP TABLE Sintoma_Paciente CASCADE CONSTRAINTS;

-- *****************************************************************************

CREATE TABLE diagnostico (
    id_diagnostico  INTEGER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) NOT NULL,
    descripcion     VARCHAR2(50),
    CONSTRAINT diagnostico_pk PRIMARY KEY(id_diagnostico)
);



CREATE TABLE sintoma (
    id_sintoma           INTEGER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) NOT NULL,
    descripcion_sintoma  VARCHAR2(50),
    CONSTRAINT sintoma_pk PRIMARY KEY(id_sintoma)
);



CREATE TABLE tratamiento (
    id_tratamiento           INTEGER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) NOT NULL,
    descripcion_tratamiento  VARCHAR2(50),
    CONSTRAINT tratamiento_pk PRIMARY KEY(id_tratamiento)
);




CREATE TABLE genero (
    id_genero    INTEGER  NOT NULL,
    descripcion  VARCHAR2(10),
    CONSTRAINT genero_pk PRIMARY KEY(id_genero)
);


CREATE TABLE titulo (
    id_titulo    INTEGER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) NOT NULL,
    descripcion  VARCHAR2(50),
    CONSTRAINT titulo_pk PRIMARY KEY(id_titulo)
);


CREATE TABLE empleado (
    id_empleado       INTEGER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) NOT NULL,
    nombre            VARCHAR2(75),
    apellido          VARCHAR2(75),
    direccion         VARCHAR2(75),
    telefono          VARCHAR2(30),
    fecha_nacimiento  DATE,
    id_genero  INTEGER NOT NULL,
    id_titulo  INTEGER NOT NULL,
    CONSTRAINT empleado_pk PRIMARY KEY(id_empleado),
    CONSTRAINT genero_empleado_fk FOREIGN KEY(id_genero) REFERENCES genero(id_genero),
    CONSTRAINT titulo_fk FOREIGN KEY(id_titulo) REFERENCES titulo(id_titulo)
);


CREATE TABLE paciente (
    id_paciente       INTEGER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) NOT NULL,
    nombre            VARCHAR2(75),
    apellido          VARCHAR2(75),
    direccion         VARCHAR2(75),
    telefono          VARCHAR2(30),
    fecha_nacimiento  DATE,
    altura            FLOAT,
    peso              FLOAT,
    id_genero  INTEGER NOT NULL,
    CONSTRAINT paciente_pk PRIMARY KEY(id_paciente),
    CONSTRAINT genero_paciente_pk FOREIGN KEY(id_genero) REFERENCES genero(id_genero)
);



CREATE TABLE evaluacion_general (
    id_eva_general        INTEGER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) NOT NULL,
    fecha                 DATE,
    id_empleado  INTEGER NOT NULL,
    id_paciente  INTEGER NOT NULL,
    CONSTRAINT evaluacion_general_pk PRIMARY KEY(id_eva_general),
    CONSTRAINT empleado_fk FOREIGN KEY(id_empleado) REFERENCES empleado(id_empleado),
    CONSTRAINT paciente_fk FOREIGN KEY(id_paciente) REFERENCES paciente(id_paciente)
);

CREATE TABLE Sintoma_Paciente(
    id_sintoma_paciente INTEGER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) NOT NULL,
    id_sintoma          INTEGER NOT NULL,
    id_paciente         INTEGER NOT NULL,
    CONSTRAINT id_sintoma_paciente_pk PRIMARY KEY(id_sintoma_paciente),
    CONSTRAINT s_p_sintoma_fk FOREIGN KEY(id_sintoma) REFERENCES Sintoma(id_sintoma),
    CONSTRAINT s_p_paciente_fk FOREIGN KEY(id_paciente) REFERENCES Paciente(id_paciente)
);



CREATE TABLE diagnostico_sintoma(
    id_diagnostico_sintoma          INTEGER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) NOT NULL,
    rango                              INTEGER,
    id_diagnostico                      INTEGER NOT NULL,
    id_sintoma                          INTEGER NOT NULL, 
    CONSTRAINT diagnostico_sintoma_pk PRIMARY KEY(id_diagnostico_sintoma),
    CONSTRAINT diagnostico_fk FOREIGN KEY(id_diagnostico) REFERENCES diagnostico(id_diagnostico),
    CONSTRAINT d_s_sintoma_fk FOREIGN KEY(id_sintoma) REFERENCES Sintoma(id_sintoma)
);



CREATE TABLE tratamiento_paciente (
    id_tratamiento_paciente     INTEGER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) NOT NULL,
    fecha                       DATE,
    id_paciente        INTEGER NOT NULL,
    id_tratamiento  INTEGER NOT NULL,
    CONSTRAINT tratamiento_paciente_pk PRIMARY KEY(id_tratamiento_paciente),
    CONSTRAINT paciente_fk_trata FOREIGN KEY(id_paciente) REFERENCES paciente(id_paciente),
    CONSTRAINT tratamiento_fk FOREIGN KEY(id_tratamiento) REFERENCES tratamiento(id_tratamiento)
);
