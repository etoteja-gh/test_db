Create FUNCTION FN9_DATEDIFFDAYSTR (expr1 datetime, expr2 varchar(20))
 RETURNS numeric(10)
 BEGIN
   DECLARE n1 numeric(10);
   SET n1 = datediff(expr1, expr2);
   RETURN(@n1);
END;
;

