select * from Continent
select * from Customers
select * from Transactions

--1. Display the count of customers in each region who have done the transaction in the year 2020.

SELECT CO.region_name, COUNT(*) TRANSC_NO FROM Transactions T
JOIN Customers C ON C.customer_id = T.customer_id
JOIN Continent CO ON CO.region_id = C.region_id 
WHERE YEAR(txn_date) = 2020 
GROUP BY CO.region_name

--2. Display the maximum and minimum transaction amount of each transaction type

SELECT txn_type, MIN(txn_amount) AS MIN_TRANS, MAX(txn_amount) AS MAX_TRANS FROM Transactions
GROUP BY txn_type

--3. Display the customer id, region name and transaction amount where transaction type is deposit and transaction amount > 2000.

SELECT C.customer_id, C.region_id, T.txn_amount FROM Customers C
JOIN Transactions T ON T.customer_id = C.customer_id
WHERE T.txn_type = 'DEPOSIT' AND T.txn_amount > 2000

--4. Find duplicate records in the Customer table.

SELECT * FROM Customers
GROUP BY customer_id, region_id, start_date, end_date
HAVING COUNT(*) > 1

--5. Display the customer id, region name, transaction type and transaction amount for the minimum transaction amount in deposit.

SELECT DISTINCT C.customer_id, CO.region_name, T.txn_amount FROM Customers C
JOIN Continent CO ON CO.region_id = C.region_id
JOIN Transactions T ON T.customer_id = C.customer_id 
WHERE T.txn_amount = (SELECT MAX(txn_amount) FROM Transactions
WHERE txn_type = 'DEPOSIT')

--6. Create a stored procedure to display details of customers in the Transaction table where the transaction date is greater than Jun 2020.

CREATE PROCEDURE TRANS_DATE(@MONTH INT, @YEAR INT)
AS BEGIN
	SELECT * FROM Transactions
	WHERE MONTH(txn_date) = @MONTH AND YEAR(txn_date) = @YEAR
END

EXEC TRANS_DATE 6 , 2020

--7. Create a stored procedure to insert a record in the Continent table.

CREATE PROCEDURE ADD_RECORD(@REG_ID INT, @REG_NAME VARCHAR(20))
AS
BEGIN
	INSERT INTO Continent
	VALUES (@REG_ID , @REG_NAME)
END

EXEC ADD_RECORD 6, 'INDIA'


--8. Create a stored procedure to display the details of transactions that happened on a specific day.

CREATE PROCEDURE SHOW(@DATE DATE)
AS 
BEGIN
	SELECT * FROM Transactions
	WHERE txn_date = @DATE
END

EXEC SHOW '2020-02-10'

--9. Create a user defined function to add 10% of the transaction amount in a table.

CREATE FUNCTION UPDATE_TRANS(@AMOUNT FLOAT)
RETURNS FLOAT
AS BEGIN
	RETURN (SELECT @AMOUNT + @AMOUNT*0.1)
END

SELECT *, dbo.UPDATE_TRANS(txn_amount) FROM Transactions

--10. Create a user defined function to find the total transaction amount for a given transaction type.

CREATE FUNCTION TOTAL(@TYPE VARCHAR(20))
RETURNS FLOAT
AS
BEGIN
	RETURN (SELECT SUM(txn_amount) FROM Transactions WHERE txn_type = @TYPE)
END

SELECT dbo.TOTAL('WITHDRAWAL')

--11. Create a table value function which comprises the columns customer_id, region_id ,txn_date , txn_type , 
--txn_amount which will retrieve data from the above table.

CREATE FUNCTION details()
RETURNS table
AS
return (
	SELECT C.customer_id, CO.Region_id, T.txn_date, T.txn_type, T.txn_amount FROM Customers C
	JOIN Continent CO ON CO.region_id = C.region_id
	JOIN Transactions T ON T.customer_id = C.customer_id)

SELECT * FROM dbo.details()

--12. Create a TRY...CATCH block to print a region id and region name in a single column.

BEGIN TRY
	SELECT region_id FROM Continent
	UNION
	SELECT region_name FROM Continent
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE()
END CATCH


--13. Create a TRY...CATCH block to insert a value in the Continent table.

BEGIN TRY
	INSERT INTO Continent 
	VALUES (7, 'SL')
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE()
END CATCH

--14. Create a trigger to prevent deleting a table in a database.

ALTER TRIGGER DEL
ON Continent
FOR DELETE 
AS
BEGIN 
	PRINT 'CANT DELETE'
	ROLLBACK
END

DELETE FROM Continent WHERE region_id = 7

--15. Create a trigger to audit the data in a table.

CREATE TABLE CONTINENT_AUDIT
(REGION_ID INT,
REGION_NAME VARCHAR(20),
INSERTED_BY VARCHAR(50))

CREATE TRIGGER TRG_CONTINET
ON CONTINENT
FOR INSERT, UPDATE, DELETE
AS
BEGIN

DECLARE @ID INT, @NAME VARCHAR(20)
SELECT @ID = REGION_ID, @NAME = REGION_NAME FROM inserted
INSERT INTO CONTINENT_AUDIT(REGION_ID, REGION_NAME, INSERTED_BY)VALUES (@ID, @NAME, ORIGINAL_LOGIN())
PRINT 'INSERT TRIGGER EXECUTED'

END;


--16. Create a trigger to prevent login of the same user id in multiple pages.

CREATE TRIGGER PREVENT_MULTIPLE_LOGINS
ON ALL SERVER
FOR LOGON
AS
BEGIN
DECLARE @SESSION_COUNT INT
SELECT @SESSION_COUNT = COUNT(*) FROM SYS.DM_EXEC_SESSIONS
WHERE is_user_process = 1 AND LOGIN_NAME = ORIGINAL_LOGIN()
	IF @SESSION_COUNT > 1 
	BEGIN
		PRINT 'MULTIPLE LOGINS NOT ALLOWED'
	ROLLBACK
	END
END;


--17. Display top n customers on the basis of transaction type.

ALTER FUNCTION TOP_N(@N INT, @TYPE VARCHAR(20))
RETURNS TABLE
AS
RETURN
	(SELECT TOP (@N) * FROM Transactions
	WHERE txn_type = @TYPE
	ORDER BY txn_amount DESC)

SELECT * FROM dbo.TOP_N(10, 'DEPOSIT')


--18. Create a pivot table to display the total purchase, withdrawal and deposit for all the customers

SELECT *  FROM Transactions
PIVOT(SUM(TXN_AMOUNT) FOR TXN_TYPE IN (purchase, withdrawal, deposit)) DT
ORDER BY customer_id
