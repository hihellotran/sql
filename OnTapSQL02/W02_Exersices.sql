show databases;
select * from sys.databases;

use classicmodels;

-- 01. List all the records in the Payments table. Display only the first 10 rows of results.
select *
from payments
-- 02. Display all the values for checkNumber in the Payments table.
select checkNumber 
from payments
-- 03. Display all the values for paymentDate in the Payments
-- 04. Display all the values for amount in the Payments table.
-- 05. Display all the values for customerNumber in the Payments table.
-- 06. Display all the values for checkNumber in the Payments table. Sort the results by checkNumber.
-- 07. Display all the values for checkNumber in the Payments table. Sort the results by checkNumber in descending order.
-- 08. Display all the values for paymentDate in the Payments table. Sort the results by paymentDate.
-- 09. Display all the values for paymentDate in the Payments table. Sort the results by paymentDate in descending order.
-- 10. Display all the values for customerNumber in the Payments table. Sort the results by customerNumber.
-- 11. Display all the values for customerNumber in the Payments table. Sort the results by customerNumber in descending order.
-- 12. Display the values for checkNumber and paymentDate in the Payments table.
-- 13. Display the values for checkNumber and amount in the Payments table. Display only the first
-- 14. Display the values for checkNumber and customerNumber in the Payments table.
-- 15. Display a list of unique customerNumber values in the Payments table.
-- 16. Display the smallest amount value in the Payments table. Label the result 'Smallest Payment'.
-- 17. Display the largest amount value in the Payments table. Label the result "Largest Payment"
-- 18. Display the average amount value in the Payments table.
-- 19. Display the earliest paymentDate value in the Payments table.
-- 20. Display the latest paymentDate value in the Payments table.
-- 21. Display the customerNumber and the total payment amount assigned to that customerNumber in the Payments table. Display only the first 10 rows of results.
-- 22. Display the customerNumber and the average payment amount assigned to that customerNumber in the Payments table.
-- 23. Calculate the number of rows in the Payments table.
-- 24. Count the number of unique customerNumber values in the Payments table.
-- 25. Display the customerNumber values for those customerNumbers in the Payments table that have values less than 200.
-- 26. Display the customerNumber values for those customerNumbers in the Payments table that have values between 200 and 400.
-- 27. Display the customerNumber values for those customerNumbers in the Payments table that have values greater than 400.
-- 28. Display the paymentDate values for those records in the Payments table in which the payment date is earlier than 12/31/2003.
-- 29. Display the paymentDate values for those records in the Payments table in which the payment date is between 12/31/2003 and 12/31/2004.
-- 30. Display the paymentDate values for those records in the Payments table in which the payment date is 02/02/2005.
-- 31. Display the amount values for those records in the Payments table in which the amount values is less than the average amount value in the Payments table. Sort the results by payment amount from highest to lowest amount. Display only the first 10 rows of results.
-- 32. Display the amount values for those records in the Payments table in which the amount values is less than the average amount value in the Payments table.
-- 33. Display the customerName, paymentDate, and amount from the Payments and Customers tables. Display only the first 10 rows of results.
-- 34. Display the customerName, phone and latest paymentDate for each customer in the Payments and Customers tables. Label the latest paymentDate column as Last Payment Date. Display only the first 10 rows of results.
-- 35. Display a list of country values in the Customers table along with the number of customers in each country. The list should be in alphabetical order. Display only the first 10 rows of results.
-- 36. Display a list of country values in the Customers table along with the number of payments for each country. Label the number of payments column 'Payments'. The list should be in alphabetical order. Display only the first 10 rows of results.
-- 37. Display a list of orderNumber and orderDate values from the Orders table. Display only the first 10 rows of results.
-- 38. Display the customerName, orderNumber, and orderDate values from the Customers and Orders tables. Display only the first 10 rows of results.
-- 39. Display the orderNumber, orderDate, and value of each order from the Orders and OrderDetails tables. The value of each order is calculated by multiplying quantityOrdered by priceEach. Label the calculated column "Order Value". Format the order value column so that only two digits are displayed after the decimal point. Display only the first ten results.
-- 40. Display the customerName, orderNumber, and value of each order from the Orders and OrderDetails tables. The value of each order is calculated by multiplying quantityOrdered by priceEach. Label the calculated column "Order Value". Format the order value column so that only two digits are displayed after the decimal point. Display only the first ten results.
-- 41. Display the customerName, and value of all orders made by that customer. The value of each order is calculated by multiplying quantityOrdered by priceEach. Label the calculated column "Value of All Orders". Format the order value column so that only two digits are displayed after the decimal point. Display only the first ten results.
-- 42. Display the customerNumber, orderNumber, and productName values for each order using the Orders, OrderDetails, and Products tables. Display only the first ten results.
-- 43. Display the lastName of each Employee followed by the lastName of the Employee they report to. Display only the first ten results.
-- 44. Display the firstName and lastName of each manager followed by the firstName and lastName of each employee they supervise. Sort the results by the lastName of each manager. Display only the first ten results.

/* 
Advanced SQL
1. Create a view that shows all employees who work in France
2. Create a view that shows all employees who work in the USA
3. Query the view to show all employees who work in the Boston office
4. Find all customers for each employee.
5. Find all orders for each customer.
6. Find all customers where their names start with D
7. Find all customers who are not located in the USA.
8. Find the product whose buy price is in the range of $20 and $100
*/