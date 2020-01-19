-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 19.01.2020
-- Description:	Calculates payment deadline for a conference reservation
-- =============================================
CREATE FUNCTION CalculatePaymentDeadline 
(
	@ReservationID int
)
	RETURNS date
	AS
		BEGIN
			DECLARE @Result date;

			SELECT @Result = R.ReservationDate
			FROM [Conference Reservations] AS R
			WHERE R.ReservationID = @ReservationID

			RETURN DATEADD(week, 2, @Result)
	END
GO

