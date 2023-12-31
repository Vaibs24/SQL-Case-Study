--CASE STUDY - 1

SELECT * FROM Fact
SELECT * FROM Location
SELECT * FROM Product

--1. Display the number of states present in the Location Table.

SELECT COUNT(DISTINCT State) AS STATE_COUNT FROM Location

--2. How many products are of regular type?

SELECT COUNT(Product) as count FROM Product
WHERE Type = 'Regular'

--3. How much spending has been done on marketing of product ID 1? 

SELECT SUM(Marketing) AS MARKETING_COST FROM Fact
WHERE ProductId = 1

--4. What is the minimum sales of a product?

SELECT MIN(sales) AS MIN_SALES FROM Fact

--5. Display the max Cost of Good Sold(COGS).

SELECT MAX(COGS) AS MAX_COGS FROM Fact

--6. Display the details of the product where product type is coffee.

SELECT * FROM Product
WHERE Product_Type = 'Coffee'

--7. Display the details where total expenses are greater than 40.

SELECT * FROM Fact
WHERE Total_Expenses > 40

--8. What is the average sales in area code 719?

SELECT AVG(SALES) AVG_SALES FROM Fact
WHERE Area_Code = 719
GROUP BY Area_Code

--9. Find out the total profit generated by Colorado state.

SELECT SUM(F.Profit) TOTAL_PROFIT FROM Fact F
JOIN Location L ON L.Area_Code = F.Area_Code
WHERE L.state = 'Colorado'
GROUP BY L.State

--10. Display the average inventory for each product ID.

SELECT ProductId, AVG(Inventory) AVG_INVI FROM Fact
GROUP BY ProductId
ORDER BY ProductId

--11. Display state in a sequential order in a Location Table.

SELECT DISTINCT State FROM Location
ORDER BY State

--12. Display the average budget of the Product where the average budget margin should be greater than 100.

SELECT P.PRODUCTID, P.PRODUCT, AVG(F.BUDGET_MARGIN) AVG_BUDGET_MARGIN FROM FACT F,PRODUCT P
WHERE F.PRODUCTID=P.PRODUCTID GROUP BY PRODUCT, P.PRODUCTID  HAVING AVG(BUDGET_MARGIN)>100 ORDER BY P.PRODUCTID

--13. What is the total sales done on date 2010-01-01?

SELECT SUM(SALES) SALES_AT_DATE FROM Fact
WHERE DATE = '2010-01-01'

--14. Display the average total expense of each productID on an individual date. 

SELECT ProductId, Date, AVG(Total_Expenses) AVG_EXPENSES FROM Fact
GROUP BY ProductId, Date
ORDER BY ProductId, DATE

--15. Display the table with the following attributes such as date, productID, product_type, product, sales, profit, state, area_code.

SELECT F.Date, F.ProductId, P.Product_Type, P.Product, F.Sales, F.Profit, L.State, F.Area_Code FROM Fact F
JOIN Location L ON L.Area_Code = F.Area_Code
JOIN Product P ON P.ProductId = F.ProductId

--16. Display the rank without any gap to show the sales wise rank.

SELECT *, DENSE_RANK() OVER(ORDER BY sales DESC) Rank FROM fact 

--17. Find the state wise profit and sales.

SELECT L.State, SUM(F.Profit) TOTAL_PROFIT, SUM(F.Sales) TOTAL_SALES FROM Fact F
JOIN Location L ON L.Area_Code = F.Area_Code
GROUP BY L.State
ORDER BY L.State

--18. Find the state wise profit and sales along with the product name.

SELECT L.State, P.Product, SUM(F.Profit) TOTAL_PROFIT, SUM(F.Sales) TOTAL_SALES FROM Fact F
JOIN Location L ON L.Area_Code = F.Area_Code
JOIN Product P ON P.ProductId = F.ProductId
GROUP BY L.State, P.Product
ORDER BY L.State, P.Product

--19. If there is an increase in sales of 5%, calculate the increased sales.

SELECT SALES, (Sales + Sales*0.05) INCREASED_SALES FROM Fact

--20. Find the maximum profit along with the productID and product type.

SELECT F.ProductId, P.Product_Type, MAX(F.Profit) MAX_PROFIT FROM Fact F
JOIN Product P ON P.ProductId = F.ProductId
GROUP BY F.ProductId, P.Product_Type

--21. Create a stored procedure to fetch the result according to the product type from Product Table.

CREATE PROCEDURE PRO_DATA(@Pro_type VARCHAR(50))
AS
BEGIN
SELECT * FROM Product
WHERE Product_Type = @Pro_type
END

EXEC PRO_DATA 'espresso'


--22. Write a query by creating a condition in which if the total expenses is less than 60 then it is a profit or else loss.

SELECT Total_Expenses, CASE WHEN Total_Expenses < 60 THEN 'PROFIT' ELSE 'LOSS' END AS STATUS FROM Fact

SELECT * FROM Fact

--23. Give the total weekly sales value with the date and productID details. Use roll-up to pull the data in hierarchical order.

SELECT Date, ProductId, SUM(Sales) AS WEEKLY_SALES 
FROM fact
GROUP BY Date, ProductId
WITH ROLLUP;


--24. Apply union and intersection operator on the tables which consist of attribute are a code.

SELECT Area_Code FROM Fact
UNION
SELECT Area_Code FROM Location

SELECT Area_Code FROM fact
INTERSECT
SELECT Area_Code FROM Location;


--25. Create a user-defined function for the product table to fetch a particular product type based upon the user�s preference.

CREATE FUNCTION PRODUCT_TYPE(@P_TYPE VARCHAR(50)) 
RETURNS TABLE AS
RETURN 
SELECT * FROM Product
WHERE Product_Type = @P_TYPE

SELECT * FROM PRODUCT_TYPE('espresso')


--26. Change the product type from coffee to tea where productID is 1 and undo it.

BEGIN TRANSACTION
UPDATE Product
SET Product_Type = 'tea'
WHERE ProductId = 1
SELECT * FROM Product
WHERE ProductId= 1
ROLLBACK TRANSACTION

SELECT * FROM Product
WHERE ProductId= 1


--27. Display the date, productID and sales where total expenses are between 100 to 200.

SELECT Date, ProductId, Sales, Total_Expenses FROM Fact
WHERE Total_Expenses BETWEEN 100 AND 200
ORDER BY Total_Expenses


--28. Delete the records in the Product Table for regular type.

DELETE FROM Product
WHERE Type = 'Regular'


--29. Display the ASCII value of the fifth character from the column Product.

SELECT Product, ASCII(SUBSTRING(Product,5,1)) ASCII_VAL FROM Product



