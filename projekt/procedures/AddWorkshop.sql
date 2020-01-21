USE [u_jastrzab]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE AddWorkshop
	@WorkshopName NVARCHAR(100),
	@WorkshopDescription NVARCHAR(250) = NULL,
	@Limit INT,
	@Price MONEY,
	@OrganizerID INT,
	@ConferenceDayID INT,
	@StartDate DATE,
	@EndDate DATE
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO Workshops(
		WorkshopName,
		WorkshopDescription,
		Limit,
		Price,
		Cancelled,
		ConferenceDayID,
		OrganizerID,
		StartDate,
		EndDate
		)
	VALUES(
		@WorkshopName,
		@WorkshopDescription,
		@Limit,
		@Price,
		0,
		@ConferenceDayID,
		@OrganizerID,
		@StartDate,
		@EndDate
		)

END
