USE [u_jastrzab]
GO
for i as int
INSERT INTO [dbo].[People]
           ([PersonID]
           ,[Firstname]
           ,[Lastname]
           ,[Student]
           ,[CompanyID])
     VALUES
           (<PersonID, int,>
           ,<Firstname, nvarchar(50),>
           ,<Lastname, nvarchar(50),>
           ,<Student, bit,>
           ,<CompanyID, int,>)
GO


