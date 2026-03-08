IF NOT EXISTS (SELECT * FROM sys.tables WHERE name='events')
BEGIN
CREATE TABLE events (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(150) NOT NULL,
    location NVARCHAR(150) NOT NULL,
    event_date DATETIME2 NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    total_seats INT NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE()
);
END


IF NOT EXISTS (SELECT * FROM sys.tables WHERE name='bookings')
BEGIN
CREATE TABLE bookings (
    id INT IDENTITY(1,1) PRIMARY KEY,
    event_id INT NOT NULL,
    user_name NVARCHAR(150) NOT NULL,
    tickets INT NOT NULL,
    booking_time DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT fk_event
    FOREIGN KEY (event_id) REFERENCES events(id)
);
END


IF NOT EXISTS (SELECT * FROM events)
BEGIN
INSERT INTO events (name,location,event_date,price,total_seats)
VALUES
('Music Festival','Delhi','2026-05-10',500,200),
('Tech Conference','Bangalore','2026-06-15',1200,300),
('Startup Meetup','Gurgaon','2026-07-01',300,150),
('AI Summit','Hyderabad','2026-08-20',1500,250),
('Gaming Expo','Mumbai','2026-09-12',800,180);
END