DROP DATABASE IF EXISTS library_rental_analytics;

CREATE DATABASE library_rental_analytics
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

USE library_rental_analytics;

CREATE TABLE members (
    member_id INT UNSIGNED AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender ENUM('M', 'F', 'Other') DEFAULT 'Other',
    birth_date DATE,
    email VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    join_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    CONSTRAINT pk_members PRIMARY KEY (member_id),
    CONSTRAINT uq_members_email UNIQUE (email)
);

CREATE TABLE authors (
    author_id INT UNSIGNED AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_year YEAR,
    country VARCHAR(50),
    CONSTRAINT pk_authors PRIMARY KEY (author_id)
);

CREATE TABLE categories (
    category_id INT UNSIGNED AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL,
    CONSTRAINT pk_categories PRIMARY KEY (category_id),
    CONSTRAINT uq_categories_name UNIQUE (category_name)
);

CREATE TABLE books (
    book_id INT UNSIGNED AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    publish_year YEAR,
    price DECIMAL(8,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_books PRIMARY KEY (book_id)
);

CREATE TABLE book_authors (
    book_id INT UNSIGNED NOT NULL,
    author_id INT UNSIGNED NOT NULL,
    CONSTRAINT pk_book_authors PRIMARY KEY (book_id, author_id),
    CONSTRAINT fk_book_authors_book
        FOREIGN KEY (book_id) REFERENCES books(book_id),
    CONSTRAINT fk_book_authors_author
        FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

CREATE TABLE book_categories (
    book_id INT UNSIGNED NOT NULL,
    category_id INT UNSIGNED NOT NULL,
    CONSTRAINT pk_book_categories PRIMARY KEY (book_id, category_id),
    CONSTRAINT fk_book_categories_book
        FOREIGN KEY (book_id) REFERENCES books(book_id),
    CONSTRAINT fk_book_categories_category
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE branches (
    branch_id INT UNSIGNED AUTO_INCREMENT,
    branch_name VARCHAR(80) NOT NULL,
    city VARCHAR(50) NOT NULL,
    address VARCHAR(150),
    CONSTRAINT pk_branches PRIMARY KEY (branch_id)
);

CREATE TABLE copies (
    copy_id INT UNSIGNED AUTO_INCREMENT,
    book_id INT UNSIGNED NOT NULL,
    branch_id INT UNSIGNED NOT NULL,
    status ENUM('Available', 'Loaned', 'Reserved', 'Lost') DEFAULT 'Available',
    added_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_copies PRIMARY KEY (copy_id),
    CONSTRAINT fk_copies_book
        FOREIGN KEY (book_id) REFERENCES books(book_id),
    CONSTRAINT fk_copies_branch
        FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

CREATE TABLE loans (
    loan_id INT UNSIGNED AUTO_INCREMENT,
    member_id INT UNSIGNED NOT NULL,
    copy_id INT UNSIGNED NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE NULL,
    status ENUM('Open', 'Returned', 'Overdue') DEFAULT 'Open',
    CONSTRAINT pk_loans PRIMARY KEY (loan_id),
    CONSTRAINT fk_loans_member
        FOREIGN KEY (member_id) REFERENCES members(member_id),
    CONSTRAINT fk_loans_copy
        FOREIGN KEY (copy_id) REFERENCES copies(copy_id)
);

CREATE TABLE payments (
    payment_id INT UNSIGNED AUTO_INCREMENT,
    loan_id INT UNSIGNED NOT NULL,
    amount DECIMAL(8,2) NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_type ENUM('Late Fee', 'Lost Book Fee', 'Membership Fee') DEFAULT 'Late Fee',
    CONSTRAINT pk_payments PRIMARY KEY (payment_id),
    CONSTRAINT fk_payments_loan
        FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

CREATE TABLE reservations (
    reservation_id INT UNSIGNED AUTO_INCREMENT,
    member_id INT UNSIGNED NOT NULL,
    book_id INT UNSIGNED NOT NULL,
    reservation_date DATE NOT NULL,
    status ENUM('Active', 'Completed', 'Cancelled') DEFAULT 'Active',
    CONSTRAINT pk_reservations PRIMARY KEY (reservation_id),
    CONSTRAINT fk_reservations_member
        FOREIGN KEY (member_id) REFERENCES members(member_id),
    CONSTRAINT fk_reservations_book
        FOREIGN KEY (book_id) REFERENCES books(book_id)
);

CREATE TABLE reviews (
    review_id INT UNSIGNED AUTO_INCREMENT,
    member_id INT UNSIGNED NOT NULL,
    book_id INT UNSIGNED NOT NULL,
    rating TINYINT UNSIGNED NOT NULL,
    review_text TEXT,
    review_date DATE NOT NULL,
    CONSTRAINT pk_reviews PRIMARY KEY (review_id),
    CONSTRAINT fk_reviews_member
        FOREIGN KEY (member_id) REFERENCES members(member_id),
    CONSTRAINT fk_reviews_book
        FOREIGN KEY (book_id) REFERENCES books(book_id),
    CONSTRAINT chk_reviews_rating CHECK (rating BETWEEN 1 AND 5)
);

CREATE TABLE staff (
    staff_id INT UNSIGNED AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    branch_id INT UNSIGNED NOT NULL,
    hire_date DATE NOT NULL,
    role VARCHAR(50) NOT NULL,
    CONSTRAINT pk_staff PRIMARY KEY (staff_id),
    CONSTRAINT uq_staff_email UNIQUE (email),
    CONSTRAINT fk_staff_branch
        FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);
show tables;

CREATE TABLE audit_logs (
    log_id INT UNSIGNED AUTO_INCREMENT,
    table_name VARCHAR(50) NOT NULL,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(255),
    CONSTRAINT pk_audit_logs PRIMARY KEY (log_id)
);