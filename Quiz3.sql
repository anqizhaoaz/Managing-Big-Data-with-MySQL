

Database ua_dillards;

# Q2: On what day was Dillard’s income based on total sum of purchases the greatest
SELECT saledate, SUM(amt)
FROM trnsact
GROUP BY saledate
ORDER BY SUM(amt) DESC;


# Q3: What is the deptdesc of the departments that have the top 3 greatest numbers of skus from the skuinfo table associated with them?
SELECT d.deptdesc, COUNT(DISTINCT s.sku)
FROM skuinfo s LEFT JOIN deptinfo d
ON s.dept = d.dept
GROUP BY d.deptdesc
ORDER BY COUNT(DISTINCT s.sku) DESC


# Q4: Which table contains the most distinct sku numbers?
SELECT COUNT(DISTINCT sku)
FROM skuinfo
#1564178
SELECT COUNT(DISTINCT sku)
FROM trnsact
#714499
SELECT COUNT(DISTINCT sku)
FROM skstinfo
#760212

# Q5: How many skus are in the skstinfo table, but NOT in the skuinfo table?
SELECT COUNT(DISTINCT a.sku)
FROM skstinfo a LEFT JOIN skuinfo b
ON a.sku = b.sku
WHERE b.sku IS NULL;

# Q6: What is the average amount of profit Dillard’s made per day?
SELECT SUM(amt-(cost*quantity))/ COUNT(DISTINCT saledate) AS avg_sales
FROM trnsact t JOIN skstinfo si
ON t.sku=si.sku AND t.store=si.store
WHERE stype='P';

# Q7:  how many MSAs are there within the state of North Carolina (abbreviated “NC”), 
# and within these MSAs, what is the lowest population level (msa_pop) and highest income level (msa_income)?
SELECT s.state, m.msa, m.msa_pop, m.msa_income
FROM STORE_MSA m JOIN STRINFO s
ON m.store = s.store
WHERE s.state = 'NC'
ORDER BY m.msa_pop DESC


# Q8 What department (with department description), brand, style, and color brought in the greatest total amount of sales?
SELECT AVG(d.dept), s.style, s.color, s.brand, d.deptdesc, SUM(amt) AS tot_sales
FROM skuinfo s JOIN trnsact t ON s.sku=t.sku JOIN deptinfo d ON s.dept=d.dept
GROUP BY d.deptdesc, s.style, s.color, s.brand
ORDER BY tot_sales DESC

# Q9 How many stores have more than 180,000 distinct skus associated with them in the skstinfo table?
SELECT store, COUNT(DISTINCT sku)
FROM skstinfo
GROUP BY store
HAVING COUNT(DISTINCT sku)> 180000

# Q10 size and style
 SELECT DISTINCT s.sku, s.dept, s.style, s.color, s.size, s.vendor, s.brand, s.packsize, d.deptdesc, st.retail, st.cost
FROM skuinfo s JOIN deptinfo d
ON s.dept= d.dept JOIN skstinfo st
ON s.sku=st.sku
WHERE d.deptdesc='cop' AND s.brand='federal' AND s.color='rinse wash';

# Q11 How many skus are in the skuinfo table, but NOT in the skstinfo table?
SELECT COUNT(DISTINCT a.sku)
FROM skuinfo a LEFT JOIN skstinfo b
ON a.sku=b.sku
WHERE b.sku IS NULL
#803966

# Q12 In what city and state is the store that had the greatest total sum of sales?
SELECT t.store, s.city, s.state, SUM(amt) AS tot_sales
FROM trnsact t JOIN strinfo s 
ON t.store=s.store
GROUP BY 1, 2, 3
ORDER BY tot_sales DESC


# Q14: How many states have more than 10 Dillards stores in them?
SELECT COUNT(state)
FROM strinfo
GROUP BY state
HAVING COUNT(DISTINCT store) >10
#15

# Q15: What is the suggested retail price of all the skus in the “reebok” department with the “skechers” brand and a “wht/saphire” color?
SELECT DISTINCT s.sku, s.dept, s.color, d.deptdesc, st.retail
FROM skuinfo s JOIN deptinfo d
ON s.dept= d.dept JOIN skstinfo st
ON s.sku=st.sku
WHERE d.deptdesc='reebok' AND s.brand='skechers' AND s.color='wht/saphire';






