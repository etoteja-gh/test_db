Create FUNCTION FN9_DATEADDDAYSTR (expr1 int, expr2 Varchar(20))
 RETURNS Datetime
 BEGIN
   DECLARE d1 datetime;
   SET d1 = DATE_ADD(expr2,INTERVAL expr1 DAY);
   RETURN(d1);
END ;
;