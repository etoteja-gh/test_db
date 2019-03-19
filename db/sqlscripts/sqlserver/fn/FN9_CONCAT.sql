Create FUNCTION FN9_CONCAT
  (@expr1 varchar(1600), @expr2 varchar(1600), @expr3 varchar(1600))
 RETURNS varchar(5000)
 AS
 BEGIN
   DECLARE @Concat Varchar(5000)
   SET @Concat = @expr1 + @expr2 + @expr3
   RETURN(@Concat)
END 

