
CREATE PROCEDURE [dbo].[dcs_api_ArTran_Update] as

/* Update the ARDOCS table using the ARDocsAPI table.

*/

/* Update the ARDOCS table using the ArTranApi table.

*/

Update  api set api.arTranId = ArTranSource.arTranId
          from ArTran, ArTranApi API, ArTranSource
          where api.sourceIdErp = ArTranSource.sourceId and ArTranSource.sourceType='Erp' 
            AND arTran.id = ArTranSource.arTranId AND api.arTranId is null

Update api  set api.arTranId = ArTranSource.arTranId
          from ArTran, ArTranApi api, ArTranSource
          where api.sourceIdApp = ArTranSource.sourceId 
            AND ArTranSource.sourceType='App'
            AND ArTran.id = ArTranSource.arTranId AND api.arTranId is null

-- updating ardocs with any changed disc, refNum or cust info
UPDATE D SET
D.DiscAmount = I.DiscAmount,
D.DiscDate = I.DueDate,
D.RefNum = I.RefNum
FROM ARTran D JOIN ArTranApi I ON d.id = i.arTranId 

-- update Customer
UPDATE D SET
D.CustId=I.CustId,
D.custNum=I.custNum
FROM ARTran D JOIN ArTranApi I ON d.id = i.arTranId 
and I.custId is not null

---=========== change amount ============== 
-- change amount only when all payments got processed
declare  @NoArTranApi int
select @NoArTranApi =   COUNT(*) from ArTranApi
 IF   @NoArTranApi>1000
 BEGIN
 	 
	 -- reopen from api or partial adjust for ArTranExt
	Update ax  set 
	SyncOldAmount=a.amount,
	SyncMasterAmount=api.amount,
	SyncDateReentered=getdate() 
	from ArTran a
	JOIN ArTranExt ax on ax.id=a.id
	Join ArTranApi api on a.id = api.arTranId  
	where ( a.amount <> api.amount and  api.Amount<>0 )
	
	-- reopen from api for ArDocs
	update A set
	a.Amount = api.amount,
	a.StatusId = 1,
	a.state = 0,
	a.ClosedDate = null
	from ArTran a
	Join ArTranApi api on a.id = api.arTranId    
	where ( api.Amount<>0 and a.Amount=0 ) 

	-- amount is different in api
	update A set
	a.Amount = api.amount
	from ArTran a
	Join ArTranApi api on a.id = api.arTranId    
	where ( a.amount <> api.amount and  api.Amount<>0 ) 
	
    -- close if it's not in api Ext
	Update ax  set 
	SyncOldAmount=a.amount,
	SyncMasterAmount = 0,
	SyncDateReentered=getdate()
	from ArTran a
	JOIN ArTranExt ax on ax.id=a.id
	where not exists (select 1 from ArTranApi api  where api.arTranId = a.id)

 -- closed in api for ArTranAutoCash
	Update ax  set 
	recentPayNum='Closed in import'
	from ArTran a
	JOIN ArTranAutoCash ax on ax.id=a.Id
	where not exists (select 1 from ArTranApi api  where api.arTranId = a.id) 

	 -- close if it's not in api ArDocs
	update A set
	a.Amount = 0,
	a.StatusId = 5,
	a.State = 1,
	a.ClosedDate = GETDATE()
	from ArTran a
	where not exists (select 1 from ArTranApi api  where api.arTranId = a.id) 
		   
END
  ELSE
  BEGIN
		print 'amounts not updated';
		--exec dcs_eventLog 2, 'ar api', 'in api - arDocs', 'amounts not updated', 'skip update amounts, there were less than 1,000 arTranAPi' , 40000
   END


-- assign artrantypeid where artrantype is null. It assigns always the first value for the specific doctype (default values)
-- FIXME artrantypeid cannot be null any longer
update a set a.trantypeid=t.id 
from ArTran a, artrantype t where t.name=a.doctype and a.trantypeid is null

--catch all for closeddate on open ardocs
update ArTran set ClosedDate=null where State=0 and ClosedDate is not null


-- catch all to close items that have amount = 0
Update a set a.State = 1, ClosedDate=GETDATE(),  StatusId=5
from ArTran a 
where a.State = 0 and Amount = 0 

-- catch all to reopen items that have amount <> 0
Update a set a.State = 0, ClosedDate= null,  StatusId=1
from ArTran a 
where a.State = 1 and Amount <> 0 

