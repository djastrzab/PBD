
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE ChangeConfDayLimit
	@ConferenceDayID INT,
	@NewLimit INT
AS
BEGIN
	
	SET NOCOUNT ON;

	UPDATE [Conference Days] SET Limit = @NewLimit
	WHERE ConferenceDayID = @ConferenceDayID
END
