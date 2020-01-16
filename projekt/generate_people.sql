USE [u_jastrzab]
GO

declare @i int = 0
while @i<20
begin
INSERT INTO [dbo].[People]
           ([Firstname]
           ,[Lastname]
           ,[Student]
           ,[CompanyID])
     VALUES
           ('name'
           ,'lastname'
           ,1
		   ,null
           )
SET @i = @i + 1;
end
GO


