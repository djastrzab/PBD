USE [u_jastrzab]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE AddContactInformation
	@Phone VARCHAR(15),
	@Email  NVARCHAR(40) = NULL,
	@AddressID INT = NULL
AS
BEGIN
	
	SET NOCOUNT ON;

	INSERT INTO [Contact Information](Email, Phone, AddressID)
	VALUES(@Email, @Phone, @AddressID)
END