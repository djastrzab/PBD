USE [u_jastrzab]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE AddCompany
	@CompanyName NVARCHAR(50),
	@NIP VARCHAR(15),
	@ContactName VARCHAR(30) = NULL
AS
BEGIN
	
	SET NOCOUNT ON;

	INSERT INTO Companies(CompanyName, NIP, ContactName)
	VALUEs(@CompanyName, @NIP, @ContactName)
END