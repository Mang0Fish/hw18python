-- Creating the tables 
CREATE TABLE category (category_id serial PRIMARY KEY, name text)

CREATE TABLE products (product_id serial PRIMARY KEY, name text, price float, category_id integer,
FOREIGN KEY (category_id) REFERENCES category(category_id))

CREATE TABLE nutritions (nutrition_id serial PRIMARY KEY, product_id integer UNIQUE, name text, calories integer,
 fats float, sugar float,
 FOREIGN KEY (product_id) REFERENCES products(product_id))
 
CREATE TABLE orders(order_id serial PRIMARY KEY, date_time text, address text, customer_name text,
customer_ph text, total_price float)

CREATE TABLE products_orders (order_id integer, product_id integer, amount float,
PRIMARY KEY (order_id, product_id),
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (product_id) REFERENCES products(product_id))
--Table relations
-- category to products = 1:M, products to nutritions = 1:1, products to 
-- products_orders = 1:M, orders to products_orders = 1:M,
-- products to orders = M:M
----

--i.
select p.name, p.price, c."name", n.calories, n.fats, n.sugar from products p join category c using (category_id)
join nutritions n using (product_id)

--ii.
select o.*, p.* from products_orders po join (select * from products p join category c using (category_id)) p using (product_id) join orders o using (order_id)

--iii.
insert into products_orders (order_id, product_id, amount) values 
(1,12,1),(2,11,1),(3,11,1),(4,11,1),(5,11,1)

--iv.
UPDATE orders o
SET total_price = (
    SELECT SUM(p.price * po.amount)
    FROM products p
    JOIN products_orders po using(product_id)
    WHERE po.order_id = o.order_id
);

--v.
select max(total_price) as max, min(total_price) as min, avg(total_price) as avg from orders o 

--vi.
select customer_name, total_amount from (select customer_name, sum(po.amount) as total_amount from products_orders po 
join orders o using (order_id) group by o.customer_name) order by (total_amount) desc limit 1

--vii.
select p.name as Biggest, sum(amount) as total_amount from products p join products_orders po using (product_id) group by p.name having sum(po.amount) =
(select sum(amount) from products_orders po join products p using (product_id) group by p.name order by sum desc limit 1);

select p.name as Smallest, sum(amount) as total_amount from products p join products_orders po using (product_id) group by p.name having sum(po.amount) =
(select sum(amount) from products_orders po join products p using (product_id) group by p.name order by sum limit 1);
--I did'nt fully understand the meaning of average here, I tried to find the median and was exhausted and gave up lol...

--viii.
select c.name as Biggest, sum(amount) as total_amount from products p join products_orders po 
using (product_id) join category c  using (category_id) group by c.name having sum(amount) =
(select sum(amount) from products_orders po join products p using (product_id) join category c  using (category_id) group by c.name order by sum desc limit 1);

select c.name as Smallest, sum(amount) as total_amount from products p join products_orders po 
using (product_id) join category c  using (category_id) group by c.name having sum(amount) =
(select sum(amount) from products_orders po join products p using (product_id) join category c  using (category_id) group by c.name order by sum limit 1);

--xi. bonus
select p."name" as product, count(p."name") as counter from products p join products_orders po using (product_id) group by p."name" order by counter desc limit 1

	


	

