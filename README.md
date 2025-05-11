# Airbnb Clone Project

## Overview
This project is a functional clone of Airbnb, built to demonstrate proficiency in modern full-stack development practices. It implements core features of the Airbnb platform while focusing on scalable architecture, security, and collaborative development workflows.

## Learning Objectives
- Master collaborative team workflows using GitHub
- Deepen understanding of backend architecture and database design principles
- Implement advanced security measures for API development
- Gain proficiency in designing and managing CI/CD pipelines
- Strengthen documentation and planning skills for complex software projects
- Develop expertise in integrating Django, MySQL, and GraphQL in a unified ecosystem

## Technology Stack
- **Backend**: Django
- **Database**: MySQL
- **API**: GraphQL
- **Containerization**: Docker
- **CI/CD**: GitHub Actions
- **Version Control**: Git/GitHub

## Requirements
- GitHub account for repository management
- Working knowledge of Markdown syntax
- Experience with Django and MySQL
- Understanding of software development lifecycle practices
- Familiarity with Docker, GitHub Actions, or similar CI/CD platforms

## Getting Started
*Instructions for setup and installation to be added as the project progresses*

## Features
*Feature list to be expanded as development continues*

## Contributors
*List of contributors will be added here*
## Team Roles

- **Backend Engineer**: Responsible for Django application development, API endpoints, and server-side logic
- **Database Administrator**: Manages MySQL database schema, optimizes queries, and ensures data integrity
- **Frontend Developer**: Creates responsive UI components and implements client-side functionality
- **DevOps Engineer**: Handles Docker containerization, CI/CD pipeline configuration, and deployment strategies
- **QA Specialist**: Conducts testing, identifies bugs, and ensures overall application quality
- **Project Manager**: Coordinates team efforts, tracks progress, and manages project timelines
- **Security Specialist**: Implements authentication, authorization, and ensures data protection measures

## Technology Stack
### Technology Stack Details

- **Django**: Python-based web framework powering the backend application logic and MVC architecture
- **MySQL**: Relational database management system for structured data storage and retrieval
- **GraphQL**: Query language for APIs, providing a more efficient alternative to REST
- **Docker**: Platform for developing, shipping, and running applications in containers
- **GitHub Actions**: CI/CD automation tool integrated with the GitHub repository
- **Git/GitHub**: Version control system and platform for collaborative development workflow
## Database Design
### Entity Structure
![Database Entity Relationship Diagram](images/airbnb-clone-erd.png)
### Entity Relationship Diagram

### 
The diagram above illustrates the relationships between key entities in our database system, showing the interconnections between Users, Properties, Bookings, Payments, Reviews, and Messages.
#### Users
- **user_id**: Primary Key, UUID, Indexed
- **first_name**: VARCHAR, NOT NULL
- **last_name**: VARCHAR, NOT NULL
- **email**: VARCHAR, UNIQUE, NOT NULL
- **password_hash**: VARCHAR, NOT NULL
- **phone_number**: VARCHAR, NULL
- **role**: ENUM (guest, host, admin), NOT NULL
- **created_at**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

#### Properties
- **property_id**: Primary Key, UUID, Indexed
- **host_id**: Foreign Key, references User(user_id)
- **name**: VARCHAR, NOT NULL
- **description**: TEXT, NOT NULL
- **location**: VARCHAR, NOT NULL
- **price_per_night**: DECIMAL, NOT NULL
- **created_at**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
- **updated_at**: TIMESTAMP, ON UPDATE CURRENT_TIMESTAMP

#### Bookings
- **booking_id**: Primary Key, UUID, Indexed
- **property_id**: Foreign Key, references Property(property_id)
- **user_id**: Foreign Key, references User(user_id)
- **start_date**: DATE, NOT NULL
- **end_date**: DATE, NOT NULL
- **total_price**: DECIMAL, NOT NULL
- **status**: ENUM (pending, confirmed, canceled), NOT NULL
- **created_at**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

#### Payments
- **payment_id**: Primary Key, UUID, Indexed
- **booking_id**: Foreign Key, references Booking(booking_id)
- **amount**: DECIMAL, NOT NULL
- **payment_date**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
- **payment_method**: ENUM (credit_card, paypal, stripe), NOT NULL

#### Reviews
- **review_id**: Primary Key, UUID, Indexed
- **property_id**: Foreign Key, references Property(property_id)
- **user_id**: Foreign Key, references User(user_id)
- **rating**: INTEGER, CHECK: rating >= 1 AND rating <= 5, NOT NULL
- **comment**: TEXT, NOT NULL
- **created_at**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

#### Messages
- **message_id**: Primary Key, UUID, Indexed
- **sender_id**: Foreign Key, references User(user_id)
- **recipient_id**: Foreign Key, references User(user_id)
- **message_body**: TEXT, NOT NULL
- **sent_at**: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

### Entity Relationships

- A User can be either a guest, host, or admin
- A User (as host) can have multiple Properties
- A User (as guest) can make multiple Bookings
- A Property can have multiple Bookings
- A Booking belongs to exactly one Property and one User (guest)
- A Payment belongs to exactly one Booking
- Reviews are linked to specific Properties and Users
- Messages can be sent between Users

### Constraints and Indexing

- Unique constraint on User email
- Rating values constrained between 1-5
- All primary keys are automatically indexed
- Additional indexes on frequently accessed fields
## Feature Breakdown
### User Management
User management provides secure authentication and profile systems allowing guests and hosts to create accounts, manage their profiles, and build reputation in the community. This feature forms the foundation of the platform's identity system, enabling personalized experiences and account-specific functionalities.

### Property Management
Property management enables hosts to create, update, and manage their property listings with detailed descriptions, photos, pricing, and availability calendars. This core feature gives property owners control over their listings while providing potential guests with comprehensive information needed to make informed booking decisions.

### Booking System
The booking system facilitates the reservation process from initial search to confirmation, handling date selection, pricing calculations, and booking status tracking. It serves as the primary transaction mechanism of the platform, coordinating the critical connection between guests seeking accommodations and hosts offering their properties.

### Review and Rating System
This feature allows guests to provide feedback and ratings after their stays, building trust in the community and helping future guests make informed decisions. The system also enables hosts to respond to reviews, creating transparent communication channels that enhance the platform's reliability.

### Search and Filtering
Advanced search functionality lets users find properties based on location, price range, amenities, dates, and other criteria for a tailored browsing experience. This discovery mechanism optimizes the user experience by efficiently connecting guests with relevant property listings that match their specific requirements.

### Payment Processing
Secure payment processing handles transactions between guests and hosts, including initial payments, refunds, and host payouts. This critical infrastructure ensures financial security while managing the monetary aspects of bookings with appropriate fee calculations and payment status tracking.

### Messaging System
An integrated messaging system enables direct communication between hosts and guests before, during, and after bookings for questions, coordination, and support. This feature facilitates clear communication channels that are essential for addressing specific needs and building trust between users.
## API Security
## Security Implementation

### Key Security Measures

1. **Authentication**
    - Multi-factor authentication for user accounts
    - JWT (JSON Web Tokens) for secure session management
    - Secure password storage with bcrypt hashing

2. **Authorization**
    - Role-based access control (RBAC) system
    - Principle of least privilege for all system components
    - Fine-grained permission system for resource access

3. **API Protection**
    - Rate limiting to prevent abuse and DDoS attacks
    - Request validation using schema verification
    - API keys with proper secret management

4. **Data Protection**
    - End-to-end encryption for sensitive data
    - Data masking for personally identifiable information (PII)
    - Database encryption at rest

5. **Network Security**
    - TLS/SSL implementation for all connections
    - Proper CORS configuration
    - Web Application Firewall (WAF) integration

### Security Rationale

- **User Data Protection**: Implementing strong authentication and data encryption ensures user privacy and builds trust in our platform.

- **Transaction Security**: Securing payment flows with encryption and authorization controls protects both our users and our business from financial fraud.

- **System Integrity**: Rate limiting and validation prevent system abuse, ensuring consistent performance and availability for all users.

- **Compliance**: Our security measures help ensure compliance with relevant regulations like GDPR, CCPA, and industry standards.

- **Threat Mitigation**: Implementing defense-in-depth security measures creates multiple layers of protection against evolving cyber threats.
## CI/CD Pipeline
## CI/CD Pipeline

### Overview
Our Continuous Integration and Continuous Deployment (CI/CD) pipeline automates the building, testing, and deployment processes of the application, ensuring code quality and streamlining the development workflow. This automation reduces manual errors, provides faster feedback loops, and enables more frequent, reliable releases.

### Pipeline Components

- **Continuous Integration**: Automatically builds and tests code changes when pushed to the repository
- **Continuous Delivery**: Prepares code for deployment after successful testing
- **Continuous Deployment**: Automatically deploys approved changes to production environments

### Implementation Tools

- **GitHub Actions**: Workflow automation directly integrated with our GitHub repository
- **Docker**: Containerization for consistent environments across development, testing, and production
- **pytest**: Automated testing framework for Python code
- **Linters**: Code quality tools (flake8, ESLint) to ensure coding standards
- **SonarQube**: Static code analysis to identify security vulnerabilities and code smells

### Pipeline Workflow

1. **Code Commit**: Developer pushes changes to a feature branch
2. **Automated Tests**: Unit and integration tests run automatically
3. **Code Quality Checks**: Linting and static analysis tools validate code quality
4. **Build Process**: Application is built into Docker containers
5. **Preview Deployment**: Changes deployed to staging environment for review
6. **Approval Process**: Required approvals before production deployment
7. **Production Deployment**: Automatic deployment to production after approval
## License
*License information to be added*