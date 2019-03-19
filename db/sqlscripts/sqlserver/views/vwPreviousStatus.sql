CREATE VIEW dbo.vwPreviousStatus AS 
Select max(H.EditedDate) AS MaxDate, AR.ID AS ARDocID, MAX(H.OldValue) as OldStatus, MAX(H.NewValue) as NewStatus
FROM dbo.ArTran AR LEFT OUTER JOIN dbo.History H on (AR.ID=H.LinkedID)
WHERE (H.linkedtable = 'ARDocs') and H.ColumnName='Status'
GROUP BY AR.ID