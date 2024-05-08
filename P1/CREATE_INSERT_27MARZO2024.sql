-- Creando una nueva base de datos llamada BIBLIOTECA
CREATE DATABASE BIBLIOTECA

-- Cambiando a la base de datos recién creada
USE BIBLIOTECA

-- Creando un nuevo tipo t_nombre a partir de varchar(50)
CREATE TYPE t_nombre
    FROM varchar(50)

-- Seleccionando todos los tipos de SYS.types y ordenándolos por nombre
SELECT *
FROM SYS.types
ORDER BY name

-- Creando una nueva tabla EDITORIAL con las columnas id_editorial, nombre_editorial, ubicacion_editorial
-- id_editorial es la clave primaria
CREATE TABLE EDITORIAL
(
    id_editorial        int NOT NULL,
    nombre_editorial    t_nombre,
    ubicacion_editorial varchar(100),
    CONSTRAINT PK_ID_EDITORIAL PRIMARY KEY (id_editorial)
)

-- Creando una nueva tabla Autor con las columnas id_autor, nombre_autor, apellido_autor, pais_origen_autor
-- id_autor es la clave primaria
CREATE TABLE Autor
(
    id_autor          int      NOT NULL,
    nombre_autor      t_nombre NOT NULL,
    apellido_autor    t_nombre NOT NULL,
    pais_origen_autor t_nombre,
    CONSTRAINT PK_ID_AUTOR PRIMARY KEY (id_autor)
)

-- Creando una nueva tabla GENEROS con las columnas id_generos, nombre_genero
-- id_generos es la clave primaria
CREATE TABLE GENEROS
(
    id_generos    INT NOT NULL,
    nombre_genero t_nombre,
    CONSTRAINT PK_ID_GENEROS PRIMARY KEY (id_generos)
)

-- Creando una nueva tabla USUARIOS con las columnas id_usuario, nombre_usuario, apellido_usuario, direccion_usuario, telefono_usuario
-- id_usuario es la clave primaria
CREATE TABLE USUARIOS
(
    id_usuario        int NOT NULL,
    nombre_usuario    t_nombre,
    apellido_usuario  t_nombre,
    direccion_usuario varchar(100),
    telefono_usuario  varchar(20),
    CONSTRAINT PK_ID_USUARIO PRIMARY KEY (id_usuario)
)

-- Creando una nueva tabla LIBROS con las columnas ISBN, Titulo_Libro, Fecha_Publicacion, id_generos, id_editorial, id_autor
-- ISBN es la clave primaria
CREATE TABLE LIBROS
(
    ISBN              NCHAR(20)    NOT NULL,
    Titulo_Libro      varchar(100) NOT NULL,
    Fecha_Publicacion DATE,
    id_generos        int          NOT NULL,
    id_editorial      int          NOT NULL,
    id_autor          int          NOT NULL,
    CONSTRAINT PK_IBSN PRIMARY KEY (ISBN)
)

-- Creando una nueva tabla PRESTAMOS con las columnas id_prestamo, fecha_prestamo, fecha_devolucion, estado_prestamo, ISBN, id_usuario
-- id_prestamo es la clave primaria
CREATE TABLE PRESTAMOS
(
    id_prestamo      int       NOT NULL,
    fecha_prestamo   Date,
    fecha_devolucion Date,
    estado_prestamo  VARCHAR(20),
    ISBN             NCHAR(20) NOT NULL,
    id_usuario       int       NOT NULL,
    CONSTRAINT PK_IDPRESTANO PRIMARY KEY (id_prestamo)
)

-- Agregando restricciones de clave externa a la tabla LIBROS
ALTER TABLE LIBROS
    ADD CONSTRAINT FK_LIBROS_GENEROS FOREIGN KEY (id_generos)
REFERENCES GENEROS (id_generos)
GO

ALTER TABLE LIBROS
    ADD CONSTRAINT FK_LIBROS_EDITORIAL FOREIGN KEY (id_editorial)
        REFERENCES EDITORIAL (id_editorial)
GO

-- Agregando restricciones de clave externa a la tabla PRESTAMOS
ALTER TABLE PRESTAMOS
    ADD CONSTRAINT FK_PRESTAMOS_LIBROS FOREIGN KEY (ISBN)
        REFERENCES LIBROS (ISBN)
GO
ALTER TABLE PRESTAMOS
    ADD CONSTRAINT FK_PRESTAMOS_USUARIOS FOREIGN KEY (id_usuario)
        REFERENCES USUARIOS (id_usuario)
GO

-- Creando una regla RG_ESTADO
CREATE RULE RG_ESTADO AS
    @ESTADO IN ('Activo', 'Inactivo')
GO

-- Insertando datos en la tabla AUTOR
INSERT INTO AUTOR (id_autor, nombre_autor, apellido_autor, pais_origen_autor)
VALUES (1, 'Carlos', 'Mendoza', 'Argentina'),
       (2, 'Luis', 'Gonzalez', 'Chile');
GO

-- Insertando datos en la tabla EDITORIAL
INSERT INTO EDITORIAL(id_editorial, nombre_editorial)
VALUES (1, 'Editorial Luna'),
       (2, 'Editorial Sol');
GO

-- Insertando datos en la tabla GENEROS
INSERT INTO GENEROS(id_generos, nombre_genero)
VALUES (1, 'Drama'),
       (2, 'Comedia');
GO

-- Insertando datos en la tabla LIBROS
INSERT INTO LIBROS(ISBN, Titulo_Libro, Fecha_Publicacion, id_autor, id_generos, id_editorial)
VALUES (1, 'El Principito', '2010/01/01', 1, 1, 1),
       (2, 'Don Juan Tenorio', '2005/05/05', 2, 2, 2);
GO

-- Insertando datos en la tabla USUARIOS
INSERT INTO USUARIOS(id_usuario, nombre_usuario, apellido_usuario, direccion_usuario, telefono_usuario)
VALUES (1, 'Ana', 'Perez', 'Los Alamos', '0981234567'),
       (2, 'Juan', 'Martinez', 'Las Rosas', '0987654321');
GO

-- Insertando datos en la tabla PRESTAMOS
INSERT INTO PRESTAMOS([id_prestamo], [fecha_prestamo], [fecha_devolucion], [estado_prestamo], [ISBN], [id_usuario])
VALUES (1, '2024/05/01', NULL, 'PRESTADO', 1, 1)