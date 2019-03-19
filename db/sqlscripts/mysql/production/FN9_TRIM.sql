Create FUNCTION FN9_TRIM (expr1 varchar(255))
 RETURNS varchar(255)
 BEGIN
   DECLARE s1 Varchar(255) ;
   SET s1 = LTRIM(RTRIM(expr1));
   RETURN(s1);
END;
;
