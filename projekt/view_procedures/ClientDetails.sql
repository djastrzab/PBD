USE [u_jastrzab]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ClientDetails]
	@ClientID int = 0
AS
BEGIN
	SET NOCOUNT ON;

	SELECT C.ClientID, P.Firstname, P.Lastname, P.Student,
	COMP.CompanyName, COMP.ContactName, COMP.NIP, I.Email,
	I.Phone, A.Country, A.City, A.Street, A.Zipcode
	FROM Clients AS C
	INNER JOIN [Contact Information] AS I
	ON C.ClientID = @ClientID AND C.InformationID = I.InformationId
	LEFT OUTER JOIN Address AS A
	ON I.AddressID = A.AddressID
	LEFT OUTER JOIN Companies AS COMP
	ON C.ClientID = COMP.ClientID
	LEFT OUTER JOIN People AS P
	ON C.ClientID = P.PersonID
END 
