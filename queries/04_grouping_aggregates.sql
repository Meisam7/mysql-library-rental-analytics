USE library_rental_analytics;

-- =========================================================
-- 04_grouping_aggregates.sql
-- Grouping and aggregate queries for the Library Rental Analytics project
-- Topics covered:
-- GROUP BY, COUNT, SUM, AVG, MIN, MAX, COUNT DISTINCT,
-- HAVING, grouping by multiple columns, grouping by expressions,
-- WITH ROLLUP
-- =========================================================


-- 1. Count total members
SELECT
    COUNT(*) AS total_members
FROM members;


-- 2. Count active and inactive members
SELECT
    is_active,
    COUNT(*) AS total_members
FROM members
GROUP BY is_active;


-- 3. Count members by city
SELECT
    city,
    COUNT(*) AS total_members
FROM members
GROUP BY city
ORDER BY total_members DESC, city;


-- 4. Count books by publish year
SELECT
    publish_year,
    COUNT(*) AS total_books
FROM books
GROUP BY publish_year
ORDER BY publish_year;


-- 5. Basic aggregate functions on book prices
SELECT
    COUNT(*) AS total_books,
    MIN(price) AS cheapest_book,
    MAX(price) AS most_expensive_book,
    AVG(price) AS average_price,
    SUM(price) AS total_catalog_value
FROM books;


-- 6. Rounded average book price
SELECT
    ROUND(AVG(price), 2) AS average_book_price
FROM books;


-- 7. Count copies by status
SELECT
    status,
    COUNT(*) AS total_copies
FROM copies
GROUP BY status
ORDER BY total_copies DESC;


-- 8. Count copies by branch
SELECT
    br.branch_name,
    br.city,
    COUNT(c.copy_id) AS total_copies
FROM branches br
LEFT JOIN copies c
    ON br.branch_id = c.branch_id
GROUP BY br.branch_id, br.branch_name, br.city
ORDER BY total_copies DESC;


-- 9. Count available copies by branch
SELECT
    br.branch_name,
    br.city,
    COUNT(c.copy_id) AS available_copies
FROM branches br
LEFT JOIN copies c
    ON br.branch_id = c.branch_id
   AND c.status = 'Available'
GROUP BY br.branch_id, br.branch_name, br.city
ORDER BY available_copies DESC;


-- 10. Count loans by member
SELECT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    COUNT(l.loan_id) AS total_loans
FROM members m
LEFT JOIN loans l
    ON m.member_id = l.member_id
GROUP BY m.member_id, member_name
ORDER BY total_loans DESC, member_name;


-- 11. Find members with at least 2 loans
SELECT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    COUNT(l.loan_id) AS total_loans
FROM members m
INNER JOIN loans l
    ON m.member_id = l.member_id
GROUP BY m.member_id, member_name
HAVING COUNT(l.loan_id) >= 2
ORDER BY total_loans DESC;


-- 12. Count loans by status
SELECT
    status,
    COUNT(*) AS total_loans
FROM loans
GROUP BY status
ORDER BY total_loans DESC;


-- 13. Count loans by month
SELECT
    EXTRACT(YEAR FROM loan_date) AS loan_year,
    EXTRACT(MONTH FROM loan_date) AS loan_month,
    COUNT(*) AS total_loans
FROM loans
GROUP BY
    EXTRACT(YEAR FROM loan_date),
    EXTRACT(MONTH FROM loan_date)
ORDER BY loan_year, loan_month;


-- 14. Count returned loans and open loans using conditional aggregation
SELECT
    COUNT(*) AS total_loans,
    SUM(CASE WHEN return_date IS NULL THEN 1 ELSE 0 END) AS open_loans,
    SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) AS returned_loans
FROM loans;


-- 15. Count late returned loans
SELECT
    COUNT(*) AS late_returned_loans
FROM loans
WHERE return_date > due_date;


-- 16. Average late days for late returned loans
SELECT
    ROUND(AVG(DATEDIFF(return_date, due_date)), 2) AS avg_late_days
FROM loans
WHERE return_date > due_date;


-- 17. Maximum late days
SELECT
    MAX(DATEDIFF(return_date, due_date)) AS max_late_days
FROM loans
WHERE return_date > due_date;


-- 18. Count payments by payment type
SELECT
    payment_type,
    COUNT(*) AS total_payments,
    SUM(amount) AS total_amount,
    ROUND(AVG(amount), 2) AS average_amount
FROM payments
GROUP BY payment_type
ORDER BY total_amount DESC;


-- 19. Total revenue by month
SELECT
    EXTRACT(YEAR FROM payment_date) AS payment_year,
    EXTRACT(MONTH FROM payment_date) AS payment_month,
    SUM(amount) AS monthly_revenue
FROM payments
GROUP BY
    EXTRACT(YEAR FROM payment_date),
    EXTRACT(MONTH FROM payment_date)
ORDER BY payment_year, payment_month;


-- 20. Revenue by member
SELECT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    SUM(p.amount) AS total_paid
FROM payments p
INNER JOIN loans l
    ON p.loan_id = l.loan_id
INNER JOIN members m
    ON l.member_id = m.member_id
GROUP BY m.member_id, member_name
ORDER BY total_paid DESC;


-- 21. Members who paid more than 5 euros total
SELECT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    SUM(p.amount) AS total_paid
FROM payments p
INNER JOIN loans l
    ON p.loan_id = l.loan_id
INNER JOIN members m
    ON l.member_id = m.member_id
GROUP BY m.member_id, member_name
HAVING SUM(p.amount) > 5.00
ORDER BY total_paid DESC;


-- 22. Average review rating by book
SELECT
    b.book_id,
    b.title,
    COUNT(rv.review_id) AS total_reviews,
    ROUND(AVG(rv.rating), 2) AS avg_rating
FROM books b
LEFT JOIN reviews rv
    ON b.book_id = rv.book_id
GROUP BY b.book_id, b.title
ORDER BY avg_rating DESC, total_reviews DESC;


-- 23. Books with average rating at least 4.5
SELECT
    b.book_id,
    b.title,
    COUNT(rv.review_id) AS total_reviews,
    ROUND(AVG(rv.rating), 2) AS avg_rating
FROM books b
INNER JOIN reviews rv
    ON b.book_id = rv.book_id
GROUP BY b.book_id, b.title
HAVING AVG(rv.rating) >= 4.5
ORDER BY avg_rating DESC;


-- 24. Count books by category
SELECT
    cat.category_name,
    COUNT(b.book_id) AS total_books
FROM categories cat
LEFT JOIN book_categories bc
    ON cat.category_id = bc.category_id
LEFT JOIN books b
    ON bc.book_id = b.book_id
GROUP BY cat.category_id, cat.category_name
ORDER BY total_books DESC, cat.category_name;


-- 25. Average book price by category
SELECT
    cat.category_name,
    COUNT(b.book_id) AS total_books,
    ROUND(AVG(b.price), 2) AS avg_price
FROM categories cat
LEFT JOIN book_categories bc
    ON cat.category_id = bc.category_id
LEFT JOIN books b
    ON bc.book_id = b.book_id
GROUP BY cat.category_id, cat.category_name
ORDER BY avg_price DESC;


-- 26. Count books by author
SELECT
    a.author_id,
    CONCAT(a.first_name, ' ', a.last_name) AS author_name,
    COUNT(b.book_id) AS total_books
FROM authors a
LEFT JOIN book_authors ba
    ON a.author_id = ba.author_id
LEFT JOIN books b
    ON ba.book_id = b.book_id
GROUP BY a.author_id, author_name
ORDER BY total_books DESC, author_name;


-- 27. Count distinct members who borrowed books
SELECT
    COUNT(member_id) AS total_loan_rows,
    COUNT(DISTINCT member_id) AS distinct_borrowing_members
FROM loans;


-- 28. Count distinct books that have been loaned
SELECT
    COUNT(l.loan_id) AS total_loans,
    COUNT(DISTINCT b.book_id) AS distinct_books_loaned
FROM loans l
INNER JOIN copies c
    ON l.copy_id = c.copy_id
INNER JOIN books b
    ON c.book_id = b.book_id;


-- 29. Multicolumn grouping: loans by member and status
SELECT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    l.status,
    COUNT(*) AS total_loans
FROM members m
INNER JOIN loans l
    ON m.member_id = l.member_id
GROUP BY m.member_id, member_name, l.status
ORDER BY m.member_id, l.status;


-- 30. Multicolumn grouping: copies by branch and status
SELECT
    br.branch_name,
    c.status,
    COUNT(*) AS total_copies
FROM branches br
INNER JOIN copies c
    ON br.branch_id = c.branch_id
GROUP BY br.branch_name, c.status
ORDER BY br.branch_name, c.status;


-- 31. Grouping by expression: members by join year and month
SELECT
    EXTRACT(YEAR FROM join_date) AS join_year,
    EXTRACT(MONTH FROM join_date) AS join_month,
    COUNT(*) AS new_members
FROM members
GROUP BY
    EXTRACT(YEAR FROM join_date),
    EXTRACT(MONTH FROM join_date)
ORDER BY join_year, join_month;


-- 32. Grouping by expression: books by price range
SELECT
    CASE
        WHEN price < 25 THEN 'Budget'
        WHEN price BETWEEN 25 AND 35 THEN 'Standard'
        ELSE 'Premium'
    END AS price_range,
    COUNT(*) AS total_books,
    ROUND(AVG(price), 2) AS avg_price
FROM books
GROUP BY
    CASE
        WHEN price < 25 THEN 'Budget'
        WHEN price BETWEEN 25 AND 35 THEN 'Standard'
        ELSE 'Premium'
    END
ORDER BY avg_price;


-- 33. WITH ROLLUP: total copies by branch and status, plus subtotals
SELECT
    br.branch_name,
    c.status,
    COUNT(*) AS total_copies
FROM branches br
INNER JOIN copies c
    ON br.branch_id = c.branch_id
GROUP BY br.branch_name, c.status WITH ROLLUP;


-- 34. WITH ROLLUP: total revenue by payment type, plus grand total
SELECT
    payment_type,
    SUM(amount) AS total_amount
FROM payments
GROUP BY payment_type WITH ROLLUP;


-- 35. Complete member activity summary
SELECT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    COUNT(DISTINCT l.loan_id) AS total_loans,
    COUNT(DISTINCT r.reservation_id) AS total_reservations,
    COUNT(DISTINCT rv.review_id) AS total_reviews,
    COALESCE(SUM(p.amount), 0) AS total_paid
FROM members m
LEFT JOIN loans l
    ON m.member_id = l.member_id
LEFT JOIN reservations r
    ON m.member_id = r.member_id
LEFT JOIN reviews rv
    ON m.member_id = rv.member_id
LEFT JOIN payments p
    ON l.loan_id = p.loan_id
GROUP BY m.member_id, member_name
ORDER BY total_loans DESC, total_paid DESC;