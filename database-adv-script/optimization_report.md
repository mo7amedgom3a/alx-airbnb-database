# Database Query Optimization Techniques

## Indexing Strategies
- **Create appropriate indexes**: Add indexes on columns frequently used in WHERE, JOIN, and ORDER BY clauses
- **Composite indexes**: Create multi-column indexes for queries that filter or join on multiple columns
- **Covering indexes**: Include all columns needed by the query in the index to avoid table lookups
- **Avoid over-indexing**: Too many indexes can slow down write operations and consume storage

## JOIN Optimizations
- **Minimize JOINs**: Denormalize data where appropriate to reduce the need for joins
- **Use INNER JOINs** instead of OUTER JOINs when possible
- **Join order**: Ensure smaller tables are joined first when possible
- **Use join hints** when the optimizer consistently chooses a sub-optimal plan

## Query Structure
- **Be specific**: Select only needed columns instead of using SELECT *
- **Limit results**: Use LIMIT/TOP to restrict result sets
- **Use EXISTS** instead of IN for subqueries when checking existence
- **Avoid correlated subqueries**: Rewrite as JOINs when possible
- **Use EXPLAIN/EXPLAIN ANALYZE** to understand query execution plans

## WHERE Clause Optimization
- **SARGable predicates**: Structure conditions to allow index usage (avoid functions on indexed columns)
- **Avoid wildcards at the beginning** of LIKE patterns
- **Use appropriate operators**: = is better than LIKE when exact matching
- **Avoid OR conditions** when possible; use UNION ALL instead

## Data Type Considerations
- **Use appropriate data types**: Smaller is generally better for performance
- **Consistent data types**: Avoid type conversions in join conditions and WHERE clauses
- **Consider partitioning** large tables based on query patterns

## Caching and Materialized Views
- **Use materialized views** for complex, frequently-run queries
- **Implement query caching** at application level
- **Create summary tables** for analytical queries

## General Best Practices
- **Regular maintenance**: Update statistics, rebuild indexes, and remove fragmentation
- **Batch operations**: Combine multiple similar operations when possible
- **Consider read replicas** for read-heavy workloads
- **Monitor and tune**: Continuously identify and optimize slow queries