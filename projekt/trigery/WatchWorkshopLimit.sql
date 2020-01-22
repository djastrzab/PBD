
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER dbo.WatchWorkshopLimit 
   ON  dbo.Workshops 
   AFTER UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	IF EXISTS(SELECT 'YES'
		FROM inserted as NEW_W
		INNER JOIN [Workshops Available Spaces] AS OLD_W
		ON NEW_W.WorkshopID = OLD_W.WorkshopID
		WHERE NEW_W.Limit < OLD_W.
		)
	BEGIN
		RAISERROR('You can not reduce the limit
		because there are already too much participants enrolled', 1, 1);
		ROLLBACK TRANSACTION;
	END
END
GO
