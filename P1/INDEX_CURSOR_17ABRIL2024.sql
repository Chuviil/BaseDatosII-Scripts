-- Selecciona el businessEntityId, firstName y lastName de la tabla person.person
SELECT ppe.businessEntityId, ppe.firstName, ppe.LastName
FROM person.person AS ppe

-- Ejecuta el procedimiento almacenado sp_helpindex para la tabla person.person
EXECUTE sp_helpindex 'person.person'
GO

-- Selecciona el businessEntityId, firstName y lastName de la tabla person.person donde el lastName es 'Smith'
SELECT ppe.businessEntityID, ppe.firstName, ppe.LastName
FROM person.person AS ppe
WHERE ppe.LastName = 'Smith'
GO

-- Crea índices no agrupados en las columnas lastName y firstName de la tabla person.person
CREATE NONCLUSTERED INDEX IDX_PERSONA_LASTNAME ON person.person (lastname)
CREATE NONCLUSTERED INDEX IDX_PERSONA_FIRSTNAME ON person.person (firstname)

-- Selecciona el businessEntityId, firstName y lastName de la tabla person.person donde el firstName es 'John'
SELECT ppe.businessEntityId, ppe.firstName, ppe.LastName
FROM person.person AS ppe
WHERE ppe.firstName = 'John'
GO

-- Declara un cursor para iterar sobre el firstName y lastName de la tabla person.person
DECLARE @Nombre VARCHAR(15), @Apellido VARCHAR(15);
DECLARE CursorPersona CURSOR FOR
    SELECT FirstName, LastName
    FROM Person.Person;
OPEN CursorPersona
FETCH NEXT FROM CursorPersona INTO @Nombre, @Apellido
WHILE @@FETCH_STATUS = 0 BEGIN
    -- Imprime el firstName y lastName
    PRINT @Nombre + ' ' + @Apellido
    FETCH NEXT FROM CursorPersona INTO @Nombre, @Apellido
END
CLOSE CursorPersona
DEALLOCATE CursorPersona

-- Crea una vista que selecciona el firstName, lastName, año de RateChangeDate y la tasa promedio de la tabla EmployeePayHistory unida con la tabla person.person
CREATE VIEW Consultas.vTotalEmpleado AS
SELECT ppe.FirstName AS Nombre, ppe.LastName AS apellido, YEAR(hh.RateChangeDate) AS Anio, AVG(hh.Rate) AS Comision
FROM HumanResources.EmployeePayHistory AS hh
         INNER JOIN Person.Person AS ppe
                    ON hh.BusinessEntityID = ppe.BusinessEntityID
GROUP BY ppe.FirstName, ppe.LastName, YEAR(hh.RateChangeDate)
HAVING AVG(hh.Rate) > 10

-- Selecciona el businessEntityId, firstName y lastName de la tabla person.person donde el firstName es 'Adam'
SELECT ppe.businessEntityId,
       ppe.firstName,
       ppe.LastName
FROM person.person AS ppe
WHERE ppe.firstName = 'Adam'

-- Crea un índice no agrupado en la columna firstName de la tabla person.person
CREATE NONCLUSTERED INDEX idx_persona_firstname ON person.person (firstname)

-- Crea una tabla para registrar cambios de precios
CREATE TABLE Production.LogPrecios
(
    id_producto         INT         NOT NULL,
    nombre_prducto      VARCHAR(50) NULL,
    Precio_Anterior     Decimal(10, 2),
    Precio_Nuevo        Decimal(10, 2),
    fecha_actualizacion DATETIME,
    CONSTRAINT PK_ID_prudcto PRIMARY KEY (id_producto, fecha_actualizacion)
)

-- Declara un cursor para iterar sobre el ProductID, Name y ListPrice de la tabla Production.Product donde el ListPrice es mayor que 0
DECLARE @ProductID          INT
DECLARE @ld_Precio_Anterior Decimal(10, 2),@ld_Precio_Nuevo Decimal(10, 2)
DECLARE @NombreProducto     VARCHAR(50)
DECLARE CursorPrecios CURSOR FOR
    SELECT ProductID, Name, ListPrice
    FROM Production.Product
    WHERE ListPrice > 0
    ORDER BY ProductID
OPEN CursorPrecios
FETCH NEXT FROM CursorPrecios INTO @ProductID,@NombreProducto, @ld_Precio_Anterior
WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Actualiza el ListPrice en la tabla Production.Product e inserta un registro del cambio de precio en la tabla Production.LogPrecios
        SET @ld_Precio_Nuevo = @ld_Precio_Anterior * 1.05
        UPDATE Production.Product
        SET ListPrice = @ld_Precio_Nuevo
        WHERE ProductID = @ProductID
        INSERT INTO Production.LogPrecios(id_producto, nombre_prducto, Precio_Anterior, Precio_Nuevo,
                                          fecha_actualizacion)
        VALUES (@ProductID, @NombreProducto, @ld_Precio_Anterior, @ld_Precio_Nuevo, GETDATE())
        FETCH NEXT FROM CursorPrecios INTO @ProductID,@NombreProducto, @ld_Precio_Anterior
    END
CLOSE CursorPrecios
DEALLOCATE CursorPrecios

-- Selecciona todos los registros de la tabla Production.LogPrecios
SELECT *
FROM Production.LogPrecios