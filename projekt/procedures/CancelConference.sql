USE [u_jastrzab]
GO
/****** Object:  StoredProcedure [dbo].[CancelConference]    Script Date: 21.01.2020 11:16:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CancelConference]
	@ConferenceID int = 0
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE [Conferences]
	SET Cancelled = 1
	WHERE ConferenceID = @ConferenceID

	UPDATE [Workshops]
	SET Cancelled = 1
	WHERE WorkshopID IN (
		SELECT W.WorkshopID
		FROM Conferences AS C
		INNER JOIN [Conference Days] AS CD
		ON C.ConferenceID = @ConferenceID AND C.ConferenceID = CD.ConferenceID
		INNER JOIN Workshops AS W
		ON CD.ConferenceDayID = W.ConferenceDayID
		)

END
