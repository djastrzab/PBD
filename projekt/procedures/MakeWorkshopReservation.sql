USE [u_jastrzab]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE MakeWorkshopReservation
	@WorkshopID INT,
	@ParticipantID INT
AS
BEGIN
	
	SET NOCOUNT ON;

	INSERT INTO [Workshop Reservations](
	WorkshopID,
	ParticipantID,
	Cancelled,
	ReservationDate
	)
	VALUES(@WorkshopID,
	@ParticipantID,
	0,
	GETDATE()
	)
END