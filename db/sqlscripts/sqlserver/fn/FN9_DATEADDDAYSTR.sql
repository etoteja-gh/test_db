Create FUNCTION FN9_DATEADDDAYSTR (@expr1 int, @expr2 Varchar(20))
 RETURNS Datetime
 AS
 BEGIN
   DECLARE @d1 datetime
   SET @d1 = dateadd(d,@expr1, @expr2)
   RETURN(@d1)
END 

