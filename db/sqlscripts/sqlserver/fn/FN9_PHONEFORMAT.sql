Create FUNCTION FN9_PHONEFORMAT (@phone Varchar(50))
 RETURNS varchar(50)
 AS
 BEGIN
   DECLARE @d1 varchar(50)
   SET @d1 = left(@phone,3) + '-' + substring(@phone,4,3) + '-' + substring(@phone,7,4) + substring(@phone,12,20)
   RETURN(@d1)
END 

