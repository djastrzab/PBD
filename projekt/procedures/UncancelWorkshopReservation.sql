SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE UncancelWorkshopReservation
	@ReservationID int = 0
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE [Workshop Reservations]
	SET Cancelled = 0
	WHERE WorkshopReservationID = @ReservationID
END
GO
