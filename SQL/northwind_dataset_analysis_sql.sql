
-- QUESTIONS :

-- How many customers are there of each type?

select ccd.CustomerTypeID,
     COUNT(c.CustomerID) as customer_count
from Customers c
left join CustomerCustomerDemo ccd on c.CustomerID=ccd.CustomerID
group by ccd.CustomerTypeID


--  How many customers are there from each country?

select Country,
     COUNT(CustomerID) as customer_count
from Customers
group by Country

--  How many products are there in each product category?

select c.CategoryName,
     (select count(p.ProductID)
      from Products p
    where c.CategoryID=p.CategoryID
    ) as product_count
from Categories c
group by c.CategoryName, c.CategoryID


--  What are the 10 most expensive products?

select top 10 ProductName
from Products
order by UnitPrice desc


--  How many orders did each worker receive?

select e.FirstName + ' ' + e.LastName as employee,
       (select count(o.OrderID)
      from Orders o
    where o.EmployeeID=e.EmployeeID) as order_count
from Employees e
group by e.FirstName,e.LastName,e.EmployeeID

--  What is the average product price for each category?

select c.CategoryName,
     (select avg(p.UnitPrice)
      from Products p
    where c.CategoryID=p.CategoryID
    ) as average_product_price
from Categories c
group by c.CategoryName, c.CategoryID

--  How many orders were placed in 1997?

select count(OrderID) as order_count_in1997
from Orders
where year(OrderDate) = 1997

--  What are the products with less than 50 left in stock?

select ProductName
from Products
where UnitsInStock<50

-- How many orders does each customer have?

select c.ContactName,
     (select count(o.OrderID)
      from Orders o
    where c.CustomerID=o.CustomerID) as order_count
from Customers c
group by c.ContactName, c.CustomerID

-- Top 5 customers with the highest number of orders:

select top 5 CustomerID,
     count(OrderID) as order_count
from Orders
group by CustomerID 
order by order_count desc

----------------------------------------------------------------------------------------------------

-- Top 5 customers with the highest order amount:

select s.CustomerID,
     round(sum(s.mebleg),2) as mebleg1
from 
(select o.CustomerID,
       (select sum((od.UnitPrice - od.UnitPrice*od.Discount)*od.Quantity)
      from [Order Details] od
    where od.OrderID=o.OrderID) mebleg
from orders o) s
group by s.CustomerID


--  Sales amount of each worker + number of orders :

select 
    o.EmployeeID,
    sum((od.UnitPrice - od.UnitPrice * od.Discount) * od.Quantity) as sales,
    count(o.order_id) as order_count
from Orders o
join [Order Details] od
    on o.OrderID = od.OrderID
group by o.EmployeeID;


-- Total sales amount

select sum((od.UnitPrice- od.UnitPrice*od.Discount)*od.Quantity) as sales
from [Order Details] od

-- How many orders were delivered late?

select count(s.OrderID) as delayed_orders
from
(select o.OrderID,
       o.RequiredDate,
     o.ShippedDate,
     DATEDIFF(day,RequiredDate,ShippedDate) as date_difference
from Orders o) s
where s.date_difference>0


-- What products should be ordered for stock and how much should be ordered?

select s.ProductName,
     s.order_case,
     case when s.order_case = 'yeniden sifaris et' then s.ReorderLevel - (s.UnitsInStock + s.UnitsOnOrder)
     else 0
     end as unit_required
from
(select ProductName,
       UnitsInStock,
     UnitsOnOrder,
     ReorderLevel,
       case when UnitsInStock + UnitsOnOrder < ReorderLevel then 'yeniden sifaris et'
     else 'ehtiyac yoxdur'
     end as order_case
from Products ) s

-- What are the discounted products?

select ProductName
from Products
where Discontinued = 1

-- How many workers are there from each country?
 
 select country,
    COUNT(EmployeeID) employee_count
 from Employees
 group by Country


 -- How many products does each supplier bring?

 select SupplierID,
      (select count(p.ProductID)
     from Products p
     where p.SupplierID = s.SupplierID) as product_count
 from Suppliers s 
 order by product_count desc

 -- How many orders has each shipping company delivered?

 select s.CompanyName,
    (select count(o.OrderID)
     from Orders o
     where o.ShipVia=s.ShipperID) as order_count
 from Shippers s


-- Which shipping company has had the most delivery delays?

select s.ShipVia,
     count(s.OrderID) as late_order_count
from
(select o.OrderID,
       o.RequiredDate,
     o.ShippedDate,
     o.ShipVia,
     DATEDIFF(day,RequiredDate,ShippedDate) as date_difference
from Orders o
left join Shippers sh on sh.ShipperID = o.ShipVia
) s
where s.date_difference>0
group by s.ShipVia
order by late_order_count desc

--------------------------------------------------------------------------------

-- How many employees were hired each year?

select YEAR(HireDate),
     COUNT(EmployeeID) employee_count
from Employees
group by YEAR(HireDate)


-- How many orders were shipped to each country, and how many of those orders were delayed?

select s.ShipCountry,
     s.total_orders,
     s.delayed_orders,
     ROUND(CONVERT(FLOAT, s.delayed_orders) / s.total_orders * 100, 1) as delay_rate
from 
(select 
    o.ShipCountry,
    COUNT(o.OrderID) as total_orders,
    SUM(case 
            when DATEDIFF(day, o.RequiredDate, o.ShippedDate) > 0 
            then 1 
            else 0 
        end) as delayed_orders
from Orders o
group by o.ShipCountry) s;


-- Which category does each supplier supply the most products from?

select dd.SupplierID,
     dd.CategoryName,
     dd.product_count
from
(select d.SupplierID,
     d.CategoryName,
     d.product_count,
     ROW_NUMBER() over (partition by d.SupplierID order by d.product_count desc) as rownum
from
(select s.SupplierID,
     c.CategoryName,
     count(p.ProductID) as product_count
from Products p
join Categories c on c.CategoryID=p.CategoryID
join Suppliers s on s.SupplierID=p.SupplierID
group by s.SupplierID, c.CategoryName) d ) dd
where dd.rownum = 1


-- What are the On Delivery Time Rate and Delay Rate ?

select 
    count(s.OrderID) as total_orders,
    round(sum(case when s.date_difference>0 then 1 else 0 end)*100.0/count(s.OrderID),2) as delay_rate,
    round(sum(case when s.date_difference<=0 then 1 else 0 end)*100.0/count(s.OrderID),2) as on_deliverytime_rate
from
(select OrderID,
     RequiredDate,
     ShippedDate,
     DATEDIFF(day,RequiredDate,ShippedDate) as date_difference
from Orders) s


-- What is the Average Delivery Time? (in days)

select 
       sum(s.delivery_time) / count(s.OrderID) avg_delivery_time
from
(select OrderID,
     RequiredDate,
     ShippedDate,
     DATEDIFF(day,OrderDate,ShippedDate) as delivery_time
from Orders) s


-- How many orders were shipped to each city in each country?

select
  o.ShipCountry,
  o.ShipCity,
  count(o.OrderID) as order_count
from Orders o
group by o.ShipCountry, o.ShipCity

-- What are the top 10 orders with the highest total amount?

select  top 10 OrderID,
     round(sum((UnitPrice - UnitPrice*Discount)*Quantity),2) as mebleg
from [Order Details]
group by OrderID
order by mebleg desc

-- Which category does each customer order the most from?

select ss.CustomerID,
     ss.CategoryName,
     ss.order_count
from
(select s.CustomerID,
       s.CategoryName,
     s.order_count,
     ROW_NUMBER() over(partition by s.CustomerID order by s.order_count desc) rownum
from 
(select 
     c.CustomerID,
       cat.CategoryName,
       COUNT(od.OrderID) as order_count
from Customers c
join Orders o on c.CustomerID = o.CustomerID
join [Order Details] od on o.OrderID = od.OrderID
join Products p on od.ProductID = p.ProductID
join Categories cat on p.CategoryID = cat.CategoryID
group by c.CustomerID, cat.CategoryName) s ) ss
where ss.rownum = 1



-- Which product is ordered the most in each category?

select ss.CategoryName,
     ss.ProductName,
     ss.order_count
from
(select s.CategoryName,
     s.ProductName,
     s.order_count,
     ROW_NUMBER() over (partition by s.CategoryName order by s.order_count desc) as rownum
from 
(select 
     cat.CategoryName,
     p.ProductName,
     count(o.OrderID) as order_count
from Orders o
join [Order Details] od on o.OrderID = od.OrderID
join Products p on od.ProductID = p.ProductID
join Categories cat on p.CategoryID = cat.CategoryID
group by cat.CategoryName, p.ProductName) s) ss
where rownum = 1


-- Which is the most expensive product in each category?

select s.CategoryName,
       s.ProductName,
     s.UnitPrice
from
(select distinct 
     cat.CategoryName,
     p.ProductName,
     p.UnitPrice,
     ROW_NUMBER() over (partition by cat.CategoryName order by p.UnitPrice desc) as rownum
from Products p 
join Categories cat on p.CategoryID = cat.CategoryID) s
where rownum = 1

----------------------------------------------------------------------------------------------------------------------

-- Which employees work in more than 5 territories?

select s.full_name
from
(select e.FirstName + ' ' + e.LastName as full_name,
     (select count(te.TerritoryID)
      from EmployeeTerritories te 
    where te.EmployeeID=e.EmployeeID) as territory_count
from Employees e) s
where s.territory_count>5

-- How many territories are there in each region?

select r.RegionDescription,
       (select count(t.TerritoryID)
      from Territories t
    where r.RegionID=t.RegionID) as territory_count
from Region r

-- How many employees work in each region?

select r.RegionDescription,
     count(te.EmployeeID) employee_count
from Region r
join Territories t on t.RegionID=r.RegionID
join EmployeeTerritories te on te.TerritoryID= t.TerritoryID
group by r.RegionDescription


-- Which is the cheapest product?

select top 1 ProductName,
     UnitPrice
from Products
order by UnitPrice

-- How many orders were placed each year?

select YEAR(OrderDate) as order_year,
     COUNT(OrderID) as order_count
from Orders
group by YEAR(OrderDate) ;

-- How does the number of orders change by month?

select FORMAT(OrderDate, 'MMM') AS months,
     COUNT(OrderID) as order_count
from Orders
group by FORMAT(OrderDate, 'MMM');

-- What is the peak day (the day with the highest number of orders)?

select top 1 DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), DAY(OrderDate)) as date_column,
     COUNT(OrderID) as order_count
from Orders
group by DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), DAY(OrderDate))
order by order_count desc

-- What is the AOV per customer?

select round(sum((od.UnitPrice- od.UnitPrice*od.Discount)*od.Quantity) / COUNT(distinct c.CustomerID),2) as aov_per_customer
from [Order Details] od 
join Orders o on od.OrderID=o.OrderID
join Customers c on c.CustomerID=o.CustomerID


--- What is AOV per order ?

select round(sum((od.UnitPrice - od.UnitPrice*od.Discount)*od.Quantity) / count(distinct od.OrderID),2) as aov_per_order
from [Order Details] od


-- What is each customer's favorite product? (The product they ordered most frequently, regardless of quantity.)

select ss.ContactName,
     ss.ProductName,
     ss.countt
from 
(select s.ContactName,
     s.ProductName,
     s.countt,
     ROW_NUMBER() over (partition by s.ContactName order by s.countt desc) as rownum
from
(select c.ContactName,
     p.ProductName,
     sum(od.Quantity) as quantity,
     count(p.ProductID) as countt
from Orders o
join [Order Details] od on o.OrderID=od.OrderID
join Products p on p.ProductID=od.ProductID
join Customers c on c.CustomerID=o.CustomerID
group by c.ContactName, p.ProductName ) s ) ss
where ss.rownum = 1


-- What are the 3 least-ordered products?

select top 3 p.ProductName,
     sum(od.Quantity) as quantity
from Orders o 
join [Order Details] od on o.OrderID=od.OrderID
join Products p on p.ProductID=od.ProductID
group by p.ProductName
order by quantity

----------------------------------------------------------------------------------------------------------------

-- Are there any products that have never been sold?  (No.)

select p.ProductName
from Products p
where p.ProductID not in (select od.ProductID
              from [Order Details] od)


-- How many customers placed only one order, and how many placed more than two orders?

select s.CustomerID,
     case when s.order_count=1 then '1 defe sifaris eden'
     else '1-den cox sifaris eden' end as sifaris_statusu
from
(select CustomerID,
     COUNT(OrderID) as order_count
from Orders
group by CustomerID) s

-- Which customers have never placed an order?

select c.ContactName
from Customers c
where c.CustomerID not in (select o.CustomerID
               from Orders o)


-- What is the average delivery time for orders?

select AVG(DATEDIFF(day, OrderDate, ShippedDate)) as avg_ship_date
from Orders


-- Which month had the highest sales? (Based on total sales amount, not order count.)

select o.OrderID,
     sum((od.UnitPrice -od.UnitPrice*od.Discount)*od.Quantity),
     FORMAT(o.OrderDate, 'MMM') as months
from Orders o
join [Order Details] od on o.OrderID=od.OrderID
group by o.OrderID, FORMAT(o.OrderDate, 'MMM')


-- What percentage of all orders were placed with a discount?

select round((s.discounted_orders*1.0/s.total_orders)* 100,0)
from
(select count(o.OrderID) total_orders,
       sum(case when od.Discount<> 0 then 1
         else 0 end) as discounted_orders
from Orders o
join [Order Details] od on o.OrderID=od.OrderID ) s



---------------------------------------------------------------------------------------------------------------------------------
-



select *
from orders

select *
from [Order Details]

select *
from Products

select *
from Suppliers

select *
from Categories

select *
from Employees

select *
from Region

select *
from CustomerCustomerDemo
