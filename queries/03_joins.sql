USE library_rental_analytics;

-- =========================================================
-- 03_joins.sql
-- Join queries for the Library Rental Analytics project
-- Topics covered:
-- INNER JOIN, LEFT JOIN, joining three or more tables,
-- many-to-many relationships, aliases, joined filtering
-- =========================================================


-- 1. Show each loan with member name and copy ID
SELECT
    l.loan_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    l.copy_id,
    l.loan_date,
    l.due_date,
    l.return_date,
    l.status
FROM loans l
INNER JOIN members m
    ON l.member_id = m.member_id
ORDER BY l.loan_id;


-- 2. Show each loan with member name and book title
SELECT
    l.loan_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
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
ORDER BY l.loan_id;


-- 3. Show each book copy with its branch
SELECT
    c.copy_id,
    b.title,
    br.branch_name,
    br.city,
    c.status
FROM copies c
INNER JOIN books b
    ON c.book_id = b.book_id
INNER JOIN branches br
    ON c.branch_id = br.branch_id
ORDER BY br.branch_name, b.title;


-- 4. Show books with their authors
SELECT
    b.book_id,
    b.title,
    CONCAT(a.first_name, ' ', a.last_name) AS author_name,
    a.country
FROM books b
INNER JOIN book_authors ba
    ON b.book_id = ba.book_id
INNER JOIN authors a
    ON ba.author_id = a.author_id
ORDER BY b.title;


-- 5. Show books with their categories
SELECT
    b.book_id,
    b.title,
    cat.category_name
FROM books b
INNER JOIN book_categories bc
    ON b.book_id = bc.book_id
INNER JOIN categories cat
    ON bc.category_id = cat.category_id
ORDER BY b.title, cat.category_name;


-- 6. Show books with author and category
SELECT
    b.title,
    CONCAT(a.first_name, ' ', a.last_name) AS author_name,
    cat.category_name,
    b.publish_year,
    b.price
FROM books b
INNER JOIN book_authors ba
    ON b.book_id = ba.book_id
INNER JOIN authors a
    ON ba.author_id = a.author_id
INNER JOIN book_categories bc
    ON b.book_id = bc.book_id
INNER JOIN categories cat
    ON bc.category_id = cat.category_id
ORDER BY b.title, cat.category_name;


-- 7. Show open loans with member, book, and branch information
SELECT
    l.loan_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    b.title,
    br.branch_name,
    br.city AS branch_city,
    l.loan_date,
    l.due_date,
    l.status
FROM loans l
INNER JOIN members m
    ON l.member_id = m.member_id
INNER JOIN copies c
    ON l.copy_id = c.copy_id
INNER JOIN books b
    ON c.book_id = b.book_id
INNER JOIN branches br
    ON c.branch_id = br.branch_id
WHERE l.return_date IS NULL
ORDER BY l.due_date;


-- 8. Show late returned loans
SELECT
    l.loan_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    b.title,
    l.loan_date,
    l.due_date,
    l.return_date,
    DATEDIFF(l.return_date, l.due_date) AS late_days
FROM loans l
INNER JOIN members m
    ON l.member_id = m.member_id
INNER JOIN copies c
    ON l.copy_id = c.copy_id
INNER JOIN books b
    ON c.book_id = b.book_id
WHERE l.return_date > l.due_date
ORDER BY late_days DESC;


-- 9. Show payments with member and book details
SELECT
    p.payment_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    b.title,
    p.amount,
    p.payment_type,
    p.payment_date
FROM payments p
INNER JOIN loans l
    ON p.loan_id = l.loan_id
INNER JOIN members m
    ON l.member_id = m.member_id
INNER JOIN copies c
    ON l.copy_id = c.copy_id
INNER JOIN books b
    ON c.book_id = b.book_id
ORDER BY p.payment_date;


-- 10. Show reservations with member and book information
SELECT
    r.reservation_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    b.title,
    r.reservation_date,
    r.status
FROM reservations r
INNER JOIN members m
    ON r.member_id = m.member_id
INNER JOIN books b
    ON r.book_id = b.book_id
ORDER BY r.reservation_date;


-- 11. Show reviews with member and book information
SELECT
    rv.review_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    b.title,
    rv.rating,
    rv.review_text,
    rv.review_date
FROM reviews rv
INNER JOIN members m
    ON rv.member_id = m.member_id
INNER JOIN books b
    ON rv.book_id = b.book_id
ORDER BY rv.rating DESC, rv.review_date DESC;


-- 12. LEFT JOIN: show all members, including those with no loans
SELECT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    l.loan_id,
    l.loan_date,
    l.status
FROM members m
LEFT JOIN loans l
    ON m.member_id = l.member_id
ORDER BY m.member_id, l.loan_id;


-- 13. LEFT JOIN: show members who have never borrowed a book
SELECT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.city
FROM members m
LEFT JOIN loans l
    ON m.member_id = l.member_id
WHERE l.loan_id IS NULL
ORDER BY m.member_id;


-- 14. LEFT JOIN: show all books, including books with no reviews
SELECT
    b.book_id,
    b.title,
    rv.rating,
    rv.review_text
FROM books b
LEFT JOIN reviews rv
    ON b.book_id = rv.book_id
ORDER BY b.book_id;


-- 15. Show books that have never been reviewed
SELECT
    b.book_id,
    b.title
FROM books b
LEFT JOIN reviews rv
    ON b.book_id = rv.book_id
WHERE rv.review_id IS NULL
ORDER BY b.title;


-- 16. Show all branches and their copies
SELECT
    br.branch_id,
    br.branch_name,
    br.city,
    c.copy_id,
    b.title,
    c.status
FROM branches br
LEFT JOIN copies c
    ON br.branch_id = c.branch_id
LEFT JOIN books b
    ON c.book_id = b.book_id
ORDER BY br.branch_name, b.title;


-- 17. Find available copies with book and branch information
SELECT
    c.copy_id,
    b.title,
    br.branch_name,
    br.city,
    c.status
FROM copies c
INNER JOIN books b
    ON c.book_id = b.book_id
INNER JOIN branches br
    ON c.branch_id = br.branch_id
WHERE c.status = 'Available'
ORDER BY br.city, b.title;


-- 18. Find books reserved by members from Pavia
SELECT
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.city,
    b.title,
    r.reservation_date,
    r.status
FROM reservations r
INNER JOIN members m
    ON r.member_id = m.member_id
INNER JOIN books b
    ON r.book_id = b.book_id
WHERE m.city = 'Pavia'
ORDER BY r.reservation_date;


-- 19. Show staff with their branch information
SELECT
    s.staff_id,
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    s.role,
    br.branch_name,
    br.city
FROM staff s
INNER JOIN branches br
    ON s.branch_id = br.branch_id
ORDER BY br.branch_name, s.role;


-- 20. Many-to-many example:
-- Books can have many authors and authors can write many books.
SELECT
    a.author_id,
    CONCAT(a.first_name, ' ', a.last_name) AS author_name,
    b.title
FROM authors a
INNER JOIN book_authors ba
    ON a.author_id = ba.author_id
INNER JOIN books b
    ON ba.book_id = b.book_id
ORDER BY author_name, b.title;


-- 21. Many-to-many example:
-- Books can belong to many categories and categories can contain many books.
SELECT
    cat.category_name,
    b.title
FROM categories cat
INNER JOIN book_categories bc
    ON cat.category_id = bc.category_id
INNER JOIN books b
    ON bc.book_id = b.book_id
ORDER BY cat.category_name, b.title;


-- 22. Show complete loan report
SELECT
    l.loan_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.city AS member_city,
    b.title,
    CONCAT(a.first_name, ' ', a.last_name) AS author_name,
    br.branch_name,
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
INNER JOIN book_authors ba
    ON b.book_id = ba.book_id
INNER JOIN authors a
    ON ba.author_id = a.author_id
INNER JOIN branches br
    ON c.branch_id = br.branch_id
ORDER BY l.loan_id;


-- 23. Show loan report with late fee if payment exists
SELECT
    l.loan_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    b.title,
    l.status,
    p.amount AS payment_amount,
    p.payment_type
FROM loans l
INNER JOIN members m
    ON l.member_id = m.member_id
INNER JOIN copies c
    ON l.copy_id = c.copy_id
INNER JOIN books b
    ON c.book_id = b.book_id
LEFT JOIN payments p
    ON l.loan_id = p.loan_id
ORDER BY l.loan_id;


-- 24. Cross join example:
-- Generate all possible branch/category combinations.
SELECT
    br.branch_name,
    cat.category_name
FROM branches br
CROSS JOIN categories cat
ORDER BY br.branch_name, cat.category_name;