-- ============================================================
--  SAFAR DATABASE SETUP  (Upgraded v2)
--  Run: mysql -u root -p < backend/safar_db_setup.sql
-- ============================================================

CREATE DATABASE IF NOT EXISTS safar;
USE safar;

-- users
CREATE TABLE IF NOT EXISTS users (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100)  NOT NULL,
    email      VARCHAR(100)  NOT NULL UNIQUE,
    password   VARCHAR(255)  NOT NULL,
    role       ENUM('user','owner') NOT NULL DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- trips (owner packages shown on explore page)
CREATE TABLE IF NOT EXISTS trips (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    title        VARCHAR(150) NOT NULL,
    location     VARCHAR(150) NOT NULL,
    price        DECIMAL(10,2) NOT NULL,
    image        VARCHAR(255) DEFAULT '',
    organizer_id INT,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (organizer_id) REFERENCES users(id) ON DELETE SET NULL
);

-- hotels (owner-added hotel listings shown on properties page)
CREATE TABLE IF NOT EXISTS hotels (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(150) NOT NULL,
    city         VARCHAR(100) NOT NULL,
    price        DECIMAL(10,2) NOT NULL,
    image        VARCHAR(255) DEFAULT 'p1.jpg',
    owner_id     INT,
    owner_email  VARCHAR(100),
    description  TEXT,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE SET NULL
);

-- hotel_bookings with counter_offer and payment columns
CREATE TABLE IF NOT EXISTS hotel_bookings (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT NOT NULL,
    property_name   VARCHAR(150) NOT NULL,
    hotel_id        INT DEFAULT NULL,
    original_price  DECIMAL(10,2),
    offered_price   DECIMAL(10,2),
    counter_offer   DECIMAL(10,2) DEFAULT NULL,
    counter_note    VARCHAR(255) DEFAULT NULL,
    owner_email     VARCHAR(100),
    checkin         DATE NOT NULL,
    checkout        DATE NOT NULL,
    guests          INT DEFAULT 1,
    city            VARCHAR(100) DEFAULT '',
    status          ENUM('Pending','Accepted','Rejected','Counter Offered','Paid & Confirmed') DEFAULT 'Pending',
    payment_ref     VARCHAR(50) DEFAULT NULL,
    paid_at         TIMESTAMP NULL DEFAULT NULL,
    booked_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)   REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (hotel_id)  REFERENCES hotels(id) ON DELETE SET NULL
);

-- activity_bookings
CREATE TABLE IF NOT EXISTS activity_bookings (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    user_id          INT NOT NULL,
    activity_name    VARCHAR(150) NOT NULL,
    city             VARCHAR(100) DEFAULT '',
    date             DATE NOT NULL,
    people           INT DEFAULT 1,
    price_per_person DECIMAL(10,2),
    total            DECIMAL(10,2),
    contact_name     VARCHAR(100),
    phone            VARCHAR(20),
    special          TEXT,
    status           ENUM('Confirmed','Cancelled') DEFAULT 'Confirmed',
    booked_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Seed users
INSERT IGNORE INTO users (name, email, password, role) VALUES
  ('Test User',  'user@safar.com',  '123456', 'user'),
  ('Test Owner', 'owner@safar.com', '123456', 'owner'),
  ('Owner One',  'owner1@gmail.com','123456', 'owner'),
  ('Owner Two',  'owner2@gmail.com','123456', 'owner');

-- Seed trips
INSERT IGNORE INTO trips (title, location, price, image, organizer_id) VALUES
  ('Chopta Weekend Escape',   'Chopta',     6999,  'chopta.webp',   2),
  ('Rishikesh Adventure',     'Rishikesh',  4500,  'rishikesh.jpg', 2),
  ('Mussoorie Hill Retreat',  'Mussoorie',  6500,  'mussorie.jpg',  2);

-- Seed hotels
INSERT IGNORE INTO hotels (name, city, price, image, owner_id, owner_email, description) VALUES
  ('Himalayan Eco Lodge',  'Chopta',    3500, 'p1.jpg',   3, 'owner1@gmail.com', 'Peaceful eco stay amid pine forests.'),
  ('Snow View Resort',     'Chopta',    4200, 'p2.jpg',   3, 'owner1@gmail.com', 'Stunning views of snow-capped peaks.'),
  ('Mountain Bliss Stay',  'Chopta',    3900, 'p3.jpg',   4, 'owner2@gmail.com', 'Cozy rooms with mountain views.'),
  ('Hotel Pacific',        'Dehradun',  4000, 'p4.jpg',   4, 'owner2@gmail.com', 'Modern hotel in city centre.'),
  ('Forest View Resort',   'Dehradun',  3200, 'p5.jpg',   3, 'owner1@gmail.com', 'Serene resort near forest.'),
  ('Royal Residency',      'Dehradun',  4500, 'p6.avif',  4, 'owner2@gmail.com', 'Premium stay with all amenities.'),
  ('River View Stay',      'Devprayag', 3000, 'p7.jpg',   3, 'owner1@gmail.com', 'Wake up to the sound of rivers.'),
  ('Sangam Hotel',         'Devprayag', 2600, 'p8.jpg',   4, 'owner2@gmail.com', 'Budget stay at the Sangam.'),
  ('Ganga View Resort',    'Rishikesh', 4500, 'p2.jpg',   4, 'owner2@gmail.com', 'Overlooking the holy Ganga.'),
  ('Yoga Retreat Ashram',  'Rishikesh', 3000, 'p3.jpg',   3, 'owner1@gmail.com', 'Peace, yoga, and riverside calm.'),
  ('Hilltop Hotel',        'Mussoorie', 5000, 'p12.jpg',  3, 'owner1@gmail.com', 'At the top of Queen of Hills.'),
  ('Mall Road Residency',  'Mussoorie', 3800, 'p13.jpg',  4, 'owner2@gmail.com', 'Steps away from the famous Mall Road.');

SELECT 'Database setup complete v2' AS status;
