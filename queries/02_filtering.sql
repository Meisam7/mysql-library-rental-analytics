USE library_rental_analytics;

-- =========================================================
-- 02_filtering.sql
-- Filtering queries for the Library Rental Analytics project
-- Topics covered:
-- WHERE, AND, OR, IN, NOT IN, BETWEEN, LIKE,
-- IS NULL, IS NOT NULL, comparison operators, date filtering
-- =========================================================


-- 1. Books published after 2010
SELECT
    title,
    publish_year,
    price
FROM books
WHERE publish_year > 2010
ORDER BY publish_year DESC;


-- 2. Books with price between 20 and 35 euros
SELECT
    title,
    price
FROM books
WHERE price BETWEEN 20.00 AND 35.00
ORDER BY price;


-- 3. Members from Pavia or Milan using OR
SELECT
    member_id,
    CONCAT(first_name, ' ', last_name) AS member_name,
    city
FROM members
WHERE city = 'Pavia'
   OR city = 'Milan'
ORDER BY city, member_name;


-- 4. Members from Pavia or Milan using IN
SELECT
    member_id,
    CONCAT(first_name, ' ', last_name) AS member_name,
    city
FROM members
WHERE city IN ('Pavia', 'Milan')
ORDER BY city, member_name;


-- 5. Members not from Pavia, Milan, or Rome
SELECT
    member_id,
    CONCAT(first_name, ' ', last_name) AS member_name,
    city
FROM members
WHERE city NOT IN ('Pavia', 'Milan', 'Rome')
ORDER BY city;


-- 6. Books whose title contains SQL
SELECT
    book_id,
    title,
    publish_year
FROM books
WHERE title LIKE '%SQL%';


-- 7. Books whose title starts with D
SELECT
    book_id,
    title
FROM books
WHERE title LIKE 'D%';


-- 8. Members whose last name contains letter i
SELECT
    member_id,
    first_name,
    last_name
FROM members
WHERE last_name LIKE '%i%'
ORDER BY last_name;


-- 9. Open loans where return_date is NULL
SELECT
    loan_id,
    member_id,
    copy_id,
    loan_date,
    due_date,
    return_date,
    status
FROM loans
WHERE return_date IS NULL
ORDER BY due_date;


-- 10. Returned loans where return_date is not NULL
SELECT
    loan_id,
    member_id,
    copy_id,
    loan_date,
    due_date,
    return_date,
    status
FROM loans
WHERE return_date IS NOT NULL
ORDER BY return_date;


-- 11. Loans made between two dates
SELECT
    loan_id,
    member_id,
    copy_id,
    loan_date,
    due_date,
    status
FROM loans
WHERE loan_date BETWEEN '2025-03-01' AND '2025-04-30'
ORDER BY loan_date;


-- 12. Late returned loans
SELECT
    loan_id,
    member_id,
    copy_id,
    loan_date,
    due_date,
    return_date,
    DATEDIFF(return_date, due_date) AS late_days
FROM loans
WHERE return_date > due_date
ORDER BY late_days DESC;


-- 13. Loans that are currently overdue or marked as overdue
SELECT
    loan_id,
    member_id,
    copy_id,
    loan_date,
    due_date,
    return_date,
    status
FROM loans
WHERE status = 'Overdue'
   OR (return_date IS NULL AND due_date < CURRENT_DATE())
ORDER BY due_date;


-- 14. Active members who joined after March 2024
SELECT
    member_id,
    CONCAT(first_name, ' ', last_name) AS member_name,
    city,
    join_date,
    is_active
FROM members
WHERE is_active = TRUE
  AND join_date >= '2024-03-01'
ORDER BY join_date;


-- 15. Books that are either expensive or recently published
SELECT
    book_id,
    title,
    publish_year,
    price
FROM books
WHERE price >= 35.00
   OR publish_year >= 2020
ORDER BY publish_year DESC, price DESC;


-- 16. Books that are both recent and expensive
SELECT
    book_id,
    title,
    publish_year,
    price
FROM books
WHERE publish_year >= 2020
  AND price >= 35.00
ORDER BY price DESC;


-- 17. Payments greater than or equal to 5 euros
SELECT
    payment_id,
    loan_id,
    amount,
    payment_type,
    payment_date
FROM payments
WHERE amount >= 5.00
ORDER BY amount DESC;


-- 18. Late fee payments only
SELECT
    payment_id,
    loan_id,
    amount,
    payment_date
FROM payments
WHERE payment_type = 'Late Fee'
ORDER BY payment_date;


-- 19. Reviews with high ratings
SELECT
    review_id,
    member_id,
    book_id,
    rating,
    review_date
FROM reviews
WHERE rating >= 4
ORDER BY rating DESC, review_date DESC;


-- 20. Reservations that are active
SELECT
    reservation_id,
    member_id,
    book_id,
    reservation_date,
    status
FROM reservations
WHERE status = 'Active'
ORDER BY reservation_date;