USE library_rental_analytics;

-- =========================================================
-- 01_basic_selects.sql
-- Basic SELECT queries for the Library Rental Analytics project
-- Topics covered:
-- SELECT, FROM, aliases, DISTINCT, ORDER BY, LIMIT,
-- string functions, date functions, simple expressions
-- =========================================================


-- 1. Show all members
SELECT *
FROM members;


-- 2. Select specific columns from members
SELECT
    member_id,
    first_name,
    last_name,
    email,
    city
FROM members;


-- 3. Create a full name using CONCAT
SELECT
    member_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    email,
    city
FROM members;


-- 4. Show all books with a readable price label
SELECT
    book_id,
    title,
    publish_year,
    price,
    CONCAT('€', price) AS price_label
FROM books;


-- 5. Sort books from newest to oldest
SELECT
    title,
    publish_year,
    price
FROM books
ORDER BY publish_year DESC;


-- 6. Sort books from most expensive to cheapest
SELECT
    title,
    price
FROM books
ORDER BY price DESC;


-- 7. Show only the top 5 most expensive books
SELECT
    title,
    price
FROM books
ORDER BY price DESC
LIMIT 5;


-- 8. Show distinct member cities
SELECT DISTINCT
    city
FROM members
ORDER BY city;


-- 9. Show all available book copies
SELECT
    copy_id,
    book_id,
    branch_id,
    status
FROM copies
WHERE status = 'Available'
ORDER BY copy_id;


-- 10. Show all active members
SELECT
    member_id,
    CONCAT(first_name, ' ', last_name) AS member_name,
    city,
    join_date
FROM members
WHERE is_active = TRUE
ORDER BY join_date;


-- 11. Show inactive members
SELECT
    member_id,
    CONCAT(first_name, ' ', last_name) AS member_name,
    city,
    is_active
FROM members
WHERE is_active = FALSE;


-- 12. Show member names in uppercase
SELECT
    member_id,
    UPPER(CONCAT(first_name, ' ', last_name)) AS uppercase_name,
    city
FROM members;


-- 13. Show books with calculated discounted price
SELECT
    title,
    price,
    ROUND(price * 0.90, 2) AS discounted_price
FROM books
ORDER BY discounted_price DESC;


-- 14. Show loan duration in days
SELECT
    loan_id,
    member_id,
    copy_id,
    loan_date,
    due_date,
    DATEDIFF(due_date, loan_date) AS allowed_days
FROM loans
ORDER BY loan_id;


-- 15. Show current date and time
SELECT
    CURDATE() AS today_date,
    CURTIME() AS now_time,
    NOW() AS now_timestamp;