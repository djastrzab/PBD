-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 19.01.2020
-- Description:	Given person ID it shows his/her workshops
-- =============================================
CREATE PROCEDURE MyWorkshops
	@PersonID int = 0
AS
BEGIN
	SET NOCOUNT ON;

	SELECT W.WorkshopID, W.WorkshopName, W.WorkshopDescription, W.WorkshopDate,
		   COMP.CompanyName as 'Organizer', W.Cancelled, W.Limit, W.Price
	FROM People AS P
	INNER JOIN Participants AS PART
	ON P.PersonID = @PersonID and P.PersonID = PART.PersonID
	INNER JOIN [Workshop Reservations] AS WR
	ON PART.ParticipantID = WR.ParticipantID AND WR.Cancelled = 0
	INNER JOIN Workshops AS W
	ON WR.WorkshopID= W.WorkshopID
	INNER JOIN Organizers AS O
	ON W.OrganizerID = O.OrganizerID
	INNER JOIN Companies AS COMP
	ON O.CompanyID = COMP.ClientID
END
GO
