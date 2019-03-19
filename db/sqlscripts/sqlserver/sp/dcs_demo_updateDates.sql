CREATE PROCEDURE dcs_demo_updateDates as


update ArTran set glPostDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),glPostDate);
update ArTran set tranDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),tranDate );
update ArTran set DueDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),DueDate );
update ArTran set ClosedDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),ClosedDate) where state=1
update ArTran set CreatedDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),CreatedDate);
update ArTran set EditedDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),EditedDate);
    

update Notes set EditedDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),EditedDate);
update Notes set CreatedDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),CreatedDate);
update Activities set EditedDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),EditedDate);
update Activities set CreatedDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),CreatedDate);
update Activities set ActDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),ActDate);
update Activities set CompletedDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),CompletedDate);


update Activity set EditedDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),EditedDate);
	update Activity set CreatedDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),CreatedDate);
	update Task set EditedDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),EditedDate);
	update Task set CreatedDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),CreatedDate);
	update Task set CompletedDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),CompletedDate);
	update Task set DueDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),DueDate);
	
update History set EditedDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),EditedDate);


update  aradjust
		 	set  
				createddate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),aradjust.CreatedDate),
				arPostDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),aradjust.arPostDate),
				EditedDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),aradjust.EditedDate),
				GlPostDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()),aradjust.GlPostDate)
		from ArAdjust aradjust, ArTran arTran where aradjust.id=arTranId;


update ArBatch set BatchDate=DATEADD(DAY, DATEDIFF(DAY,'2008-12-24', getDate()) ,BatchDate);
update ArBatch set CreatedDate=DATEADD(DAY, DATEDIFF(DAY, '2008-12-24', getDate()) ,CreatedDate);
update ArBatch set EditedDate=DATEADD(DAY, DATEDIFF(DAY, '2008-12-24', getDate()) ,EditedDate);
update ArBatch set ArPostedDate=DATEADD(DAY, DATEDIFF(DAY, '2008-12-24', getDate()) ,ArPostedDate);

update Payment set PayDate=DATEADD(DAY, DATEDIFF(DAY, '2008-12-24', getDate()) ,PayDate);
update Payment set ArPostedDate=DATEADD(DAY, DATEDIFF(DAY, '2008-12-24', getDate()) ,ArPostedDate);
update Payment set CreatedDate=DATEADD(DAY, DATEDIFF(DAY, '2008-12-24', getDate()) ,CreatedDate);
update Payment set EditedDate=DATEADD(DAY, DATEDIFF(DAY, '2008-12-24', getDate()) ,EditedDate);
	
---- run aging -----------------------
--exec dcs_api_ardocsaging

--exec dcs_update_orgsaging



