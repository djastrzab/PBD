USE [u_jastrzab]
GO
/****** Object:  StoredProcedure [dbo].[AddPerson]    Script Date: 21.01.2020 13:50:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE AddPayment
	@ReservationID INT,
	@Payment MONEY,
	@PaymentDate DATE,
	@IsConference BIT
AS
BEGIN
	
	SET NOCOUNT ON;

	INSERT INTO Payments(ReservationId, Payment, PaymentDate, IsConference)
	VALUEs(@ReservationId, @Payment, @PaymentDate, @IsConference)
END