/*This is essentially a copy of "vwLastNotesUnion" but relates the last notes to ARDocs. 
Create the view with the most recent notes from the Ardocs table and the notes in the Notes table 
that are realated to ARDocs  (tpl 2004.10.20 */ 
CREATE VIEW dbo.vwLastNotesUnionARDocs AS 
Select max(N.CreatedDate) AS MaxDate, AR.ID AS ARDocID, MAX(N.ID) as NoteID
FROM ArTran AR LEFT OUTER JOIN dbo.Notes N on (AR.ID=N.LinkedID)
WHERE (N.linkedtable = 'ARDocs')
GROUP BY AR.ID

