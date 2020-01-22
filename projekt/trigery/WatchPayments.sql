SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER dbo.WatchPayments
   ON  dbo.Payments
   AFTER INSERT
AS 
BEGIN

	SET NOCOUNT ON;

	DECLARE @IsConference BIT;
	SELECT @IsConference = IsConference FROM inserted

	IF (@IsConference = 1)
	BEGIN 
		IF EXISTS(SELECT 'YES'
			FROM inserted as I
			INNER JOIN [Conf Reservations Payments Balance] as CB
			ON I.ReservationId = CB.ReservationID
			WHERE I.Payment > 0 AND CB.ToPay < 0
			)
		BEGIN
			RAISERROR('You can not pay for the reservation which
			is already fully paid', 1, 1);
			ROLLBACK TRANSACTION;
		END
	END
	ELSE
	BEGIN
		IF EXISTS(SELECT 'YES'
			FROM inserted as I
			INNER JOIN [Workshop Reservations Payments Balance] as WB
			ON I.ReservationId = WB.WorkshopReservationID
			WHERE I.Payment > 0 AND WB.ToPay < 0
			)
		BEGIN
			RAISERROR('You can not pay for the reservation which
			is already fully paid', 1, 1);
			ROLLBACK TRANSACTION;
		END
	END
END
GO
