USE [u_jastrzab]
GO
/****** Object:  StoredProcedure [dbo].[AddPerson]    Script Date: 21.01.2020 14:06:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE AddParticipantsToReservation
	@ReservationID INT,
	@FirstName NVARCHAR(50),
	@LastName VARCHAR(15),
	@Student VARCHAR(30) = 0,
	@CompanyID INT = NULL
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @PersonID INT;

	EXEC dbo.AddPerson @FirstName, @LastName, @Student, @CompanyID
	SELECT @PersonID = MAX(PersonID) FROM People

	EXEC dbo.AddParticipants @PersonID, @ReservationID
END