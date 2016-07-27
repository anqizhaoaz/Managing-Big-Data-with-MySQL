# MySQL Exercise 7: Joining Tables with Inner Joins
%load_ext sql
%sql mysql://studentuser:studentpw@mysqlserver/dognitiondb
%sql USE dognitiondb

$sql SHOW Tables


# An inner join is a join that outputs only rows that have an exact match in both tables being joined

%%sql SELECT d.dog_guid AS DogID, d.user_guid AS UserID, AVG(r.rating) AS AvgRating, 
       COUNT(r.rating) AS NumRatings, d.breed, d.breed_group, d.breed_type
FROM dogs d, reviews r
WHERE d.dog_guid=r.dog_guid AND d.user_guid=r.user_guid
GROUP BY d.user_guid
HAVING NumRatings >= 10
ORDER BY AvgRating DESC
LIMIT 200

# Questions 1-4: How many unique dog_guids and user_guids are there 
# in the reviews and dogs table independently?

%%sql
SELECT COUNT(DISTINCT dog_guid)
FROM reviews;
%%sql
SELECT COUNT(DISTINCT user_guid)
FROM reviews;
%%sql
SELECT COUNT(DISTINCT dog_guid)
FROM dogs;
%%sql
SELECT COUNT(DISTINCT user_guid)
FROM dogs;


# Question 5: How would you extract the user_guid, dog_guid, breed, breed_type, and breed_group for all animals who completed the "Yawn Warm-up" 
# game (you should get 20,845 rows if you join on dog_guid only)?
%%sql
SELECT d.user_guid AS UserID, d.dog_guid AS DogID, d.breed,
d.breed_type, d.breed_group
FROM dogs d, complete_tests c
WHERE d.dog_guid=c.dog_guid AND test_name='Yawn Warm-up';

# Question 6: How would you extract the user_guid, membership_type, and dog_guid of all the golden retrievers 
# who completed at least 1 Dognition test (you should get 711 rows)?
%%sql
SELECT DISTINCT d.user_guid AS UserID, u.membership_type, d.dog_guid AS
DogID, d.breed
FROM dogs d, complete_tests c, users u
WHERE d.dog_guid=c.dog_guid
AND d.user_guid=u.user_guid
AND d.breed="golden retriever";


# Question 7: How many unique Golden Retrievers who live in North Carolina are there in the Dognition database (you should get 30)?
%%sql
SELECT u.state AS state, d.breed AS breed, COUNT(DISTINCT d.dog_guid)
FROM users u, dogs d
WHERE d.user_guid=u.user_guid AND breed="Golden Retriever"
GROUP BY state
HAVING state="NC";

# Question 8:
%%sql
SELECT u.membership_type AS Membership, COUNT(DISTINCT r.user_guid)
FROM users u, reviews r
WHERE u.user_guid=r.user_guid
GROUP BY membership_type;

# Question 9:
%%sql
SELECT d.breed, COUNT(s.script_detail_id) AS activity
FROM dogs d, site_activities s
WHERE d.dog_guid=s.dog_guid AND s.script_detail_id IS NOT NULL
GROUP BY breed
ORDER BY activity DESC
LIMIT 3;












