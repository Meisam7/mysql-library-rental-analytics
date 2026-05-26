USE library_rental_analytics;

-- =========================================================
-- 05_subqueries.sql
-- Subqueries and set operations for the Library Rental Analytics project
-- Topics covered:
-- scalar subqueries, IN, NOT IN, EXISTS, NOT EXISTS,
-- derived tables, correlated subqueries,
-- UNION, UNION ALL, and MySQL alternatives for INTERSECT/EXCEPT
-- =========================================================


-- =========================================================
-- PART 1: BASIC SUBQUERIES
-- =========================================================

-- 1. Books more expensive than the average book price
SELECT
    book_id,
    title,
    price
FROM books
WHERE price > (
    SELECT AVG(price)
    FROM books
)
ORDER BY price DESC;


-- 2. Books cheaper than the average book price
SELECT
    book_id,
    title,
    price
FROM books
WHERE price < (
    SELECT AVG(price)
    FROM books
)
ORDER BY price;


-- 3. Members who have borrowed at least one book
SELECT
    member_id,
    CONCAT(first_name, ' ', last_name) AS member_name,
    city
FROM members
WHERE member_id IN (
    SELECT member_id
    FROM loans
)
ORDER BY member_id;


-- 4. Members who have never borrowed a book
SELECT
    member_id,
    CONCAT(first_name, ' ', last_name) AS member_name,
    city
FROM members
WHERE member_id NOT IN (
    SELECT member_id
    FROM loans
)
ORDER BY member_id;


-- 5. Books that have at least one review
SELECT
    book_id,
    title
FROM books
WHERE book_id IN (
    SELECT book_id
    FROM reviews
)
ORDER BY title;


-- 6. Books that have no reviews
SELECT
    book_id,
    title
FROM books
WHERE book_id NOT IN (
    SELECT book_id
    FROM reviews
)
ORDER BY title;


-- 7. Loans that have a payment
SELECT
    loan_id,
    member_id,
    copy_id,
    loan_date,
    status
FROM loans
WHERE loan_id IN (
    SELECT loan_id
    FROM payments
)
ORDER BY loan_id;


-- 8. Loans that do not have a payment
SELECT
    loan_id,
    member_id,
    copy_id,
    loan_date,
    status
FROM loans
WHERE loan_id NOT IN (
    SELECT loan_id
    FROM payments
)
ORDER BY loan_id;


-- =========================================================
-- PART 2: SUBQUERIES WITH AGGREGATES
-- =========================================================

-- 9. Members with more loans than the average member loan count
SELECT
    member_id,
    member_name,
    total_loans
FROM (
    SELECT
        m.member_id,
        CONCAT(m.first_name, ' ', m.last_name) AS member_name,
        COUNT(l.loan_id) AS total_loans
    FROM members m
    LEFT JOIN loans l
        ON m.member_id = l.member_id
    GROUP BY m.member_id, member_name
) member_loan_counts
WHERE total_loans > (
    SELECT AVG(total_loans)
    FROM (
        SELECT
            COUNT(l.loan_id) AS total_loans
        FROM members m
        LEFT JOIN loans l
            ON m.member_id = l.member_id
        GROUP BY m.member_id
    ) avg_counts
)
ORDER BY total_loans DESC;


-- 10. Books with a rating above the average review rating
SELECT
    b.book_id,
    b.title,
    ROUND(AVG(rv.rating), 2) AS avg_rating
FROM books b
INNER JOIN reviews rv
    ON b.book_id = rv.book_id
GROUP BY b.book_id, b.title
HAVING AVG(rv.rating) > (
    SELECT AVG(rating)
    FROM reviews
)
ORDER BY avg_rating DESC;


-- 11. Categories with more books than the average category book count
SELECT
    category_name,
    total_books
FROM (
    SELECT
        cat.category_name,
        COUNT(bc.book_id) AS total_books
    FROM categories cat
    LEFT JOIN book_categories bc
        ON cat.category_id = bc.category_id
    GROUP BY cat.category_id, cat.category_name
) category_counts
WHERE total_books > (
    SELECT AVG(total_books)
    FROM (
        SELECT
            COUNT(bc.book_id) AS total_books
        FROM categories cat
        LEFT JOIN book_categories bc
            ON cat.category_id = bc.category_id
        GROUP BY cat.category_id
    ) avg_category_counts
)
ORDER BY total_books DESC;


-- =========================================================
-- PART 3: EXISTS AND NOT EXISTS
-- =========================================================

-- 12. Members who have at least one active reservation
SELECT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.city
FROM members m
WHERE EXISTS (
    SELECT 1
    FROM reservations r
    WHERE r.member_id = m.member_id
      AND r.status = 'Active'
)
ORDER BY m.member_id;


-- 13. Members who have no active reservations
SELECT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.city
FROM members m
WHERE NOT EXISTS (
    SELECT 1
    FROM reservations r
    WHERE r.member_id = m.member_id
      AND r.status = 'Active'
)
ORDER BY m.member_id;


-- 14. Books that have been loaned at least once
SELECT
    b.book_id,
    b.title
FROM books b
WHERE EXISTS (
    SELECT 1
    FROM copies c
    INNER JOIN loans l
        ON c.copy_id = l.copy_id
    WHERE c.book_id = b.book_id
)
ORDER BY b.title;


-- 15. Books that have never been loaned
SELECT
    b.book_id,
    b.title
FROM books b
WHERE NOT EXISTS (
    SELECT 1
    FROM copies c
    INNER JOIN loans l
        ON c.copy_id = l.copy_id
    WHERE c.book_id = b.book_id
)
ORDER BY b.title;


-- =========================================================
-- PART 4: CORRELATED SUBQUERIES
-- =========================================================

-- 16. For each member, show their total number of loans using a correlated subquery
SELECT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    (
        SELECT COUNT(*)
        FROM loans l
        WHERE l.member_id = m.member_id
    ) AS total_loans
FROM members m
ORDER BY total_loans DESC, member_name;


-- 17. For each book, show its number of reviews using a correlated subquery
SELECT
    b.book_id,
    b.title,
    (
        SELECT COUNT(*)
        FROM reviews rv
        WHERE rv.book_id = b.book_id
    ) AS total_reviews
FROM books b
ORDER BY total_reviews DESC, b.title;


-- 18. For each book, show its average rating using a correlated subquery
SELECT
    b.book_id,
    b.title,
    (
        SELECT ROUND(AVG(rv.rating), 2)
        FROM reviews rv
        WHERE rv.book_id = b.book_id
    ) AS avg_rating
FROM books b
ORDER BY avg_rating DESC;


-- =========================================================
-- PART 5: SUBQUERY AS A TABLE / DERIVED TABLE
-- =========================================================

-- 19. Create a derived table of member loan counts
SELECT
    loan_summary.member_id,
    loan_summary.member_name,
    loan_summary.total_loans
FROM (
    SELECT
        m.member_id,
        CONCAT(m.first_name, ' ', m.last_name) AS member_name,
        COUNT(l.loan_id) AS total_loans
    FROM members m
    LEFT JOIN loans l
        ON m.member_id = l.member_id
    GROUP BY m.member_id, member_name
) loan_summary
ORDER BY loan_summary.total_loans DESC;


-- 20. Use a derived table to find high-activity members
SELECT
    member_id,
    member_name,
    total_loans
FROM (
    SELECT
        m.member_id,
        CONCAT(m.first_name, ' ', m.last_name) AS member_name,
        COUNT(l.loan_id) AS total_loans
    FROM members m
    LEFT JOIN loans l
        ON m.member_id = l.member_id
    GROUP BY m.member_id, member_name
) loan_summary
WHERE total_loans >= 2
ORDER BY total_loans DESC;


-- 21. Derived table for book popularity
SELECT
    book_popularity.book_id,
    book_popularity.title,
    book_popularity.total_loans
FROM (
    SELECT
        b.book_id,
        b.title,
        COUNT(l.loan_id) AS total_loans
    FROM books b
    LEFT JOIN copies c
        ON b.book_id = c.book_id
    LEFT JOIN loans l
        ON c.copy_id = l.copy_id
    GROUP BY b.book_id, b.title
) book_popularity
ORDER BY total_loans DESC, title;


-- =========================================================
-- PART 6: SET OPERATIONS
-- =========================================================

-- 22. UNION: combine member names and staff names, removing duplicates
SELECT
    first_name,
    last_name,
    'Member' AS person_type
FROM members
UNION
SELECT
    first_name,
    last_name,
    'Staff' AS person_type
FROM staff
ORDER BY last_name, first_name;


-- 23. UNION ALL: combine member names and staff names, keeping duplicates
SELECT
    first_name,
    last_name,
    'Member' AS person_type
FROM members
UNION ALL
SELECT
    first_name,
    last_name,
    'Staff' AS person_type
FROM staff
ORDER BY last_name, first_name;


-- 24. UNION: books that are either reviewed or reserved
SELECT
    b.book_id,
    b.title,
    'Reviewed' AS source_type
FROM books b
INNER JOIN reviews rv
    ON b.book_id = rv.book_id
UNION
SELECT
    b.book_id,
    b.title,
    'Reserved' AS source_type
FROM books b
INNER JOIN reservations r
    ON b.book_id = r.book_id
ORDER BY title;


-- 25. UNION ALL: all activity records from loans, reservations, and reviews
SELECT
    member_id,
    loan_date AS activity_date,
    'Loan' AS activity_type
FROM loans
UNION ALL
SELECT
    member_id,
    reservation_date AS activity_date,
    'Reservation' AS activity_type
FROM reservations
UNION ALL
SELECT
    member_id,
    review_date AS activity_date,
    'Review' AS activity_type
FROM reviews
ORDER BY activity_date, member_id;


-- =========================================================
-- PART 7: MYSQL ALTERNATIVES FOR INTERSECT AND EXCEPT
-- =========================================================

-- 26. INTERSECT alternative:
-- Members who both borrowed a book and wrote a review
SELECT DISTINCT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name
FROM members m
INNER JOIN loans l
    ON m.member_id = l.member_id
INNER JOIN reviews rv
    ON m.member_id = rv.member_id
ORDER BY m.member_id;


-- 27. INTERSECT alternative using EXISTS:
-- Members who both borrowed a book and wrote a review
SELECT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name
FROM members m
WHERE EXISTS (
    SELECT 1
    FROM loans l
    WHERE l.member_id = m.member_id
)
AND EXISTS (
    SELECT 1
    FROM reviews rv
    WHERE rv.member_id = m.member_id
)
ORDER BY m.member_id;


-- 28. EXCEPT alternative:
-- Members who borrowed a book but never wrote a review
SELECT DISTINCT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name
FROM members m
INNER JOIN loans l
    ON m.member_id = l.member_id
WHERE NOT EXISTS (
    SELECT 1
    FROM reviews rv
    WHERE rv.member_id = m.member_id
)
ORDER BY m.member_id;


-- 29. EXCEPT alternative:
-- Books that have copies but have never been reviewed
SELECT DISTINCT
    b.book_id,
    b.title
FROM books b
INNER JOIN copies c
    ON b.book_id = c.book_id
WHERE NOT EXISTS (
    SELECT 1
    FROM reviews rv
    WHERE rv.book_id = b.book_id
)
ORDER BY b.title;


-- 30. EXCEPT alternative:
-- Books that were reserved but never loaned
SELECT DISTINCT
    b.book_id,
    b.title
FROM books b
INNER JOIN reservations r
    ON b.book_id = r.book_id
WHERE NOT EXISTS (
    SELECT 1
    FROM copies c
    INNER JOIN loans l
        ON c.copy_id = l.copy_id
    WHERE c.book_id = b.book_id
)
ORDER BY b.title;


SELECT
    first_name,
    last_name,
    'Member' AS person_type
FROM members
UNION ALL
SELECT
    first_name,
    last_name,
    'Staff' AS person_type
FROM staff
ORDER BY last_name, first_name;