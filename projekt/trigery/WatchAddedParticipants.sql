SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER dbo.WatchAddedParticipants
   ON  dbo.Participants
   AFTER INSERT
AS 
BEGIN

	SET NOCOUNT ON;

	DECLARE @PersonID INT;
	DECLARE @ReservationID INT;
	DECLARE @ConferenceDayID INT;

	SELECT @PersonID = PersonID, @ReservationID = ReservationID
	FROM inserted

	SELECT @ConferenceDayID = ConferenceDayID
	FROM [Conference Reservations] as CR
	WHERE CR.ReservationID = @ReservationID

	IF @PersonID in (SELECT PART.PersonID
		FROM [Conference Days] as CD
		INNER JOIN [Conference Reservations] as CR
		ON CD.ConferenceDayID = @ConferenceDayID 
		AND CD.ConferenceDayID = CR.ConferenceDayID
		INNER JOIN Participants as PART
		ON CR.Cancelled = 0 AND CR.ReservationID = PART.ReservationID
		)
	BEGIN
		RAISERROR('Person is already registred for this conference day', 1, 1);
		ROLLBACK TRANSACTION;
	END

	IF EXISTS(SELECT 'YES' 
		FROM [Conference Reservations] AS CR
		INNER JOIN Participants as PART
		ON CR.ReservationID = @ReservationID AND CR.ReservationID = PART.ReservationID
		GROUP BY CR.ReservationID, CR.ParticipantsNumber
		HAVING CR.ParticipantsNumber <= COUNT(PART.ParticipantID)
		)
	BEGIN
		RAISERROR('All participants are already added to reservation', 1, 1);
		ROLLBACK TRANSACTION;
	END

	IF EXISTS(SELECT 'YES' 
		FROM [Conference Reservations] AS CR
		INNER JOIN Participants as PART
		ON CR.ReservationID = @ReservationID AND CR.ReservationID = PART.ReservationID
		INNER JOIN People as P
		ON PART.PersonID = P.PersonID AND P.Student = 1
		GROUP BY CR.ReservationID, CR.ParticipantsNumber
		HAVING CR.NumberOfStudents <= COUNT(PART.ParticipantID)
		)
	BEGIN
		RAISERROR('All participants are already added to reservation', 1, 1);
		ROLLBACK TRANSACTION;
	END
END
GO
