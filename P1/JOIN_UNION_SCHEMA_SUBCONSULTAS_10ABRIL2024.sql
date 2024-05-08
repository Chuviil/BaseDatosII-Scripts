-- Usar la base de datos 'adventure-works-OLD'
USE [adventure-works-OLD]
GO

-- Seleccionar el nombre del producto, cantidad de pedido, precio unitario y año de modificación de las tablas SalesOrderDetail y Product donde el precio unitario está entre 1 y 100
SELECT ppd.Name, ssd.OrderQty, ssd.UnitPrice AS PrecionUnitario, YEAR(ssd.ModifiedDate) AS Año
FROM Sales.SalesOrderDetail AS ssd
         INNER JOIN Production.Product AS ppd ON ssd.ProductID = ppd.ProductID
WHERE ssd.UnitPrice BETWEEN 1 AND 100
GO

-- Seleccionar el nombre del producto, cantidad de pedido, precio unitario y año de modificación de las tablas SalesOrderDetail y Product donde el precio unitario es nulo
SELECT ppd.Name, ssd.OrderQty, ssd.UnitPrice AS PrecioUnitario, YEAR(ssd.ModifiedDate) AS año
FROM sales.SalesOrderDetail AS ssd
         INNER JOIN Production.Product AS ppd ON ssd.ProductID = ppd.ProductID
WHERE ssd.UnitPrice IS NULL
GO

-- Seleccionar el primer nombre, apellido y segundo nombre de la tabla Person donde el primer nombre es 'JOSE' o 'luis'
SELECT ppe.firstname AS nombre, ppe.Lastname, ppe.Middlename
FROM person.person AS ppe
WHERE ppe.FirstName IN ('JOSE', 'luis')
GO

-- Seleccionar el primer nombre, apellido, tipo de persona y título del trabajo de las tablas Person y Employee
SELECT ppe.FirstName  AS Nombre,
       ppe.LastName   AS Apellido,
       ppe.PersonType AS
                         TipoPersona,
       hem.JobTitle   AS CargoEmpleado
FROM Person.Person AS ppe
         LEFT JOIN HumanResources.Employee AS hem ON ppe.BusinessEntityID = hem.BusinessEntityID
GO

-- Seleccionar el primer nombre, cuota de ventas total y año de la fecha de cuota de las tablas SalesPersonQuotaHistory y Person donde la cuota de ventas total es menor que 800000
-- Agrupar por ID de entidad comercial, año de la fecha de cuota y primer nombre
-- Ordenar por ID de entidad comercial
SELECT pp.FirstName, SUM(SalesQuota) AS total_vendido, YEAR(QuotaDate) AS año
FROM Sales.SalesPersonQuotaHistory qh
         INNER JOIN Person.Person pp ON qh.BusinessEntityID = pp.BusinessEntityID
GROUP BY pp.BusinessEntityID, YEAR(QuotaDate), pp.FirstName
HAVING SUM(SalesQuota) < 800000
ORDER BY pp.BusinessEntityID
GO

-- Seleccionar el nombre del producto, cantidad de pedido, tipo de transacción y año de modificación de las tablas SalesOrderDetail, PurchaseOrderDetail y Product para el año 2005
-- Unir los resultados de los detalles de pedidos de venta y compra
SELECT ppd.Name, ssd.OrderQty, 'Vendido' AS Transaccion, YEAR(ssd.ModifiedDate) AS Año
FROM Sales.SalesOrderDetail AS ssd
         INNER JOIN Production.Product AS ppd ON ssd.ProductID = ppd.ProductID
WHERE YEAR(ssd.ModifiedDate) = '2005'
UNION
SELECT ppd.Name, ppo.OrderQty, 'Comprado' AS Transaccion, YEAR(ppo.ModifiedDate) AS Año
FROM Purchasing.PurchaseOrderDetail AS ppo
         INNER JOIN Production.Product AS ppd ON ppo.ProductID = ppd.ProductID
WHERE YEAR(ppo.ModifiedDate) = '2005'
GO

-- Seleccionar el número de producto y categoría de la tabla Product basado en la línea de producto
SELECT ProductNumber,
       Category =
           CASE ProductLine
               WHEN 'R' THEN 'Carretera'
               WHEN 'M' THEN 'Montaña'
               WHEN 'T' THEN 'Turismo'
               WHEN 'S' THEN 'Otros artículos de venta'
               ELSE 'No está a la venta'
               END
FROM Production.Product
GO

-- Seleccionar el número de producto, nombre y rango de precios de la tabla Product basado en el precio de lista
SELECT ProductNumber,
       Name,
       "Rango de Precios" =
           CASE
               WHEN ListPrice = 0 THEN 'Artículo de fabricación - no para reventa'
               WHEN ListPrice < 50 THEN 'Menos de $50'
               WHEN ListPrice >= 50 AND ListPrice < 250 THEN 'Menos de $250'
               WHEN ListPrice >= 250 AND ListPrice < 1000 THEN 'Menos de $1000'
               ELSE 'Más de $1000'
               END
FROM Production.Product
GO

-- Seleccionar el nombre del producto de la tabla Product donde el ID del producto está en la tabla SpecialOfferProduct
SELECT ppr.Name
FROM Production.Product AS ppr
WHERE ppr.ProductID IN (SELECT ssp.ProductID FROM Sales.SpecialOfferProduct AS ssp)
GO

-- Seleccionar el nombre, precio de lista, precio de lista promedio y diferencia de la tabla Product donde el ID de la subcategoría del producto es 1
SELECT [Name],
       ListPrice,
       (SELECT AVG(ListPrice) FROM Production.Product)             AS Promedio,
       ListPrice - (SELECT AVG(ListPrice) FROM Production.Product) AS Diferencia
FROM Production.Product
WHERE ProductSubcategoryID = 1

-- Actualizar el precio de lista en la tabla Product donde el ID del producto está en la tabla ProductVendor y el ID de la entidad comercial es 1540
UPDATE Production.Product
SET ListPrice=ListPrice * 2
WHERE ProductID IN (SELECT ProductID
                    FROM Purchasing.ProductVendor
                    WHERE BusinessEntityID = 1540)

-- Crear un nuevo esquema 'CONSULTAS'
CREATE SCHEMA CONSULTAS
-- Crear una nueva vista 'vTotalVentas' bajo el esquema 'CONSULTAS'
    CREATE VIEW Consultas.vTotalVentas
    AS
    (
    SELECT pp.FirstName,
           pp.LastName,
           YEAR(QuotaDate) AS año,
           SUM(SalesQuota) AS
                              total_vendido
    FROM Sales.SalesPersonQuotaHistory qh
             INNER JOIN Person.Person pp ON qh.BusinessEntityID = pp.BusinessEntityID
    GROUP BY pp.BusinessEntityID, pp.FirstName, pp.LastName, YEAR(QuotaDate))
-- Seleccionar todo de la vista 'vTotalVentas'
SELECT *
FROM Consultas.vTotalVentas