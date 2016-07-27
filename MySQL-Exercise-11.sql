#MySQL Exercise 11 - Useful Logical Operators

%load_ext sql
%sql mysql://studentuser:studentpw@mysqlserver/dognitiondb
%sql USE dognitiondb


## Question 1: To get a feeling for what kind of values exist in the Dognition personality dimension column, write a query that will output all of the distinct values in the dimension column.  Use your relational schema or the course materials 
## to determine what table the dimension column is in.  Your output should have 11 rows
%%sql
SELECT DISTINCT dimension
FROM dogs;

## Question 2: Use the equijoin syntax (described in MySQL Exercise 8) to write a query 
## that will output the Dognition personality dimension and total number of tests completed by each unique DogID. 
# This query will be used as an inner subquery in the next question. LIMIT your output to 100 rows for troubleshooting purposes.
%%sql
SELECT d.dog_guid AS dogID, d.dimension AS dimension, count(c.created_at) AS
numtests
FROM dogs d, complete_tests c
WHERE d.dog_guid=c.dog_guid
GROUP BY dogID
LIMIT 100;

# Question 3: Re-write the query in Question 2 using traditional join syntax (described in MySQL Exercise 8).
%%sql
SELECT d.dog_guid AS dogID, d.dimension AS dimension, count(c.created_at) AS
numtests
FROM dogs d JOIN complete_tests c
ON d.dog_guid=c.dog_guid
GROUP BY dogID
LIMIT 100;

# Question 4: To start, write a query that will output the average number of tests completed by unique dogs in each Dognition personality dimension. 
# Choose either the query in Question 2 or 3 to serve as an inner query in your main query. If you have trouble, 
# make sure you use the appropriate aliases in your GROUP BY and SELECT statements.
%%sql
SELECT dimension, AVG(numtests_per_dog.numtests) AS avg_tests_completed
FROM( SELECT d.dog_guid AS dogID, d.dimension AS dimension, count(c.created_at)
AS numtests
FROM dogs d, complete_tests c
WHERE d.dog_guid=c.dog_guid
GROUP BY dogID) AS numtests_per_dog
GROUP BY numtests_per_dog.dimension;


## Question 5: How many unique DogIDs are summarized in the Dognition dimensions labeled "None" or ""? 
# (You should retrieve values of 13,705 and 71)
%%sql
SELECT dimension, COUNT(DISTINCT dogID) AS num_dogs
FROM( SELECT d.dog_guid AS dogID, d.dimension AS dimension
FROM dogs d JOIN complete_tests c
ON d.dog_guid=c.dog_guid
WHERE d.dimension IS NULL OR d.dimension=''
GROUP BY dogID) AS dogs_in_complete_tests
GROUP BY dimension


## Question 6: To determine whether there are any features that are common to all dogs that have non-NULL empty strings in the dimension column, write a query that outputs the breed, weight, value in the "exclude" column, 
# first or minimum time stamp in the complete_tests table, last or maximum time stamp in the complete_tests table, and total number of tests completed 
# by each unique DogID that has a non-NULL empty string in the dimension column.









