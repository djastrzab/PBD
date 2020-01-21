USE [u_jastrzab]
GO
/****** Object:  StoredProcedure [dbo].[AddCompany]    Script Date: 21.01.2020 13:55:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE CancelUnpaidReservations
AS
BEGIN
	
	SET NOCOUNT ON;

	UPDATE [Conference Reservations]
	SET Cancelled = 1
	WHERE ReservationID in (
		SELECT CR.ReservationID
		FROM [Conference Reservations] AS CR
		WHERE dbo.ShouldBeCancelled(Cr.ReservationID) = 1
		)
END