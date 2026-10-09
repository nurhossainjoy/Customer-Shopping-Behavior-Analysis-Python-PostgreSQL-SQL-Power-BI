/*1. Revenue Contribution by Male and Female */
SELECT
gender,
SUM(purchase_amount) AS Revenue
FROM customer
GROUP BY gender; 
/* 02. Which customers used discount and still spent more than the average */
SELECT
customer_id,
SUM(purchase_amount) AS revenue,
(SELECT ROUND(AVG(purchase_amount), 2)FROM customer) AS avg_purchase
FROM customer
WHERE discount_applied = 'Yes'
GROUP BY customer_id
HAVING SUM(purchase_amount) > (SELECT AVG(purchase_amount)FROM customer)
ORDER BY revenue DESC;
/* 03. Top 5 products with highest average review ratings */
SELECT
item_purchased,
category,
ROUND(AVG(review_rating)::numeric,2) AS avg_rating
FROM customer
GROUP BY item_purchased, category
ORDER BY avg_rating DESC
LIMIT 5;
/* 04. Compare the average purchase amount between standered and express Shipping*/
SELECT
shipping_type,
ROUND(AVG(purchase_amount):: numeric,2) AS avg_purchase_amount
FROM customer
WHERE "shipping_type" IN('Standard','Express')
GROUP BY shipping_type;
/*05. Do subscribed customers spend more? Compare average spend and total revenue between subscibers and non subscribers */
SELECT
subscription_status,
COUNT(customer_id) AS total_customer,
SUM(purchase_amount) AS total_revenue,
ROUND (AVG(purchase_amount)::numeric,2) AS avg_revenue
FROM customer
GROUP BY subscription_status
ORDER BY total_revenue DESC;

/* 06. Which 5 products have the highest percentage of purchase with discount applied? */
SELECT
item_purchased,
ROUND (100* SUM(CASE WHEN "discount_applied"='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS discount_rate
FROM customer
GROUP BY item_purchased;
/* Segment customers based on the number of previous purchases in New, Returning and loyal and Show number in each segmentation */
WITH customer_segmantation AS
(
SELECT
"customer_id", 
"previous_purchases",
(
CASE 
WHEN "previous_purchases"= 1 THEN 'New'
WHEN "previous_purchases" BETWEEN 2 AND 10 THEN 'Returning'
ELSE 'Loyal'
END
) AS customer_category
FROM customer
)
SELECT
"customer_category",
COUNT ("customer_id") AS "no_of_customers"
FROM customer_segmantation
GROUP BY "customer_category";
/*What are the most 3 purchahed products within each category */
WITH category_wise_product AS
(
SELECT
"item_purchased",
"category",
COUNT("customer_id") AS "total_Orders",
ROW_NUMBER () OVER (PARTITION BY "category" ORDER BY COUNT("customer_id") DESC) AS "category_rank"
FROM customer
GROUP BY "item_purchased", "category"
)
SELECT
"category_rank",
"category",
"item_purchased",
"total_Orders"
FROM category_wise_product WHERE "category_rank" <=3;
/* Are customers are repeated buyers (more than 5 times) who likely to subscribe? */
SELECT 
"subscription_status",
COUNT ("customer_id") AS "repeated_customers"
FROM customer 
WHERE "previous_purchases" >5
GROUP BY "subscription_status";
/* What is the revenue contributiuon of each age group */ 
SELECT
"age_group",
SUM("purchase_amount") AS total_revenue
FROM customer
GROUP BY "age_group";





