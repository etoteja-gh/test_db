create   VIEW dbo.vwNotesByCustomer
AS
SELECT     N.ID, N.Version, N.Visible, N.LinkedTable, N.LinkedID,
left(N.Note,200) as NoteText, ''
AS ARDocRefNum, N.CreatedDate AS CreatedDate, N.CreatedBy,
                      dbo.Contact.Name AS CreatedByNm, N.ActivityID,
1 AS Editable
FROM         dbo.Notes N LEFT OUTER JOIN
                      dbo.Contact ON N.CreatedBy = dbo.Contact.ID
WHERE     (N.LinkedTable = 'Orgs')
UNION
 (SELECT     NAR.ID, NAR.Version, NAR.Visible, NAR.LinkedTable, AR.CustID
AS LinkedCustID,
left(NAR.Note,200), AR.RefNum AS ARDocRefNum,
                       NAR.CreatedDate CreatedDate, NAR.CreatedBy,
dbo.Contact.Name AS CreatedByNm,
NAR.ActivityID, 1 Editable
 FROM         dbo.Notes NAR LEFT OUTER JOIN
                       dbo.ArTran AR ON NAR.LinkedID = AR.ID LEFT OUTER
JOIN
                       dbo.Contact ON NAR.CreatedBy = dbo.Contact.ID
 WHERE     (NAR.LinkedTable = 'ArTran'))
UNION
(SELECT     A.ID, A.Version, 1 AS Visible, A.LinkedTable, A.LinkedID, 'Act
Subject:' +
isnull(A.Subject, '') + ' Comment:' + isnull(A.Comments, '') + CHAR(13)
                        + 'Owner:' + isnull(SChedFor.Name, '') + '
Contact:' +
isnull(Contact.name, '') + CHAR(13) + 'Type:' + isnull(A.Activity, '')
                        + '  Result:' +
CHAR(13) + 'Act Date:' +
CONVERT(varchar, A.ActDate, 101) + '  ' + DATENAME(hh, A.ActDate)
                        + ':' + DATENAME(mi, A.ActDate) AS Note, '' AS
ARDocRefNum, A.EditedDate
CreatedDate, A.EditedBy, P.Name AS CreatedByNm,
                        A.ID AS ActivityID, 0 AS Editable
 FROM         dbo.Activities A LEFT OUTER JOIN
                        dbo.Contact P ON A.EditedBy = P.ID LEFT OUTER JOIN
                        dbo.Contact SChedFor ON A.UserID = SChedFor.ID LEFT
OUTER JOIN
                        dbo.Contact Contact ON A.ContactID = Contact.ID
 WHERE     (A.LinkedTable = 'Orgs' AND A.Completed = 1 AND A.comments is not
null and A.comments <>
''))
UNION
(SELECT     A.ID, A.Version, 1 AS Visible, A.LinkedTable, D .CustID,
left(A.Comments,200) AS Note,
--'' AS ARDocRefNum, A.CreatedDate CreatedDate, A.CreatedBy,
'' AS ARDocRefNum, A.CompletedDate CreatedDate, 
case
 when A.CompletedBy is null or   A.CompletedBy =0 then 
  case when a.Editedby is null or   A.Editedby =0 then a.createdby
       else a.editedby
  end
 else a.completedby
end createdby,
                        P.Name AS CreatedByNm, A.ID AS ActivityID,
0 Editable
 FROM         dbo.Activities A LEFT OUTER JOIN
    dbo.Contact P ON 
         (case
   when A.CompletedBy is null or   A.CompletedBy =0 then 
    case when a.Editedby is null or   A.Editedby =0 then a.createdby
         else a.editedby
    end
   else a.completedby
   end) = P.ID
  LEFT OUTER JOIN
                        dbo.ArTran D ON D.ID = A.LinkedID LEFT OUTER JOIN
                        dbo.Org O ON O.ID = D.CustID
 WHERE     (A.LinkedTable = 'ArTran') AND NOT A.Comments IS NULL AND NOT
A.Comments IN ('') AND
A.Completed = 1)
