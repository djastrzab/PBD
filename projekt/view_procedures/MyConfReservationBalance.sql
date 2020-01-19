USE [u_jastrzab]
GO
/****** Object:  StoredProcedure [dbo].[MyConfReservationsBalance]    Script Date: 19.01.2020 15:57:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 19.01,2020
-- Description:	Shows reservations with their payment balance for the client
-- =============================================
ALTER PROCEDURE [dbo].[MyConfReservationsBalance] 
	@ClientID int = 0
AS
BEGIN
	SET NOCOUNT ON;

    
	SELECT R.ReservationID, R.Cancelled, R.FinalPrice, R.PaymentsSum, R.ToPay, dbo.CalculatePaymentDeadline(R.ReservationID)
	FROM [Conf Reservations Payments Balance] AS R
	WHERE R.ClientID = @ClientID
END
