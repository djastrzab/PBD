USE [u_jastrzab]
GO
/****** Object:  StoredProcedure [dbo].[MyConferences]    Script Date: 19.01.2020 14:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 19.01.2020
-- Description:	Given
-- =============================================
ALTER PROCEDURE [dbo].[MyConferences] 
	@PersonID int = 0
AS
BEGIN
	SET NOCOUNT ON;

    
	SELECT C.ConferenceID, C.ConferenceName, C.ConferenceDescription, C.StartDate,
	A.Street, A.Zipcode, A.City, COMP.CompanyName, C.Cancelled, CD.ConferenceDayID, CD.Day, CD.Limit
	FROM People AS P
	INNER JOIN Participants AS PART
	ON P.PersonID = @PersonID and P.PersonID = PART.PersonID
	INNER JOIN [Conference Reservations] AS CR
	ON PART.ReservationID = CR.ReservationID AND CR.Cancelled = 0
	INNER JOIN [Conference Days] AS CD
	ON CR.ConferenceDayID = CD.ConferenceDayID
	INNER JOIN Conferences AS C
	ON CD.ConferenceID = C.ConferenceID
	INNER JOIN Address as A
	ON C.AddressID = A.AddressID
	INNER JOIN Organizers AS O
	ON C.OrganizerID = O.OrganizerID
	INNER JOIN Companies AS COMP
	ON O.CompanyID = COMP.ClientID
END
