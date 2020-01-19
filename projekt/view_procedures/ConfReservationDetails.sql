USE [u_jastrzab]
GO
/****** Object:  StoredProcedure [dbo].[ConfReservationDetails]    Script Date: 19.01.2020 15:57:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 19.01.2020
-- Description:	Show details of certain reservation
-- =============================================
ALTER PROCEDURE [dbo].[ConfReservationDetails]
	@ReservationID int = 0
AS
BEGIN
	SET NOCOUNT ON;

	SELECT CR.ReservationID, CR.ReservationDate, CR.Cancelled, CR.ParticipantsNumber,
		   CR.NumberOfStudents, dbo.CalculatePaymentDeadline(CR.ReservationID), CR.ClientID, CD.Day, CD.Limit,
		   C.ConferenceID, C.ConferenceName, C.Cancelled
	FROM [Conference Reservations] AS CR
	INNER JOIN [Conference Days] AS CD
	ON CR.ReservationID = @ReservationID AND CR.ConferenceDayID = CD.ConferenceDayID
	INNER JOIN Conferences AS C
	ON CD.ConferenceID = C.ConferenceID
END
