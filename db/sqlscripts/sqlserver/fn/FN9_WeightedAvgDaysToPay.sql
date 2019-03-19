

CREATE   FUNCTION dbo.FN9_WeightedAvgDaysToPay  (@sourceID varchar(50))
RETURNS DECIMAL(21,2)
AS
BEGIN
DECLARE @weightedavgDaysToPay DECIMAL(21,2)
DECLARE @sumARDocs DECIMAL(20,4)
DECLARE @startDate DATETIME
DECLARE @vcStartDate varchar(30)
-- Below we create a string representation of the end date at midnight that morning.  The end date will almost always
-- be the date generated fromt the getDate() function (ie. the current date).




SET @sumARDocs = (select sum(ARDocs.OrigAmount)
from dbo.ARDocs ARDocs INNER JOIN dbo.Orgs Orgs ON (ARDocs.CustID = Orgs.OID)
where ARDocs.Doctype = 'IN' and ARDocs.Closed = 1 AND ARDocs.ClosedDate > '1/1/1990' AND Orgs.SourceID like @sourceID)


IF @sumARDocs > 0
BEGIN
SET @weightedavgDaysToPay = (Select cast(sum((DATEDIFF(day, ARDocs.DocDate, ARDocs.ClosedDate) * ARDocs.OrigAmount)/@sumARDocs) as DECIMAL(21,5))
from dbo.ARDocs ARDocs INNER JOIN dbo.Orgs Orgs ON (ARDocs.CustID = Orgs.OID)
where ARDocs.Doctype = 'IN' and ARDocs.OrigAmount <> 0 and ARDocs.Closed = 1
	AND ARDocs.ClosedDate >='1/1/1990'
	AND Orgs.SourceID = @sourceID)
END
ELSE
BEGIN
SET @weightedavgDaysToPay = cast(0 as DECIMAL(21,2))
END
   RETURN(@weightedavgDaysToPay)
END






