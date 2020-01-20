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
-- Description:	It checks if user can register for a workshop
-- =============================================
CREATE FUNCTION CanRegisterForWorkshop 
(
	@ParticipantID int,
	@WorkshopID int
)
RETURNS bit
AS
BEGIN

	DECLARE @Result bit
	DECLARE @ConferenceDayID int;
	DECLARE @WorkshopStartDate date;
	DECLARE @WorkshopEndDate date;
	SELECT @ConferenceDayID = W.ConferenceDayID,
	@WorkshopStartDate = W.StartDate,
	@WorkshopEndDate = W.EndDate
	FROM Workshops AS W
	WHERE W.WorkshopID = @WorkshopID

	IF @ParticipantID not in (
		SELECT P.ParticipantID
		FROM [Conference Days] AS CD
		INNER JOIN [Conference Reservations] AS CR
		ON CD.ConferenceDayID = @ConferenceDayID AND CD.ConferenceDayID = CR.ConferenceDayID
		INNER JOIN Participants AS P
		ON CR.ReservationID = P.ReservationID
		)
	BEGIN
		RETURN 0;
	END

	DECLARE @count INT;
	SELECT @count = COUNT(*)
		FROM Workshops W
		INNER JOIN [Workshop Reservations] AS WR
		ON W.WorkshopID = WR.WorkshopID
		INNER JOIN Participants AS P
		ON P.ParticipantID = @ParticipantID AND WR.ParticipantID = P.ParticipantID
		WHERE W.StartDate <= @WorkshopEndDate AND W.EndDate >= @WorkshopStartDate

	RETURN iif(@count > 0, 0, 1);
END
GO

