USE [u_jastrzab]
GO
/****** Object:  StoredProcedure [dbo].[TopCustomers]    Script Date: 20.01.2020 17:49:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[TopCustomers]
	@OrganizerID int = 0
AS
BEGIN
	SET NOCOUNT ON;

	SELECT CL.ClientID, COUNT(CR.ReservationID) as 'ReservationsNumber'
	FROM Organizers AS O
	INNER JOIN Conferences AS C
	ON O.OrganizerID = @OrganizerID AND O.OrganizerID = C.OrganizerID
	INNER JOIN [Conference Days] AS CD
	ON C.ConferenceID = CD.ConferenceID
	INNER JOIN [Conference Reservations] AS CR
	ON CR.Cancelled = 0 AND CD.ConferenceDayID = CR.ConferenceDayID
	INNER JOIN Clients AS CL
	ON CR.ClientID = CL.ClientID
	GROUP BY CL.ClientID
	ORDER BY [ReservationsNumber] DESC
END 
