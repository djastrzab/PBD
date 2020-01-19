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
-- Create date: 19.01,2020
-- Description:	Shows reservations with their payment balance for the client
-- =============================================
CREATE PROCEDURE MyWorkshopReservationsBalance 
	@PersonID int = 0
AS
BEGIN
	SET NOCOUNT ON;
    
	SELECT WR.WorkshopReservationID, WR.Cancelled, WR.Price, WR.PaymentsSum, WR.ToPay
	FROM People AS P
	INNER JOIN Participants AS PART
	ON P.PersonID = @PersonID AND P.PersonID = PART.PersonID
	INNER JOIN [Workshop Reservations Payments Balance] AS WR
	ON PART.ParticipantID = WR.ParticipantID
END
GO
