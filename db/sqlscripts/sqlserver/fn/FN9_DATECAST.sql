Create FUNCTION FN9_DATECAST (@expr1 datetime)
 RETURNS varchar(20)
 AS
 BEGIN
   DECLARE @s1 varchar(20)
   SET @s1 = cast(@expr1 as varchar(20))
   RETURN(@s1)
END 

