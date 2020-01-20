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
-- Description:	Given Workshop id, shows list of its participants
-- =============================================
CREATE PROCEDURE WorkshopParticipantsList 
	@WorkshopID int = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT P.PersonID, P.Firstname, P.Lastname, C.CompanyName
	FROM dbo.Workshops AS W
	INNER JOIN dbo.[Workshop Reservations] WR
	ON W.WorkshopID = @WorkshopID AND W.WorkshopID = WR.WorkshopID
	INNER JOIN dbo.Participants AS PART 
	ON WR.Cancelled = 0 and WR.ParticipantID = PART.ParticipantID
	INNER JOIN PEOPLE AS P
	ON PART.PersonID = P.PersonID
	LEFT OUTER JOIN Companies AS C
	ON P.CompanyID = C.ClientID
END
GO
