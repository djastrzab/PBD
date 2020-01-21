USE [u_jastrzab]
GO
/****** Object:  StoredProcedure [dbo].[CancelConfReservation]    Script Date: 21.01.2020 14:49:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE ChangeParticipantsNumber
	@ReservationID INT,
	@NewParticipantsNumber INT,
	@NewStudentsNumber INT = NULL

AS
BEGIN

	SET NOCOUNT ON;

	IF @NewStudentsNumber IS NOT NULL
	BEGIN
		UPDATE [Conference Reservations]
		SET NumberOfStudents = @NewStudentsNumber
		WHERE ReservationID = @ReservationID
	END
	UPDATE [Conference Reservations]
	SET ParticipantsNumber = @NewParticipantsNumber
	WHERE ReservationID = @ReservationID
END
