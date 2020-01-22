SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER dbo.WatchWorkshopReservation
   ON  dbo.[Workshop Reservations]
   AFTER INSERT
AS 
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @WorkshopID INT;
	DECLARE @ParticipantID INT;

	SELECT @WorkshopID = WorkshopID, @ParticipantID = ParticipantID FROM inserted

	IF dbo.CanRegisterForWorkshop(@ParticipantID, @WorkshopID) = 0
	BEGIN
		RAISERROR('Participant can not register for this workshop', 1, 1);
		ROLLBACK TRANSACTION;
	END

	IF @ParticipantID in (SELECT WR.ParticipantID
		FROM Workshops AS W
		INNER JOIN [Workshop Reservations] AS WR
		ON W.WorkshopID = @WorkshopID AND W.WorkshopID = WR.WorkshopID
		WHERE WR.Cancelled = 0
		)
	BEGIN
		RAISERROR('Participant is already registred for workshop', 1, 1);
		ROLLBACK TRANSACTION;
	END

	IF EXISTS( SELECT 'YES'
		FROM [Workshops Available Spaces] as W
		WHERE W.WorkshopID = @WorkshopID AND W.Free > 0
		)
	BEGIN
		RAISERROR('Workshop is full', 1, 1);
		ROLLBACK TRANSACTION;
	END

END
GO
