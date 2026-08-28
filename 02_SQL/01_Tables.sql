create table olist_customers_dataset(
customer_id	varchar(100),
customer_unique_id varchar(100),
customer_zip_code_prefix int,
customer_city varchar(50),
customer_state varchar(50)
);

create table olist_geolocation_dataset(
geolocation_zip_code_prefix int,
geolocation_lat float,
geolocation_lng	float,
geolocation_city varchar(50),
geolocation_state varchar(50)
);

create table olist_order_items_dataset(
order_id varchar(100),
order_item_id int,
product_id varchar(100),
seller_id varchar(100),
shipping_limit_date timestamp,
price float,
freight_value float
);

create table olist_order_payments_dataset(
order_id varchar(100),
payment_sequential int,
payment_type varchar(20),
payment_installments int,
payment_value float
);

create table olist_order_reviews_dataset(
review_id varchar(100),
order_id varchar(100),
review_score int,
review_comment_title varchar(100),
review_comment_message varchar(500),
review_creation_date timestamp,
review_answer_timestamp timestamp
);

create table olist_orders_dataset(
order_id varchar(100),
customer_id varchar(100),
order_status varchar(50),
order_purchase_timestamp timestamp,
order_approved_at timestamp,
order_delivered_carrier_date timestamp,
order_delivered_customer_date timestamp,
order_estimated_delivery_date timestamp
);

create table olist_products_dataset(
product_id varchar(100),
product_category_name  varchar(100),
product_name_lenght int,
product_description_lenght int,
product_photos_qty int,
product_weight_g int,
product_length_cm int,
product_height_cm int,
product_width_cm int
);

create table olist_sellers_dataset(
seller_id varchar(100),
seller_zip_code_prefix int,
seller_city	varchar(50),
seller_state varchar(5)
);

create table product_category_name_translation(
product_category_name varchar(100),
product_category_name_english varchar(100)
);

Alter database "Brazillian_Dataset" set datestyle to 'ISO, DMY';
--converted datestyle iso, dmy

