-- Usando la base de datos 'adventure-works-OLD'
USE [adventure-works-OLD]
GO

-- Creando un procedimiento almacenado 'ue_persona' que toma el apellido de una persona como entrada y devuelve su businessEntityId, nombre y apellido
CREATE PROCEDURE ue_persona @apellido_persona varchar(50)
AS
BEGIN
    -- Seleccionando el businessEntityId, firstName y LastName de la tabla person.person donde el LastName coincide con el parámetro de entrada
    SELECT ppe.businessEntityId, ppe.firstName, ppe.LastName
    FROM person.person AS ppe
    WHERE ppe.LastName = @apellido_persona
END
GO

-- Ejecutando el procedimiento almacenado 'ue_persona' con 'Green' como parámetro de entrada
EXEC ue_persona @apellido_persona='Green'
GO

-- Modificando el procedimiento almacenado 'usp_ActualizaPrecio' que toma un código de vendedor y un incremento de valor como entrada
ALTER PROCEDURE [dbo].[usp_ActualizaPrecio] @CodigoVendedor INT, @ValorIncremento Decimal(10, 2)
AS
BEGIN
    -- Declarando variables
    DECLARE @ProductID INT
    DECLARE @ld_Precio_Anterior Decimal(10, 2),@ld_Precio_Nuevo Decimal(10, 2)
    DECLARE @NombreProducto VARCHAR(50)

    -- Declarando un cursor 'CursorPrecios' para una sentencia select
    DECLARE CursorPrecios CURSOR FOR
        SELECT ppr.ProductID, ppr.Name, ppr.ListPrice
        FROM Production.Product AS ppr
                 INNER JOIN Purchasing.ProductVendor AS ppv
                            ON ppr.ProductID = ppv.ProductID
        WHERE ppv.BusinessEntityID = @CodigoVendedor
    OPEN CursorPrecios
    FETCH NEXT FROM CursorPrecios INTO @ProductID,@NombreProducto, @ld_Precio_Anterior
    WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Actualizando el ListPrice en la tabla Production.Product e insertando un registro de la actualización en la tabla Production.LogPrecios
            SET @ld_Precio_Nuevo = @ld_Precio_Anterior * @ValorIncremento
            UPDATE Production.Product
            SET ListPrice = @ld_Precio_Nuevo
            WHERE ProductID = @ProductID
            INSERT INTO Production.LogPrecios(id_producto, nombre_prducto, Precio_Anterior, Precio_Nuevo,
                                              fecha_actualizacion)
            VALUES (@ProductID, @NombreProducto, @ld_Precio_Anterior, @ld_Precio_Nuevo, GETDATE())
            FETCH NEXT FROM CursorPrecios INTO @ProductID,@NombreProducto, @ld_Precio_Anterior
        END
    -- Cerrando y desasignando el cursor
    CLOSE CursorPrecios
    DEALLOCATE CursorPrecios
    PRINT 'Proceso Finalizado con Exito'
END
GO

-- Ejecutando el procedimiento almacenado 'usp_ActualizaPrecio' con 1 como código de vendedor y 1.5 como incremento de valor
EXEC usp_ActualizaPrecio @CodigoVendedor=1, @ValorIncremento=1.5
GO

-- Usando la base de datos 'master'
USE [master]

-- Creando un inicio de sesión 'consultor' con la contraseña 'UDLA'
CREATE LOGIN [consultor] WITH PASSWORD ='UDLA'
GO

-- Usando la base de datos 'adventure-works-OLD' y creando un usuario 'consultor' para el inicio de sesión 'consultor'
USE [adventure-works-OLD];
CREATE USER [consultor] FOR LOGIN consultor

-- Usando la base de datos 'Biblioteca' y creando un usuario 'consultor' para el inicio de sesión 'consultor'
USE Biblioteca;
CREATE USER [consultor] FOR LOGIN consultor

-- Otorgando al usuario 'consultor' permisos para insertar y seleccionar en la tabla 'PERSON.PERSON' y seleccionar en el esquema 'HumanResources'
GRANT INSERT ON PERSON.PERSON TO consultor
GRANT SELECT ON PERSON.PERSON TO consultor
GRANT SELECT ON SCHEMA :: HumanResources TO consultor