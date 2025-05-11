import mysql.connector
from faker import Faker
import uuid
import random
from datetime import timedelta

# Initialize Faker
fake = Faker()

# Database connection configuration
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '2003',
    'database': 'airbnb_clone'
}
# Connect to the MySQL database
conn = mysql.connector.connect(**db_config)
cursor = conn.cursor()

# Lists to store generated IDs for foreign key relationships
user_ids = []
property_ids = []
booking_ids = []

# Insert Users
roles = ['guest', 'host', 'admin']
for _ in range(10):
    user_id = str(uuid.uuid4())
    first_name = fake.first_name()
    last_name = fake.last_name()
    email = fake.unique.email()
    password_hash = fake.sha256()
    phone_number = fake.phone_number()[:15] if random.choice([True, False]) else None
    role = random.choice(roles)
    created_at = fake.date_time_between(start_date='-2y', end_date='now')
    
    cursor.execute("""
        INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
    """, (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at))
    
    user_ids.append({'id': user_id, 'role': role})

conn.commit()

# Insert Properties
host_ids = [user['id'] for user in user_ids if user['role'] == 'host']
for _ in range(5):
    property_id = str(uuid.uuid4())
    host_id = random.choice(host_ids)
    name = fake.catch_phrase()
    description = fake.text(max_nb_chars=200)
    location = f"{fake.city()}, {fake.country()}"
    pricepernight = round(random.uniform(50, 500), 2)
    created_at = fake.date_time_between(start_date='-2y', end_date='now')
    updated_at = fake.date_time_between(start_date=created_at, end_date='now')
    
    cursor.execute("""
        INSERT INTO Property (property_id, host_id, name, description, location, pricepernight, created_at, updated_at)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
    """, (property_id, host_id, name, description, location, pricepernight, created_at, updated_at))
    
    property_ids.append(property_id)

conn.commit()

# Insert Bookings
guest_ids = [user['id'] for user in user_ids if user['role'] == 'guest']
for _ in range(8):
    booking_id = str(uuid.uuid4())
    property_id = random.choice(property_ids)
    user_id = random.choice(guest_ids)
    start_date = fake.date_between(start_date='today', end_date='+30d')
    end_date = start_date + timedelta(days=random.randint(1, 14))
    total_price = round(random.uniform(100, 2000), 2)
    status = random.choice(['pending', 'confirmed', 'canceled'])
    created_at = fake.date_time_between(start_date='-1y', end_date='now')
    
    cursor.execute("""
        INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
    """, (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at))
    
    booking_ids.append(booking_id)

conn.commit()

# Insert Payments
for booking_id in booking_ids:
    if random.choice([True, False]):
        payment_id = str(uuid.uuid4())
        amount = round(random.uniform(100, 2000), 2)
        payment_date = fake.date_time_between(start_date='-1y', end_date='now')
        payment_method = random.choice(['credit_card', 'paypal', 'stripe'])
        
        cursor.execute("""
            INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method)
            VALUES (%s, %s, %s, %s, %s)
        """, (payment_id, booking_id, amount, payment_date, payment_method))

conn.commit()

# Insert Reviews
for _ in range(5):
    review_id = str(uuid.uuid4())
    property_id = random.choice(property_ids)
    user_id = random.choice(guest_ids)
    rating = random.randint(1, 5)
    comment = fake.sentence(nb_words=15)
    created_at = fake.date_time_between(start_date='-1y', end_date='now')
    
    cursor.execute("""
        INSERT INTO Review (review_id, property_id, user_id, rating, comment, created_at)
        VALUES (%s, %s, %s, %s, %s, %s)
    """, (review_id, property_id, user_id, rating, comment, created_at))

conn.commit()

# Insert Messages
for _ in range(10):
    sender = random.choice(user_ids)
    recipient = random.choice([user for user in user_ids if user['id'] != sender['id']])
    message_id = str(uuid.uuid4())
    message_body = fake.text(max_nb_chars=200)
    sent_at = fake.date_time_between(start_date='-1y', end_date='now')
    
    cursor.execute("""
        INSERT INTO Message (message_id, sender_id, recipient_id, message_body, sent_at)
        VALUES (%s, %s, %s, %s, %s)
    """, (message_id, sender['id'], recipient['id'], message_body, sent_at))

conn.commit()

# Close the database connection
cursor.close()
conn.close()

print("Sample data inserted successfully.")