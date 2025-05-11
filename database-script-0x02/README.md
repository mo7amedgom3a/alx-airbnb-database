# Database Seeding Scripts

This directory contains scripts for seeding the Airbnb Clone database with sample data. Two methods are provided: a SQL script for static data and a Python script for generating dynamic test data.

## 1. SQL Seeding (seed.sql)

The `seed.sql` script provides a basic set of static test data with predefined UUIDs for easier testing and development.

### Sample Data Includes:
- 4 Users (2 hosts, 2 guests)
- 2 Properties
- 2 Bookings
- 1 Payment
- 2 Messages

### Usage:
```bash
mysql -u your_username -p < seed.sql
```

## 2. Python Seeding (seed.py)

The `seed.py` script uses the Faker library to generate more realistic random test data at scale.

### Features:
- Generates randomized but realistic-looking data
- Maintains referential integrity between tables
- Creates varied timestamps for realistic data distribution
- Supports large-scale data generation

### Data Generation:
- 10 Users (mixed roles)
- 5 Properties
- 8 Bookings
- Random number of Payments
- 5 Reviews
- 10 Messages

### Prerequisites:
```bash
pip install mysql-connector-python faker
```

### Configuration:
Update the database connection settings in `seed.py`:
```python
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'your_password',
    'database': 'airbnb_clone'
}
```

### Running the Script:
```bash
python seed.py
```

## Data Characteristics

### Users
- Randomized first and last names
- Unique email addresses
- Hashed passwords
- Optional phone numbers
- Roles: guest, host, or admin

### Properties
- Creative property names
- Detailed descriptions
- Various locations
- Price range: $50-500 per night
- Timestamps within last 2 years

### Bookings
- Future dates (next 30 days)
- Variable duration (1-14 days)
- Status: pending, confirmed, or canceled
- Total price: $100-2000

### Payments
- Matches booking amounts
- Payment methods: credit_card, paypal, stripe
- Timestamps aligned with bookings

### Reviews
- Ratings: 1-5 stars
- Generated review comments
- Linked to properties and users

### Messages
- Realistic message content
- Proper sender/recipient relationships
- Time-stamped conversations

## Notes
- All IDs are UUID v4 format
- Timestamps are distributed realistically
- Foreign key relationships are maintained
- The Python script includes error handling and connection management