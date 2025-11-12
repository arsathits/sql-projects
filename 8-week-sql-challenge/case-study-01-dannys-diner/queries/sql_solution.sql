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

WITH cte AS (
    SELECT 
        customer_id,
        product_id,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS rn
    FROM sales
)
SELECT c.customer_id, m.product_name
FROM cte c
JOIN menu m ON m.product_id = c.product_id
WHERE c.rn = 1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT 
  m.product_name AS most_ordered_item,
  COUNT(*) AS no_of_items_ordered
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY no_of_items_ordered DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?

SELECT DISTINCT ON (s.customer_id)
    s.customer_id,
    m.product_name
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.product_id, s.customer_id, m.product_name
ORDER BY s.customer_id, COUNT(*) DESC;

-- 6. Which item was purchased first by the customer after they became a member?

with cte as (
	select 
		s.customer_id,
		s.product_id,
		row_number() over (partition by s.customer_id order by order_date) as rn
	from members m
	join sales s on m.customer_id = s.customer_id
	where order_date > m.join_date
	)

select 
	customer_id,
	product_id
from cte 
where rn = 1;

-- 7. Which item was purchased just before the customer became a member?

SELECT s.*
FROM sales s
JOIN members m ON s.customer_id = m.customer_id
WHERE s.order_date = (
    SELECT MAX(order_date)
    FROM sales
    WHERE customer_id = s.customer_id
      AND order_date < m.join_date
);

-- 8. What is the total items and amount spent for each member before they became a member?

SELECT 
	s.customer_id,
	count(*) as total_items,
	sum(price) as total_amount
FROM members m
JOIN sales s ON m.customer_id = s.customer_id
JOIN menu me ON s.product_id = me.product_id
WHERE order_date < m.join_date
group by s.customer_id;

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT 
    s.customer_id,
    SUM(CASE 
            WHEN m.product_name = 'sushi' THEN (m.price * 2)  -- Apply 2x multiplier for sushi
            ELSE (m.price * 1)  -- Apply 1x multiplier for other products
        END) AS points
FROM sales s 
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

WITH cte_OfferValidity AS (
    SELECT 
        s.customer_id, 
        m.join_date, 
        s.order_date,
        m.join_date + INTERVAL '6 days' AS firstweek_ends,  -- Updated date calculation
        menu.product_name, 
        menu.price
    FROM sales s
    LEFT JOIN members m ON s.customer_id = m.customer_id
    LEFT JOIN menu ON s.product_id = menu.product_id
)
SELECT 
    customer_id,
    SUM(CASE
            WHEN order_date BETWEEN join_date AND firstweek_ends THEN 20 * price  -- Double points in first week
            WHEN order_date NOT BETWEEN join_date AND firstweek_ends AND product_name = 'sushi' THEN 20 * price  -- Sushi points after first week
            ELSE 10 * price  -- Regular points for all other items
        END) AS points
FROM cte_OfferValidity
WHERE order_date < '2021-02-01'  -- Filter January points only
GROUP BY customer_id;
