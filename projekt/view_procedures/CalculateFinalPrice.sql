USE [u_jastrzab]
GO
/****** Object:  UserDefinedFunction [dbo].[CalculatePaymentDeadline]    Script Date: 19.01.2020 16:18:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 19.01.2020
-- Description:	Calculate final price for conf reservations
-- =============================================
CREATE FUNCTION [dbo].CalculateFinalPrice 
(
	@ReservationID int
)
	RETURNS money
	AS
		BEGIN
			DECLARE @BasePrice money;
			DECLARE @StudentDiscount float;
			DECLARE @Students int;
			DECLARE @Participants int;
			DECLARE @PriceIncreasePerDay money;
			DECLARE @ConfDate date;
			DECLARE @ReservationDate date;

			SELECT @BasePrice = C.BasePrice, @StudentDiscount = C.StudentDiscount,
			@PriceIncreasePerDay = C.PriceIncreasePerDay, @ConfDate = C.StartDate,
			@Students = CR.NumberOfStudents, @Participants = CR.ParticipantsNumber,
			@ReservationDate =CR.ReservationDate
			FROM [Conference Reservations] AS CR
			INNER JOIN [Conference Days] AS CD
			ON CR.ReservationID = @ReservationID AND CR.ConferenceDayID = CD.ConferenceDayID
			INNER JOIN Conferences AS C
			ON CD.ConferenceID = C.ConferenceID

			DECLARE @NormalPrice money = @BasePrice + DATEDIFF(day, @ConfDate, @ReservationDate)*@PriceIncreasePerDay
			DECLARE @StudentPrice money = @NormalPrice * (1 - @StudentDiscount)

			RETURN @NormalPrice*(@Participants - @Students) + @StudentPrice * @Students
	END
