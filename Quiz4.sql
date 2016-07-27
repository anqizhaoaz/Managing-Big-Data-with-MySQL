Database ua_dillards;

SELECT * FROM SKUINFO
#Q1. How many distinct skus have the brand “Polo fas”, and are either size “XXL” or “black” in color?
SELECT COUNT (DISTINCT sku)
FROM SKUINFO
WHERE BRAND='POLO FAS' AND (SIZE='XXL' OR COLOR='BLACK');
#13623

#Q2. There was one store in the database which had only 11 days in one of its months (in other words, that store/month/year combination only contained 11 days of transaction data). In what city and state was this store located?
SELECT s.city, s.state, t.store, extract(YEAR FROM t.saledate) "year", 
extract(MONTH FROM t.saledate) "month", COUNT(DISTINCT extract(DAY FROM t.saledate)) AS countday
FROM TRNSACT t LEFT JOIN STRINFO s
ON t.store = s.store
GROUP BY 1, 2, 3, 4, 5
ORDER BY countday;
#Atlanta, Georgia

#Q3. Which sku number had the greatest increase in total sales revenue from November to December?

SELECT c.sku, SUM(case when tmonth=11 then amt Else 0 end) AS month11, SUM(case when tmonth = 12 then amt Else 0 end) AS month12
FROM (SELECT sku, extract(MONTH FROM t.saledate) AS Tmonth, extract(DAY FROM t.saledate) AS Tday,amt 
		FROM TRNSACT t WHERE Tmonth=11 OR Tmonth=12) AS c 
GROUP BY 1
ORDER BY month12-month11 DESC;
#3949538

# Q4. What vendor has the greatest number of distinct skus in the transaction table that do not exist in the skstinfo table? (Remember that vendors are listed as distinct numbers in our data set).
SELECT b.vendor, COUNT(DISTINCT a.sku)
FROM (SELECT DISTINCT t.sku FROM TRNSACT t LEFT JOIN SKSTINFO s ON t.sku = s.sku WHERE s.sku IS NULL) AS a,  SKUINFO AS b
WHERE a.sku = b.sku
GROUP BY b.vendor
ORDER BY COUNT(DISTINCT a.sku) DESC;
#5715232 16024

# Q5. What is the brand of the sku with the greatest standard deviation in sprice? Only examine skus which have been part of over 100 transactions.
SELECT s.brand, a.sku, a.std, a.tran
FROM (SELECT sku,  STDDEV_POP(sprice) AS std, COUNT(sprice) AS tran
	FROM TRNSACT
	WHERE stype='P'
	GROUP BY sku 
	HAVING tran > 100) AS a JOIN SKUINFO AS s
ON a.sku = s.sku
ORDER BY a.std DESC
#HART SCH



# Q6. What is the city and state of the store which had the greatest increase in average daily revenue (as I define it in Teradata Week 5 Exercise Guide) from November to December?
SELECT c.store, c.city, c.state, SUM(case when tmonth=11 then amt Else 0 end)/COUNT(DISTINCT Tday) AS month11, SUM(case when tmonth = 12 then amt Else 0 end)/COUNT(DISTINCT Tday) AS month12
FROM (SELECT t.store, s.city, s.state, extract(MONTH FROM t.saledate) AS Tmonth, extract(DAY FROM t.saledate) AS Tday, amt
	FROM trnsact t JOIN strinfo s 
	ON t.store=s.store
	WHERE Tmonth=11 OR Tmonth=12) AS c
GROUP BY 1,2,3
ORDER BY month12-month11 DESC;
# Metairie, LA


# Q7. Compare the average daily revenue (as I define it in Teradata Week 5 Exercise Guide) of the store with the highest msa_income and the store with the lowest median msa_income (according to the msa_income field). 
# In what city and state were these two stores, and which store had a higher average daily revenue?

SSELECT state, city, store, msa_income
FROM STORE_MSA
WHERE store=2707 or store =3902
#lowest income store 2707 and highest income 3902
#AL SPANISH FORT 3902, 56099
#TX MCALLEN 2707, 16022

#Q8. Which of these groups has the highest average daily revenue (as I define it in Teradata Week 5 Exercise Guide) per store
SELECT (CASE 
	WHEN msa_income<=20000 AND msa_income>1 THEN "low"
	WHEN msa_income=<30000 AND msa_income>20001 THEN "med-low"
	WHEN msa_income=<40000 AND msa_income>30001 THEN "med-high"
	WHEN msa_income=<60000 AND msa_income>40001 THEN "high"
	END) AS income_group, SUM(t.amt)/COUNT(DISTINCT extract(DAY FROM t.saledate)) AS adrevenue
FROM STORE_MSA AS s, TRNSACT AS t 
WHERE s.store = t.store
GROUP BY 1
ORDER BY adrevenue


SELECT (CASE WHEN s.msa_income BETWEEN 1 AND 20000 THEN "low" 
	WHEN s.msa_income BETWEEN 20001 AND 30000 THEN "med-low" 
	WHEN s.msa_income BETWEEN 30001 AND 40000 THEN "med-high" 
	WHEN s.msa_income BETWEEN 40001 AND 60000 THEN "high"
	END) AS s.igroup, SUM(t.amt)/COUNT(DISTINCT extract(DAY FROM t.saledate)) AS t.adrevenue
FROM STORE_MSA s JOIN TRNSACT t
ON s.store = t.store
GROUP BY 1

# not high, not med-high
#Try again! Make sure you are excluding the appropriate data, and calculating average daily revenue by summing together all the revenue associated with an income group, and then dividing that summed total by the total number of sales days that contributed to that particular summed revenue total. Do not compute averages of averages.


# Q10. Which department in which store had the greatest percent increase in average daily sales revenue from November to December, and what city and state was that store located in? Only examine departments whose total sales were at least $1,000 in both November and December.
SELECT s.store, s.city, s.state, d.deptdesc, sum(case when extract(month from saledate)=11 then amt end) as November,
COUNT(DISTINCT (case WHEN EXTRACT(MONTH from saledate) ='11' then saledate END)) as Nov_numdays, sum(case when extract(month from saledate)=12 then amt end) as December,
COUNT(DISTINCT (case WHEN EXTRACT(MONTH from saledate) ='12' then saledate END)) as Dec_numdays, ((December/Dec_numdays)-(November/Nov_numdays))/(November/Nov_numdays)*100 AS bump
FROM trnsact t JOIN strinfo s
ON t.store=s.store JOIN skuinfo si
ON t.sku=si.sku JOIN deptinfo d
ON si.dept=d.dept
WHERE t.stype='P' and t.store||EXTRACT(YEAR from t.saledate)||EXTRACT(MONTH from t.saledate) IN (SELECT store||EXTRACT(YEAR from saledate)||EXTRACT(MONTH from saledate)
	FROM trnsact
	GROUP BY store, EXTRACT(YEAR from saledate), EXTRACT(MONTH from saledate)
	HAVING COUNT(DISTINCT saledate)>= 20)
GROUP BY s.store, s.city, s.state, d.deptdesc HAVING November > 1000 AND December > 1000
ORDER BY bump DESC;


#Q11. Which department within a particular store had the greatest decrease in average daily sales revenue from August to September, 
# and in what city and state was that store located?
SELECT s.store, s.city, s.state, d.deptdesc, sum(case when extract(month from saledate)=8 then amt end) as August,
COUNT(DISTINCT (case WHEN EXTRACT(MONTH from saledate) ='8' then saledate END)) as Aug_numdays, sum(case when extract(month from saledate)=9 then amt end) as September,
COUNT(DISTINCT (case WHEN EXTRACT(MONTH from saledate) ='9' then saledate END)) as Sep_numdays, ((September/Sep_numdays)-(August/Aug_numdays))/(August/Aug_numdays)*100 AS bump
FROM trnsact t JOIN strinfo s
ON t.store=s.store JOIN skuinfo si
ON t.sku=si.sku JOIN deptinfo d
ON si.dept=d.dept
WHERE t.stype='P' and t.store||EXTRACT(YEAR from t.saledate)||EXTRACT(MONTH from t.saledate) IN (SELECT store||EXTRACT(YEAR from saledate)||EXTRACT(MONTH from saledate)
	FROM trnsact
	GROUP BY store, EXTRACT(YEAR from saledate), EXTRACT(MONTH from saledate)
	HAVING COUNT(DISTINCT saledate)>= 20)
GROUP BY s.store, s.city, s.state, d.deptdesc
ORDER BY bump ASC;


# Q12
SELECT s.city, s.state, d.deptdesc, t.store, CASE when extract(year from t.saledate) = 2005 AND extract(month from t.saledate) = 8 then 'exclude' END as exclude_flag,
SUM(case WHEN EXTRACT(MONTH from saledate) =’8’ then t.quantity END) as August,
SUM(case WHEN EXTRACT(MONTH from saledate) =’9’ then t.quantity END) as September, August-September AS dip
FROM trnsact t JOIN strinfo s
ON t.store=s.store JOIN skuinfo si
ON t.sku=si.sku JOIN deptinfo d
ON si.dept=d.dept WHERE t.stype='P' AND exclude_flag IS NULL AND t.store||EXTRACT(YEAR from t.saledate)||EXTRACT(MONTH from t.saledate) IN (SELECT store||EXTRACT(YEAR from saledate)||EXTRACT(MONTH from saledate)
	FROM trnsact
	GROUP BY store, EXTRACT(YEAR from saledate), EXTRACT(MONTH from saledate) 
	HAVING COUNT(DISTINCT saledate)>= 20)
GROUP BY s.city, s.state, d.deptdesc, t.store, exclude_flag
ORDER BY dip DESC; 


# Q13. For each store, determine the month with the minimum average daily revenue
# For each of the twelve months of the year, count how many stores' minimum average daily revenue was in that month. During which month(s) did over 100 stores have their minimum average daily revenue?

SELECT CASE when max_month_table.month_num = 1 then 'January' when max_month_table.month_num = 2 then 'February' when max_month_table.month_num = 3 then 'March' when max_month_table.month_num = 4 then 'April' when max_month_table.month_num = 5 then 'May' when max_month_table.month_num = 6 then 'June' when max_month_table.month_num = 7 then 'July' when max_month_table.month_num = 8 then 'August' when max_month_table.month_num = 9 then 'September' when max_month_table.month_num = 10 then 'October' when max_month_table.month_num = 11 then 'November' when max_month_table.month_num = 12 then 'December' END, COUNT(*)
FROM (SELECT DISTINCT extract(year from saledate) as year_num, extract(month from saledate) as month_num, CASE when extract(year from saledate) = 2005 AND extract(month from saledate) = 8 then 'exclude' END as exclude_flag, store, SUM(amt) AS tot_sales, COUNT (DISTINCT saledate) as numdays, tot_sales/numdays as dailyrev, ROW_NUMBER () over (PARTITION BY store ORDER BY dailyrev DESC) AS month_rank
	FROM trnsact
	WHERE stype='P' AND exclude_flag IS NULL AND store||EXTRACT(YEAR from saledate)||EXTRACT(MONTH from saledate) IN (SELECT store||EXTRACT(YEAR from saledate)||EXTRACT(MONTH from saledate)
		FROM trnsact
		GROUP BY store, EXTRACT(YEAR from saledate), EXTRACT(MONTH from saledate)
		HAVING COUNT(DISTINCT saledate)>= 20)
	GROUP BY store, month_num, year_num
	HAVING numdays>=20 QUALIFY month_rank=12) as max_month_table
GROUP BY max_month_table.month_num
ORDER BY max_month_table.month_num;




# Q14. Write a query that determines the month in which each store had its maximum number of sku units returned. 
# During which month did the greatest number of stores have their maximum number of sku units returned?


