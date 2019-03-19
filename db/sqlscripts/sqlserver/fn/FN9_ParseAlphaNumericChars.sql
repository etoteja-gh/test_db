/** 
 * Function removes all non alpha numeric characters.
 */
CREATE FUNCTION [dbo].[FN9_parseAlphaNumericChars]
(
	@string varchar(5000)
)
RETURNS varchar(5000)
AS
BEGIN
     declare    @charPos int
     set @charPos = patindex('%[^0-9A-Za-z]%', @string)
     while @charPos > 0 begin
          set @string = stuff(@string, @charPos, 1, '')
          set @charPos = patindex('%[^0-9A-Za-z]%', @string)
     end
     set @string = @string
     return @string
END