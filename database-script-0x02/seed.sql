SET sql_mode = 'STRICT_ALL_TABLES';
-- Create a new database
CREATE DATABASE IF NOT EXISTS `airbnb_clone` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- Use the new database
USE `airbnb_clone`;
-- get the tables from air_bnb_clone
select * from Review