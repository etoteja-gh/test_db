
--if exists(select * from sysobjects where name = 'Customer') drop view Customer;
if exists(select * from sysobjects where name = 'SalesOrgs') drop view SalesOrgs;
if exists(select * from sysobjects where name = 'Salesperson') drop view Salesperson;
if exists(select * from sysobjects where name = 'vwLastNotesUnionARDocs') drop view vwLastNotesUnionARDocs;
if exists(select * from sysobjects where name = 'vwNotesByCustomer') drop view vwNotesByCustomer;
if exists(select * from sysobjects where name = 'vwSplitGroupBalance') drop view vwSplitGroupBalance;
if exists(select * from sysobjects where name = 'vwPreviousReasonCode') drop view vwPreviousReasonCode;
if exists(select * from sysobjects where name = 'vwPreviousStatus') drop view vwPreviousStatus;
if exists(select * from sysobjects where name = 'ArbatchHistory') drop view ArbatchHistory;
if exists(select * from sysobjects where name = 'PaymentsHistory') drop view PaymentsHistory;
if exists(select * from sysobjects where name = 'PaymentDetailHistory') drop view PaymentDetailHistory;
if exists(select * from sysobjects where name = 'vwArbatch') drop view vwArbatch;
if exists(select * from sysobjects where name = 'vwPayments') drop view vwPayments;
if exists(select * from sysobjects where name = 'vwPaymentDetail') drop view vwPaymentDetail;