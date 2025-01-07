-- Query: USER_COUPONS
SELECT User.user_name_surname, Coupon.code, Coupon.discount_amount, Coupon.is_active
FROM User
JOIN User_has_Coupon ON User.user_id = User_has_Coupon.user_id
JOIN Coupon ON User_has_Coupon.code = Coupon.code;