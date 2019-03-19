Create FUNCTION FN9_PERIODTOPOST (@postedate datetime)
 RETURNS varchar(6)
 AS
 BEGIN
   DECLARE @month varchar(2)
   DECLARE @year varchar(4)
   SET @month = left(CONVERT ( varchar(20) , @postedate , 101 ),2)
   SET @year = CONVERT (varchar(4), YEAR(@postedate))
   RETURN(@year+@month)
END