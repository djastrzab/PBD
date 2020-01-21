USE [u_jastrzab]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE AddPerson
	@FirstName NVARCHAR(50),
	@LastName VARCHAR(15),
	@Student VARCHAR(30) = 0,
	@CompanyID INT = NULL
AS
BEGIN
	
	SET NOCOUNT ON;

	INSERT INTO People(Firstname, Lastname, Student, CompanyID)
	VALUEs(@Firstname, @Lastname, @Student, @CompanyID)
END