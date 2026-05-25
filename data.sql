USE library_rental_analytics;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE audit_logs;
TRUNCATE TABLE payments;
TRUNCATE TABLE reviews;
TRUNCATE TABLE reservations;
TRUNCATE TABLE loans;
TRUNCATE TABLE copies;
TRUNCATE TABLE staff;
TRUNCATE TABLE book_categories;
TRUNCATE TABLE book_authors;
TRUNCATE TABLE books;
TRUNCATE TABLE categories;
TRUNCATE TABLE authors;
TRUNCATE TABLE branches;
TRUNCATE TABLE members;

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO members (first_name, last_name, gender, birth_date, email, city, join_date, is_active) VALUES
('Sara', 'Ahmadi', 'F', '1998-04-10', 'sara.ahmadi@example.com', 'Pavia', '2024-01-10 10:15:00', TRUE),
('Ali', 'Rezaei', 'M', '1995-11-21', 'ali.rezaei@example.com', 'Rome', '2024-01-15 09:20:00', TRUE),
('Mina', 'Karimi', 'F', '2000-01-05', 'mina.karimi@example.com', 'Milan', '2024-02-01 14:30:00', TRUE),
('John', 'Smith', 'M', '1992-07-18', 'john.smith@example.com', 'Pavia', '2024-02-12 11:45:00', TRUE),
('Emma', 'Brown', 'F', '1999-09-30', 'emma.brown@example.com', 'Turin', '2024-03-05 16:10:00', TRUE),
('Luca', 'Bianchi', 'M', '1997-03-12', 'luca.bianchi@example.com', 'Milan', '2024-03-20 08:50:00', TRUE),
('Giulia', 'Rossi', 'F', '1996-12-02', 'giulia.rossi@example.com', 'Pavia', '2024-04-02 12:00:00', FALSE),
('David', 'Wilson', 'M', '1994-06-25', 'david.wilson@example.com', 'Rome', '2024-04-18 13:35:00', TRUE);

INSERT INTO authors (first_name, last_name, birth_year, country) VALUES
('Alan', 'Beaulieu', 1960, 'USA'),
('Robert', 'Martin', 1952, 'USA'),
('Stephen', 'Hawking', 1942, 'UK'),
('Umberto', 'Eco', 1932, 'Italy'),
('J.K.', 'Rowling', 1965, 'UK'),
('George', 'Orwell', 1903, 'UK'),
('Yuval', 'Harari', 1976, 'Israel'),
('Cal', 'Newport', 1982, 'USA');

INSERT INTO categories (category_name) VALUES
('Database'),
('Programming'),
('Science'),
('Novel'),
('History'),
('Productivity'),
('Fantasy'),
('Technology');

INSERT INTO books (title, publish_year, price) VALUES
('Learning SQL', 2020, 39.90),
('Clean Code', 2008, 45.50),
('A Brief History of Time', 1988, 30.00),
('The Name of the Rose', 1980, 22.75),
('Harry Potter and the Philosopher''s Stone', 1997, 25.00),
('1984', 1949, 18.50),
('Sapiens', 2011, 28.90),
('Deep Work', 2016, 24.99),
('Database Design for Beginners', 2022, 34.90),
('Python Data Analysis Basics', 2023, 42.00);

INSERT INTO book_authors (book_id, author_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 1),
(10, 2);

INSERT INTO book_categories (book_id, category_id) VALUES
(1, 1),
(1, 8),
(2, 2),
(2, 8),
(3, 3),
(4, 4),
(5, 7),
(5, 4),
(6, 4),
(7, 5),
(8, 6),
(9, 1),
(10, 2),
(10, 8);

INSERT INTO branches (branch_name, city, address) VALUES
('Central Library', 'Pavia', 'Via Roma 10'),
('Science Library', 'Milan', 'Via Torino 22'),
('City Reading Hub', 'Rome', 'Via Nazionale 50');

INSERT INTO staff (first_name, last_name, email, branch_id, hire_date, role) VALUES
('Marco', 'Ferrari', 'marco.ferrari@library.com', 1, '2022-01-10', 'Manager'),
('Anna', 'Conti', 'anna.conti@library.com', 1, '2023-03-15', 'Librarian'),
('Paolo', 'Galli', 'paolo.galli@library.com', 2, '2021-07-01', 'Manager'),
('Laura', 'Moretti', 'laura.moretti@library.com', 3, '2024-02-20', 'Librarian');

INSERT INTO copies (book_id, branch_id, status) VALUES
(1, 1, 'Available'),
(1, 2, 'Loaned'),
(2, 1, 'Loaned'),
(2, 2, 'Available'),
(3, 2, 'Available'),
(3, 3, 'Loaned'),
(4, 1, 'Available'),
(5, 1, 'Reserved'),
(5, 3, 'Available'),
(6, 3, 'Loaned'),
(7, 2, 'Available'),
(8, 1, 'Loaned'),
(9, 1, 'Available'),
(9, 2, 'Available'),
(10, 2, 'Loaned'),
(10, 3, 'Available');

INSERT INTO loans (member_id, copy_id, loan_date, due_date, return_date, status) VALUES
(1, 2, '2025-01-05', '2025-01-19', '2025-01-17', 'Returned'),
(1, 3, '2025-02-01', '2025-02-15', NULL, 'Open'),
(2, 6, '2025-01-12', '2025-01-26', '2025-01-30', 'Returned'),
(2, 10, '2025-03-02', '2025-03-16', NULL, 'Overdue'),
(3, 12, '2025-02-10', '2025-02-24', '2025-02-23', 'Returned'),
(4, 15, '2025-03-05', '2025-03-19', NULL, 'Open'),
(5, 1, '2025-01-20', '2025-02-03', '2025-02-02', 'Returned'),
(5, 4, '2025-02-22', '2025-03-08', '2025-03-12', 'Returned'),
(6, 5, '2025-03-10', '2025-03-24', NULL, 'Open'),
(6, 7, '2025-04-01', '2025-04-15', '2025-04-14', 'Returned'),
(7, 9, '2025-04-05', '2025-04-19', NULL, 'Open'),
(8, 11, '2025-04-10', '2025-04-24', '2025-04-28', 'Returned'),
(1, 13, '2025-05-01', '2025-05-15', NULL, 'Open'),
(3, 14, '2025-05-02', '2025-05-16', NULL, 'Open'),
(4, 16, '2025-05-03', '2025-05-17', NULL, 'Open');

INSERT INTO payments (loan_id, amount, payment_date, payment_type) VALUES
(3, 2.00, '2025-01-30 10:30:00', 'Late Fee'),
(4, 5.00, '2025-03-20 12:15:00', 'Late Fee'),
(8, 3.00, '2025-03-12 09:45:00', 'Late Fee'),
(12, 4.00, '2025-04-28 11:20:00', 'Late Fee'),
(1, 10.00, '2025-01-05 08:10:00', 'Membership Fee'),
(5, 10.00, '2025-02-10 14:00:00', 'Membership Fee');

INSERT INTO reservations (member_id, book_id, reservation_date, status) VALUES
(1, 5, '2025-03-01', 'Active'),
(2, 1, '2025-03-05', 'Completed'),
(3, 2, '2025-03-10', 'Cancelled'),
(4, 7, '2025-04-01', 'Active'),
(5, 10, '2025-04-05', 'Active'),
(6, 4, '2025-04-10', 'Completed');

INSERT INTO reviews (member_id, book_id, rating, review_text, review_date) VALUES
(1, 1, 5, 'Very useful SQL book for beginners.', '2025-01-20'),
(1, 2, 4, 'Great programming principles.', '2025-02-20'),
(2, 3, 5, 'Excellent science book.', '2025-02-01'),
(3, 5, 5, 'Fun and magical story.', '2025-03-01'),
(4, 6, 4, 'A powerful novel.', '2025-03-15'),
(5, 8, 5, 'Very practical productivity book.', '2025-04-01'),
(6, 10, 4, 'Good introduction to Python data analysis.', '2025-04-20'),
(8, 7, 5, 'Interesting history perspective.', '2025-05-01');

INSERT INTO audit_logs (table_name, action_type, description) VALUES
('members', 'INSERT', 'Initial member sample data inserted'),
('books', 'INSERT', 'Initial book sample data inserted'),
('loans', 'INSERT', 'Initial loan sample data inserted');