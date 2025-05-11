# Normalization of the Airbnb Database

The current Airbnb database schema demonstrates strong normalization principles, making it efficient and well-structured for transactional operations. Below is an analysis of how the schema conforms to standard normal forms.

## Normal Forms Analysis

### ✅ First Normal Form (1NF)
- **Atomic values**: All attributes contain single, indivisible values
- **Unique rows**: Each record is uniquely identified with a clear primary key
- **No repeating groups**: Data is organized into separate rows rather than multiple values in one column

### ✅ Second Normal Form (2NF)
- **Meets 1NF requirements**: Builds upon first normal form compliance
- **No partial dependencies**: All tables use single-column primary keys (UUIDs), eliminating partial dependency concerns
- **Full key dependency**: Non-key columns depend on the entire primary key (not just part of it)

### ✅ Third Normal Form (3NF)
- **Meets 2NF requirements**: Extends second normal form compliance
- **No transitive dependencies**: All non-key attributes depend directly on the primary key
    - Example: In the User table, all columns depend solely on user_id
    - Example: In the Property table, all attributes depend exclusively on property_id
- **No derived attributes**: There are no columns calculated from other non-key attributes
    - Note: total_price could potentially be calculated dynamically from start_date × pricepernight, but storing it directly is acceptable for performance reasons

## Potential Further Normalization

While the schema is sufficiently normalized for most practical applications, some potential enhancements could include:

- **Enum Conversion**: Currently using ENUMs for payment methods, status values, and roles
    - Could be normalized into lookup tables for greater flexibility
    - Current approach is efficient when value lists are small and static

### Example of Further Normalization

```sql
CREATE TABLE PaymentMethod (
        method_id TINYINT PRIMARY KEY,
        method_name VARCHAR(50) UNIQUE
);
```

> **Note**: Further normalization should be carefully balanced against performance considerations and application requirements.