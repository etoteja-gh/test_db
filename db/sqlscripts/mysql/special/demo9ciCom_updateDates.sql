update ArTran set TranDate=DATE_ADD(TranDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);
update ArTran set GlPostDate=TranDate;
update ArTran set DueDate=DATE_ADD(DueDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);
update ArTran set ClosedDate=DATE_ADD(ClosedDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);
update ArTran set CreatedDate=DATE_ADD(CreatedDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);
update ArTran set EditedDate=DATE_ADD(EditedDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);

update ArTranMatch set TranDate=(select trandate from ArTran where ArTran.id=ArTranMatch.id);
update ArTranMatch set DueDate=(select DueDate from ArTran where ArTran.id=ArTranMatch.id);

update Activity set EditedDate=DATE_ADD(EditedDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);
update Activity set CreatedDate=DATE_ADD(CreatedDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);
update Task set EditedDate=DATE_ADD(EditedDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);
update Task set CreatedDate=DATE_ADD(CreatedDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);
update Task set CompletedDate=DATE_ADD(CompletedDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);
update Task set DueDate=DATE_ADD(DueDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);
update Notes set EditedDate=DATE_ADD(EditedDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);
update Notes set CreatedDate=DATE_ADD(CreatedDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);
update Activities set EditedDate=DATE_ADD(EditedDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);
update Activities set CreatedDate=DATE_ADD(CreatedDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);
update Activities set ActDate=DATE_ADD(ActDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);
	
update History set EditedDate=DATE_ADD(EditedDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);

update ArAdjust aradjust,  ArTran r
	 	set  
			aradjust.CreatedDate=DATE_ADD(aradjust.CreatedDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY),
			arPostDate=DATE_ADD(arPostDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY),
			aradjust.EditedDate=DATE_ADD(aradjust.EditedDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY),
			aradjust.GlPostDate=DATE_ADD(aradjust.GlPostDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY)
	where r.id=arTranId;
/*  don't delete them, unless you want to have no DD databse, but some of them are used for payment matches
delete from ArTranLine where exists (select 1 from ArTran a where a.id=arTranId and docType='DD');
delete from ArAdjustLine where exists (select 1 from ArTran a where a.id=arTranId and docType='DD');
delete from ArAdjust where not exists (select 1 from ArTran where arTranId=ArTran.id);
delete from ArTran where doctype='DD';
*/
update Parameters set value="false" where variable='useglPostPeriod';
update ArTran set GlPostPeriod = DATE_FORMAT(TranDate, '%Y%m') ;

update ArScoreCard set glPostPeriod = DATE_FORMAT(now(), '%Y%m') where id in (221,205);
update ArScoreCard set glPostPeriod = DATE_FORMAT(DATE_SUB(now(),INTERVAL 1 MONTH), '%Y%m') where id in(189,173);
update ArScoreCard set glPostPeriod = DATE_FORMAT(DATE_SUB(now(),INTERVAL 2 MONTH), '%Y%m') where id in(157,141);
update ArScoreCard set glPostPeriod = DATE_FORMAT(DATE_SUB(now(),INTERVAL 3 MONTH), '%Y%m') where id in(125,109);
update ArScoreCard set glPostPeriod = DATE_FORMAT(DATE_SUB(now(),INTERVAL 4 MONTH), '%Y%m') where id in(93,77);
update ArScoreCard set glPostPeriod = DATE_FORMAT(DATE_SUB(now(),INTERVAL 5 MONTH), '%Y%m') where id in(61,45);
update ArScoreCard set glPostPeriod = DATE_FORMAT(DATE_SUB(now(),INTERVAL 6 MONTH), '%Y%m') where id in(29,13);


update ArBatch set BatchDate=DATE_ADD(BatchDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);
update ArBatch set CreatedDate=DATE_ADD(CreatedDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);
update ArBatch set EditedDate=DATE_ADD(EditedDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);
update ArBatch set ArPostedDate=DATE_ADD(ArPostedDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);

update Payment set PayDate=DATE_ADD(PayDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);
update Payment set ArPostedDate=DATE_ADD(ArPostedDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);
update Payment set CreatedDate=DATE_ADD(CreatedDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);
update Payment set EditedDate=DATE_ADD(EditedDate, INTERVAL DATEDIFF(now(),'2008-12-24') DAY);


-- delete from GbParams where Variable='crmPluginEnabled' and CompanyId='2';
