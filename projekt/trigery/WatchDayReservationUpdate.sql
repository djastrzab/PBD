SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER dbo.WatchDayReservationUpdate 
   ON  dbo.[Conference Reservations]
   AFTER UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	IF EXISTS(SELECT NEW_RES.ReservationID
		FROM inserted as NEW_RES
		INNER JOIN Participants AS P
		ON NEW_RES.ReservationID = P.ReservationID
		GROUP BY NEW_RES.ReservationID
		HAVING COUNT(P.ParticipantID) > NEW_RES.ParticipantsNumber
		)
	BEGIN
		RAISERROR('You can not reduce Particiapnts Number
		as you already added too much participants to reservation', 1, 1);
		ROLLBACK TRANSACTION;
	END

	IF EXISTS(SELECT NEW_RES.ReservationID
		FROM inserted as NEW_RES
		INNER JOIN Participants AS PART
		ON NEW_RES.ReservationID = PART.ReservationID
		INNER JOIN People AS P
		ON PART.PersonID = P.PersonId AND P.Student = 1
		GROUP BY NEW_RES.ReservationID
		HAVING COUNT(PART.ParticipantID) > NEW_RES.NumberOfStudents
		)
	BEGIN
		RAISERROR('You can not reduce NumberOfStudents
		as you already added too much students to reservation', 1, 1);
		ROLLBACK TRANSACTION;
	END
END
GO

