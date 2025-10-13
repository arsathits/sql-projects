/* --------------------
   Case Study Questions
   --------------------*/

SET search_path TO dannys_diner;

-- 1. What is the total amount each customer spent at the restaurant?

Select 
	customer_id,
	sum(price) as total_amount
from sales
join menu 
on sales.product_id = menu.product_id
group by customer_id;

-- 2. How many days has each customer visited the restaurant?

Select 
	customer_id,
	count(distinct order_date) as total_days_visited
from sales
group by customer_id;

-- 3. What was the first item from the menu purchased by each customer?
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

-- Example Query:
SELECT
  	product_id,
    product_name,
    price
FROM dannys_diner.menu
ORDER BY price DESC
LIMIT 5;