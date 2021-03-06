USE [u_jastrzab]
GO
/****** Object:  StoredProcedure [dbo].[ConferenceDayParticipantsList]    Script Date: 19.01.2020 13:55:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 19.01.2020
-- Description:	Given Conference day id, shows list of its participants
-- =============================================
ALTER PROCEDURE [dbo].[ConferenceDayParticipantsList] 
	@ConferenceDayID int = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT P.PersonID, P.Firstname, P.Lastname, C.CompanyName
	FROM dbo.[Conference Days] AS CD
	INNER JOIN dbo.[Conference Reservations] AS CR 
	ON CD.ConferenceDayID = @ConferenceDayID AND CD.ConferenceDayID = CR.ConferenceDayID
	INNER JOIN dbo.Participants AS PART 
	ON CR.Cancelled = 0 AND CR.ReservationID = PART.ReservationID
	INNER JOIN PEOPLE AS P
	ON PART.PersonID = P.PersonID
	LEFT OUTER JOIN Companies AS C
	ON P.CompanyID = C.ClientID
END
