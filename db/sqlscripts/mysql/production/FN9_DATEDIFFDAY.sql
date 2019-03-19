Create FUNCTION FN9_DATEDIFFDAY (expr1 datetime, expr2 datetime)
 RETURNS int
 BEGIN
   DECLARE n1 int;
   SET n1 = datediff(expr1, expr2);
   RETURN(n1);
END;
;

