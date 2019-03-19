CREATE FUNCTION dbo.FN9_AverageDaysToPay  (@daysBack int,@sourceID varchar(50), @endDate datetime)
RETURNS DECIMAL(21,5)
AS
BEGIN
DECLARE @avgDaysToPay DECIMAL(21,5)
DECLARE @sumARDocs DECIMAL(20,4)
DECLARE @startDate DATETIME
DECLARE @vcStartDate varchar(30)
-- Below we create a string representation of the end date at midnight that morning.  The end date will almost always
-- be the date generated fromt the getDate() function (ie. the current date).
SET @endDate =  CAST(CAST(@endDate AS CHAR(11)) AS DATETIME)
SET @startDate = DATEADD(DAY, -1*@daysBack, @endDate)


SET @sumARDocs = (select sum(ARDocs.OrigAmount)
from dbo.ARDocs ARDocs INNER JOIN dbo.Orgs Orgs ON (ARDocs.CustID = Orgs.OID)
where ARDocs.Doctype = 'IN' and ARDocs.Closed = 1 AND ARDocs.ClosedDate >= @startDate AND Orgs.SourceID like @sourceID)


IF @sumARDocs > 0
BEGIN
SET @avgDaysToPay = (Select cast(sum((DATEDIFF(day, ARDocs.DocDate, ARDocs.ClosedDate) * ARDocs.OrigAmount)/@sumARDocs) as DECIMAL(21,5))
from dbo.ARDocs ARDocs INNER JOIN dbo.Orgs Orgs ON (ARDocs.CustID = Orgs.OID)
where ARDocs.Doctype = 'IN' and ARDocs.OrigAmount <> 0 and ARDocs.Closed = 1
	AND ARDocs.ClosedDate >= @startDate
	AND Orgs.SourceID = @sourceID)
END
ELSE
BEGIN
SET @avgDaysToPay = cast(0 as DECIMAL(21,5))
END
   RETURN(@avgDaysToPay)
END

