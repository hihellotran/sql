--MySQL
show databases;
--SQL Server
select name from sys.databases;

use classicmodels;

-- 01. List all the records in the Payments table. Display only the first 10 rows of results.
SELECT * FROM Payments LIMIT 10;
SELECT TOP 10 * FROM Payments;

-- 02. Display all the values for checkNumber in the Payments table.
SELECT checkNumber FROM Payments;

-- 03. Display all the values for paymentDate in the Payments
SELECT paymentDate FROM Payments;

-- 04. Display all the values for amount in the Payments table.
SELECT amount FROM Payments;

-- 05. Display all the values for customerNumber in the Payments table.
SELECT customerNumber FROM Payments;

-- 06. Display all the values for checkNumber in the Payments table. Sort the results by checkNumber.
SELECT checkNumber FROM Payments ORDER BY checkNumber;

-- 07. Display all the values for checkNumber in the Payments table. Sort the results by checkNumber in descending order.
SELECT checkNumber FROM Payments ORDER BY checkNumber DESC;

-- 08. Display all the values for paymentDate in the Payments table. Sort the results by paymentDate.
SELECT paymentDate FROM Payments ORDER BY paymentDate;

-- 09. Display all the values for paymentDate in the Payments table. Sort the results by paymentDate in descending order.
SELECT paymentDate FROM Payments ORDER BY paymentDate DESC;

-- 10. Display all the values for customerNumber in the Payments table. Sort the results by customerNumber.
SELECT customerNumber FROM Payments ORDER BY customerNumber;

-- 11. Display all the values for customerNumber in the Payments table. Sort the results by customerNumber in descending order.
SELECT customerNumber FROM Payments ORDER BY customerNumber DESC;

-- 12. Display the values for checkNumber and paymentDate in the Payments table.
SELECT checkNumber, paymentDate FROM Payments;

-- 13. Display the values for checkNumber and amount in the Payments table. Display only the first
SELECT top 1 checkNumber, amount FROM Payments;

-- 14. Display the values for checkNumber and customerNumber in the Payments table.
SELECT checkNumber, customerNumber FROM Payments;

-- 15. Display a list of unique customerNumber values in the Payments table.
SELECT DISTINCT(customerNumber) FROM Payments;

-- 16. Display the smallest amount value in the Payments table. Label the result 'Smallest Payment'.
SELECT MIN(amount) AS [Smallest Payment] FROM Payments;

-- 17. Display the largest amount value in the Payments table. Label the result "Largest Payment"
SELECT MAX(amount) AS "Largest Payment" FROM Payments;

-- 18. Display the average amount value in the Payments table.
SELECT AVG(amount) FROM Payments;

-- 19. Display the earliest paymentDate value in the Payments table.
SELECT MIN(paymentDate) FROM Payments;

-- 20. Display the latest paymentDate value in the Payments table.
SELECT MAX(paymentDate) FROM Payments;

-- 21. Display the customerNumber and the total payment amount assigned to that customerNumber in the Payments table. Display only the first 10 rows of results.
SELECT customerNumber, SUM(amount) FROM Payments GROUP BY customerNumber LIMIT 10;
SELECT TOP 10 customerNumber, SUM(amount) FROM Payments GROUP BY customerNumber;

-- 22. Display the customerNumber and the average payment amount assigned to that customerNumber in the Payments table.
SELECT customerNumber, AVG(amount) FROM Payments GROUP BY customerNumber LIMIT 10;
SELECT customerNumber, AVG(amount) FROM Payments GROUP BY customerNumber;

-- 23. Calculate the number of rows in the Payments table.
SELECT COUNT(*) FROM Payments;

-- 24. Count the number of unique customerNumber values in the Payments table.
SELECT COUNT(DISTINCT(customerNumber)) FROM Payments;

-- 25. Display the customerNumber values for those customerNumbers in the Payments table that have values less than 200.
SELECT customerNumber FROM Payments WHERE customerNumber < 200;

-- 26. Display the customerNumber values for those customerNumbers in the Payments table that have values between 200 and 400.
SELECT customerNumber FROM Payments WHERE customerNumber BETWEEN 200 AND 400;

-- 27. Display the customerNumber values for those customerNumbers in the Payments table that have values greater than 400.
SELECT customerNumber FROM Payments WHERE customerNumber > 400;

-- 28. Display the paymentDate values for those records in the Payments table in which the payment date is earlier than 12/31/2003.
SELECT paymentDate FROM Payments WHERE paymentDate < '2003-12-31';

-- 29. Display the paymentDate values for those records in the Payments table in which the payment date is between 12/31/2003 and 12/31/2004.
SELECT paymentDate FROM Payments WHERE paymentDate BETWEEN '2003-12-31' AND '2004-12-31';

-- 30. Display the paymentDate values for those records in the Payments table in which the payment date is 02/02/2005.
SELECT paymentDate FROM Payments WHERE paymentDate = '2005-02-02';

-- 31. Display the amount values for those records in the Payments table in which the amount values is less than the average amount value in the Payments table. Sort the results by payment amount from highest to lowest amount. Display only the first 10 rows of results.
SELECT TOP 10 amount FROM Payments WHERE amount < (SELECT AVG(amount) FROM Payments) ORDER BY amount DESC;

-- 32. Display the amount values for those records in the Payments table in which the amount values is less than the average amount value in the Payments table.
SELECT amount FROM Payments WHERE amount < (SELECT AVG(amount) FROM Payments);

-- 33. Display the customerName, paymentDate, and amount from the Payments and Customers tables. Display only the first 10 rows of results.
SELECT c.customerName, p.paymentDate, p.amount FROM Customers c JOIN Payments p ON p.customerNumber = c.customerNumber LIMIT 10;
SELECT TOP 10 customerName, paymentDate, amount FROM customers c, payments p WHERE c.customerNumber = p.customerNumber;

-- 34. Display the customerName, phone and latest paymentDate for each customer in the Payments and Customers tables. Label the latest paymentDate column as Last Payment Date. Display only the first 10 rows of results.
SELECT TOP 10 customerName, phone, MAX(paymentDate) AS [Last Payment Date]
FROM payments p JOIN customers c ON p.customerNumber = c.customerNumber
GROUP BY customerName, phone

-- 35. Display a list of country values in the Customers table along with the number of customers in each country. The list should be in alphabetical order. Display only the first 10 rows of results.
SELECT * FROM customers ORDER BY country
SELECT TOP 10 country, COUNT(*) FROM Customers GROUP BY country ORDER BY country;

-- 36. Display a list of country values in the Customers table along with the number of payments for each country. Label the number of payments column 'Payments'. The list should be in alphabetical order. Display only the first 10 rows of results.
SELECT TOP 10 country, COUNT(*) AS 'Payments'
FROM customers c, payments p
WHERE c.customerNumber = p.customerNumber
GROUP BY country
ORDER BY country
--ORDER BY [Payments] DESC

-- 37. Display a list of orderNumber and orderDate values from the Orders table. Display only the first 10 rows of results.
SELECT orderNumber, orderDate FROM Orders;

-- 38. Display the customerName, orderNumber, and orderDate values from the Customers and Orders tables. Display only the first 10 rows of results.
SELECT TOP 10 c.customerName, o.orderNumber, o.orderDate 
FROM Customers c JOIN Orders o 
ON o.customerNumber = c.customerNumber;

-- 39. Display the orderNumber, orderDate, and value of each order from the Orders and OrderDetails tables. The value of each order is calculated by multiplying quantityOrdered by priceEach. Label the calculated column "Order Value". Format the order value column so that only two digits are displayed after the decimal point. Display only the first ten results.
SELECT TOP 10 o.orderNumber, o.orderDate, FORMAT(SUM(od.quantityOrdered*od.priceEach),'#.00') AS 'Order Value' 
FROM Orders o JOIN OrderDetails od ON od.orderNumber = o.orderNumber 
GROUP BY o.orderNumber, o.orderDate;

-- 40. Display the customerName, orderNumber, and value of each order from the Orders and OrderDetails tables. The value of each order is calculated by multiplying quantityOrdered by priceEach. Label the calculated column "Order Value". Format the order value column so that only two digits are displayed after the decimal point. Display only the first ten results.
SELECT c.customerName, o.orderNumber, FORMAT(SUM(od.quantityOrdered*od.priceEach),'#.00') AS 'Order Value' 
FROM Customers c JOIN Orders o ON o.customerNumber = c.customerNumber 
JOIN OrderDetails od ON od.orderNumber = o.orderNumber 
GROUP BY c.customerName, o.orderNumber
ORDER BY c.customerName, o.orderNumber;

-- 41. Display the customerName, and value of all orders made by that customer. The value of each order is calculated by multiplying quantityOrdered by priceEach. Label the calculated column "Value of All Orders". Format the order value column so that only two digits are displayed after the decimal point. Display only the first ten results.
SELECT c.customerName, FORMAT(SUM(od.quantityOrdered*od.priceEach),'#.00') AS 'Value of All Orders' 
FROM Customers c JOIN Orders o ON o.customerNumber = c.customerNumber 
JOIN OrderDetails od ON od.orderNumber = o.orderNumber 
GROUP BY c.customerName
ORDER BY c.customerName;

-- 42. Display the customerNumber, orderNumber, and productName values for each order using the Orders, OrderDetails, and Products tables. Display only the first ten results.
SELECT o.customerNumber, od.orderNumber, pr.productName
FROM OrderDetails od JOIN Products pr ON pr.productCode = od.productCode JOIN Orders o ON o.orderNumber = od.orderNumber
ORDER BY o.customerNumber, od.orderNumber, pr.productName;

-- 43. Display the lastName of each Employee followed by the lastName of the Employee they report to. Display only the first ten results.
SELECT e.lastName, b.lastName FROM Employees e JOIN Employees b ON e.reportsTo = b.employeeNumber;

-- 44. Display the firstName and lastName of each manager followed by the firstName and lastName of each employee they supervise. Sort the results by the lastName of each manager. Display only the first ten results.
SELECT b.firstName, b.lastName, e.firstName, e.lastName FROM Employees e JOIN Employees b ON e.reportsTo = b.employeeNumber ORDER BY b.lastName;

--Advanced SQL
--1. Create a view that shows all employees who work in France
CREATE VIEW [FranceEmployees]
AS
SELECT e.*
FROM employees e JOIN offices o ON e.officeCode = o.officeCode
WHERE country = 'France'

SELECT * FROM FranceEmployees

--2. Create a view that shows all employees who work in the USA
CREATE VIEW USAEmployees
AS
SELECT e.*
FROM employees e JOIN offices o ON e.officeCode = o.officeCode
WHERE country = 'France'

ALTER VIEW USAEmployees
AS
SELECT e.*
FROM employees e JOIN offices o ON e.officeCode = o.officeCode
WHERE country = 'USA'


SELECT * FROM USAEmployees

--3. Query the view to show all employees who work in the Boston office
CREATE VIEW BostonEmployees
AS
SELECT e.*
FROM employees e JOIN offices o ON e.officeCode = o.officeCode
WHERE city = 'Boston'

SELECT * FROM BostonEmployees
--4. Find all customers for each employee.
SELECT e.employeeNumber, c.* 
FROM customers c JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber

--5. Find all orders for each customer.
--6. Find all customers where their names start with D
SELECT *
FROM customers
WHERE customerName like 'D%'
--7. Find all customers who are not located in the USA.
SELECT *
FROM customers
WHERE country != 'USA'

--8. Find the product whose buy price is in the range of $20 and $100
SELECT * FROM products WHERE buyPrice between 20 and 100