USE [u_jastrzab]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE AddConference
	@ConferenceName NVARCHAR(100),
	@ConferenceDescription NVARCHAR(250) = NULL,
	@StudentDiscount FLOAT = 0,
	@BasePrice MONEY,
	@PriceIncreasePerDay FLOAT = 0,
	@OrganizerID INT,
	@Street NVARCHAR(40),
	@Zipcode VARCHAR(12),
	@City NVARCHAR(40),
	@Country NVARCHAR(20),
	@StartDate DATE
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @AddressID INT;
	
	SELECT @AddressID = A.AddressID
	FROM Address AS A
	WHERE A.City LIKE @City AND A.Country LIKE @Country
	AND A.Zipcode LIKE @Zipcode AND A.Street LIKE @Street

	IF @AddressID is NULL
	BEGIN
		INSERT INTO Address(Street, City, Zipcode, Country)
		VALUES(@Street, @City, @Zipcode, @Country)
		
		SELECT @AddressID = SCOPE_IDENTITY()
	END

	INSERT INTO Conferences(
		ConferenceName,
		ConferenceDescription,
		StudentDiscount,
		Cancelled,
		BasePrice,
		PriceIncreasePerDay,
		AddressID,
		OrganizerID,
		StartDate,
		AddedOn
		)
	VALUES(
		@ConferenceName,
		@ConferenceDescription,
		@StudentDiscount,
		0,
		@BasePrice,
		@PriceIncreasePerDay,
		@AddressID,
		@OrganizerID,
		@StartDate,
		GETDATE()
		)

END
