-- Query: SPECIFIC_DATE_REVIEWS
SELECT ParkingSpot.address, Review.review_text
FROM ParkingSpot
JOIN Review ON ParkingSpot.spot_id = Review.spot_id
WHERE Review.rating > 3 AND Review.review_date > '2024-11-19 00:01';