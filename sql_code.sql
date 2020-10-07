USE	db_consumer_panel;

SELECT count(*) FROM dta_at_hh;
SELECT count(*) FROM dta_at_prod_id;
SELECT count(*) FROM dta_at_tc;
SELECT count(*) FROM dta_at_TC_upc;

# dta_at_hh: 39577
# dta_at_TC: 7596145
# dta_at_prod_id: 4231283
# dta_at_TC_upc: 38587942

-- a (1) How many store shopping trips are recorded in db?
SELECT COUNT(TC_id) FROM dta_at_TC;  #7596145

-- a (2) How many Households appear in db?
SELECT COUNT(hh_id) FROM dta_at_hh;  #39577

-- a(3) How many stores od different retailers appear in db?
SELECT COUNT(DISTINCT TC_retailer_code_store_code)
FROM dta_at_TC;    #26402

-- a(4) How many Products?
SELECT COUNT(prod_id)
FROM dta_at_prod_id;  #4231283

-- a(4.1) How many Categories of product?
SELECT COUNT(DISTINCT group_at_prod_id)
FROM dta_at_prod_id;    #118

-- a(4.1) How many modules of product?
SELECT COUNT(DISTINCT module_at_prod_id)
FROM dta_at_prod_id;  #1224

-- a(4.2)1. plot products per deparment
DROP TABLE IF EXISTS product_per_department;
CREATE TEMPORARY TABLE prodct_per_department
SELECT T1.department_at_prod_id AS Department, COUNT(T1.prod_id) AS Count FROM 
	(SELECT DISTINCT prod_id, department_at_prod_id FROM dta_at_prod_id) AS T1 
GROUP BY T1.department_at_prod_id;
SELECT * FROM prodct_per_department;

-- a(4.2)2.plot products per deparment
DROP TABLE IF EXISTS module_per_department;
CREATE TEMPORARY TABLE module_per_department
SELECT T2.department_at_prod_id AS Department, COUNT(T2.module_at_prod_id) AS Count FROM 
	(SELECT DISTINCT module_at_prod_id, department_at_prod_id FROM dta_at_prod_id) AS T2 
GROUP BY T2.department_at_prod_id;
SELECT * FROM module_per_department;

-- a(5) Total transactions
SELECT COUNT(deal_flag_TC_prod_id) FROM dta_at_TC_upc;  #38587942
-- Transactions realized under some kind of promotion
SELECT COUNT(deal_flag_at_TC_prod_id) 
FROM dta_at_TC_upc
WHERE deal_flag_at_TC_prod_id = 1;  #11384077




-- b.1
SELECT COUNT(DISTINCT hh_id) FROM
	(SELECT hh_id, hh_id_2, TC_date, TC_date_2, DATEDIFF(A.TC_date, B.TC_date_2) AS TIME_GAP, A.ID FROM 
		(SELECT hh_id, DATE_FORMAT(TC_date, '%Y-%m-01') as TC_date, 
        ROW_NUMBER() OVER (ORDER BY hh_id, TC_date) AS ID FROM dta_at_TC 
        ORDER BY hh_id, TC_date)AS A
INNER JOIN
	(SELECT hh_id as hh_id_2, DATE_FORMAT(TC_date, '%Y-%m-01') as TC_date_2, 
	1 + ROW_NUMBER() OVER (ORDER BY hh_id, TC_date) AS ID_2 FROM dta_at_TC ORDER BY hh_id, TC_date)AS B
ON A.ID = B.ID_2
WHERE hh_id = hh_id_2 and DATEDIFF(A.TC_date, B.TC_date_2) > 92) AS C;
-- return 6   rows >92


-- b.2
SELECT DISTINCT hh_id FROM
	(SELECT hh_id, hh_id_2, TC_date, TC_date_2, DATEDIFF(A.TC_date, B.TC_date_2) AS TIME_GAP, A.ID FROM 
		(SELECT hh_id, DATE_FORMAT(TC_date, '%Y-%m') AS TC_date, 
        ROW_NUMBER() OVER (ORDER BY hh_id, TC_date) AS ID FROM dta_at_TC ORDER BY hh_id, TC_date)AS A
INNER JOIN
	(SELECT hh_id as hh_id_2, DATE_FORMAT(TC_date, '%Y-%m') AS TC_date_2, 
    1 + ROW_NUMBER() OVER (ORDER BY hh_id, TC_date) AS ID_2 FROM dta_at_TC ORDER BY hh_id, TC_date)AS B
ON A.ID = B.ID_2
WHERE hh_id = hh_id_2 and DATEDIFF(A.TC_date, B.TC_date_2) >= 50) AS F;  #2366
# which means the number of households that at least go shoppping once a month is: 39577-2366=37211

-- first large and sum
CREATE TEMPORARY TABLE one_larger_than_80
SELECT D.hh_id, sum_hh, sum_first, TC_retailer_code FROM
	(SELECT hh_id , SUM(TC_total_spent) AS sum_hh FROM dta_at_tc WHERE hh_id NOT IN
		(SELECT DISTINCT hh_id FROM
			(SELECT hh_id, hh_id_2, TC_date, TC_date_2, DATEDIFF(A.TC_date, B.TC_date_2) AS TIME_GAP, A.ID FROM 
				(SELECT hh_id, DATE_FORMAT(TC_date, '%Y-%m') AS TC_date, ROW_NUMBER() OVER (ORDER BY hh_id, TC_date) AS ID FROM dta_at_TC ORDER BY hh_id, TC_date)AS A
	INNER JOIN
		(SELECT hh_id as hh_id_2, DATE_FORMAT(TC_date, '%Y-%m') AS TC_date_2, 
		1 + ROW_NUMBER() OVER (ORDER BY hh_id, TC_date) AS ID_2 FROM dta_at_TC ORDER BY hh_id, TC_date)AS B
	ON A.ID = B.ID_2
	WHERE hh_id = hh_id_2 AND DATEDIFF(A.TC_date, B.TC_date_2) >= 50) AS C) 
	GROUP BY hh_id ) AS D
INNER JOIN
	(SELECT hh_id , TC_retailer_code, MAX(sum_hh_retailer) AS sum_first FROM
		(SELECT hh_id , TC_retailer_code, SUM(TC_total_spent) AS sum_hh_retailer FROM dta_at_tc WHERE hh_id NOT IN
			(SELECT DISTINCT hh_id FROM 
				(SELECT hh_id, DATE_FORMAT(TC_date, '%Y-%m') AS TC_date, 
                ROW_NUMBER() OVER (ORDER BY hh_id, TC_date) AS ID FROM dta_at_TC ORDER BY hh_id, TC_date)AS A1
	INNER JOIN
		(SELECT hh_id AS hh_id_2, DATE_FORMAT(TC_date, '%Y-%m') AS TC_date_2, 1 + ROW_NUMBER() OVER (ORDER BY hh_id, TC_date) AS ID_2 FROM dta_at_TC ORDER BY hh_id, TC_date)AS B1
	ON A1.ID = B1.ID_2
	WHERE hh_id = hh_id_2 AND DATEDIFF(A1.TC_date, B1.TC_date_2) >= 50) GROUP BY hh_id, TC_retailer_code) AS C1 GROUP BY hh_id ) AS D1
ON D.hh_id = D1.hh_id
WHERE sum_first / sum_hh > 0.8;   #124


-- first and second large and sum
CREATE TEMPORARY TABLE two_larger_than_80
SELECT T1.hh_id, sum_hh, sum_two FROM
	(SELECT hh_id , SUM(TC_total_spent) AS sum_hh FROM dta_at_tc WHERE hh_id NOT IN
		(SELECT DISTINCT hh_id FROM
			(SELECT hh_id, hh_id_2, TC_date, TC_date_2, DATEDIFF(A.TC_date, B.TC_date_2) AS TIME_GAP, A.ID FROM 
				(SELECT hh_id, DATE_FORMAT(TC_date, '%Y-%m') AS TC_date, 
                ROW_NUMBER() OVER (ORDER BY hh_id, TC_date) AS ID FROM dta_at_TC 
                ORDER BY hh_id, TC_date)AS A
	INNER JOIN
		(SELECT hh_id as hh_id_2, DATE_FORMAT(TC_date, '%Y-%m') AS TC_date_2, 
		1 + ROW_NUMBER() OVER (ORDER BY hh_id, TC_date) AS ID_2 FROM dta_at_TC ORDER BY hh_id, TC_date)AS B
	ON A.ID = B.ID_2
	WHERE hh_id = hh_id_2 AND DATEDIFF(A.TC_date, B.TC_date_2) >= 50) AS C) 
	GROUP BY hh_id ) AS T1
INNER JOIN
	(SELECT hh_id, SUM(sum_hh_retailer) AS sum_two FROM
		(SELECT hh_id, TC_retailer_code, sum_hh_retailer, 
        ROW_NUMBER() OVER (ORDER BY hh_id, sum_hh_retailer) AS id3 FROM
			(SELECT hh_id, TC_retailer_code, SUM(TC_total_spent) AS sum_hh_retailer FROM dta_at_tc WHERE hh_id NOT IN
				(SELECT DISTINCT hh_id FROM 
					(SELECT hh_id, DATE_FORMAT(TC_date, '%Y-%m') AS TC_date, 
                    ROW_NUMBER() OVER (ORDER BY hh_id, TC_date) AS ID FROM dta_at_TC 
                    ORDER BY hh_id, TC_date)AS A1
	INNER JOIN
		(SELECT hh_id , DATE_FORMAT(TC_date, '%Y-%m') AS TC_date_2, 
        1 + ROW_NUMBER() OVER (ORDER BY hh_id, TC_date) AS ID_2 FROM dta_at_TC 
        ORDER BY hh_id, TC_date)AS B1
	ON A1.hh_ID = B1.hh_ID
	WHERE hh_id = hh_id_2 AND DATEDIFF(A1.TC_date, B1.TC_date_2) >= 50) 
	GROUP BY hh_id, TC_retailer_code) AS C1 WHERE id3=1 OR 2) AS D1 GROUP BY hh_id )AS T2
ON T1.hh_id=T2.hh_id
WHERE sum_two / sum_hh > 0.8;   #165


-- b 2i 
SELECT COUNT(dta_at_hh.hh_id) AS hh1, hh_income FROM
	(SELECT hh_id FROM one_larger_than_80)
INNER JOIN
	(SELECT hh_id, hh_income FROM dta_at_hh)
ON one_larger_than_80.hh_id = dta_at_hh.hh_id
GROUP BY hh_income;

SELECT COUNT(dta_at_hh.hh_id) AS hh2, hh_income FROM
	(SELECT hh_id FROM two_larger_than_80)
INNER JOIN
	(SELECT hh_id, hh_income FROM dta_at_hh)
ON one_larger_than_80.hh_id = dta_at_hh.hh_id
GROUP BY hh_income;

-- b 2ii
SELECT COUNT(hh_id) AS number_of_households, TC_retailer_code FROM one_larger_than_80
GROUP BY TC_retailer_code
ORDER BY number_of_households LIMIT 5;

-- b 2iii
SELECT COUNT(dta_at_hh.hh_id)/124 AS portion, hh_state FROM
	(SELECT hh_id FROM one_larger_than_80)
INNER JOIN
	(SELECT hh_id, hh_state FROM dta_at_hh)
ON one_larger_than_80.hh_id = dta_at_hh.hh_id
GROUP BY hh_state;



-- b.3.i Average number of items purchased on a given month.
SELECT TC_date, AVG(prod_number) FROM
	(SELECT hh_id, TC_date, SUM(quantity_at_TC_prod_id) AS prod_number FROM
		(SELECT TC_id, quantity_at_TC_prod_id FROM dta_at_TC_upc) AS A
	INNER JOIN
		(SELECT TC_id, hh_id, DATE_FORMAT(TC_date, '%Y-%m') as TC_date FROM dta_at_TC) AS B
	ON A.TC_id = B.TC_id
	GROUP BY hh_id, TC_date) AS II
GROUP BY TC_date
ORDER BY TC_date;


-- b.3.ii Average number of shopping trips per month.
SELECT TC_date, AVG(TC_number) FROM
	(SELECT DATE_FORMAT(TC_date, '%Y-%m'), hh_id, COUNT(TC_id) AS TC_number FROM dta_at_TC 
	GROUP BY TC_date, hh_id) as c
GROUP BY TC_date
ORDER BY TC_date;


-- b.3.iii Average number of days between 2 consecutive shopping trips.
SELECT hh_id, AVG(TIME_GAP), ROW_NUMBER() OVER (ORDER BY hh_id, AVG(TIME_GAP)) AS ID FROM
	(SELECT hh_id, hh_id_2, DATEDIFF(A.TC_date, B.TC_date_2) AS TIME_GAP FROM 
		(SELECT hh_id, DATE_FORMAT(TC_date, '%Y-%m-01') as TC_date, 
		ROW_NUMBER() OVER (ORDER BY hh_id, TC_date) AS ID FROM dta_at_TC ORDER BY hh_id, TC_date)AS A
	INNER JOIN
		(SELECT hh_id as hh_id_2, DATE_FORMAT(TC_date, '%Y-%m-01') as TC_date_2, 
		1 + ROW_NUMBER() OVER (ORDER BY hh_id, TC_date) AS ID_2 FROM dta_at_TC ORDER BY hh_id, TC_date)AS B
	ON A.ID = B.ID_2
	WHERE hh_id = hh_id_2) as b
GROUP BY hh_id;


-- C.1 write by R

-- C.2
SELECT T1.AvgPrice, T2.NumOfItem FROM
	(SELECT AVG(total_price_paid_at_TC_prod_id) AS AvgPrice, TC_id
	FROM dta_at_TC_upc
	GROUP BY TC_id) AS T1
INNER JOIN
	(SELECT SUM(quantity_at_TC_prod_id) AS NumOfItem, TC_id
	FROM dta_at_TC_upc
	GROUP BY TC_id) AS T2
ON T1.TC_id = T2.TC_id;


-- C.3.i
SELECT A.total, B.private, A.department_at_prod_id, (B.private/A.total) AS percentage FROM
	(SELECT COUNT(prod_id) AS total, department_at_prod_id FROM dta_at_prod_id
	GROUP BY department_at_prod_id) AS A
INNER JOIN
	(SELECT COUNT(prod_id) AS private, department_at_prod_id FROM dta_at_prod_id 
	WHERE brand_at_prod_id REGEXP "CTL BR" GROUP BY department_at_prod_id) AS B
ON A.department_at_prod_id = B.department_at_prod_id;


-- C.3.ii
SELECT D1.TC_date, private_label, total, private_label/total FROM
	(SELECT TC_date, SUM(total_price_paid_at_TC_prod_id) AS private_label FROM
		(SELECT TC_date, total_price_paid_at_TC_prod_id, prod_id FROM
			(SELECT DATE_FORMAT(TC_date, '%Y-%m') as TC_date, TC_id FROM dta_at_TC) AS A1
		INNER JOIN
			(SELECT TC_id, total_price_paid_at_TC_prod_id, prod_id FROM dta_at_TC_upc) AS B1
		ON A1.TC_id = B1.TC_id) AS C1
	INNER JOIN
		(SELECT prod_id FROM dta_at_prod_id WHERE brand_at_prod_id REGEXP "CTL BR") AS C2
	ON C1.prod_id = C2.prod_id
	GROUP BY TC_date) AS D1
INNER JOIN
	(SELECT TC_date, SUM(total_price_paid_at_TC_prod_id) AS total FROM
		(SELECT DATE_FORMAT(TC_date, '%Y-%m') as TC_date, TC_id FROM dta_at_TC) AS A
	INNER JOIN
		(SELECT TC_id, total_price_paid_at_TC_prod_id, prod_id FROM dta_at_TC_upc) AS B
	ON A.TC_id = B.TC_id
	GROUP BY TC_date) AS D2
ON D1.TC_date = D2.TC_date
ORDER BY TC_date;


-- c.3.iii
-- HIGH
SELECT AVG(total_high), AVG(private_high), AVG(private_high)/AVG(total_high) AS percentage FROM
	(SELECT Y1.TC_date, total_high, private_high, (private_high/total_high) AS percentage FROM
		(SELECT TC_date, SUM(total_price_paid_at_TC_prod_id) AS total_high FROM
			(SELECT A1.hh_id, TC_date, TC_id FROM
				(SELECT hh_id, hh_income AS high_income FROM dta_at_hh WHERE hh_income BETWEEN 21 AND 27) AS A1
		INNER JOIN
			(SELECT hh_id, DATE_FORMAT(TC_date, '%Y-%m') AS TC_date, TC_id FROM dta_at_TC) AS A2
		ON A1.hh_id = A2.hh_id) AS B1
	INNER JOIN
		(SELECT TC_id, total_price_paid_at_TC_prod_id FROM dta_at_TC_upc) AS B2
	ON B1.TC_id = B2.TC_id
	GROUP BY TC_date) AS Y1
INNER JOIN
	(SELECT TC_date, SUM(total_price_paid_at_TC_prod_id) AS private_high FROM
		(SELECT AA1.hh_id, TC_date, TC_id FROM
			(SELECT hh_id, hh_income AS high_income FROM dta_at_hh WHERE hh_income BETWEEN 21 AND 27) AS AA1
		INNER JOIN
			(SELECT hh_id, DATE_FORMAT(TC_date, '%Y-%m') AS TC_date, TC_id FROM dta_at_TC) AS AA2
		ON AA1.hh_id = AA2.hh_id) AS BB1
	INNER JOIN
		(SELECT TC_id, total_price_paid_at_TC_prod_id FROM
			(SELECT TC_id, prod_id, total_price_paid_at_TC_prod_id FROM dta_at_TC_upc) AS W2
		INNER JOIN
			(SELECT prod_id FROM dta_at_prod_id WHERE brand_at_prod_id REGEXP "CTL BR") AS W1
		ON W1.prod_id = W2.prod_id) AS BB2
	ON BB1.TC_id = BB2.TC_id
	GROUP BY TC_date) AS Y2
ON Y1.TC_date = Y2.TC_date) AS F1;


-- MEDIUM
SELECT AVG(total_medium), AVG(private_medium), AVG(private_medium)/AVG(total_medium) AS percentage FROM
	(SELECT Y1.TC_date, total_medium, private_medium, (private_medium/total_medium) AS percentage FROM
		(SELECT TC_date, SUM(total_price_paid_at_TC_prod_id) AS total_medium FROM
			(SELECT A1.hh_id, TC_date, TC_id FROM
				(SELECT hh_id, hh_income AS medium_income FROM dta_at_hh WHERE hh_income BETWEEN 13 AND 19) AS A1
		INNER JOIN
			(SELECT hh_id, DATE_FORMAT(TC_date, '%Y-%m') AS TC_date, TC_id FROM dta_at_TC) AS A2
		ON A1.hh_id = A2.hh_id) AS B1
	INNER JOIN
		(SELECT TC_id, total_price_paid_at_TC_prod_id FROM dta_at_TC_upc) AS B2
	ON B1.TC_id = B2.TC_id
	GROUP BY TC_date) AS Y1
INNER JOIN
	(SELECT TC_date, SUM(total_price_paid_at_TC_prod_id) AS private_medium FROM
		(SELECT AA1.hh_id, TC_date, TC_id FROM
			(SELECT hh_id, hh_income AS medium_income FROM dta_at_hh WHERE hh_income BETWEEN 13 AND 19) AS AA1
		INNER JOIN
			(SELECT hh_id, DATE_FORMAT(TC_date, '%Y-%m') AS TC_date, TC_id FROM dta_at_TC) AS AA2
		ON AA1.hh_id = AA2.hh_id) AS BB1
	INNER JOIN
		(SELECT TC_id, total_price_paid_at_TC_prod_id FROM
			(SELECT TC_id, prod_id, total_price_paid_at_TC_prod_id FROM dta_at_TC_upc) AS W2
		INNER JOIN
			(SELECT prod_id FROM dta_at_prod_id WHERE brand_at_prod_id REGEXP "CTL BR") AS W1
		ON W1.prod_id = W2.prod_id) AS BB2
	ON BB1.TC_id = BB2.TC_id
	GROUP BY TC_date) AS Y2
ON Y1.TC_date = Y2.TC_date) AS F1;


-- LOW
SELECT AVG(total_low), AVG(private_low), AVG(private_low)/AVG(total_low) AS percentage FROM
	(SELECT Y1.TC_date, total_low, private_low, (private_low/total_low) AS percentage FROM
		(SELECT TC_date, SUM(total_price_paid_at_TC_prod_id) AS total_low FROM
			(SELECT A1.hh_id, TC_date, TC_id FROM
				(SELECT hh_id, hh_income AS low_income FROM dta_at_hh WHERE hh_income BETWEEN 3 AND 11) AS A1
		INNER JOIN
			(SELECT hh_id, DATE_FORMAT(TC_date, '%Y-%m') AS TC_date, TC_id FROM dta_at_TC) AS A2
		ON A1.hh_id = A2.hh_id) AS B1
	INNER JOIN
		(SELECT TC_id, total_price_paid_at_TC_prod_id FROM dta_at_TC_upc) AS B2
	ON B1.TC_id = B2.TC_id
	GROUP BY TC_date) AS Y1
INNER JOIN
	(SELECT TC_date, SUM(total_price_paid_at_TC_prod_id) AS private_low FROM
		(SELECT AA1.hh_id, TC_date, TC_id FROM
			(SELECT hh_id, hh_income AS low_income FROM dta_at_hh WHERE hh_income BETWEEN 3 AND 11) AS AA1
		INNER JOIN
			(SELECT hh_id, DATE_FORMAT(TC_date, '%Y-%m') AS TC_date, TC_id FROM dta_at_TC) AS AA2
		ON AA1.hh_id = AA2.hh_id) AS BB1
	INNER JOIN
		(SELECT TC_id, total_price_paid_at_TC_prod_id FROM
			(SELECT TC_id, prod_id, total_price_paid_at_TC_prod_id FROM dta_at_TC_upc) AS W2
		INNER JOIN
			(SELECT prod_id FROM dta_at_prod_id WHERE brand_at_prod_id REGEXP "CTL BR") AS W1
		ON W1.prod_id = W2.prod_id) AS BB2
	ON BB1.TC_id = BB2.TC_id
	GROUP BY TC_date) AS Y2
ON Y1.TC_date = Y2.TC_date) AS F1;





