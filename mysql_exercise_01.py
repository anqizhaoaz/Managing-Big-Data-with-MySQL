# MySQL Exercise 1: Welcome to your first notebook!

#1. load the SQL library
%load_ext sql

#2. connect to the database you need to use
%sql mysql://studentuser:studentpw@mysqlserver/dognitiondb
%sql USE dognitiondb

#3. every time you start working with a new database: get to know your data
%sql SHOW tables

#how many coluns does the dogs table have: SHOW and DESCRIBE can show the same information
%sql SHOW columns from dogs
%sql DESCRIBE dogs
%sql DESCRIBE complete_tests
%sql DESCRIBE exam_answers
%sql DESCRIBE reviews
%sql DESCRIBE site_activities


#4. Using SELECT to look at your raw data
## in order to tell Python that you want to execute SQL language on multiple lines, 
## you must include two percent signs in front of the SQL prefix instead of one

%%sql
SELECT breed
FROM dogs;

## Using LIMIT to restrict the number of rows in your output (and prevent system crashes)
%%sql
SELECT breed
FROM dogs LIMIT 10;

## The number after the OFFSET clause indicates from which row the output will begin querying.
%%sql
SELECT breed
FROM dogs LIMIT 10 OFFSET 5;

## Using SELECT to query multiple columns
%%sql
SELECT breed, breed_type, breed_group
FROM dogs LIMIT 5,10

## using * to select all
%%sql
SELECT *
FROM dogs LIMIT 5, 10;

# adding in a column to your output that shows you the original median_iti in minutes.
%%sql
SELECT median_iti_minutes / 60
FROM dogs LIMIT 5, 10;

# question 10: How would you retrieve the first 15 rows of data from the dog_guid, subcategory_name, 
# and test_name fields of the Reviews table, in that order?
%%sql
SELECT dog_guid, subcategory_name,test_name
FROM reviews LIMIT 15;

# Question 11: How would you retrieve 10 rows of data from the activity_type, created_at, 
# and updated_at fields of the site_activities table, starting at row 50? 
%%sql
SELECT activity_type, created_at, updated_at
FROM site_activities LIMIT 10 OFFSET 49

# Question 12: How would you retrieve 20 rows of data from all the columns in the users table, 
# starting from row 2000? 
%%sql
SELECT *
FROM users LIMIT 20 OFFSET 1999


