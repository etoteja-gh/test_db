package v9_9_x

databaseChangeLog{
    clid = '9-9-16-vwPaymentDetailArTranWithOracle'

    changeSet(id: "${clid}.1", author: "Joanna", failOnError: 'false') {
        dropView(viewName: "vwPaymentDetailArTran")
    }

    changeSet(id: "${clid}.2-ms", author: "Joanna", dbms:'mssql') {
        sql( """ create view vwPaymentDetailArTran as 
            select ('PD' + CAST(pd.id AS varchar(1000))) as 'sourceId', p.CustId as 'custId' , p.id as 'paymentId',
             pd.ArTranType as 'pdArTranType' , pd.Amount as 'pdAmount', pd.DiscAmount as 'pdDiscAmount', pd.PayAmount as 'pdPayAmount', pd.id as 'pdId' ,
             pd.refnum as 'refnum', pd.custNum as 'custNum', pd.custAccountNum as 'custAccountNum',
             tt.Name as 'tTranType', t.amount as 'tAmount', t.origAmount as 'tOrigAmount', t.discAmount as 'tDiscAmount', t.netAmount  as 'tNetAmount',
             t.match6 as 'tPoNum', t.match7  tRefnum2,  t.tranDate as 'tTranDate', t.dueDate as 'tDueDate',t.DiscDate as tDiscDate, t.id as 'tranId', null as 'state', 0 as 'isPending',
             null as 'text1', null as 'text2', null as 'text3', null as 'text4', null as 'text5', null as 'text6', null as 'text7', 
             null as 'text8', null as 'text9', null as 'text10', null as 'num1', null as 'num2', null as 'num3', null as 'num4',
             null as 'num5', null as 'num6', null as 'date1', null as 'date2', null as 'date3', null as 'date4'
             from PaymentDetail pd with (nolock)
             inner JOIN Payment p  with (nolock) on p.id=pd.PaymentId
             left outer JOIN ArTranMatch t  with (nolock) on pd.arTranId=t.ArTranTypeId
             left outer JOIN ArTranType tt  on tt.id=t.id


             UNION
             select ('TR'+ CAST(t.id AS varchar(1000))) as 'sourceId', t.custId, null,
             null , null, null, null, null,
             t.refnum, t.custNum, ca.num,
             isNull(tt.Name, 'IN'),  t.amount-isnull((select sum(pd.amount) from Paymentdetail pd with (nolock), Payment p with (nolock) where pd.arTranId=t.id and p.id=pd.paymentId and p.arPostedDate is not null),0) as 'tAmount',
             t.origAmount, t.discAmount, t.Amount-t.discAmount as 'tNetAmount' , t.ponum as 'tPoNum', t.refnum2  tRefnum2,
              t.tranDate as 'tTranDate', t.dueDate as 'tDueDate',t.DiscDate as tDiscDate, t.id as 'tranId', t.state,  (case when  p.id is null then 0 else 1 end ) as 'isPending',
             null as 'text1', null as 'text2', null as 'text3', null as 'text4', null as 'text5', null as 'text6', null as 'text7', 
             null as 'text8', null as 'text9', null as 'text10', null as 'num1', null as 'num2', null as 'num3', null as 'num4',
             null as 'num5', null as 'num6', null as 'date1', null as 'date2', null as 'date3', null as 'date4'
             from   ArTran  t  with (nolock)
             LEFT OUTER  JOIN ArTranType tt  on tt.id=t.tranTypeId
             LEFT OUTER  JOIN ArTranPending p  on p.id=t.id
             LEFT OUTER JOIN CustAccount ca  on ca.id=t.custAccountId """
	)

    }

    changeSet(id: "${clid}.2-my", author: "Joanna", dbms:'mysql') {
        sql( """ create view vwPaymentDetailArTran as 
           select CONCAT('PD', CAST(pd.id AS CHAR)) as 'sourceId', p.CustId as 'custId' , p.id as 'paymentId',
             pd.ArTranType as 'pdArTranType' , pd.Amount as 'pdAmount', pd.DiscAmount as 'pdDiscAmount', pd.PayAmount as 'pdPayAmount', pd.id as 'pdId' ,
             pd.refnum as 'refnum', pd.custNum as 'custNum', pd.custAccountNum as 'custAccountNum',
             tt.Name as 'tTranType', t.amount as 'tAmount', t.origAmount as 'tOrigAmount', t.discAmount as 'tDiscAmount', t.netAmount  tNetAmount,
             t.match6 as 'tPoNum', t.match7  tRefnum2,  t.tranDate as 'tTranDate', t.dueDate as 'tDueDate', t.DiscDate as tDiscDate, t.id as 'tranId', null as 'state', 0 as 'isPending',
             null as 'text1', null as 'text2', null as 'text3', null as 'text4', null as 'text5', null as 'text6', null as 'text7', 
             null as 'text8', null as 'text9', null as 'text10', null as 'num1', null as 'num2', null as 'num3', null as 'num4',
             null as 'num5', null as 'num6', null as 'date1', null as 'date2', null as 'date3', null as 'date4'
             from PaymentDetail pd
             inner JOIN Payment p   on p.id=pd.PaymentId
             left outer JOIN ArTranMatch t   on pd.arTranId=t.ArTranTypeId
             left outer JOIN ArTranType tt  on tt.id=t.id

             UNION
            select CONCAT('TR', CAST(t.id AS CHAR)) as 'sourceId', t.custId, null,
             null , null, null, null, null,
             t.refnum, t.custNum, ca.num,
             ifnull(tt.Name, 'IN'),  t.amount-ifnull((select sum(pd.amount) from PaymentDetail pd  , Payment p   where pd.arTranId=t.id and p.id=pd.paymentId and p.arPostedDate is not null),0) as 'tAmount',
             t.origAmount, t.discAmount, t.Amount-t.discAmount  tNetAmount, t.ponum as 'tPoNum', t.refnum2  tRefnum2,
              t.tranDate as 'tTranDate', t.dueDate as 'tDueDate', t.DiscDate as tDiscDate, t.id as 'tranId', t.state,  (case when  p.id is null then 0 else 1 end ) as 'isPending',
             null as 'text1', null as 'text2', null as 'text3', null as 'text4', null as 'text5', null as 'text6', null as 'text7', 
             null as 'text8', null as 'text9', null as 'text10', null as 'num1', null as 'num2', null as 'num3', null as 'num4',
             null as 'num5', null as 'num6', null as 'date1', null as 'date2', null as 'date3', null as 'date4'
             from   ArTran  t
             LEFT OUTER  JOIN ArTranType tt  on tt.id=t.tranTypeId
             LEFT OUTER  JOIN ArTranPending p  on p.id=t.id
             LEFT OUTER JOIN CustAccount ca  on ca.id=t.custAccountId """
	)
    }

    changeSet(id: "${clid}.2-or", author: "Joanna", dbms:'oracle') {
        sql( """ create view vwPaymentDetailArTran as 
           select ('PD' || CAST(pd.id AS varchar(1000))) sourceId, p.CustId  custId , p.id  paymentId,
             pd.ArTranType  pdArTranType , pd.Amount  pdAmount, pd.DiscAmount  pdDiscAmount, pd.PayAmount  pdPayAmount, pd.id  pdId ,
             pd.refnum  refnum, pd.custNum  custNum, pd.custAccountNum  custAccountNum,
             tt.Name  tTranType, t.amount  tAmount, t.origAmount  tOrigAmount, t.discAmount  tDiscAmount, t.netAmount  tNetAmount,
             t.match6  tPoNum,t.match7  tRefnum2,   t.tranDate  tTranDate, t.dueDate  tDueDate, t.DiscDate tDiscDate,  t.id  tranId, null  state, 0  isPending,
             null as 'text1', null as 'text2', null as 'text3', null as 'text4', null as 'text5', null as 'text6', null as 'text7', 
             null as 'text8', null as 'text9', null as 'text10', null as 'num1', null as 'num2', null as 'num3', null as 'num4',
             null as 'num5', null as 'num6', null as 'date1', null as 'date2', null as 'date3', null as 'date4'
             from PaymentDetail pd
             inner JOIN Payment p  on p.id=pd.PaymentId
             left outer JOIN ArTranMatch t  on pd.arTranId=t.ArTranTypeId
             left outer JOIN ArTranType tt  on tt.id=t.id


             UNION
             select ('TR' || CAST(t.id AS  varchar(1000)))  sourceId, t.custId, null,
             null , null, null, null, null,
             t.refnum, t.custNum, ca.num,
             nvl(tt.Name, 'IN'),  t.amount-nvl((select sum(pd.amount) from Paymentdetail pd , Payment p where pd.arTranId=t.id and p.id=pd.paymentId and p.arPostedDate is not null),0)  tAmount,
             t.origAmount, t.discAmount,  t.Amount - t.discAmount tNetAmount, t.ponum  tPoNum, t.refnum2  tRefnum2,
              t.tranDate  tTranDate, t.dueDate  tDueDate, t.DiscDate tDiscDate, t.id  tranId, t.state ,  (case when  p.id is null then 0 else 1 end )  isPending,
             null as 'text1', null as 'text2', null as 'text3', null as 'text4', null as 'text5', null as 'text6', null as 'text7', 
             null as 'text8', null as 'text9', null as 'text10', null as 'num1', null as 'num2', null as 'num3', null as 'num4',
             null as 'num5', null as 'num6', null as 'date1', null as 'date2', null as 'date3', null as 'date4'
             from   ArTran  t
             LEFT OUTER  JOIN ArTranType tt  on tt.id=t.tranTypeId
             LEFT OUTER  JOIN ArTranPending p  on p.id=t.id
             LEFT OUTER JOIN CustAccount ca  on ca.id=t.custAccountId """

	)
    }



}
