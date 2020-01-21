USE [u_jastrzab]
GO
/****** Object:  StoredProcedure [dbo].[CancelConfReservation]    Script Date: 21.01.2020 14:49:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE ChangeContactAddress
	@InformationID INT,
	@Street NVARCHAR(40),
	@Zipcode NVARCHAR(12),
	@City NVARCHAR(40),
	@Country NVARCHAR(20)
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @AddressID INT;
	EXEC dbo.AddAddress @Street,  @Zipcode, @City, @Country
	SELECT @AddressID = MAX(AddressID) FROM Address

	UPDATE [Contact Information]
	SET AddressID = @AddressID
	WHERE InformationId = @InformationID
END
