use modelcarsdb;
-- Task 1.1 

select customerName, creditLimit from customers order by creditLimit desc 
limit 10;

-- Task 1.2

select country, avg(creditLimit) as averageCreditLimit from customers
group by country order by averageCreditLimit desc;

-- Task 1.3 

select state, count(*) as numberOfCustomers from customers
group by state order by numberOfCustomers desc;

-- Task 1.4 

select customers.customerName from customers
left join orders on customers.customerNumber = orders.customerNumber
where orders.orderNumber is null;

-- Task 1.5

	select customers.customerName, sum(orderdetails.quantityOrdered * orderdetails.priceEach) as totalSales from customers
	join orders on customers.customerNumber = orders.customerNumber
	join orderdetails on orders.orderNumber = orderdetails.orderNumber
	group by customers.customerName order by totalSales desc;

-- Task 1.6

select customers.customerName, concat(employees.firstName, ' ', employees.lastName) as salesRepresentative from customers
left join employees on customers.salesRepEmployeeNumber = employees.employeeNumber;

-- Task 1.7

select customers.customerName,customers.contactLastName, customers.contactFirstName, customers.phone, payments.paymentDate, payments.amount from customers
join payments on customers.customerNumber = payments.customerNumber where payments.paymentDate = 
(
	select max(p.paymentDate) from payments p 
	where p.customerNumber = customers.customerNumber
)
order by payments.paymentDate desc;

-- Task 1.8

select customers.customerName, customers.creditLimit, sum(payments.amount) as totalPayments from customers
join payments on customers.customerNumber = payments.customerNumber
group by customers.customerNumber having totalPayments > customers.creditLimit
order by totalPayments desc;

-- Task 1.9

select distinct customers.customerName from customers
join orders on customers.customerNumber = orders.customerNumber
join orderdetails on orders.orderNumber = orderdetails.orderNumber
join products on orderdetails.productCode = products.productCode
join productlines on products.productLine = productlines.productLine
where productlines.productLine = 'YourSpecificProductLine';

-- Task 1.10

select distinct customers.customerName from customers
join orders on customers.customerNumber = orders.customerNumber
join orderdetails on orders.orderNumber = orderdetails.orderNumber
join products on orderdetails.productCode = products.productCode
where products.buyPrice = (select max(buyPrice) from products);

-- Task 2.1

select offices.city as officeLocation, count(employees.employeeNumber) as numberOfEmployees from offices
left join employees on offices.officeCode = employees.officeCode
group by offices.city
order by numberOfEmployees desc;

-- Task 2.2 

select offices.city as officeLocation, count(employees.employeeNumber) as numberOfEmployees from offices
left join employees ON offices.officeCode = employees.officeCode
group by offices.city
having count(employees.employeeNumber) < 10
order by numberOfEmployees asc;

-- Task 2.3 

select officeCode, city as officeLocation, territory from offices;

-- Task 2.4 

select offices.officeCode, offices.city as officeLocation from offices
left join employees on offices.officeCode = employees.officeCode
where employees.employeeNumber is null;

-- Task 2.5 

select  offices.officeCode, offices.city AS officeLocation, 
    sum(orderdetails.quantityOrdered * orderdetails.priceEach) as totalSales from offices
join employees on offices.officeCode = employees.officeCode
join customers on employees.employeeNumber = customers.salesRepEmployeeNumber
join orders on customers.customerNumber = orders.customerNumber
join orderdetails on orders.orderNumber = orderdetails.orderNumber
group by offices.officeCode, offices.city
order by totalSales desc
limit 1;

-- Task 2.6

select offices.officeCode, offices.city as officeLocation,
    count(employees.employeeNumber) as numberOfEmployees from offices
left join employees on offices.officeCode = employees.officeCode
group by offices.officeCode, offices.city
order by numberOfEmployees desc
limit 1;

-- Task 2.7

select offices.officecode, offices.city as officelocation, 
    avg(customers.creditlimit) as averagecreditlimit from offices
join employees on offices.officecode = employees.officecode
join customers on employees.employeenumber = customers.salesrepemployeenumber
group by offices.officecode, offices.city;

-- Task 2.8

select country, count(officecode) as numberofoffices from offices
group by country;

--  Task 3.1
select * from products;

select productline, count(productcode) as numberofproducts from products
group by productline;

-- Task 3.2


select productline, avg(buyprice) as averageprice from products
group by productline
order by averageprice desc
limit 1;

-- Task 3.3
select productname, msrp from products
where msrp between 50 and 100;

-- Task 3.4

select productline, sum(quantityordered * priceeach) as total_sales_amount from products
join orderdetails on products.productcode = orderdetails.productcode
group by productline;


-- Task 3.5

select productname, quantityinstock from products
where quantityinstock < 10;
;

-- Task 3.6
select productname, msrp
from products
order by msrp desc
limit 1;


-- Task 3.7

select productname, sum(quantityordered * priceeach) as total_sales
from products
join orderdetails on products.productcode = orderdetails.productcode
group by productname;


-- Task 3.8

delimiter //

create procedure top_selling_products(in top_n int)
begin
    select productname, sum(quantityordered) as total_quantity_ordered
    from products
    join orderdetails on products.productcode = orderdetails.productcode
    group by productname
    order by total_quantity_ordered desc
    limit top_n;
end //

delimiter ;


-- Task 3.9
select productname, productline, quantityinstock
from products
where quantityinstock < 10
and productline in ('Classic Cars', 'Motorcycles');


-- Task 3.10

select productname
from products
join orderdetails on products.productcode = orderdetails.productcode
join orders on orderdetails.ordernumber = orders.ordernumber
group by productname
having count(distinct orders.customernumber) > 10;


-- Task 3.11

select productname, productline, sum(quantityordered) as total_orders
from products
join orderdetails on products.productcode = orderdetails.productcode
group by productname, productline
having sum(quantityordered) > (
    select avg(total_quantity)
    from (
        select productline, sum(quantityordered) as total_quantity
        from products
        join orderdetails on products.productcode = orderdetails.productcode
        group by productline
    ) as productline_avg
    where productline_avg.productline = products.productline
);


 -- Sprint  10 
 -- Task 1.1
select count(*) AS total_employees from employees;


-- Task 1.2

select employeeNumber, firstName, lastName, email, jobTitle from employees;

-- Task 1.3
select jobTitle, count(*) as employee_count from employees group by jobTitle;

-- Task 1.4

select employeeNumber, firstName, lastName from employees where reportsTo is null;

-- Task 1.5
select e.employeeNumber, e.firstName, e.lastName, sum(od.priceEach * od.quantityOrdered) as total_sales from employees e
join customers c on e.employeeNumber = c.salesRepEmployeeNumber
join orders o on c.customerNumber = o.customerNumber
join orderdetails od on o.orderNumber = od.orderNumber
group by e.employeeNumber, e.firstName, e.lastName;

-- Task 1.6

select e.employeeNumber, e.firstName, e.lastName, sum(od.priceEach * od.quantityOrdered) as total_sales from employees e
join customers c on e.employeeNumber = c.salesRepEmployeeNumber
join orders o on c.customerNumber = o.customerNumber
join orderdetails od on o.orderNumber = od.orderNumber
group by e.employeeNumber, e.firstName, e.lastName
order by total_sales desc
limit 1;

-- Task 1.7

select e.employeeNumber, e.firstName, e.lastName from employees e
join customers c on e.employeeNumber = c.salesRepEmployeeNumber
join orders o on c.customerNumber = o.customerNumber
join orderdetails od on o.orderNumber = od.orderNumber
group by e.employeeNumber, e.firstName, e.lastName
having sum(od.priceEach * od.quantityOrdered) > (
    select avg(total_sales)
    from (
        select sum(od2.priceEach * od2.quantityOrdered) as total_sales
        from employees e2
        join customers c2 on e2.employeeNumber = c2.salesRepEmployeeNumber
        join orders o2 on c2.customerNumber = o2.customerNumber
        join orderdetails od2 on o2.orderNumber = od2.orderNumber
        where e.locationCode = e2.locationCode 
        group by e2.employeeNumber
    ) as office_sales
)
limit 1000;





 -- Task 2.1
 
select customerNumber, AVG(orderAmount) as averageOrderAmount from orders
group by customerNumber;


-- Task 2.2

select date_format(orderDate, '%Y-%m') AS orderMonth, count(orderNumber) as numberOfOrders from orders
group by orderMonth
order by orderMonth;

-- Task 2.3 

select orderNumber, orderDate, customerNumber from orders
where status = 'Pending';

-- Task 2.4

select orders.orderNumber, orders.orderDate, customers.customerName, customers.contactLastName, customers.contactFirstName, 
    customers.phone, customers.addressLine1, customers.city, customers.state, customers.postalCode, customers.country
from orders
join customers on orders.customerNumber = customers.customerNumber;

-- Task 2.5

select * from orders order by orderDate desc
limit 10;

-- Task 2.6

select orderNumber, sum(quantityOrdered * priceEach) AS totalSales from orderdetails
group by orderNumber;

-- Task 2.7

select orderNumber, sum(quantityOrdered * priceEach) as totalSales from orderdetails
group by orderNumber
order by totalSales desc
limit 1;

-- Task 2.8

select 
    orders.orderNumber, orders.orderDate, orderdetails.productCode, orderdetails.quantityOrdered, 
    orderdetails.priceEach, (orderdetails.quantityOrdered * orderdetails.priceEach) AS total
from orders
join  orderdetails on orders.orderNumber = orderdetails.orderNumber;

-- Task 2.9

select productCode, sum(quantityOrdered) AS totalQuantityOrdered from orderdetails
group by productCode
order by totalQuantityOrdered DESC
limit 10;

-- Task 2.10

select orderNumber, sum(quantityOrdered * priceEach) as totalRevenue from orderdetails
group by orderNumber;

-- Task 2.11

select orderNumber, sum(quantityOrdered * priceEach) as totalRevenue from orderdetails
group by orderNumber
order by totalRevenue desc
limit 10;

-- Task 2.12

select orders.orderNumber, orders.orderDate, products.productName, products.productLine, products.productScale, 
    products.productVendor, orderdetails.quantityOrdered, orderdetails.priceEach from orders
join orderdetails on orders.orderNumber = orderdetails.orderNumber
join products on orderdetails.productCode = products.productCode;

-- Task 2.13

select orderNumber, requiredDate, shippedDate from orders
where shippedDate > requiredDate;

-- Task 2.14

select od1.productCode as productCode1, od2.productCode as productCode2, count(*) as combinationCount from orderdetails od1
join orderdetails od2 on od1.orderNumber = od2.orderNumber 
    and od1.productCode < od2.productCode
group by productCode1, productCode2
order by combinationCount desc
limit 10;

-- Task 2.15

select orderNumber, sum(quantityOrdered * priceEach) AS totalRevenue from orderdetails
group by orderNumber
order by totalRevenue desc
limit 10;

-- Task 2.16

delimiter //

create trigger update_credit_limit_after_order after insert on orders
for each row
begin
    declare order_total decimal(10, 2);
    select sum(quantityordered * priceeach) into order_total from orderdetails
    where ordernumber = new.ordernumber;

    update customers
    set creditlimit = creditlimit - order_total
    where customernumber = new.customernumber;
end; //

delimiter ;

-- Task 2.17

delimiter //

create trigger log_product_quantity_change
after insert or update on orderdetails
for each row
begin
    insert into product_quantity_log (productcode, changedate, changetype, quantitychanged)
    values (new.productcode, now(), 'insert/update', new.quantityordered);
end; //

delimiter ;







 