Create FUNCTION FN9_CHAR (@expr1 varchar(10))
 RETURNS varchar(10)
 AS
 BEGIN
   DECLARE @s1 Varchar(10)
   SET @s1 = CHAR(@expr1)
   RETURN(@s1)
END 

