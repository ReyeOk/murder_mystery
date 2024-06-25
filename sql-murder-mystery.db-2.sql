SELECT *
FROM crime_scene_report
WHERE date = 20180115 AND city = 'SQL City' AND type = 'murder'
-- Query returned an event date of 2018-01-05, with two witnesses; one lives at last house on 'Northwestern Dr' and the second, Annabel lives on Franklin Ave 
-- I decided to investigate who the witneses were.


SELECT *
FROM person
WHERE name LIKE 'Annabel%' AND address_street_name = 'Franklin Ave'
-- Annabel Miller, id 16371 , licence_id 490173, ssn 318771143
  
SELECT *
FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC
--Morty Schapiro lives at the last house on Northwestern, with id num 14887, ssn 111564949

SELECT *
FROM interview
WHERE person_id IN (16371,14887)

--Marty says, I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. 
--The membership number on the bag started with "48Z". 
--Only gold members have those bags. The man got into a car with a plate that included "H42W".
-- Annabel says' I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.

SELECT *
FROM get_fit_now_check_in as checkin
JOIN get_fit_now_member as members
ON checkin.membership_id = members.id
WHERE check_in_date = 20180109 and membership_status = 'gold' AND id LIKE '48Z%'
--returned Joe Germuska, person id 28819 and Jeremy Bowers, person. id 67318

--to find the car owner and eliminate between the two potential suspects,
SELECT name, address_number, address_street_name, gender, plate_number, car_make
FROM drivers_license
JOIN person
on drivers_license.id = person.license_id
WHERE plate_number LIKE 'H42W%'
--Maxine Whitely, 110 Fisk Rd, H42WOX toyota

SELECT *
FROM person
WHERE name = 'Maxine Whitely'
-- 78193 , license_id is 183779 ssn is 137882671

-- since a new suspect has been introduced, i decided to check the interview outcomes from the three suspects,
SELECT *
FROM interview
WHERE person_id IN(28819, 78193, 67318);
--Confession by Jeremy Bowers who commited the crime. Now to find out who hired him;
--I was hired by a woman with a lot of money. 
--I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
--She has red hair and she drives a Tesla Model S. 
--I know that she attended the SQL Symphony Concert 3 times in December 2017.

SELECT name, address_number, address_street_name, gender, car_make, car_model, ssn
FROM drivers_license
JOIN person
on drivers_license.id = person.license_id
WHERE drivers_license.id IN 
(SELECT id
FROM drivers_license
WHERE hair_color = 'red'  AND gender = 'female' AND car_make = 'Tesla' AND car_model ='Model S'
 );
--(202298, 291182, 918773)
--Miranda Priestly, Regina George, Red Korb
--returned social security numbers were; 987756388, 337169072,961388910 in accordance.
--i decided to see what their income was

SELECT i.ssn, i.annual_income, p.id, p.name, p.license_id
FROM income i
JOIN person p
oN i.ssn = p.ssn
WHERE i.ssn IN (987756388, 337169072,961388910)
--Miranda is the waelthies of the returned pair with an annual income of 310,000 and
--Red Korb with an annual income of 278,000. 
-- Decided to see what their activities were on facebook

SELECT name, event_name, date
FROM facebook_event_checkin fb
JOIN person p 
ON fb.person_id = p.id
WHERE date < 20180115 and person_id IN (7881, 99716) 
--Miranda Priestly attended the SQL Symphony Concert and checkedin on 2017/12/06, 2017/12/12 and 2017/12/29

--Conclusion:
--Miranda Priestly Hired Jeremy Bowers to carry out the Murder.crime_scene_report
--She is the only person who fit the description in the confession given by Bowers.