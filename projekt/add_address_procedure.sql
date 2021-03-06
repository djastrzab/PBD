USE [u_jastrzab]
GO
/****** Object:  StoredProcedure [dbo].[AddAddress]    Script Date: 22.01.2020 13:06:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[AddAddress]
	@Street NVARCHAR(40),
	@Zipcode NVARCHAR(12),
	@City NVARCHAR(40),
	@Country NVARCHAR(20)
AS
BEGIN
	SET IDENTITY_INSERT Address ON
	SET NOCOUNT ON;
	declare @AddressID int
	SELECT @AddressID = ISNULL(MAX(AddressID), 0) + 1 from dbo.Address

	INSERT INTO Address(AddressID,Street, Zipcode, City, Country)
	VALUES(@AddressID,@Street, @Zipcode, @City, @Country)
	SET IDENTITY_INSERT Address off
END