
create PROCEDURE  test_CorrectionPostProcess @paymentid int output
AS
Begin TRANSACTION

-- FIXME enable it when oid is renamed to id
   update payment
   set routingNum = 2
   where id = @paymentid

	update paymentdetail  set oldDiscAmount=9
	from paymentdetail
	where  paymentdetail.paymentid =  @paymentid

COMMIT