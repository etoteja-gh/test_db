CREATE   procedure [dbo].[autocash_docs_matching] as

truncate table ArTranMatch

Insert into  ArTranMatch (
[id], 
[Match1], 	
[Match2], 			 
[Match3],
[Match4],
[Match5],
[NetAmount],
[reconciled],
custId,
Amount,
state,
DiscAmount,
DiscDate,
tranDate,
DueDate,
RefNum,
ArTranTypeId,
arTranId,
CustNum,
bucketOnStatement
) 		
Select 
id,
Case 
	When charindex('-',refnum) > 1 then												-- 12963-ID-126827	
		right(refnum, charindex('-',reverse(refnum))-1)	--126827
	Else NULL
END,
Case 
	When charindex('-',refnum) > 1 and charindex('-',reverse(refnum))>1 then	
		left(refnum,charindex('-',refnum)-1)+'-'+ left(right(refnum, charindex('-',reverse(refnum))-1), len(right(refnum, charindex('-',reverse(refnum))))-1) --12963-12682
 --12963-126827
	Else NULL
END,
 dbo.FN9_parseNumericChars(refnum),					-- 12963126827
Case 
	When charindex('-',refnum) > 1 and charindex('-',reverse(refnum))>2 then	
		left(refnum,charindex('-',refnum)-1)+'-'+ left(right(refnum, charindex('-',reverse(refnum))-1), len(right(refnum, charindex('-',reverse(refnum))))-2) --12963-1268
	Else NULL
END,
Case 
	When charindex('-',refnum) > 1 and charindex('-',reverse(refnum))>3 then	
		left(refnum,charindex('-',refnum)-1)+'-'+ left(right(refnum, charindex('-',reverse(refnum))-1), len(right(refnum, charindex('-',reverse(refnum))))-3) --12963-126
	Else NULL
END,
round(Amount-DiscAmount,2),
0,
A.custId,A.Amount,A.state,A.DiscAmount,A.DiscDate,A.tranDate,A.DueDate,A.RefNum, A.tranTypeId, A.id, A.CustNum,null

from  ArTran A
	where  a.Amount<>0 and a.state=0 and A.DocType<>'PA'


/** set amounts from ardoc detail  1-service,2-product,3-shiping, 4-tax, 5 - misc*/
  update m set MiscAmount=d.amount from
 ArTranMatch m, ArTranLine d
 where m.ID=d.arTranId and d.itemTypeId=5
 
 update m set ShippingAmount=d.amount from
 ArTranMatch m, ArTranLine d
 where m.ID=d.arTranId and d.itemTypeId=3
 
  update m set TaxAmount=d.amount from
ArTranMatch m, ArTranLine d
 where m.ID=d.arTranId and d.itemTypeId=4
 

 update m set bucketOnStatement=null from ArDocsMatch m
 --0-30
  update m set bucketOnStatement='bucket1' from
 ArTranMatch m, ArTranAging a where a.ID=m.ID and a.DaysOld>0 and a.DaysOld<31
 
 --31-60
  update m set bucketOnStatement='bucket2' from
 ArTranMatch m, ArTranAging a where a.ID=m.ID and a.DaysOld>30 and a.DaysOld<61
 
 -- 61-90
   update m set bucketOnStatement='bucket3' from
 ArTranMatch m, ArTranAging a where a.ID=m.ID and a.DaysOld>60 and a.DaysOld<91
 
 --current
  update m set bucketOnStatement='bucket4' from
 ArTranMatch m, ArTranAging a where a.ID=m.ID and a.DaysOld<1
 
 --121+
   update m set bucketOnStatement='bucket5' from
 ArTranMatch m, ArTranAging a where a.ID=m.ID and a.DaysOld>120
