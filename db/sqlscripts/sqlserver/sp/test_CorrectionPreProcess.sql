
create PROCEDURE [dbo].[test_CorrectionPreProcess] @paymentid int output
AS
Begin TRANSACTION

   update payment
   set accountNum = 1
   where id = @paymentid

	update paymentdetail  set glAcct='9'
	from paymentdetail
	where  paymentdetail.paymentid =  @paymentid

COMMIT