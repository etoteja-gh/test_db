
CREATE PROCEDURE test_CorrectionPreProcess (in paymentid int)
BEGIN

  update Payment
  set accountNum = 1
  where id = paymentid;

  update PaymentDetail set glAcct='9'
  where  PaymentDetail.paymentid =  paymentid;

END