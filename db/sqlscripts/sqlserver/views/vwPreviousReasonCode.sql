CREATE VIEW dbo.vwPreviousReasonCode AS 
Select max(H.EditedDate) AS MaxDate, AR.ID AS ARDocID, MAX(H.OldValue) as OldReason, MAX(H.NewValue) as NewReason
FROM dbo.ArTran AR LEFT OUTER JOIN dbo.History H on (AR.ID=H.LinkedID)
WHERE (H.linkedtable = 'ARDocs') and H.ColumnName='Reason'
GROUP BY AR.ID
