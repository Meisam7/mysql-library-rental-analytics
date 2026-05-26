# MySQL Library Rental Analytics Project

A complete MySQL portfolio project that demonstrates database design, data insertion, filtering, joins, grouping, subqueries, views, indexes, transactions, metadata queries, and window functions.

This project simulates a library rental system with members, books, authors, categories, branches, copies, loans, payments, reservations, reviews, staff, and audit logs.

## Project Goals

The goal of this project is to practice and demonstrate practical SQL skills using a realistic relational database.

The project covers:

- Database creation
- Table design
- Primary keys and foreign keys
- Constraints
- Sample data insertion
- Basic SELECT queries
- Filtering with WHERE
- Sorting with ORDER BY
- Joins across multiple tables
- Grouping and aggregate functions
- Subqueries
- Set operations
- Views
- Indexes
- Transactions
- Metadata queries using `information_schema`
- Window functions

## Database Schema Overview

The database is called:

```text
library_rental_analytics
```

Main tables:

| Table | Description |
|---|---|
| `members` | Library members |
| `authors` | Book authors |
| `categories` | Book categories |
| `books` | Book catalog |
| `book_authors` | Many-to-many relationship between books and authors |
| `book_categories` | Many-to-many relationship between books and categories |
| `branches` | Library branches |
| `copies` | Physical copies of books |
| `loans` | Book loan records |
| `payments` | Payments and late fees |
| `reservations` | Book reservations |
| `reviews` | Member book reviews |
| `staff` | Library staff |
| `audit_logs` | Simple audit log records |

## ER Diagram

The ER diagram for this database is available in:

```text
docs/er_diagram.png
```

It shows the relationships between members, books, authors, categories, copies, loans, payments, reservations, reviews, staff, and branches.

## Folder Structure

```text
mysql-library-rental-analytics/
│
├── README.md
├── schema.sql
├── data.sql
├── .gitignore
│
├── queries/
│   ├── 01_basic_selects.sql
│   ├── 02_filtering.sql
│   ├── 03_joins.sql
│   ├── 04_grouping_aggregates.sql
│   ├── 05_subqueries.sql
│   └── 06_views_indexes_transactions.sql
│
├── docs/
│   ├── er_diagram.png
│   └── project_notes.md
│
├── reports/
│   ├── business_questions.md
│   └── query_results.md
│
└── exports/
    └── .gitkeep
```

## How to Run the Project

### 1. Create the Database Schema

Open `schema.sql` in DataGrip, MySQL Workbench, or another MySQL client and run the full script.

This creates the database and all tables.

### 2. Insert Sample Data

Run:

```text
data.sql
```

This inserts sample members, books, authors, categories, branches, copies, loans, payments, reservations, reviews, staff, and audit logs.

### 3. Run Query Files

The query files are inside the `queries/` folder.

Recommended order:

```text
01_basic_selects.sql
02_filtering.sql
03_joins.sql
04_grouping_aggregates.sql
05_subqueries.sql
06_views_indexes_transactions.sql
```

Some advanced queries create views and indexes, so they should be run after `schema.sql` and `data.sql`.

## SQL Topics Covered

### Basic Queries

File: `queries/01_basic_selects.sql`

Covers:

- `SELECT`
- `FROM`
- Aliases
- `DISTINCT`
- `ORDER BY`
- `LIMIT`
- `CONCAT`
- `ROUND`
- `DATEDIFF`
- `CURDATE`, `CURTIME`, `NOW`

### Filtering

File: `queries/02_filtering.sql`

Covers:

- `WHERE`
- `AND` / `OR`
- `IN` / `NOT IN`
- `BETWEEN`
- `LIKE`
- `IS NULL` / `IS NOT NULL`
- Date filtering
- Comparison operators

### Joins

File: `queries/03_joins.sql`

Covers:

- `INNER JOIN`
- `LEFT JOIN`
- `CROSS JOIN`
- Joining three or more tables
- Many-to-many relationships
- Joined filtering
- Complete loan reports

### Grouping and Aggregates

File: `queries/04_grouping_aggregates.sql`

Covers:

- `GROUP BY`
- `COUNT`
- `SUM`
- `AVG`
- `MIN`
- `MAX`
- `COUNT DISTINCT`
- `HAVING`
- Grouping by multiple columns
- Grouping by expressions
- `WITH ROLLUP`

### Subqueries and Set Operations

File: `queries/05_subqueries.sql`

Covers:

- Scalar subqueries
- `IN` and `NOT IN` subqueries
- `EXISTS` and `NOT EXISTS`
- Correlated subqueries
- Derived tables
- `UNION`
- `UNION ALL`
- MySQL alternatives for `INTERSECT` and `EXCEPT`

### Advanced SQL

File: `queries/06_views_indexes_transactions.sql`

Covers:

- Views
- Indexes
- Transactions
- `COMMIT`
- `ROLLBACK`
- Metadata queries
- `information_schema`
- Window functions
- `RANK`
- `ROW_NUMBER`
- `SUM OVER`

## Example Business Questions

This project answers questions such as:

- Which members borrowed the most books?
- Which books are most popular?
- Which books have no reviews?
- Which members have active reservations?
- Which loans are overdue?
- What is the total revenue by payment type?
- What is the monthly revenue trend?
- Which books rank highest within each category?
- Which branches have the most available copies?
- Which members paid the most in fees?

More business questions are listed in:

```text
reports/business_questions.md
```

Selected query examples and explanations are available in:

```text
reports/query_results.md
```

## Example Query

```text
SELECT
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    COUNT(l.loan_id) AS total_loans
FROM members m
LEFT JOIN loans l
    ON m.member_id = l.member_id
GROUP BY m.member_id, member_name
ORDER BY total_loans DESC;
```

This query shows the total number of loans for each member.

## Key Views

The project creates several reusable views:

| View | Purpose |
|---|---|
| `active_loans_view` | Shows loans that are currently open |
| `overdue_loans_view` | Shows loans that are overdue |
| `book_popularity_view` | Summarizes loans, reviews, and ratings by book |
| `member_activity_view` | Summarizes loans, reservations, reviews, and payments by member |

## Skills Demonstrated

This project demonstrates practical SQL skills for:

- Relational database design
- Query writing
- Data analysis
- Reporting
- Query organization
- Business analytics
- Database inspection
- Portfolio-ready SQL documentation

## Technologies Used

- MySQL
- JetBrains DataGrip / IntelliJ IDEA
- Git
- GitHub

## Future Improvements

Possible extensions:

- Add stored procedures
- Add triggers for audit logs
- Add more realistic sample data
- Add CSV exports
- Add dashboard integration with Power BI or Tableau
- Add performance comparison using `EXPLAIN`
