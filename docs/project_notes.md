# Project Notes

## Project Name

MySQL Library Rental Analytics Project

## Purpose

This project was created as a complete SQL portfolio project. It demonstrates how to design a relational database, insert sample data, write analytical queries, and organize SQL files in a professional GitHub repository.

## Database Design

The database models a library rental system.

Main entities:

- Members
- Books
- Authors
- Categories
- Branches
- Copies
- Loans
- Payments
- Reservations
- Reviews
- Staff
- Audit logs

## Important Relationships

### Members and Loans

One member can have many loans.

```text
members.member_id → loans.member_id
```

### Books and Copies

One book can have many physical copies.

```text
books.book_id → copies.book_id
```

### Copies and Loans

One physical copy can appear in many loan records over time.

```text
copies.copy_id → loans.copy_id
```

### Books and Authors

Books and authors have a many-to-many relationship.

A book can have multiple authors, and an author can write multiple books.

Bridge table:

```text
book_authors
```

### Books and Categories

Books and categories also have a many-to-many relationship.

Bridge table:

```text
book_categories
```

## Why This Project Is Useful

This project is useful because it covers both database design and analytical SQL.

It can be used to demonstrate:

- Ability to design normalized schemas
- Ability to use primary keys and foreign keys
- Ability to write joins across multiple tables
- Ability to summarize data with aggregates
- Ability to use subqueries and derived tables
- Ability to create reusable views
- Ability to use transactions safely
- Ability to inspect database metadata
- Ability to write window-function queries

## Recommended Execution Order

Run the files in this order:

```text
1. schema.sql
2. data.sql
3. queries/01_basic_selects.sql
4. queries/02_filtering.sql
5. queries/03_joins.sql
6. queries/04_grouping_aggregates.sql
7. queries/05_subqueries.sql
8. queries/06_views_indexes_transactions.sql
```

## Notes About Transactions

The transaction examples in the advanced query file modify the sample database.

If the database needs to be reset, run:

```text
schema.sql
data.sql
```

again.

## Notes About Indexes

The index queries should be run once. If they are run again, MySQL may return duplicate index name errors.

This is expected because the indexes already exist.

## Notes About Views

The views are created with:

```sql
CREATE OR REPLACE VIEW
```

This makes them easier to rerun during development.

## Future Work

Possible future improvements:

- Add ER diagram
- Add triggers for audit logging
- Add stored procedures
- Add more sample data
- Add `EXPLAIN` examples
- Add CSV exports
- Add dashboard screenshots
