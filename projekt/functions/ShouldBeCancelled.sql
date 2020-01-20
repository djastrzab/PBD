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
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION ShouldBeCancelled 
(
	@ReservationID int
)
RETURNS bit
AS
BEGIN

	DECLARE @Deadline date;
	DECLARE @ToPay money;

	SELECT @Deadline = CR.PaymentDeadline, @ToPay = CR.ToPay
	FROM [Conf Reservations Payments Balance] AS CR
	WHERE CR.ReservationID = @ReservationID

	DECLARE @Result bit;
	SET @Result =IIF((@ToPay > 0 and getdate() > @Deadline), 1, 0)

	RETURN @Result

END
GO

