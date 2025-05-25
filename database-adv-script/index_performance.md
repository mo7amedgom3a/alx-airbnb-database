# Database Indexes and Query Analysis

## Table of Contents
- [What are Database Indexes?](#what-are-database-indexes)
- [Types of Indexes](#types-of-indexes)
- [Index Examples](#index-examples)
- [EXPLAIN and ANALYZE Keywords](#explain-and-analyze-keywords)
- [Practical Examples](#practical-examples)
- [Best Practices](#best-practices)

## What are Database Indexes?

Database indexes are data structures that improve the speed of data retrieval operations on a database table. Think of them like an index in a book - instead of reading every page to find a topic, you can quickly jump to the relevant section using the index.

**Key Benefits:**
- Faster query execution
- Reduced disk I/O operations
- Improved WHERE clause performance
- Enhanced JOIN operations

**Trade-offs:**
- Additional storage space required
- Slower INSERT/UPDATE/DELETE operations
- Maintenance overhead

## Types of Indexes

### 1. Primary Index (Clustered Index)
The primary index determines the physical order of data in the table. Each table can have only one primary index.

**Characteristics:**
- Automatically created for PRIMARY KEY
- Data rows are stored in the same order as the index
- Fastest for range queries

### 2. Secondary Index (Non-Clustered Index)
Points to the location of data rather than storing data in index order.

**Characteristics:**
- Can have multiple secondary indexes per table
- Contains pointers to actual data rows
- Good for equality searches

### 3. Unique Index
Ensures uniqueness of values and provides fast access.

**Characteristics:**
- Prevents duplicate values
- Automatically created for UNIQUE constraints
- Optimizes equality searches

### 4. Composite Index (Multi-Column Index)
Built on multiple columns together.

**Characteristics:**
- Order of columns matters
- Most effective when query uses leftmost columns
- Can satisfy multiple query patterns

### 5. Partial Index
Index on a subset of rows that meet certain conditions.

**Characteristics:**
- Smaller index size
- Faster maintenance
- Useful for commonly filtered data

### 6. Functional Index
Index on the result of a function or expression.

**Characteristics:**
- Optimizes queries with functions in WHERE clause
- Stores computed values
- Database-specific implementation

## Index Examples

### Creating Indexes

```sql
-- Primary Index (automatically created)
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP
);

-- Secondary Index
CREATE INDEX idx_users_username ON users(username);

-- Unique Index
CREATE UNIQUE INDEX idx_users_email ON users(email);

-- Composite Index
CREATE INDEX idx_users_username_created ON users(username, created_at);

-- Partial Index (PostgreSQL)
CREATE INDEX idx_active_users ON users(username) 
WHERE active = true;

-- Functional Index (PostgreSQL)
CREATE INDEX idx_users_lower_email ON users(LOWER(email));
```

### Index Usage Scenarios

```sql
-- Scenario 1: Single column search (uses idx_users_username)
SELECT * FROM users WHERE username = 'john_doe';

-- Scenario 2: Email lookup (uses idx_users_email)
SELECT * FROM users WHERE email = 'john@example.com';

-- Scenario 3: Composite index usage (uses idx_users_username_created)
SELECT * FROM users 
WHERE username = 'john_doe' AND created_at > '2024-01-01';

-- Scenario 4: Range query (uses primary index if querying by id)
SELECT * FROM users WHERE id BETWEEN 100 AND 200;
```

## EXPLAIN and ANALYZE Keywords

### EXPLAIN
The `EXPLAIN` keyword shows the execution plan that the database query planner will use to execute a query **without actually running it**.

**What it shows:**
- Which indexes will be used
- Join methods
- Estimated costs and row counts
- Scan types (sequential, index, bitmap)

### ANALYZE
The `ANALYZE` keyword (when used with EXPLAIN) actually **executes the query** and provides real runtime statistics along with the execution plan.

**Additional information provided:**
- Actual execution time
- Actual row counts
- Memory usage
- I/O statistics

## Practical Examples

### Basic EXPLAIN Usage

```sql
-- PostgreSQL
EXPLAIN SELECT * FROM users WHERE username = 'john_doe';

-- Output might look like:
-- Index Scan using idx_users_username on users  (cost=0.42..8.44 rows=1 width=64)
--   Index Cond: (username = 'john_doe'::text)
```

### EXPLAIN ANALYZE Usage

```sql
-- PostgreSQL
EXPLAIN ANALYZE SELECT * FROM users WHERE username = 'john_doe';

-- Output might look like:
-- Index Scan using idx_users_username on users  (cost=0.42..8.44 rows=1 width=64) 
--   (actual time=0.025..0.026 rows=1 loops=1)
--   Index Cond: (username = 'john_doe'::text)
-- Planning Time: 0.123 ms
-- Execution Time: 0.054 ms
```

### MySQL EXPLAIN Example

```sql
-- MySQL
EXPLAIN SELECT * FROM users WHERE username = 'john_doe';

-- Output columns: id, select_type, table, type, possible_keys, key, key_len, ref, rows, Extra
```

### Complex Query Analysis

```sql
-- Analyzing a JOIN query
EXPLAIN ANALYZE 
SELECT u.username, p.title 
FROM users u 
JOIN posts p ON u.id = p.user_id 
WHERE u.created_at > '2024-01-01' 
ORDER BY p.created_at DESC;

-- This will show:
-- - Which indexes are used for the JOIN
-- - Sort operations
-- - Actual vs estimated row counts
-- - Total execution time
```

### Reading EXPLAIN Output

**Key terms to understand:**

- **Seq Scan**: Full table scan (slow for large tables)
- **Index Scan**: Uses index to find rows
- **Index Only Scan**: All needed data comes from index
- **Bitmap Heap Scan**: Uses bitmap index for complex conditions
- **Hash Join/Nested Loop Join**: Different join algorithms
- **Cost**: Estimated relative expense (not time)
- **Rows**: Estimated number of rows processed
- **Width**: Average size of each row in bytes

## Best Practices

### When to Create Indexes
```sql
-- Good candidates for indexing:
-- 1. Frequently used WHERE conditions
CREATE INDEX idx_orders_status ON orders(status);

-- 2. JOIN columns
CREATE INDEX idx_order_items_order_id ON order_items(order_id);

-- 3. ORDER BY columns
CREATE INDEX idx_products_name ON products(name);

-- 4. Columns used in GROUP BY
CREATE INDEX idx_sales_category ON sales(category);
```

### Index Maintenance
```sql
-- Monitor index usage (PostgreSQL)
SELECT schemaname, tablename, indexname, idx_scan, idx_tup_read, idx_tup_fetch
FROM pg_stat_user_indexes
ORDER BY idx_scan;

-- Remove unused indexes
DROP INDEX IF EXISTS idx_unused_column;

-- Rebuild fragmented indexes (varies by database)
REINDEX TABLE users; -- PostgreSQL
```

### Common Pitfalls to Avoid

1. **Over-indexing**: Too many indexes slow down writes
2. **Wrong column order**: In composite indexes, put most selective columns first
3. **Ignoring NULL values**: Consider how NULLs affect your queries
4. **Not monitoring**: Regularly check index usage and performance

### Query Optimization Tips

```sql
-- Use EXPLAIN to identify problems:

-- Problem: Sequential scan on large table
EXPLAIN SELECT * FROM large_table WHERE rarely_used_column = 'value';
-- Solution: Create index on rarely_used_column

-- Problem: Inefficient JOIN
EXPLAIN SELECT * FROM table1 t1 JOIN table2 t2 ON t1.col = t2.col;
-- Solution: Ensure both join columns are indexed

-- Problem: Sorting without index
EXPLAIN SELECT * FROM users ORDER BY created_at;
-- Solution: Create index on created_at
```

## Database-Specific Notes

### PostgreSQL
- Use `EXPLAIN (ANALYZE, BUFFERS)` for detailed I/O information
- `pg_stat_statements` extension for query performance monitoring
- Supports partial and functional indexes

### MySQL
- Use `EXPLAIN FORMAT=JSON` for detailed output
- `SHOW INDEX FROM table_name` to view indexes
- Consider `FORCE INDEX` hints for query optimization

### SQL Server
- Use `SET STATISTICS IO ON` for I/O statistics
- SQL Server Management Studio provides graphical execution plans
- Supports filtered indexes (similar to partial indexes)

Remember: Always test index changes in a development environment first, and monitor their impact on both query performance and overall system performance.