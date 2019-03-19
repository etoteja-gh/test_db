CREATE PROCEDURE [dbo].[dcs_api_ARDocsAging] as 
print 'dcs_api_ARDocsAging ' + cast(getDate() as varchar(20))

Truncate table ARDocsAging

INSERT INTO ARDocsAging (OID, DaysOld,amount)
SELECT     OID, DATEDIFF(day, DueDate, GETDATE()) AS DaysOld,amount
FROM         ARDocs WHERE Closed = 0

--zero out the aging
UPDATE ARDocsAging SET
Aging1   = 0,
Aging2   = 0,
Aging3   = 0,
Aging4   = 0,
Aging5   = 0,
Aging6   = 0,
Aging7   = 0,
Aging8   = 0,
Aging9  = 0,
Aging10   = 0,
Aging11   = 0,
Aging12   = 0,
Aging13   = 0,
Aging14   = 0,
Aging15   = 0,
Aging16   = 0,
Aging17   = 0,
Aging18   = 0,
Aging19  = 0,
Aging20   = 0



--aging 1
UPDATE ARDocsAging SET
Aging1   = Amount, AgingID = 1, AgingName = 'Aging1', 
AgingDescrip = (SELECT Description FROM CFGAging WHERE OID = 1)
WHERE daysold
	between (SELECT StartDay FROM CFGAging WHERE OID = 1) 		
	    AND (SELECT EndDay   FROM CFGAging WHERE OID = 1) 


--aging 2
UPDATE ARDocsAging SET
Aging2   = Amount, AgingID = 2, AgingName = 'Aging2', 
AgingDescrip = (SELECT Description FROM CFGAging WHERE OID = 2)
WHERE daysold
	between (SELECT StartDay FROM CFGAging WHERE OID = 2) 		
	    AND (SELECT EndDay   FROM CFGAging WHERE OID = 2) 


--aging 3
UPDATE ARDocsAging SET
Aging3   = Amount, AgingID =3, AgingName = 'Aging3', 
AgingDescrip = (SELECT Description FROM CFGAging WHERE OID = 3)
WHERE daysold
	between (SELECT StartDay FROM CFGAging WHERE OID = 3) 		
	    AND (SELECT EndDay   FROM CFGAging WHERE OID = 3) 


--aging 4
UPDATE ARDocsAging SET
Aging4   = Amount, AgingID = 4, AgingName = 'Aging4', 
AgingDescrip = (SELECT Description FROM CFGAging WHERE OID = 4)
WHERE daysold
	between (SELECT StartDay FROM CFGAging WHERE OID = 4) 		
	    AND (SELECT EndDay   FROM CFGAging WHERE OID = 4) 


--aging 5
UPDATE ARDocsAging SET
Aging5   = Amount, AgingID = 5, AgingName = 'Aging5', 
AgingDescrip = (SELECT Description FROM CFGAging WHERE OID = 5)
WHERE daysold
	between (SELECT StartDay FROM CFGAging WHERE OID = 5) 		
	    AND (SELECT EndDay   FROM CFGAging WHERE OID = 5) 


--aging 6
UPDATE ARDocsAging SET
Aging6   = Amount, AgingID = 6, AgingName = 'Aging6', 
AgingDescrip = (SELECT Description FROM CFGAging WHERE OID = 6)
WHERE daysold
	between (SELECT StartDay FROM CFGAging WHERE OID = 6) 		
	    AND (SELECT EndDay   FROM CFGAging WHERE OID = 6) 


--aging 7
UPDATE ARDocsAging SET
Aging7   = Amount, AgingID = 7, AgingName = 'Aging7', 
AgingDescrip = (SELECT Description FROM CFGAging WHERE OID = 7)
WHERE daysold
	between (SELECT StartDay FROM CFGAging WHERE OID = 7) 		
	    AND (SELECT EndDay   FROM CFGAging WHERE OID = 7) 


--aging 8
UPDATE ARDocsAging SET
Aging8   = Amount, AgingID = 8, AgingName = 'Aging8', 
AgingDescrip = (SELECT Description FROM CFGAging WHERE OID = 8)
WHERE daysold
	between (SELECT StartDay FROM CFGAging WHERE OID = 8) 		
	    AND (SELECT EndDay   FROM CFGAging WHERE OID = 8) 


--aging 9
UPDATE ARDocsAging SET
Aging9   = Amount, AgingID = 9, AgingName = 'Aging9', 
AgingDescrip = (SELECT Description FROM CFGAging WHERE OID = 9)
WHERE daysold
	between (SELECT StartDay FROM CFGAging WHERE OID = 9) 		
	    AND (SELECT EndDay   FROM CFGAging WHERE OID = 9) 


--aging 10
UPDATE ARDocsAging SET
Aging10   = Amount, AgingID = 10, AgingName = 'Aging10', 
AgingDescrip = (SELECT Description FROM CFGAging WHERE OID = 10)
WHERE daysold
	between (SELECT StartDay FROM CFGAging WHERE OID = 10) 		
	    AND (SELECT EndDay   FROM CFGAging WHERE OID = 10) 



--aging 11
UPDATE ARDocsAging SET
Aging11   = Amount, AgingID = 11, AgingName = 'Aging11', 
AgingDescrip = (SELECT Description FROM CFGAging WHERE OID = 11)
WHERE daysold
	between (SELECT StartDay FROM CFGAging WHERE OID = 11) 		
	    AND (SELECT EndDay   FROM CFGAging WHERE OID = 11) 


--aging 12
UPDATE ARDocsAging SET
Aging12   = Amount, AgingID = 12, AgingName = 'Aging12', 
AgingDescrip = (SELECT Description FROM CFGAging WHERE OID = 12)
WHERE daysold
	between (SELECT StartDay FROM CFGAging WHERE OID = 12) 		
	    AND (SELECT EndDay   FROM CFGAging WHERE OID = 12) 


--aging 13
UPDATE ARDocsAging SET
Aging13   = Amount, AgingID = 13, AgingName = 'Aging13', 
AgingDescrip = (SELECT Description FROM CFGAging WHERE OID = 13)
WHERE daysold
	between (SELECT StartDay FROM CFGAging WHERE OID = 13) 		
	    AND (SELECT EndDay   FROM CFGAging WHERE OID = 13) 


--aging 14
UPDATE ARDocsAging SET
Aging14   = Amount, AgingID = 14, AgingName = 'Aging14', 
AgingDescrip = (SELECT Description FROM CFGAging WHERE OID = 14)
WHERE daysold
	between (SELECT StartDay FROM CFGAging WHERE OID = 14) 		
	    AND (SELECT EndDay   FROM CFGAging WHERE OID = 14) 


--aging 15
UPDATE ARDocsAging SET
Aging15   = Amount, AgingID = 15, AgingName = 'Aging15', 
AgingDescrip = (SELECT Description FROM CFGAging WHERE OID = 15)
WHERE daysold
	between (SELECT StartDay FROM CFGAging WHERE OID = 15) 		
	    AND (SELECT EndDay   FROM CFGAging WHERE OID = 15) 


--aging 16
UPDATE ARDocsAging SET
Aging16   = Amount, AgingID = 16, AgingName = 'Aging16', 
AgingDescrip = (SELECT Description FROM CFGAging WHERE OID = 16)
WHERE daysold
	between (SELECT StartDay FROM CFGAging WHERE OID = 16) 		
	    AND (SELECT EndDay   FROM CFGAging WHERE OID = 16) 


--aging 17
UPDATE ARDocsAging SET
Aging17   = Amount, AgingID = 17, AgingName = 'Aging17', 
AgingDescrip = (SELECT Description FROM CFGAging WHERE OID = 17)
WHERE daysold
	between (SELECT StartDay FROM CFGAging WHERE OID = 17) 		
	    AND (SELECT EndDay   FROM CFGAging WHERE OID = 17) 


--aging 18
UPDATE ARDocsAging SET
Aging18   = Amount, AgingID = 18, AgingName = 'Aging18', 
AgingDescrip = (SELECT Description FROM CFGAging WHERE OID = 18)
WHERE daysold
	between (SELECT StartDay FROM CFGAging WHERE OID = 18) 		
	    AND (SELECT EndDay   FROM CFGAging WHERE OID = 18) 


--aging 19
UPDATE ARDocsAging SET
Aging19   = Amount, AgingID = 19, AgingName = 'Aging19', 
AgingDescrip = (SELECT Description FROM CFGAging WHERE OID = 19)
WHERE daysold
	between (SELECT StartDay FROM CFGAging WHERE OID = 19) 		
	    AND (SELECT EndDay   FROM CFGAging WHERE OID = 19) 


--aging 20
UPDATE ARDocsAging SET
Aging20   = Amount, AgingID = 20, AgingName = 'Aging20', 
AgingDescrip = (SELECT Description FROM CFGAging WHERE OID = 20)
WHERE daysold
	between (SELECT StartDay FROM CFGAging WHERE OID = 20) 		
	    AND (SELECT EndDay   FROM CFGAging WHERE OID = 20) 


