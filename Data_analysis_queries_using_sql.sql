# 1. Montly revenue trend
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS Order_Month,
SUM((oi.quantity * oi.unit_price) - oi.discount) as Montly_Revenue
FROM orders o JOIN order_items oi
ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY Order_Month ASC;

# 2. Top 3 customers by net spend
SELECT c.customer_id, c.customer_name, 
SUM((oi.quantity * oi.unit_price) - oi.discount) AS Total_Spend
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name
ORDER BY Total_Spend DESC LIMIT 3;

# 3. Category-Wise Sales Contribution
SELECT p.category,
SUM((oi.unit_price * oi.quantity) - oi.discount) AS Category_Revenue,
ROUND(100 * SUM((oi.unit_price * oi.quantity) - oi.discount) / 
SUM(SUM((oi.unit_price * oi.quantity) - oi.discount)) OVER (), 2) as Revenue_Share_PCT
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY p.category
ORDER BY Category_Revenue DESC;

# 4. Refund rate by Payment method
SELECT p.payment_method, count(distinct p.order_id) as total_orders,
count(distinct r.order_id) as refunded_orders,
round(100.0 * count(distinct r.order_id) / count(distinct p.order_id), 2) as refund_rate_pct
from payments p
left join refunds r on p.order_id = r.order_id
where p.payment_status = 'Paid'
group by p.payment_method order by refund_rate_pct desc;

# 5. Delivery delay analysis
select w.warehouse_name,
avg(datediff(d.delivery_date, d.dispatch_date)) as avg_delivery_days,
Max(datediff(d.delivery_date, d.dispatch_date)) as max_delivery_days
from deliveries d
join orders o on o.order_id = d.order_id
join warehouses w on o.warehouse_id = w.warehourse_id
group by w.warehouse_name
order by avg_delivery_days desc;

# 6. Customer Repeat Purchase behavior
Select customer_id, count(order_id) as total_orders,
case
when count(order_id)=1 then 'one-time'
when count(order_id) between 2 AND 3 then 'repeat'
else 'loyal' end as customer_type
from orders
where order_status='completed'
group by customer_id;

# 7. Rank Products within Category
select p.category, p.product_name,
sum((oi.quantity * oi.unit_price) - oi.discount) as product_revenue,
Rank() Over(partition by p.category
order by sum((oi.quantity * oi.unit_price) - oi.discount) desc) as category_rank
from order_items oi
join products p on oi.product_id = p.product_id
join orders o on oi.order_id = o.order_id
where o.order_status = 'Completed'
group by p.category, p.product_name;

# 8. Customers with no purchases in last 30 days
select c.customer_id, c.customer_name
from customers c
left join orders o 
on c.customer_id = o.customer_id
and o.order_date >= date_sub('2024-03-31', interval 30 day)
group by c.customer_id, c.customer_name
having count(o.order_id)=0;

# 9. Net revenue after refunds
with revenue_cte as(
select o.order_id, sum((oi.quantity * oi.unit_price) - oi.discount) as gross_revenue
from orders o join order_items oi on o.order_id = oi.order_id
group by o.order_id
),
refund_cte as(
select order_id,
sum(refund_amount) as total_refund
from refunds group by order_id
)
select r.order_id, r.gross_revenue,
coalesce(f.total_refund, 0) as total_refund,
r.gross_revenue - coalesce(f.total_refund, 0) as net_revenue
from revenue_cte r
left join refund_cte f
on f.order_id = r.order_id;

# 10. Best warehouse by revenue and delivery performance
with warehouse_revenue as (
select o.warehouse_id, sum((oi.quantity * oi.unit_price) - oi.discount) as Revenue
from orders o
join order_items oi on o.order_id = oi.order_id
where o.order_status= 'completed'
group by o.warehouse_id
),
warehouse_delivery as (
select o.warehouse_id,
avg(datediff(d.delivery_date, d.dispatch_date)) as avg_days
from orders o 
join deliveries d on o.order_id = d.order_id
group by o.warehouse_id
)
select w.warehouse_name, wr.revenue, wd.avg_days
from warehouses w
join warehouse_revenue wr on w.warehouse_id = wr.warehouse_id
join warehouse_delivery wd on w.warehouse_id = wd.warehouse_id
order by wr.revenue desc, wd.avg_days asc;
