USE [u_jastrzab]
GO
/****** Object:  StoredProcedure [dbo].[AddOrganizer]    Script Date: 21.01.2020 14:20:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE AddIndividualClient
	@FirstName NVARCHAR(20),
	@LastName NVARCHAR(30),
	@Student BIT = 0,
	@CompanyID INT = NULL,
	@Email NVARCHAR(40) = NULL,
	@Phone VARCHAR(15),
	@Street NVARCHAR(40) = NULL,
	@Zipcode VARCHAR(12) = NULL,
	@City NVARCHAR(40) = NULL,
	@Country NVARCHAR(20) = NULL
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @PersonID INT;
	DECLARE @InformationID INT;
	DECLARE @AddressID INT;
	
	IF @Street IS NOT NULL AND @Zipcode IS NOT NULL
	AND @City IS NOT NULL AND @Country IS NOT NULL
	BEGIN		
		SELECT @AddressID = A.AddressID
		FROM Address AS A
		WHERE A.City LIKE @City AND A.Country LIKE @Country
		AND A.Zipcode LIKE @Zipcode AND A.Street LIKE @Street

		IF @AddressID is NULL
		BEGIN
			EXEC dbo.AddAddress @Street, @Zipcode, @City, @Country
			SELECT @AddressID = MAX(AddressID) FROM Address
		END
	END

	SELECT @InformationID = InformationId
	FROM [Contact Information]
	WHERE Phone LIKE @Phone

	IF @InformationID IS NULL
	BEGIN
		EXEC dbo.AddContactInformation @Phone, @Email, @AddressID
		SELECT @InformationID = MAX(InformationID) FROM [Contact Information]
	END
	ELSE
	BEGIN
		UPDATE [Contact Information]
		SET AddressID = @AddressID, Email = @Email
		WHERE InformationId = @InformationID
	END

	EXEC dbo.AddPerson @FirstName, @LastName, @Student, @CompanyID
	SELECT @PersonID = MAX(PersonID) FROM PEOPLE 

	INSERT INTO Clients(CompanyID, PersonID, InformationID)
	VALUES(@CompanyID, @PersonID, @InformationID)
END