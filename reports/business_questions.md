# Business Questions

This document lists the main business questions answered by the SQL queries in this project.

## Members

### 1. Which members borrowed the most books?

Relevant file:

```text
queries/04_grouping_aggregates.sql
```

Main concepts:

- `GROUP BY`
- `COUNT`
- `LEFT JOIN`
- `ORDER BY`

### 2. Which members have never borrowed a book?

Relevant files:

```text
queries/03_joins.sql
queries/05_subqueries.sql
```

Main concepts:

- `LEFT JOIN`
- `IS NULL`
- `NOT EXISTS`

### 3. Which members have active reservations?

Relevant file:

```text
queries/05_subqueries.sql
```

Main concepts:

- `EXISTS`
- Subqueries

### 4. Which members paid the most in fees?

Relevant file:

```text
queries/04_grouping_aggregates.sql
```

Main concepts:

- `SUM`
- `GROUP BY`
- `JOIN`

## Books

### 5. Which books are most popular?

Relevant file:

```text
queries/06_views_indexes_transactions.sql
```

Main concepts:

- Views
- `COUNT`
- `LEFT JOIN`
- Window functions

### 6. Which books have no reviews?

Relevant files:

```text
queries/03_joins.sql
queries/05_subqueries.sql
```

Main concepts:

- `LEFT JOIN`
- `IS NULL`
- `NOT EXISTS`

### 7. Which books are more expensive than the average book price?

Relevant file:

```text
queries/05_subqueries.sql
```

Main concepts:

- Scalar subquery
- `AVG`

### 8. Which books have an average rating above the overall average rating?

Relevant file:

```text
queries/05_subqueries.sql
```

Main concepts:

- `GROUP BY`
- `HAVING`
- Subquery
- `AVG`

## Loans

### 9. Which loans are currently open?

Relevant files:

```text
queries/02_filtering.sql
queries/06_views_indexes_transactions.sql
```

Main concepts:

- `IS NULL`
- Views

### 10. Which loans were returned late?

Relevant files:

```text
queries/02_filtering.sql
queries/03_joins.sql
```

Main concepts:

- Date comparison
- `DATEDIFF`
- `JOIN`

### 11. What is the average number of late days?

Relevant file:

```text
queries/04_grouping_aggregates.sql
```

Main concepts:

- `AVG`
- `DATEDIFF`
- `WHERE`

## Branches

### 12. Which branches have the most book copies?

Relevant file:

```text
queries/04_grouping_aggregates.sql
```

Main concepts:

- `LEFT JOIN`
- `GROUP BY`
- `COUNT`

### 13. Which branches have the most available copies?

Relevant file:

```text
queries/04_grouping_aggregates.sql
```

Main concepts:

- Conditional join
- `LEFT JOIN`
- `GROUP BY`

## Payments

### 14. What is the total revenue by payment type?

Relevant file:

```text
queries/04_grouping_aggregates.sql
```

Main concepts:

- `SUM`
- `AVG`
- `GROUP BY`

### 15. What is the monthly revenue trend?

Relevant files:

```text
queries/04_grouping_aggregates.sql
queries/06_views_indexes_transactions.sql
```

Main concepts:

- `EXTRACT`
- `GROUP BY` expression
- Window functions
- Running total

## Advanced Analytics

### 16. How can books be ranked by popularity?

Relevant file:

```text
queries/06_views_indexes_transactions.sql
```

Main concepts:

- `RANK`
- Window functions
- Views

### 17. What are the top books within each category?

Relevant file:

```text
queries/06_views_indexes_transactions.sql
```

Main concepts:

- `PARTITION BY`
- `RANK`
- `GROUP BY`

### 18. How does each member compare to the average member activity?

Relevant file:

```text
queries/06_views_indexes_transactions.sql
```

Main concepts:

- `AVG OVER`
- Window functions
