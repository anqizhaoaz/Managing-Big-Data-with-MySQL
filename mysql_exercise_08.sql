# MySQL Exercise 8: Joining Tables with Outer Joins
%load_ext sql
%sql mysql://studentuser:studentpw@mysqlserver/dognitiondb
%sql USE dognitiondb


# Question 1:
%%sql
SELECT d.user_guid AS UserID, d.dog_guid AS DogID, d.breed, d.breed_type,
d.breed_group
FROM dogs d JOIN complete_tests c
ON d.dog_guid=c.dog_guid
WHERE test_name='Yawn Warm-up';

# Question 2:
%%sql
SELECT r.dog_guid AS rDogID, d.dog_guid AS dDogID, r.user_guid AS rUserID,
d.user_guid AS dUserID, AVG(r.rating) AS AvgRating, COUNT(r.rating) AS
NumRatings, d.breed, d.breed_group, d.breed_type
FROM dogs d RIGHT JOIN reviews r
ON d.dog_guid=r.dog_guid AND d.user_guid=r.user_guid
WHERE r.dog_guid IS NOT NULL
GROUP BY r.dog_guid
HAVING NumRatings >= 10
ORDER BY AvgRating DESC;

%%sql SELECT r.dog_guid AS rDogID, d.dog_guid AS dDogID, r.user_guid AS rUserID, d.user_guid AS dUserID, AVG(r.rating) AS AvgRating, COUNT(r.rating) AS NumRatings, d.breed, d.breed_group, d.breed_type
FROM reviews r LEFT JOIN dogs d
  ON r.dog_guid=d.dog_guid AND r.user_guid=d.user_guid
WHERE d.dog_guid IS NULL
GROUP BY r.dog_guid
HAVING NumRatings >= 10
ORDER BY AvgRating DESC;

# Question 3: How would you use a left join to retrieve a list of all the unique dogs in the dogs table, 
# and retrieve a count of how many tests each one completed? Include the dog_guids and user_guids from the dogs and complete_tests tables in your output. (If you do not limit your query, your output should contain 35050 rows. 
# HINT: use the dog_guid from the dogs table to group your results.)
%%sql
SELECT d.user_guid AS dUserID, c.user_guid AS cUserID, d.dog_guid AS dDogID,
c.dog_guid AS dDogID, count(test_name)
FROM dogs d LEFT JOIN complete_tests c
ON d.dog_guid=c.dog_guid
GROUP BY d.dog_guid;


# Question 4: Repeat the query you ran in Question 3, but intentionally use the dog_guids from the completed_tests table to 
# group your results instead of the dog_guids from the dogs table. (Your output should contain 17987 rows)

#Question 5:
%%sql
SELECT COUNT(DISTINCT dog_guid)
FROM complete_tests;









