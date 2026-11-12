CREATE DATABASE QuickCartDB;
USE QuickCartDB;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    email VARCHAR(100),
    registration_date DATE
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2),
    stock_quantity INT
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Items (
    item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    selling_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_method VARCHAR(30),
    payment_status VARCHAR(30),
    amount DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

INSERT INTO Customers VALUES
(1, 'Rahul', 'Trivandrum', 'rahul@gmail.com', '2025-01-10'),
(2, 'Anu', 'Kochi', 'anu@gmail.com', '2025-02-15'),
(3, 'Arun', 'Kollam', 'arun@gmail.com', '2025-03-20'),
(4, 'Meera', 'Trivandrum', 'meera@gmail.com', '2025-04-05'),
(5, 'Priya', 'Kozhikode', 'priya@gmail.com', '2025-05-12'),
(6, 'Kiran', 'Kochi', 'kiran@gmail.com', '2025-06-18');


INSERT INTO Products VALUES
(101, 'Laptop', 'Electronics', 55000, 8),
(102, 'Headphones', 'Electronics', 2500, 25),
(103, 'Smartphone', 'Electronics', 22000, 5),
(104, 'T-Shirt', 'Fashion', 800, 40),
(105, 'Shoes', 'Fashion', 2500, 12),
(106, 'Mixer Grinder', 'Home Appliances', 3500, 6),
(107, 'Office Chair', 'Furniture', 7500, 4);

INSERT INTO Orders VALUES
(1001, 1, '2026-10-01', 'Delivered'),
(1002, 2, '2026-10-02', 'Delivered'),
(1003, 1, '2026-10-05', 'Delivered'),
(1004, 3, '2026-10-07', 'Cancelled'),
(1005, 4, '2026-10-10', 'Delivered'),
(1006, 5, '2026-10-12', 'Pending'),
(1007, 2, '2026-10-15', 'Delivered'),
(1008, 3, '2026-10-18', 'Delivered');

INSERT INTO Order_Items VALUES
(1, 1001, 101, 1, 54000),
(2, 1001, 102, 2, 2300),
(3, 1002, 104, 3, 750),
(4, 1002, 105, 1, 2400),
(5, 1003, 103, 1, 21500),
(6, 1004, 106, 1, 3400),
(7, 1005, 107, 1, 7200),
(8, 1006, 102, 1, 2300),
(9, 1007, 104, 2, 750),
(10, 1008, 106, 2, 3300),
(11, 1008, 105, 1, 2400);

INSERT INTO Payments VALUES
(1, 1001, 'UPI', 'Paid', 58600),
(2, 1002, 'Credit Card', 'Paid', 4650),
(3, 1003, 'UPI', 'Paid', 21500),
(4, 1004, 'Debit Card', 'Refunded', 3400),
(5, 1005, 'UPI', 'Paid', 7200),
(6, 1006, 'Cash on Delivery', 'Pending', 2300),
(7, 1007, 'Credit Card', 'Paid', 1500),
(8, 1008, 'UPI', 'Paid', 9000);


-- MISSION 1: DATA EXPLORATION

-- Display all customers
SELECT * from Customers;

-- Display all products.
SELECT * from Products;

-- Display all Order_items.
SELECT * from Order_items;

-- Display all orders.
SELECT * from Orders;

-- Find the total number of customers.
SELECT COUNT(*) FROM Customers;

-- Find the total number of products.
SELECT COUNT(*) FROM Products;

-- Find the total number of orders
SELECT COUNT(*) FROM Orders;

--  Identify the different product categories.
SELECT category FROM Products GROUP BY category;

-- Find all products with stock quantity below 10.
SELECT product_name,category,stock_quantity FROM Products WHERE stock_quantity<10;

-- Find all orders with status Cancelled.
SELECT order_id,customer_id,order_status from Orders where order_status='Cancelled';

--  Display customers from a particular city.
SELECT customer_id,customer_name,city FROM Customers WHERE city='Trivandrum';


-- MISSION 2

-- Find the highest-priced product.
SELECT product_name,category,unit_price FROM Products WHERE unit_price=(select(max(unit_price)) FROM Products);
SELECT product_name,category,unit_price FROM Products ORDER BY unit_price DESC LIMIT 1;

-- Find the lowest-priced product.
SELECT product_name,category,unit_price FROM Products WHERE unit_price=(select(min(unit_price)) FROM Products);
SELECT product_name,category,unit_price FROM Products ORDER BY unit_price LIMIT 1;

-- Calculate the total quantity of products sold.
SELECT SUM(quantity) from Order_items;

-- Calculate the total sales value.
SELECT SUM(quantity*selling_price) FROM Order_items;

-- Calculate the average selling price of products sold.
SELECT AVG(selling_price) FROM Order_items;

-- Find the number of orders for each order status.
SELECT order_status,count(*)  FROM Orders GROUP BY order_status;

-- MISSION 3

-- Display each order along with the customer name.
SELECT * from Orders;
SELECT * from Customers;

SELECT Orders.*,Customers.customer_name FROM Orders 
INNER JOIN Customers ON 
Orders.customer_id=Customers.customer_id;

--  Find the number of orders placed by each customer.
SELECT customer_id,COUNT(customer_id) from Orders GROUP BY customer_id;

-- Calculate the total amount spent by each customer.
SELECT * FROM Payments;
SELECT Orders.customer_id,SUM(Payments.amount) FROM Payments INNER JOIN Orders ON Payments.order_id=Orders.order_id GROUP BY Orders.customer_id;

-- Identify the customer who has spent the most.
SELECT Orders.customer_id,SUM(Payments.amount) FROM Payments INNER JOIN Orders ON Payments.order_id=Orders.order_id GROUP BY Orders.customer_id ORDER BY SUM(Payments.amount) DESC LIMIT 1;

--  Find customers who have never placed an order.
SELECT Orders.order_id,Customers.customer_id FROM Customers LEFT JOIN Orders ON Orders.customer_id=Customers.customer_id WHERE Orders.order_id IS NULL;

-- Find customers who have placed more than two orders.
SELECT customer_id,count(order_id) FROM Orders GROUP BY customer_id HAVING COUNT(order_id)>2;

-- Find the average order value.
SELECT AVG(order_total) AS average_order_value
FROM (
    SELECT order_id,
           SUM(quantity * selling_price) AS order_total
    FROM order_items
    GROUP BY order_id
) AS order_totals;

-- Identify the city with the highest number of customers.
SELECT city,count(*) AS customer_count FROM Customers GROUP BY city ORDER BY customer_count DESC LIMIT 1;

-- Find customers who registered before a specified date
SELECT customer_name,registration_date FROM Customers WHERE registration_date<'2025-05-01'; 

-- Identify repeat customers.
SELECT customer_id,count(order_id) AS order_count    from Orders GROUP BY customer_id HAVING count(order_id)>1;


-- MISSION 4


-- Display orders with their corresponding payment status.
SELECT * FROM Orders;
SELECT * FROM Payments;

SELECT Orders.order_date,Orders.customer_id,Orders.order_status,payments.* from Payments INNER JOIN  Orders ON  Orders.order_id=Payments.order_id;


-- Find all unpaid orders.
SELECT order_id,payment_method,payment_status,amount FROM Payments WHERE payment_status NOT IN ('Paid');

-- Find all cancelled orders.
SELECT customer_id,order_date,order_status from Orders WHERE order_status='Cancelled';

-- Calculate the total amount received through each payment method.
select payment_method, SUM(amount) FROM Payments GROUP BY payment_method;

-- Count successful and failed payments.
SELECT payment_status,count(*) as payment_count FROM Payments GROUP BY payment_status;

-- Find orders where the order status is Delivered but the payment status is not Paid.
SELECT Orders.order_id,
       Orders.order_status,
       Payments.payment_status
FROM Orders
INNER JOIN Payments
ON Orders.order_id = Payments.order_id
WHERE Orders.order_status = 'Delivered'
AND Payments.payment_status <> 'Paid';

-- Identify the most commonly used payment method.
select payment_method,count(*) as payment_method_count from Payments GROUP BY payment_method ORDER BY payment_method DESC LIMIT 1;

-- MISSION 5

--  Which product category should receive more attention from the marketing team?
SELECT * FROM Products;
SELECT
    Products.category,
    SUM(Order_Items.quantity * Order_Items.selling_price) AS total_sales
FROM Products
INNER JOIN Order_Items
ON Products.product_id = Order_Items.product_id
GROUP BY Products.category
ORDER BY total_sales ASC
LIMIT 1;

-- Which products need restocking?
SELECT product_name,category,stock_quantity from Products WHERE stock_quantity<15;

-- Which payment method is most popular?
SELECT * from Payments;
SELECT payment_method,count(*) as payment_method_count from Payments GROUP BY payment_method ORDER BY count(payment_method) DESC LIMIT 1;

-- Find the second-highest-priced product
SELECT product_name, unit_price
FROM Products
ORDER BY unit_price DESC
LIMIT 1 OFFSET 1;

-- Find products that have never been ordered
SELECT * FROM Orders;
SELECT Products.product_id, Products.product_name, Products.category
FROM Products
LEFT JOIN Order_Items
ON Products.product_id = Order_Items.product_id
WHERE Order_Items.product_id IS NULL;

-- Find orders containing more than one product line
SELECT order_id, COUNT(item_id) AS product_lines
FROM Order_Items
GROUP BY order_id
HAVING COUNT(item_id) > 1;
