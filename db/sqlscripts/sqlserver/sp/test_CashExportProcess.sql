
create PROCEDURE [dbo].[test_ExportCashProcess] @batchId int output
AS
Begin TRANSACTION

	-- XXX put back in when arBatch has id column
   update ArBatch set name='exported' where id = @batchId

COMMIT