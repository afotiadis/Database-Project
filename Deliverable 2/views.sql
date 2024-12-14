-- View for USER_VIEW
CREATE VIEW USER_VIEW AS
SELECT Reservation.start_time, Reservation.end_time, Reservation.status, ParkingSpot.address, Vehicle.license_plate, Vehicle.vehicle_type
FROM Reservation
JOIN ParkingSpot ON ParkingSpot.spot_id = Reservation.spot_id
JOIN Vehicle ON Vehicle.license_plate = Reservation.license_plate
WHERE Reservation.user_id = 1;

-- View for SPOT_OWNER_VIEW
CREATE VIEW SPOT_OWNER_VIEW AS
SELECT Reservation.start_time, Reservation.end_time, Reservation.status, ParkingSpot.address, Vehicle.license_plate, Vehicle.vehicle_type
FROM Reservation
JOIN ParkingSpot ON ParkingSpot.spot_id = Reservation.spot_id
JOIN Vehicle ON Vehicle.license_plate = Reservation.license_plate
WHERE ParkingSpot.spot_owner_id = 4;

-- View for ADMIN_VIEW
CREATE VIEW ADMIN_VIEW AS
SELECT Reservation.user_id, ParkingSpot.spot_owner_id, Reservation.start_time, Reservation.end_time, Reservation.status, ParkingSpot.address, Vehicle.license_plate, Vehicle.vehicle_type
FROM Reservation
JOIN ParkingSpot ON ParkingSpot.spot_id = Reservation.spot_id
JOIN Vehicle ON Vehicle.license_plate = Reservation.license_plate;
