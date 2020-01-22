SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER dbo.WatchConfDayLimitExceed
   ON  dbo.[Conference Reservations]
   AFTER INSERT, UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	IF EXISTS(SELECT SUM(IIF(I.ReservationID IS NULL, CR.ParticipantsNumber, I.ParticipantsNumber))
		FROM [Conference Reservations] as CR
		LEFT OUTER JOIN inserted as I
		ON CR.ReservationID = I.ReservationID
		INNER JOIN [Conference Days] as CD
		ON CR.ConferenceDayID = CD.ConferenceDayID
		GROUP BY CD.ConferenceDayID, CD.Limit
		HAVING SUM(IIF(I.ReservationID IS NULL, CR.ParticipantsNumber, I.ParticipantsNumber)) > CD.Limit
	)
	BEGIN
		RAISERROR('You can not make a reservation because
		there are no enough free spaces on this day', 1, 1);
		ROLLBACK TRANSACTION;
	END
END
GO

