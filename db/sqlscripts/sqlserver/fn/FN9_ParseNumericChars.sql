/** 
 * Function removes all non  numeric characters.
 */
CREATE FUNCTION [dbo].[FN9_parseNumericChars]
(
	@string varchar(5000)
)
RETURNS varchar(5000)
AS
BEGIN
     declare    @charPos int
     set @charPos = patindex('%[^0-9]%', @string)
     while @charPos > 0 begin
          set @string = stuff(@string, @charPos, 1, '')
          set @charPos = patindex('%[^0-9]%', @string)
     end
     set @string = @string
     return @string
END