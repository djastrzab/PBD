USE [u_jastrzab]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE AddAddress
	@Street NVARCHAR(40),
	@Zipcode VARCHAR(12),
	@City NVARCHAR(40),
	@Country NVARCHAR(20)
AS
BEGIN
	
	SET NOCOUNT ON;

	INSERT INTO Address(Street, Zipcode, City, Country)
	VALUES(@Street, @Zipcode, @City, @Country)
END