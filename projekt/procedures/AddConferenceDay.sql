USE [u_jastrzab]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE AddConferenceDay
	@ConferenceID INT,
	@Day DATE,
	@Limit INT = 0
AS
BEGIN
	
	SET NOCOUNT ON;

	INSERT INTO [Conference Days](ConferenceID, Day, Limit)
	VALUES(@ConferenceID, @Day, @Limit)
END