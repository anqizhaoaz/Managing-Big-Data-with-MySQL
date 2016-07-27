#MySQL Exercise 10 - Useful Logical Operators

%load_ext sql
%sql mysql://studentuser:studentpw@mysqlserver/dognitiondb
%sql USE dognitiondb

# Q1: Question 1: Write a query that will output distinct user_guids and their associated country of residence 
# from the users table, excluding any user_guids that have NULL values. You should get 16,261 rows in your result.
%%sql
SELECT DISTINCT user_guid, country
FROM users
WHERE user_guid IS NOT NULL AND country IS NOT NULL
GROUP BY user_guid, country;

# Question 2: Use an IF expression and the query you wrote in Question 1 as a subquery to determine the number of 
# unique user_guids who reside in the United States (abbreviated "US") and outside of the US.
%%sql
SELECT IF(cleaned_users.country='US','In US','Outside US') AS US_user,
count(cleaned_users.user_guid)
FROM (SELECT DISTINCT user_guid, country
FROM users
WHERE country IS NOT NULL) AS cleaned_users
GROUP BY US_user;

# Question 3: Write a query using a CASE statement that outputs 3 columns: dog_guid, dog_fixed, and a third column that reads "neutered" every time there is a 1 
# in the "dog_fixed" column of dogs, "not neutered" every time there is a value of 0 in the "dog_fixed" column of dogs, and "NULL" every time 
# there is a value of anything else in the "dog_fixed" column. Limit your results for troubleshooting purposes.
%%sql
SELECT dog_guid, dog_fixed,
CASE dog_fixed
WHEN "1" THEN "neutered"
WHEN "0" THEN "not neutered"
END AS neutered
FROM dogs
LIMIT 200;

# Question 4: We learned that NULL values should be treated the same as "0" values in the exclude columns of the dogs and users tables. Write a query using a CASE statement that outputs 3 columns: dog_guid, exclude, and a third column that reads "exclude" every time there is a 1 in the "exclude" column of dogs and "keep" every time there is 
# any other value in the exclude column. Limit your results for troubleshooting purposes.
%%sql
SELECT dog_guid, exclude,
CASE exclude
WHEN "1" THEN "exclude"
ELSE "keep"
END AS exclude_cleaned
FROM dogs
LIMIT 200;


# Question 5: Re-write your query from Question 4 using an IF statement instead of a CASE statement.
%%sql
SELECT IF(exclude="1", 'exclude', 'keep') AS exclude_cleaned, dog_guid, exclude
FROM dogs
LIMIT 200;


# Question 6: Write a query that uses a CASE expression to output 3 columns: dog_guid, weight, and a third column that reads...
#"very small" when a dog's weight is 1-10 pounds
#"small" when a dog's weight is greater than 10 pounds to 30 pounds
#"medium" when a dog's weight is greater than 30 pounds to 50 pounds
#"large" when a dog's weight is greater than 50 pounds to 85 pounds
#"very large" when a dog's weight is greater than 85 pounds
#Limit your results for troubleshooting purposes.

%%sql SELECT
dog_guid, weight,
CASE
WHEN weight<=10 THEN "very small"
WHEN weight>10 AND weight<=30 THEN "small"
WHEN weight>30 AND weight<=50 THEN "medium"
WHEN weight>50 AND weight<=85 THEN "large"
WHEN weight>85 THEN "very large"
END AS weight_grouped
FROM dogs
LIMIT 200;


# Question 7: How many distinct dog_guids are found in group 1 using this query?
%%sql
SELECT COUNT(DISTINCT dog_guid), 
CASE WHEN breed_group='Sporting' OR breed_group='Herding' AND exclude!='1' THEN "group 1"
     ELSE "everything else"
     END AS groups
FROM dogs
GROUP BY groups


# Question 8: How many distinct dog_guids are found in group 1 using this query?
%%sql
SELECT COUNT(DISTINCT dog_guid), 
CASE WHEN exclude!='1' AND breed_group='Sporting' OR breed_group='Herding' THEN "group 1"
     ELSE "everything else"
     END AS group_name
FROM dogs
GROUP BY group_name


# Question 9: How many distinct dog_guids are found in group 1 using this query?
%%sql
SELECT COUNT(DISTINCT dog_guid), 
CASE WHEN exclude!='1' AND (breed_group='Sporting' OR breed_group='Herding') THEN "group 1"
     ELSE "everything else"
     END AS group_name
FROM dogs
GROUP BY group_name


# Question 10: For each dog_guid, output its dog_guid, breed_type, number of completed tests, 
# and use an IF statement to include an extra column that reads "Pure_Breed" whenever breed_type equals 'Pure Breed" and "Not_Pure_Breed" whenever breed_type equals anything else. LIMIT your output to 50 rows for troubleshooting. HINT: you will need to use a join to complete this query.
%%sql
SELECT d.dog_guid AS dogID, d.breed_type AS breed_type, count(c.created_at) AS
numtests,
IF(d.breed_type='Pure Breed','pure_breed', 'not_pure_breed') AS pure_breed
FROM dogs d, complete_tests c
WHERE d.dog_guid=c.dog_guid
GROUP BY dogID
LIMIT 50;


# Question 11: Write a query that uses a CASE statement to report the number of unique user_guids associated with customers who live in the United States and who are in the following groups of states:
# Group 1: New York (abbreviated "NY") or New Jersey (abbreviated "NJ")
# Group 2: North Carolina (abbreviated "NC") or South Carolina (abbreviated "SC")
# Group 3: California (abbreviated "CA")
# Group 4: All other states with non-null values
# You should find 898 unique user_guids in Group1.
%%sql
SELECT COUNT(DISTINCT user_guid),
CASE
WHEN (state="NY" OR state="NJ") THEN "Group 1-NY/NJ"
WHEN (state="NC" OR state="SC") THEN "Group 2-NC/SC"
WHEN state="CA" THEN "Group 3-CA"
ELSE "Group 4-Other"
END AS state_group
FROM users
WHERE country="US" AND state IS NOT NULL
GROUP BY state_group;


# Question 12: Write a query that allows you to determine how many unique dog_guids are associated with dogs who are DNA tested and have either stargazer or socialite personality dimensions. Your answer should be 70.
%%sql
SELECT COUNT(DISTINCT user_guid)
FROM dogs 
WHERE dna_tested=1 AND (dimension='stargazer' OR dimension='socialite')




