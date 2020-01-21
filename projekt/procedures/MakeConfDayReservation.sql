USE [u_jastrzab]
GO
/****** Object:  StoredProcedure [dbo].[AddOrganizer]    Script Date: 21.01.2020 13:34:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE MakeConfDayReservation
	@ConferenceDayID INT,
	@ParticipantsNumber INT = 1,
	@NumberOfStudents INT = 0,
	@ClientID INT
AS
BEGIN
	
	SET NOCOUNT ON;

	INSERT INTO [Conference Reservations](
	ConferenceDayID,
	ParticipantsNumber,
	NumberOfStudents,
	ClientID,
	ReservationDate,
	Cancelled)
	VALUES(@ConferenceDayID,
	@ParticipantsNumber,
	@NumberOfStudents,
	@ClientID,
	GETDATE(),
	0)
END