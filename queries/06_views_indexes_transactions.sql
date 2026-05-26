USE library_rental_analytics;

-- =========================================================
-- 06_views_indexes_transactions.sql
-- Advanced SQL examples for the Library Rental Analytics project
-- Topics covered:
-- Views, indexes, transactions, metadata queries, and window functions
-- =========================================================


-- =========================================================
-- PART 1: VIEWS
-- =========================================================

-- 1. View: active loans with member and book information
CREATE OR REPLACE VIEW active_loans_view AS
SELECT
    l.loan_id,
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    b.book_id,
    b.title,
    l.loan_date,
    l.due_date,
    l.return_date,
    l.status
FROM loans l
INNER JOIN members m
    ON l.member_id = m.member_id
INNER JOIN copies c
    ON l.copy_id = c.copy_id
INNER JOIN books b
    ON c.book_id = b.book_id
WHERE l.return_date IS NULL;


-- Test active loans view
SELECT *
FROM active_loans_view
ORDER BY due_date;


-- 2. View: overdue loans
CREATE OR REPLACE VIEW overdue_loans_view AS
SELECT
    l.loan_id,
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    b.title,
    l.loan_date,
    l.due_date,
    l.return_date,
    l.status,
    DATEDIFF(CURRENT_DATE(), l.due_date) AS days_overdue
FROM loans l
INNER JOIN members m
    ON l.member_id = m.member_id
INNER JOIN copies c
    ON l.copy_id = c.copy_id
INNER JOIN books b
    ON c.book_id = b.book_id
WHERE l.return_date IS NULL
  AND l.due_date < CURRENT_DATE();


-- Test overdue loans view
SELECT *
FROM overdue_loans_view
ORDER BY days_overdue DESC;


-- 3. View: book popularity summary
CREATE OR REPLACE VIEW book_popularity_view AS
SELECT
    b.book_id,
    b.title,
    COUNT(l.loan_id) AS total_loans,
    COUNT(DISTINCT rv.review_id) AS total_reviews,
    ROUND(AVG(rv.rating), 2) AS avg_rating
FROM books b
LEFT JOIN copies c
    ON b.book_id = c.book_id
LEFT JOIN loans l
    ON c.copy_id = l.copy_id
LEFT JOIN reviews rv
    ON b.book_id = rv.book_id
GROUP BY b.book_id, b.title;


-- Test book popularity view
SELECT *
FROM book_popularity_view
ORDER BY total_loans DESC, avg_rating DESC;


-- 4. View: member activity summary
CREATE OR REPLACE VIEW member_activity_view AS
SELECT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.city,
    m.is_active,
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
GROUP BY m.member_id, member_name, m.city, m.is_active;


-- Test member activity view
SELECT *
FROM member_activity_view
ORDER BY total_loans DESC, total_paid DESC;


-- =========================================================
-- PART 2: INDEXES
-- =========================================================

-- Indexes help speed up searches, joins, filters, and sorting.
-- Some indexes may already exist automatically because of primary keys,
-- unique constraints, or foreign keys.

-- 5. Create index on members city
CREATE INDEX idx_members_city
ON members(city);


-- 6. Create index on books title
CREATE INDEX idx_books_title
ON books(title);


-- 7. Create index on loans loan_date
CREATE INDEX idx_loans_loan_date
ON loans(loan_date);


-- 8. Create index on loans status
CREATE INDEX idx_loans_status
ON loans(status);


-- 9. Create composite index on loans member_id and status
CREATE INDEX idx_loans_member_status
ON loans(member_id, status);


-- 10. Create index on payments payment_date
CREATE INDEX idx_payments_payment_date
ON payments(payment_date);


-- 11. Show indexes from important tables
SHOW INDEXES FROM members;
SHOW INDEXES FROM books;
SHOW INDEXES FROM loans;
SHOW INDEXES FROM payments;


-- 12. Example query that can benefit from idx_members_city
SELECT
    member_id,
    first_name,
    last_name,
    city
FROM members
WHERE city = 'Pavia';


-- 13. Example query that can benefit from idx_loans_status
SELECT
    loan_id,
    member_id,
    loan_date,
    due_date,
    status
FROM loans
WHERE status = 'Open';


-- =========================================================
-- PART 3: TRANSACTIONS
-- =========================================================

-- A transaction is used when multiple changes must succeed or fail together.
-- Example business process:
-- A member borrows a book copy.
-- 1. Insert a new row into loans.
-- 2. Update the copy status to Loaned.
-- If something goes wrong, rollback everything.


-- 14. Transaction example with COMMIT
START TRANSACTION;

INSERT INTO loans (
    member_id,
    copy_id,
    loan_date,
    due_date,
    return_date,
    status
)
VALUES (
    2,
    13,
    CURRENT_DATE(),
    DATE_ADD(CURRENT_DATE(), INTERVAL 14 DAY),
    NULL,
    'Open'
);

UPDATE copies
SET status = 'Loaned'
WHERE copy_id = 13;

COMMIT;


-- Check the result after COMMIT
SELECT *
FROM loans
WHERE copy_id = 13
ORDER BY loan_id DESC;

SELECT
    copy_id,
    book_id,
    branch_id,
    status
FROM copies
WHERE copy_id = 13;


-- 15. Transaction example with ROLLBACK
-- This transaction will be cancelled intentionally.

START TRANSACTION;

INSERT INTO reservations (
    member_id,
    book_id,
    reservation_date,
    status
)
VALUES (
    8,
    3,
    CURRENT_DATE(),
    'Active'
);

-- Check the row before rollback
SELECT *
FROM reservations
WHERE member_id = 8
  AND book_id = 3
ORDER BY reservation_id DESC;

ROLLBACK;


-- Check again after rollback.
-- The new reservation should not exist.
SELECT *
FROM reservations
WHERE member_id = 8
  AND book_id = 3
ORDER BY reservation_id DESC;


-- =========================================================
-- PART 4: METADATA QUERIES
-- =========================================================

-- Metadata queries inspect the database structure using INFORMATION_SCHEMA.


-- 16. Show all tables in this database
SELECT
    table_name,
    table_type
FROM information_schema.tables
WHERE table_schema = 'library_rental_analytics'
ORDER BY table_name;


-- 17. Show all columns in all project tables
SELECT
    table_name,
    column_name,
    data_type,
    is_nullable,
    column_key,
    column_default
FROM information_schema.columns
WHERE table_schema = 'library_rental_analytics'
ORDER BY table_name, ordinal_position;


-- 18. Show primary key columns
SELECT
    table_name,
    column_name,
    constraint_name
FROM information_schema.key_column_usage
WHERE table_schema = 'library_rental_analytics'
  AND constraint_name = 'PRIMARY'
ORDER BY table_name, ordinal_position;


-- 19. Show foreign key relationships
SELECT
    table_name,
    column_name,
    referenced_table_name,
    referenced_column_name,
    constraint_name
FROM information_schema.key_column_usage
WHERE table_schema = 'library_rental_analytics'
  AND referenced_table_name IS NOT NULL
ORDER BY table_name, column_name;


-- 20. Show indexes in the project database
SELECT
    table_name,
    index_name,
    column_name,
    non_unique
FROM information_schema.statistics
WHERE table_schema = 'library_rental_analytics'
ORDER BY table_name, index_name, seq_in_index;


-- =========================================================
-- PART 5: WINDOW FUNCTIONS
-- =========================================================

-- Window functions calculate values across rows while keeping row-level detail.


-- 21. Rank members by total number of loans
SELECT
    member_id,
    member_name,
    total_loans,
    RANK() OVER (ORDER BY total_loans DESC) AS loan_rank
FROM member_activity_view
ORDER BY loan_rank, member_name;


-- 22. Rank books by popularity
SELECT
    book_id,
    title,
    total_loans,
    avg_rating,
    RANK() OVER (ORDER BY total_loans DESC, avg_rating DESC) AS popularity_rank
FROM book_popularity_view
ORDER BY popularity_rank, title;


-- 23. Row number for books ordered by price
SELECT
    book_id,
    title,
    price,
    ROW_NUMBER() OVER (ORDER BY price DESC) AS price_position
FROM books
ORDER BY price_position;


-- 24. Rank books within each price range
SELECT
    title,
    price,
    CASE
        WHEN price < 25 THEN 'Budget'
        WHEN price BETWEEN 25 AND 35 THEN 'Standard'
        ELSE 'Premium'
    END AS price_range,
    RANK() OVER (
        PARTITION BY
            CASE
                WHEN price < 25 THEN 'Budget'
                WHEN price BETWEEN 25 AND 35 THEN 'Standard'
                ELSE 'Premium'
            END
        ORDER BY price DESC
    ) AS rank_within_price_range
FROM books
ORDER BY price_range, rank_within_price_range;


-- 25. Running total of payments by payment date
SELECT
    payment_id,
    payment_date,
    amount,
    SUM(amount) OVER (
        ORDER BY payment_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM payments
ORDER BY payment_date;


-- 26. Monthly revenue with running total
SELECT
    payment_year,
    payment_month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (
        ORDER BY payment_year, payment_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_revenue
FROM (
    SELECT
        EXTRACT(YEAR FROM payment_date) AS payment_year,
        EXTRACT(MONTH FROM payment_date) AS payment_month,
        SUM(amount) AS monthly_revenue
    FROM payments
    GROUP BY
        EXTRACT(YEAR FROM payment_date),
        EXTRACT(MONTH FROM payment_date)
) monthly_summary
ORDER BY payment_year, payment_month;


-- 27. Compare each member's total loans with the average total loans
SELECT
    member_id,
    member_name,
    total_loans,
    ROUND(AVG(total_loans) OVER (), 2) AS average_loans_all_members,
    total_loans - ROUND(AVG(total_loans) OVER (), 2) AS difference_from_average
FROM member_activity_view
ORDER BY total_loans DESC;


-- 28. Top books by category using window function
SELECT
    category_name,
    title,
    total_loans,
    category_rank
FROM (
    SELECT
        cat.category_name,
        b.title,
        COUNT(l.loan_id) AS total_loans,
        RANK() OVER (
            PARTITION BY cat.category_name
            ORDER BY COUNT(l.loan_id) DESC
        ) AS category_rank
    FROM categories cat
    INNER JOIN book_categories bc
        ON cat.category_id = bc.category_id
    INNER JOIN books b
        ON bc.book_id = b.book_id
    LEFT JOIN copies c
        ON b.book_id = c.book_id
    LEFT JOIN loans l
        ON c.copy_id = l.copy_id
    GROUP BY cat.category_name, b.title
) ranked_books
WHERE category_rank <= 3
ORDER BY category_name, category_rank, title;