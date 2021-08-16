#TABLES INFORMATION

---------ORDERS TABLE---------
#Calculating total orders
SELECT
  COUNT(order_id) AS Complited_Order
FROM
  `first-trial-321912.dqlab_project.order`;

---------ORDER_DETAILS TABLE---------
#Calculating total quantity January 2019-May2020
SELECT
  SUM(quantity) AS total_quantity
FROM
  `first-trial-321912.dqlab_project.order_details`;

#Calculating total quantity 2019
SELECT
  SUM(quantity) AS total_quantity 
FROM
  `first-trial-321912.dqlab_project.order_details`
JOIN 
  `first-trial-321912.dqlab_project.order`
ON order_id = orderID
WHERE created_at BETWEEN '2019-01-01' AND '2019-12-31';

#Calculating total quantity January-May 2020
SELECT
  SUM(quantity) AS total_quantity 
FROM
  `first-trial-321912.dqlab_project.order_details`
JOIN 
  `first-trial-321912.dqlab_project.order`
ON order_id = orderID
WHERE created_at BETWEEN '2020-01-01' AND '2020-05-31';

---------PRODUCTS TABLE---------
#Calculating total product categories
SELECT
  COUNT(DISTINCT category)
FROM `first-trial-321912.dqlab_project.products`;

#Calculating total unique products
SELECT
  COUNT(DISTINCT product_id)
FROM `first-trial-321912.dqlab_project.products`;

---------USERS TABLE---------
SELECT
  COUNT(user_id)
FROM `first-trial-321912.dqlab_project.users`;

#DATA ANALYSIS
----------Monthly Transaction----------
SELECT
  FORMAT_DATE('%Y-%m', created_at) AS Month,
  COUNT(order_id) AS Number_of_Transaction
FROM
  `first-trial-321912.dqlab_project.order`
GROUP BY
  1
ORDER BY
  1;

----------TRANSACTION STATUS-----------
#Calculating completed orders
SELECT
  COUNT(order_id) AS Complited_Order
FROM
  `first-trial-321912.dqlab_project.order`
WHERE
  paid_at IS NOT NULL
  AND delivery_at IS NOT NULL;

#Calculating undelivered orders
SELECT
  COUNT(order_id) AS Undelivered_Order
FROM
  `first-trial-321912.dqlab_project.order`
WHERE
  paid_at IS NOT NULL
  AND delivery_at IS NULL;

#Calculating unpaid and undelivered orders
SELECT
  COUNT(order_id)
FROM
  `first-trial-321912.dqlab_project.order`
WHERE
  paid_at IS NULL
  AND delivery_at IS NULL;

-------------USERS TRANSACTION-------------
#The number of users who have transacted as buyers
SELECT
  COUNT(DISTINCT buyer_id) AS buyers
FROM
  `first-trial-321912.dqlab_project.order`;

#The number of users who have transacted as sellers
SELECT
  COUNT(DISTINCT seller_id) AS sellers
FROM
  `first-trial-321912.dqlab_project.order`;

#The number of users who have transacted as sellers and buyers
SELECT
  COUNT(DISTINCT seller_id) AS buyer_seller
FROM
  `first-trial-321912.dqlab_project.order`
WHERE
  seller_id IN (
  SELECT
    buyer_id
  FROM
    `first-trial-321912.dqlab_project.order`);

#The number of users who have never transacted as sellers or buyers

SELECT
  COUNT(DISTINCT user_id) AS no_transaction
FROM
  `first-trial-321912.dqlab_project.users`
WHERE
  user_id NOT IN (
  SELECT
    buyer_id
  FROM
    `first-trial-321912.dqlab_project.order`
  UNION ALL
  SELECT
    seller_id
  FROM
    `first-trial-321912.dqlab_project.order`);

  -------------TOP 5 WITH THE HIGHEST PURCHASE VALUE-------------
 SELECT
  user_id,
  nama_user,
  SUM(total) AS total
FROM
  `first-trial-321912.dqlab_project.users`
JOIN
  `first-trial-321912.dqlab_project.order`
ON
  user_id = buyer_id
GROUP BY
  user_id,
  nama_user
ORDER BY
  total DESC
LIMIT
  5;

---------------Top 5 Users with The Highest Number of Transactions But Never Use Discount-----------------
SELECT
  user_id,
  nama_user,
  COUNT(total) AS total
FROM
  `first-trial-321912.dqlab_project.users`
JOIN
  `first-trial-321912.dqlab_project.order`
ON
  user_id = buyer_id
GROUP BY
  user_id,
  nama_user
HAVING
  SUM(discount) = 0
ORDER BY
  total DESC
LIMIT
  5;

------------Top 5 Users with The Highest Number of Transactions and Highest Purchase Value---------

SELECT
  user_id,
  nama_user,
  COUNT(user_id) AS transaction ,
  SUM(total) AS total
FROM
  `first-trial-321912.dqlab_project.users`
JOIN
  `first-trial-321912.dqlab_project.order`
ON
  user_id = buyer_id
GROUP BY
  user_id,
  nama_user
ORDER BY
  transaction  DESC,
  total DESC
LIMIT
  5;

--------The Number of Transactions Using a Discount----------
SELECT
  COUNT(order_id) AS discount,
  SUM(discount) AS total_discount
FROM
  `first-trial-321912.dqlab_project.order`
WHERE
  discount != 0;


--------The Number of Transactions without Using a Discount----------
SELECT
  COUNT(order_id) AS non_discount
FROM
  `first-trial-321912.dqlab_project.order`
WHERE
  discount = 0;


------------Top 5 Best Selling Products in December 2019---------------

SELECT
  desc_product,
  SUM(quantity) AS total_quantity
FROM
  `first-trial-321912.dqlab_project.products`
JOIN
  `first-trial-321912.dqlab_project.order_details`
ON
  product_id = productID
JOIN (
  SELECT
    *
  FROM
    `first-trial-321912.dqlab_project.order`
  WHERE
    paid_at BETWEEN '2019-12-01'
    AND '2019-12-31') AS paid_order
ON
  (order_id = orderID)
GROUP BY
  desc_product
ORDER BY
  total_quantity DESC
LIMIT
  5;

------------Top 5 Best Selling Products in 2019---------------
SELECT
  desc_product,
  SUM(quantity) AS total_quantity
FROM
  `first-trial-321912.dqlab_project.products`
JOIN
  `first-trial-321912.dqlab_project.order_details`
ON
  product_id = productID
JOIN (
  SELECT
    *
  FROM
    `first-trial-321912.dqlab_project.order`
  WHERE
    paid_at BETWEEN '2019-01-01'
    AND '2019-12-31') AS paid_order
ON
  (order_id = orderID)
GROUP BY
  desc_product
ORDER BY
  total_quantity DESC
LIMIT
  5;

------------Top 5 Best Selling Products in 2020---------------

SELECT
  desc_product,
  SUM(quantity) AS total_quantity
FROM
  `first-trial-321912.dqlab_project.products`
JOIN
  `first-trial-321912.dqlab_project.order_details`
ON
  product_id = productID
JOIN (
  SELECT
    *
  FROM
    `first-trial-321912.dqlab_project.order`
  WHERE
    paid_at BETWEEN '2020-01-01'
    AND '2020-05-31') AS paid_order
ON
  (order_id = orderID)
GROUP BY
  desc_product
ORDER BY
  total_quantity DESC
LIMIT
  5;


----------Monthly Transaction in 2019------------
SELECT
  FORMAT_DATE('%Y-%m', created_at) AS Month,
  COUNT(order_id) AS Number_of_Transaction,
  SUM(total) AS total_transaction_value
FROM
  `first-trial-321912.dqlab_project.order`
  WHERE created_at BETWEEN '2019-01-01' AND '2019-12-31'
GROUP BY
  1
ORDER BY
  1;

-------------Monthly Transaction in 2020-----------
SELECT
  FORMAT_DATE('%Y-%m', created_at) AS Month,
  COUNT(order_id) AS Number_of_Transaction,
  SUM(total) AS total_transaction_value
FROM
  `first-trial-321912.dqlab_project.order`
  WHERE created_at >= '2020-01-01'
GROUP BY
  1
ORDER BY
  1;


----------Top 5 Best Selling Product category in 2019------------
SELECT
  category,
  SUM(quantity) AS total_quantity,
  SUM(price) AS total_price
FROM
  `first-trial-321912.dqlab_project.order`
INNER JOIN
  `first-trial-321912.dqlab_project.order_details`
ON
  (order_id = orderID)
INNER JOIN
  `first-trial-321912.dqlab_project.products`
ON
  (product_id = productID)
WHERE
  created_at BETWEEN '2019-01-01' AND '2020-01-01'
  AND delivery_at IS NOT NULL
GROUP BY
  1
ORDER BY
  2 DESC
LIMIT
  5;
--------------Top 5 Best Selling Product Category in 2020------------

SELECT
  category,
  SUM(quantity) AS total_quantity,
  SUM(price) AS total_price
FROM
  `first-trial-321912.dqlab_project.order`
INNER JOIN
  `first-trial-321912.dqlab_project.order_details`
ON
  (order_id = orderID)
INNER JOIN
  `first-trial-321912.dqlab_project.products`
ON
  (product_id = productID)
WHERE
  created_at>='2020-01-01'
  AND delivery_at IS NOT NULL
GROUP BY
  1
ORDER BY
  2 DESC
LIMIT
  5;

----------High value buyers--------
SELECT
  nama_user,
  COUNT(nama_user) AS number_of_transaction,
  SUM(total) AS total_transaction_value,
  MIN(total) AS min_transaction_value
FROM
  `first-trial-321912.dqlab_project.users`
JOIN
  `first-trial-321912.dqlab_project.order`
ON
  user_id = buyer_id
GROUP BY
  user_id,
  nama_user
HAVING
  COUNT(nama_user) > 5
  AND MIN(total) > 2000000
ORDER BY
  total_transaction_value DESC;

------------Looking for dropshipper-------------
SELECT
  nama_user,
  COUNT(nama_user) AS number_of_transaction,
  COUNT(DISTINCT kodepos) AS pos_code,
  SUM(total) AS total_transaction_value,
  AVG(total) AS average_transaction_value
FROM
  `first-trial-321912.dqlab_project.users`
JOIN
  `first-trial-321912.dqlab_project.order`
ON
  user_id = buyer_id
GROUP BY
  user_id,
  nama_user
HAVING
  COUNT(nama_user) >= 10
  AND COUNT(nama_user) = COUNT(DISTINCT kodepos)
ORDER BY
  2 DESC;

------------Pembeli Sekaligus Penjual-----------

SELECT
  nama_user,
  Jumlah_transaksi_beli,
  Jumlah_transaksi_jual
FROM
  `first-trial-321912.dqlab_project.users`
INNER JOIN (
  SELECT
    buyer_id,
    COUNT(1) AS Jumlah_transaksi_beli
  FROM
    `first-trial-321912.dqlab_project.order`
  GROUP BY
    1) AS buyer
ON
  buyer_id = user_id
INNER JOIN (
  SELECT
    seller_id,
    COUNT(1) AS Jumlah_transaksi_jual
  FROM
    `first-trial-321912.dqlab_project.order`
  GROUP BY
    1) AS seller
ON
  seller_id = user_id
WHERE
  Jumlah_transaksi_beli >= 7
ORDER BY
  1;
