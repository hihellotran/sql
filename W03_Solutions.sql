use classicmodels

--01. Lấy thông tin khách hàng trong tên có chứa kí tự '
SELECT * FROM customers
WHERE customerName like '%''%'

--02. Thống kê doanh thu đặt hàng theo ngày [Day Value], sắp xếp theo doanh thu giảm dần
SELECT o.orderDate, SUM(quantityOrdered*priceEach) AS [Day Value]
FROM orders o JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY o.orderDate
ORDER BY [Day Value] DESC

--03. Lấy thông tin người quản lý cấp cao nhất
SELECT * FROM employees
WHERE reportsTo is NULL

SELECT * 
FROM employees e LEFT OUTER JOIN employees b ON e.reportsTo = b.employeeNumber
WHERE b.employeeNumber is NULL

--04. Lấy thông tin các nhân viên là quản lý văn phòng ở 'USA'
SELECT * 
FROM employees e JOIN offices o ON e.officeCode = o.officeCode
WHERE employeeNumber in (SELECT reportsTo FROM employees)
AND country = 'USA'

--05. Lấy thông tin các nhân viên không quản lý trực tiếp bất kì ai
SELECT * FROM employees
WHERE employeeNumber not in (SELECT DISTINCT reportsTo FROM employees WHERE reportsTo is not null)
ORDER BY employeeNumber

SELECT * 
FROM employees e RIGHT OUTER JOIN employees b ON e.reportsTo = b.employeeNumber
WHERE e.employeeNumber is NULL
ORDER BY b.employeeNumber

--06. Lấy mã (productCode) của các sản phẩm có tổng số lượng đã bán nhiều nhất
select productCode, SUM(quantityOrdered)
from orderdetails od
group by productCode
having SUM(quantityOrdered) >= ALL (select SUM(quantityOrdered)
									from orderdetails od
									group by productCode)

--07. Lấy mã loại sản phẩm (productLine) có tổng giá trị bán được thấp nhất
SELECT p.productLine, SUM(quantityOrdered*priceEach)
FROM products p JOIN orderdetails od ON p.productCode =  od.productCode
GROUP BY p.productLine
HAVING SUM(quantityOrdered*priceEach) <= ALL (SELECT SUM(quantityOrdered*priceEach)
											  FROM products p JOIN orderdetails od ON p.productCode =  od.productCode
											  GROUP BY p.productLine)

--08. Lấy thông tin sản phẩm cùng với % giảm giá [Discount Percent] (dựa trên buyPrice và MSRP - The Manufacturer Suggested Retail Price), không lấy số lẻ, sắp xếp theo % giảm dần.

SELECT *, FORMAT((MSRP-buyPrice)*100/MSRP,'0') AS [Discount Percent]
FROM products
ORDER BY [Discount Percent] DESC

--09. Lấy mã sản phẩm có % giảm giá thấp nhất
select *, FORMAT((MSRP-buyPrice)*100/MSRP,'#') [Discount Percent]
from products
where FORMAT((MSRP-buyPrice)*100/MSRP,'#') <= ALL (
								select FORMAT((MSRP-buyPrice)*100/MSRP,'#')
								from products)

--10. Lấy thông tin mã khách hàng cùng với tổng giá trị đã đặt hàng [Order Value] và tổng giá trị đã thanh toán [Payment Value] của khách hàng đó.
select *
from
	(select customerNumber, SUM(quantityOrdered*priceEach) 'Order Value'
	from orders o join orderdetails od on o.orderNumber=od.orderNumber
	group by customerNumber) a
join
	(select customerNumber, SUM(amount) 'Payment Value'
	from payments
	group by customerNumber) b on a.customerNumber=b.customerNumber
--11. Lấy toàn bộ thông tin những khách hàng chưa thanh toán đủ
select *
from
	(select customerNumber, SUM(quantityOrdered*priceEach) 'Order Value'
	from orders o join orderdetails od on o.orderNumber=od.orderNumber
	group by customerNumber) a
join
	(select customerNumber, SUM(amount) 'Payment Value'
	from payments
	group by customerNumber) b on a.customerNumber=b.customerNumber
where a.[Order Value]>b.[Payment Value]
--12. Lấy thông tin các nhân viên quản lý các khách hàng chưa thanh toán đủ
select *
from customers c join employees e on c.salesRepEmployeeNumber=e.employeeNumber
where customerNumber in (
						select a.customerNumber
						from
							(select customerNumber, SUM(quantityOrdered*priceEach) 'Order Value'
							from orders o join orderdetails od on o.orderNumber=od.orderNumber
							group by customerNumber) a
						join
							(select customerNumber, SUM(amount) 'Payment Value'
							from payments
							group by customerNumber) b on a.customerNumber=b.customerNumber
						where a.[Order Value]>b.[Payment Value]
						)