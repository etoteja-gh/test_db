Create FUNCTION FN9_CONCAT20
  (@expr1 varchar(200), @expr2 varchar(200), @expr3 varchar(200),
   @expr4 varchar(200), @expr5 varchar(200), @expr6 varchar(200),
   @expr7 varchar(200), @expr8 varchar(200), @expr9 varchar(200),
   @expr10 varchar(200), @expr11 varchar(200), @expr12 varchar(200),
   @expr13 varchar(200), @expr14 varchar(200), @expr15 varchar(200),
   @expr16 varchar(200), @expr17 varchar(200), @expr18 varchar(200),
   @expr19 varchar(200), @expr20 varchar(200))
 RETURNS varchar(5000)
 AS
 BEGIN
   DECLARE @Concat Varchar(5000)
   SET @Concat = @expr1 + @expr2 + @expr3 + @expr4 + @expr5 + @expr6 +
                @expr7 + @expr8 + @expr9 + @expr10 + @expr11 + @expr12 +
                @expr13 + @expr14 + @expr15 + @expr16 + @expr17 + @expr18 +
                @expr19 + @expr20
   RETURN(@Concat)
END 

