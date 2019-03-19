
CREATE PROCEDURE  test_CorrectionPostProcess (in paymentid int)
  BEGIN

    update Payment
    set routingNum = 2
    where id = paymentid;

    update PaymentDetail set oldDiscAmount=9
    where  PaymentDetail.paymentid = paymentid;

  END