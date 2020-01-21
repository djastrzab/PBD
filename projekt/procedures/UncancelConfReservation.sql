SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE UncancelConfReservation
	@ReservationID int = 0
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE [Conference Reservations]
	SET Cancelled = 0
	WHERE ReservationID = @ReservationID
END
GO
