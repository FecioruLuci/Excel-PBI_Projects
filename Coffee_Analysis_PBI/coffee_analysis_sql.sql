
DROP TABLE IF EXISTS coffee;
CREATE TABLE coffee(
transaction_id	INT PRIMARY KEY,
transaction_date	DATE,
transaction_time	TIME,
transaction_qty	INT,
store_id	INT,
store_location	VARCHAR(25),
product_id	INT,
unit_price	FLOAT,
product_category	VARCHAR(25),
product_type	VARCHAR(25),
product_detail	VARCHAR(30)
)

--Total sales by month
SELECT
	TO_CHAR(transaction_date, 'MON') AS monthh
FROM coffee;

ALTER TABLE coffee
ADD COLUMN month_name VARCHAR(15)

UPDATE coffee
SET month_name = (
	TO_CHAR(transaction_date, 'MON')
)

SELECT
	month_name,
	ROUND(SUM(transaction_qty * unit_price)::numeric,2) AS total_sales
FROM coffee
GROUP BY 1

-- Month on Month sales increase or decrease in sales
WITH table1
AS
(
SELECT
	EXTRACT(month from transaction_date) as month_number,
	ROUND(SUM(transaction_qty * unit_price)::numeric,2) total_rev_month
FROM coffee
GROUP BY 1
)
SELECT
	month_number,
	total_rev_month,
	LAG(total_rev_month) OVER(ORDER BY month_number) as last_month_rev,
	ROUND(total_rev_month - LAG(total_rev_month) OVER(ORDER BY month_number)::numeric,2) AS rev_difference,
	ROUND((total_rev_month - LAG(total_rev_month) OVER(ORDER BY month_number)) / LAG(total_rev_month) OVER(ORDER BY month_number)::numeric,2) AS perc_grow
FROM table1

-- calculate the total number of orders for each month

ALTER TABLE coffee
ADD COLUMN month_order INT

UPDATE coffee
SET month_order = (

	EXTRACT(month from transaction_date) * 10
)

SELECT
	month_name,
	month_order,
	COUNT(transaction_id) AS total_nr_of_orders
FROM coffee
GROUP BY 1,2
ORDER BY 2 ASC

-- determine the month on month increase or decrease in the number of orders
WITH table1
AS
(
SELECT
	EXTRACT(month from transaction_date) as monthh,
	COUNT(transaction_id) as total_orders
FROM coffee
GROUP BY 1
)
SELECT
	*
FROM
(
SELECT
	monthh,
	total_orders,
	LAG(total_orders) OVER(ORDER BY monthh) AS last_month_orders,
	ROUND((total_orders - LAG(total_orders) OVER(ORDER BY monthh)) / LAG(total_orders) OVER(ORDER BY monthh)::numeric,2) AS percentage_growth
FROM table1
)
WHERE last_month_orders IS NOT NULL

ALTER TABLE coffee
ADD COLUMN month2 DATE

UPDATE coffee
SET month2 = (
TO_DATE(transaction_date, 'DD-MM-YYYY')
)

SELECT *
FROM coffee

ALTER TABLE coffee
DROP COLUMN month2

-- Total sales in weekends

SELECT
	EXTRACT(dow FROM transaction_date)
FROM coffee

-- 0 = sunday ; 1 = monday
SELECT
	week_segmentation,
	ROUND(SUM(unit_price * transaction_qty)::numeric,2) AS total_rev
FROm
(
SELECT
	unit_price,
	transaction_qty,
	CASE WHEN EXTRACT(dow FROM transaction_date) = 0 THEN 'Weekend'
	ELSE 'Weekday'
	END AS week_segmentation
FROM coffee
)
GROUP BY 1