-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 19.01.2020
-- Description:	
-- =============================================
CREATE PROCEDURE WorkshopReservationDetails
	@ReservationID int = 0
AS
BEGIN
	SET NOCOUNT ON;

	SELECT WR.WorkshopReservationID, WR.ReservationDate, WR.Cancelled, W.Price,
		   WR.PaymentDeadline, WR.ParticipantID, W.WorkshopID, W.WorkshopName,
		   W.Cancelled, W.Limit
	FROM [Workshop Reservations] AS WR
	INNER JOIN Workshops AS W
	ON WR.WorkshopReservationID = @ReservationID AND WR.WorkshopID = W.WorkshopID
END
GO
