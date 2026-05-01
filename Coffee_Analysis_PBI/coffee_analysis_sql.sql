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
	SUM(transaction_qty) AS total_sales
FROM coffee
GROUP BY 1