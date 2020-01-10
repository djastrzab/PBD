USE [u_jastrzab]
GO
declare @i int =0
while @i<300
begin
INSERT INTO [dbo].[Clients]
           ([InformationID])
     VALUES
           (@i)
set @i=@i+1
end

GO



