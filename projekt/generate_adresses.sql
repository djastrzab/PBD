USE [u_jastrzab]
GO
declare @i as int =0

while @i<300
begin
INSERT INTO [dbo].[Contact Information]
           (
           [Email]
           ,[Phone]
           ,[AddressID])
     VALUES
           (
           'email'
           ,'phone'
           ,null)
set @i=@i+1
end
GO


