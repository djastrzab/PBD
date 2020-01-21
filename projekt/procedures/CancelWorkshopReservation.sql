SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE CancelWorkshopReservation
	@ReservationID int = 0
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE [Workshop Reservations]
	SET Cancelled = 1
	WHERE WorkshopReservationID = @ReservationID
END
GO
