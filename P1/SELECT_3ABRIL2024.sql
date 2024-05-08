-- Usar la base de datos adventure-works-OLD
USE [adventure-works-OLD]
GO

-- Seleccionar el nombre, apellido y género de los empleados. El género se determina mediante una declaración de caso.
-- El resultado se ordena por género y nombre.
SELECT ppe.FirstName AS Nombre,
       ppe.LastName  AS Apellido,
       CASE
           WHEN hem.gender = 'M' THEN 'Masculino'
           WHEN hem.gender = 'F' THEN 'Femenino'
           ELSE 'No Especificado'
           END       AS Genero
FROM HumanResources.Employee AS hem
         INNER JOIN Person.Person AS ppe
                    ON hem.BusinessEntityID = ppe.BusinessEntityID
WHERE hem.MaritalStatus = 'S'
ORDER BY hem.gender, ppe.FirstName
GO

-- Seleccionar el nombre del departamento, el nombre y apellido del empleado de los departamentos 'quality assurance' y 'production'.
-- El resultado se ordena por nombre de departamento y apellido.
SELECT hdp.Name AS Departamento, ppe.FirstName AS Nombre, ppe.LastName AS Apellido
FROM HumanResources.Employee AS hem
         INNER JOIN HumanResources.EmployeeDepartmentHistory AS hed ON hem.BusinessEntityID = hed.BusinessEntityID
         INNER JOIN HumanResources.Department AS hdp ON hed.DepartmentID = hdp.DepartmentID
         INNER JOIN Person.Person AS ppe ON hem.BusinessEntityID = ppe.BusinessEntityID
WHERE hdp.Name IN ('quality assurance', 'production')
ORDER BY hdp.Name, ppe.LastName
GO

-- Seleccionar el nombre, apellido, año de la fecha de cuota y ventas totales del empleado.
-- El resultado se agrupa por nombre, apellido y año de la fecha de cuota, y se ordena por apellido y año de la fecha de cuota.
SELECT ppe.FirstName       AS Nombre,
       ppe.LastName        AS Apellido,
       YEAR(ssh.QuotaDate) AS Año,
       SUM(ssh.SalesQuota) AS 'Ventas Totales'
FROM Person.Person AS ppe
         INNER JOIN Sales.SalesPerson AS ssp ON ppe.BusinessEntityID = ssp.BusinessEntityID
         INNER JOIN Sales.SalesPersonQuotaHistory AS ssh ON ssp.BusinessEntityID = ssh.BusinessEntityID
GROUP BY ppe.FirstName, ppe.LastName, YEAR(ssh.QuotaDate)
ORDER BY ppe.LastName, YEAR(ssh.quotadate)
GO

-- Seleccionar el nombre del proveedor, nombre de la región, nombre de la provincia y dirección.
SELECT pve.Name AS Proveedor, per.Name AS Region, psp.Name AS Provincia, pad.AddressLine1 AS Direccion
FROM Purchasing.Vendor AS pve
         INNER JOIN Person.BusinessEntity AS pbe ON pve.BusinessEntityID = pbe.BusinessEntityID
         INNER JOIN Person.BusinessEntityAddress AS pba ON pba.BusinessEntityID = pbe.BusinessEntityID
         INNER JOIN Person.Address AS pad ON pba.AddressID = pad.AddressID
         INNER JOIN Person.StateProvince AS psp ON pad.StateProvinceID = psp.StateProvinceID
         INNER JOIN Person.CountryRegion AS per ON psp.CountryRegionCode = per.CountryRegionCode
GO

-- Seleccionar el nombre del producto y la cantidad total pedida.
-- El resultado se agrupa por nombre del producto y se ordena por cantidad total en orden descendente.
SELECT ppr.Name AS Producto, SUM(sso.OrderQty) AS CantidadTotal
FROM Production.Product AS ppr
         INNER JOIN SALES.salesOrderDetail AS sso ON ppr.ProductID = sso.ProductID
GROUP BY ppr.Name
ORDER BY SUM(sso.OrderQty) DESC
GO