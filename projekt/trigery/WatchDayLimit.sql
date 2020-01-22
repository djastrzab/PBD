
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER dbo.WatchDayLimit 
   ON  dbo.[Conference Days] 
   AFTER UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	IF EXISTS(SELECT 'YES'
		FROM inserted as NEW_CD
		INNER JOIN [Conferences available spaces] AS CD
		ON NEW_CD.ConferenceDayID = CD.ConferenceDayID
		WHERE NEW_CD.Limit < CD.Reserved
		)
	BEGIN
		RAISERROR('You can not reduce the limit
		because there are already too much participants enrolled', 1, 1);
		ROLLBACK TRANSACTION;
	END
END
GO

