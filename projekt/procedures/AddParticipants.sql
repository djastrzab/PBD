USE [u_jastrzab]
GO
/****** Object:  StoredProcedure [dbo].[AddPerson]    Script Date: 21.01.2020 14:06:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE AddParticipants
	@PersonID INT,
	@ReservationID INT
AS
BEGIN
	
	SET NOCOUNT ON;

	INSERT INTO Participants(ReservationID, PersonID)
	VALUES(@ReservationID, @PersonID)
END