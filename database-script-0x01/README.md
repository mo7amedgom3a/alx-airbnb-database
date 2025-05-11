# Airbnb Clone Database Schema

This document describes the database schema for the Airbnb Clone project. The database is designed to support core functionalities similar to Airbnb, including user management, property listings, bookings, payments, reviews, and messaging.

## Database Configuration

- **Name**: `airbnb_clone`
- **Character Set**: utf8mb4
- **Collation**: utf8mb4_unicode_ci
- **SQL Mode**: STRICT_ALL_TABLES

## Table Structures

### 1. User
Stores user information for guests, hosts, and administrators.

- `user_id` - CHAR(36), Primary Key
- `first_name` - VARCHAR(255)
- `last_name` - VARCHAR(255)
- `email` - VARCHAR(255), Unique
- `password_hash` - VARCHAR(255)
- `phone_number` - VARCHAR(20)
- `role` - ENUM('guest', 'host', 'admin')
- `created_at` - TIMESTAMP

### 2. Property
Contains information about properties listed on the platform.

- `property_id` - CHAR(36), Primary Key
- `host_id` - CHAR(36), Foreign Key to User
- `name` - VARCHAR(255)
- `description` - TEXT
- `location` - VARCHAR(255)
- `pricepernight` - DECIMAL(10,2)
- `created_at` - TIMESTAMP
- `updated_at` - TIMESTAMP

### 3. Booking
Manages property reservations and booking status.

- `booking_id` - CHAR(36), Primary Key
- `property_id` - CHAR(36), Foreign Key to Property
- `user_id` - CHAR(36), Foreign Key to User
- `start_date` - DATE
- `end_date` - DATE
- `total_price` - DECIMAL(10,2)
- `status` - ENUM('pending', 'confirmed', 'canceled')
- `created_at` - TIMESTAMP

### 4. Payment
Tracks payment information for bookings.

- `payment_id` - CHAR(36), Primary Key
- `booking_id` - CHAR(36), Foreign Key to Booking
- `amount` - DECIMAL(10,2)
- `payment_date` - TIMESTAMP
- `payment_method` - ENUM('credit_card', 'paypal', 'stripe')

### 5. Review
Stores user reviews for properties.

- `review_id` - CHAR(36), Primary Key
- `property_id` - CHAR(36), Foreign Key to Property
- `user_id` - CHAR(36), Foreign Key to User
- `rating` - INT (1-5)
- `comment` - TEXT
- `created_at` - TIMESTAMP

### 6. Message
Handles communication between users.

- `message_id` - CHAR(36), Primary Key
- `sender_id` - CHAR(36), Foreign Key to User
- `recipient_id` - CHAR(36), Foreign Key to User
- `message_body` - TEXT
- `sent_at` - TIMESTAMP

## Key Features

1. **Data Integrity**
   - Foreign key constraints ensure referential integrity
   - Appropriate indexing for optimal query performance
   - Timestamp tracking for creation and updates

2. **Security**
   - Password hashing for user security
   - Strict SQL mode enabled for data validation

3. **Scalability**
   - UUID-based primary keys (CHAR(36))
   - Optimized index creation
   - Appropriate data types for each column

## Usage

To set up the database:

1. Ensure you have MySQL installed
2. Run the schema.sql script to create the database and tables:
   ```sql
   mysql -u your_username -p < schema.sql
   ```

## Notes

- All tables use UUID (CHAR(36)) as primary keys for better distribution and scalability
- Timestamps are automatically managed for creation and updates where applicable
- The schema includes necessary indexes for foreign keys and frequently queried columns