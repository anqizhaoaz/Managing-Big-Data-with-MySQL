
# MySQL Exercise 2: Selecting Data Subsets using WHERE
%load_ext sql
%sql mysql://studentuser:studentpw@mysqlserver/dognitiondb
%sql USE dognitiondb

# test
%%sql
SELECT user_guid, free_start_user
FROM users
WHERE free_start_user=1; 

# Question 1: How would you select the Dog IDs for the dogs in the Dognition data set 
# that were DNA tested (these should have a 1 in the dna_tested field of the dogs table)? 
%%sql
SELECT *
FROM dogs
WHERE dna_tested = 1
LIMIT 10

# Question 2: How would you query the User IDs of customers 
# who bought annual subscriptions, indicated by a "2" in the membership_type field of the users table? 
%%sql
SELECT user_guid
FROM users
WHERE membership_type = 2;


# Question 3: How would you query all the data from customers located 
# in the state of North Carolina (abbreviated "NC") or New York (abbreviated "NY")?  
# If you do not limit the output of this query, your output should contain 1333 rows.
%%sql
SELECT *
FROM users
WHERE state in ("NC", "NY")
LIMIT 20;

%%sql
SELECT *
FROM users
WHERE state = "NC"
LIMIT 20;

%%sql
SELECT *
FROM users
WHERE state like ("N%")
LIMIT 20;

# Question 4: how would you select all the Dog IDs and time stamps of Dognition tests 
# completed before October 15, 2015 (your output should have 193,246 rows)?
%%sql
SELECT dog_guid, created_at
FROM complete_tests
WHERE created_at < '2015-10-15';


# Question 5: How would you select all the User IDs of customers who do not have null values 
# in the State field of their demographic information 
# (if you do not limit the output, you should get 17,985 from this query 
# -- there are a lot of null values in the state field!)?
%%sql
SELECT user_guid
FROM users
WHERE state IS NOT NULL;

## Question 6: How would you retrieve the Dog ID, subcategory_name, and test_name fields, 
## in that order, of the first 10 reviews entered in the Reviews table to be submitted in 2014?**
%%sql
SELECT dog_guid, subcategory_name, test_name
FROM reviews
WHERE YEAR(created_at)=2014
LIMIT 10;

## Question 7: How would you select all of the User IDs of customers who have female dogs whose breed includes the word "terrier" 
## somewhere in its name (if you don't limit your output, you should have 1771 rows in your output)?
%%sql
SELECT dog_guid
FROM dogs
WHERE breed LIKE ("%terrier%") AND gender="female";


# Question 8: How would you select the Dog ID, test name, and subcategory associated 
# with each completed test for the first 100 tests entered in October, 2014?
%%sql
SELECT dog_guid, subcategory_name, test_name
FROM reviews
WHERE YEAR(created_at)=2014 and MONTH(created_at)=10
LIMIT 100;

