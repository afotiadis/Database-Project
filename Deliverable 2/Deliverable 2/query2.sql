-- Query: USER_VEHICLES
SELECT User.user_name_surname, Vehicle.license_plate, Vehicle.vehicle_type
FROM User
JOIN User_owns_Vehicle ON User.user_id = User_owns_Vehicle.user_id
JOIN Vehicle ON User_owns_Vehicle.license_plate = Vehicle.license_plate;