USE [u_jastrzab]
GO
/****** Object:  StoredProcedure [dbo].[ConfReservationDetails]    Script Date: 19.01.2020 16:12:36 ******/
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

	SELECT CR.ReservationID, CR.ReservationDate, CR.Cancelled,
		   CR.ParticipantsNumber, CR.NumberOfStudents, CR_BALANCE.FinalPrice,
		   CR_BALANCE.ToPay, CR_BALANCE.PaymentDeadline, CR.ClientID, CD.Day,
		   CD.Limit, C.ConferenceID, C.ConferenceName, C.Cancelled
	FROM [Conference Reservations] AS CR
	INNER JOIN [Conference Days] AS CD
	ON CR.ReservationID = @ReservationID AND CR.ConferenceDayID = CD.ConferenceDayID
	INNER JOIN Conferences AS C
	ON CD.ConferenceID = C.ConferenceID
	INNER JOIN [Conf Reservations Payments Balance] AS CR_BALANCE
	ON CR.ReservationID = CR_BALANCE.ReservationID
END
