-- Create table
CREATE TABLE transactions (
    Customer_ID VARCHAR(10),
    Transaction_ID VARCHAR(10),
    Transaction_Date DATE,
    Purchase_Amount DECIMAL(10,2),
    Product_Category VARCHAR(50),
    Payment_Method VARCHAR(20),
    Region VARCHAR(50),
    Tenure INT
);

-- Total revenue per customer (CLV)
SELECT
    Customer_ID,
    SUM(Purchase_Amount) AS CLV
FROM transactions
GROUP BY Customer_ID
ORDER BY CLV DESC;

-- Monthly revenue trend
SELECT
    DATE_FORMAT(Transaction_Date, '%Y-%m') AS Month,
    SUM(Purchase_Amount) AS Monthly_Revenue
FROM transactions
GROUP BY Month
ORDER BY Month;

-- Customer purchase frequency
SELECT
    Customer_ID,
    COUNT(Transaction_ID) AS Total_Transactions
FROM transactions
GROUP BY Customer_ID
ORDER BY Total_Transactions DESC;

-- Average order value per customer
SELECT
    Customer_ID,
    AVG(Purchase_Amount) AS Avg_Order_Value
FROM transactions
GROUP BY Customer_ID;

-- Retention analysis (customers with more than 1 purchase)
SELECT
    COUNT(DISTINCT Customer_ID) AS Returning_Customers
FROM transactions
WHERE Customer_ID IN (
    SELECT Customer_ID
    FROM transactions
    GROUP BY Customer_ID
    HAVING COUNT(Transaction_ID) > 1
);

-- Churn identification (no purchase in last 30 days)
SELECT
    Customer_ID,
    MAX(Transaction_Date) AS Last_Purchase_Date
FROM transactions
GROUP BY Customer_ID
HAVING MAX(Transaction_Date) < DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Customer segmentation based on CLV
SELECT
    Customer_ID,
    SUM(Purchase_Amount) AS CLV,
    CASE
        WHEN SUM(Purchase_Amount) >= 2000 THEN 'High Value'
        WHEN SUM(Purchase_Amount) BETWEEN 1000 AND 1999 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Customer_Segment
FROM transactions
GROUP BY Customer_ID;

-- Revenue by region
SELECT
    Region,
    SUM(Purchase_Amount) AS Total_Revenue
FROM transactions
GROUP BY Region
ORDER BY Total_Revenue DESC;

-- Revenue by product category
SELECT
    Product_Category,
    SUM(Purchase_Amount) AS Category_Revenue
FROM transactions
GROUP BY Product_Category
ORDER BY Category_Revenue DESC;
