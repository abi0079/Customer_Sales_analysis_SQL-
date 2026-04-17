USE customer_sales_db;

-- total revenue generated --
SELECT SUM(Total_Amount) AS Total_Revenue
FROM orders;

-- Top 5 customers --
SELECT c.Customer_Name, SUM(o.Total_Amount) AS Total_Sales
FROM customers c
JOIN orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_Name
ORDER BY Total_Sales DESC
LIMIT 5;

-- City generates the highest revenue --

SELECT c.City, SUM(o.Total_Amount) AS Revenue
FROM customers c
JOIN orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.City
ORDER BY Revenue DESC;

-- Best-selling product --

SELECT Product, SUM(Quantity) AS Total_Sold
FROM orders
GROUP BY Product
ORDER BY Total_Sold DESC;

-- Highest revenue according to Catagory -- 

SELECT Category, SUM(Total_Amount) AS Revenue
FROM orders
GROUP BY Category
ORDER BY Revenue DESC;

-- Repeat customers --

SELECT c.Customer_Name, COUNT(o.Order_ID) AS Orders_Count
FROM customers c
JOIN orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_Name
HAVING COUNT(o.Order_ID) > 1
ORDER BY Orders_Count DESC;

-- Monthly sales trend --


SELECT 
    MONTH(Order_Date) AS Month,
    SUM(Total_Amount) AS Revenue
FROM orders
GROUP BY Month
ORDER BY Month;

-- Find high-value orders (> 50,000) --

SELECT *
FROM orders
WHERE Total_Amount > 50000
ORDER BY Total_Amount desc;


-- Customer Lifetime Value (CLV) --

SELECT c.Customer_Name, SUM(o.Total_Amount) AS Lifetime_Value
FROM customers c
JOIN orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_Name
ORDER BY Lifetime_Value DESC;

-- Customers Ranking based on spending --

SELECT 
    c.Customer_Name,
    SUM(o.Total_Amount) AS Total_Sales,
    RANK() OVER (ORDER BY SUM(o.Total_Amount) DESC) AS Rank_Position
FROM customers c
JOIN orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_Name;

-- Average Order Value -- 

SELECT AVG(Total_Amount) AS Avg_Order_Value
FROM orders;

-- Customers with No Orders --

SELECT c.Customer_Name
FROM customers c
LEFT JOIN orders o ON c.Customer_ID = o.Customer_ID
WHERE o.Order_ID IS NULL;

-- Running Total of Sales --

SELECT 
    Order_Date,
    SUM(Total_Amount) AS Daily_Sales,
    SUM(SUM(Total_Amount)) OVER (ORDER BY Order_Date) AS Running_Total
FROM orders
GROUP BY Order_Date;

-- Top Product in Each Category --

SELECT Category, Product, Total_Sold
FROM (
    SELECT 
        Category,
        Product,
        SUM(Quantity) AS Total_Sold,
        RANK() OVER (PARTITION BY Category ORDER BY SUM(Quantity) DESC) AS rnk
    FROM orders
    GROUP BY Category, Product
) ranked
WHERE rnk = 1;