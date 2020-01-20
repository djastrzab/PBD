USE [master]
GO
/****** Object:  Database [u_jastrzab]    Script Date: 20.01.2020 18:44:00 ******/
CREATE DATABASE [u_jastrzab]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'u_jastrzab', FILENAME = N'/var/opt/mssql/data/u_jastrzab.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'u_jastrzab_log', FILENAME = N'/var/opt/mssql/data/u_jastrzab_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [u_jastrzab] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [u_jastrzab].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [u_jastrzab] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [u_jastrzab] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [u_jastrzab] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [u_jastrzab] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [u_jastrzab] SET ARITHABORT OFF 
GO
ALTER DATABASE [u_jastrzab] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [u_jastrzab] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [u_jastrzab] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [u_jastrzab] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [u_jastrzab] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [u_jastrzab] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [u_jastrzab] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [u_jastrzab] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [u_jastrzab] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [u_jastrzab] SET  ENABLE_BROKER 
GO
ALTER DATABASE [u_jastrzab] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [u_jastrzab] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [u_jastrzab] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [u_jastrzab] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [u_jastrzab] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [u_jastrzab] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [u_jastrzab] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [u_jastrzab] SET RECOVERY FULL 
GO
ALTER DATABASE [u_jastrzab] SET  MULTI_USER 
GO
ALTER DATABASE [u_jastrzab] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [u_jastrzab] SET DB_CHAINING OFF 
GO
ALTER DATABASE [u_jastrzab] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [u_jastrzab] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [u_jastrzab] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [u_jastrzab] SET QUERY_STORE = OFF
GO
USE [u_jastrzab]
GO
/****** Object:  UserDefinedFunction [dbo].[CalculateFinalPrice]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 19.01.2020
-- Description:	Calculate final price for conf reservations
-- =============================================
CREATE FUNCTION [dbo].[CalculateFinalPrice] 
(
	@ReservationID int
)
	RETURNS money
	AS
		BEGIN
			DECLARE @BasePrice money;
			DECLARE @StudentDiscount float;
			DECLARE @Students int;
			DECLARE @Participants int;
			DECLARE @PriceIncreasePerDay money;
			DECLARE @ConfDate date;
			DECLARE @ReservationDate date;

			SELECT @BasePrice = C.BasePrice, @StudentDiscount = C.StudentDiscount,
			@PriceIncreasePerDay = C.PriceIncreasePerDay, @ConfDate = C.AddedOn,
			@Students = CR.NumberOfStudents, @Participants = CR.ParticipantsNumber,
			@ReservationDate =CR.ReservationDate
			FROM [Conference Reservations] AS CR
			INNER JOIN [Conference Days] AS CD
			ON CR.ReservationID = @ReservationID AND CR.ConferenceDayID = CD.ConferenceDayID
			INNER JOIN Conferences AS C
			ON CD.ConferenceID = C.ConferenceID

			DECLARE @NormalPrice money = @BasePrice + DATEDIFF(day, @ConfDate, @ReservationDate)*@PriceIncreasePerDay
			DECLARE @StudentPrice money = @NormalPrice * (1 - @StudentDiscount)

			RETURN @NormalPrice*(@Participants - @Students) + @StudentPrice * @Students
	END
GO
/****** Object:  UserDefinedFunction [dbo].[CanRegisterForWorkshop]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 19.01.2020
-- Description:	It checks if user can register for a workshop
-- =============================================
CREATE FUNCTION [dbo].[CanRegisterForWorkshop] 
(
	@ParticipantID int,
	@WorkshopID int
)
RETURNS bit
AS
BEGIN

	DECLARE @Result bit
	DECLARE @ConferenceDayID int;
	DECLARE @WorkshopStartDate date;
	DECLARE @WorkshopEndDate date;
	SELECT @ConferenceDayID = W.ConferenceDayID,
	@WorkshopStartDate = W.StartDate,
	@WorkshopEndDate = W.EndDate
	FROM Workshops AS W
	WHERE W.WorkshopID = @WorkshopID

	IF @ParticipantID not in (
		SELECT P.ParticipantID
		FROM [Conference Days] AS CD
		INNER JOIN [Conference Reservations] AS CR
		ON CD.ConferenceDayID = @ConferenceDayID AND CD.ConferenceDayID = CR.ConferenceDayID
		INNER JOIN Participants AS P
		ON CR.ReservationID = P.ReservationID
		)
	BEGIN
		RETURN 0;
	END

	DECLARE @count INT;
	SELECT @count = COUNT(*)
		FROM Workshops W
		INNER JOIN [Workshop Reservations] AS WR
		ON W.WorkshopID = WR.WorkshopID
		INNER JOIN Participants AS P
		ON P.ParticipantID = @ParticipantID AND WR.ParticipantID = P.ParticipantID
		WHERE W.StartDate <= @WorkshopEndDate AND W.EndDate >= @WorkshopStartDate

	RETURN iif(@count > 0, 0, 1);
END
GO
/****** Object:  UserDefinedFunction [dbo].[ShouldBeCancelled]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[ShouldBeCancelled] 
(
	@ReservationID int
)
RETURNS bit
AS
BEGIN

	DECLARE @Deadline date;
	DECLARE @ToPay money;

	SELECT @Deadline = CR.PaymentDeadline, @ToPay = CR.ToPay
	FROM [Conf Reservations Payments Balance] AS CR
	WHERE CR.ReservationID = @ReservationID

	DECLARE @Result bit;
	SET @Result =IIF((@ToPay > 0 and getdate() > @Deadline), 1, 0)

	RETURN @Result

END
GO
/****** Object:  Table [dbo].[Conferences]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Conferences](
	[ConferenceID] [int] NOT NULL,
	[ConferenceName] [nvarchar](100) NOT NULL,
	[StudentDiscount] [float] NOT NULL,
	[Cancelled] [bit] NOT NULL,
	[BasePrice] [money] NOT NULL,
	[PriceIncreasePerDay] [float] NOT NULL,
	[AddressID] [int] NOT NULL,
	[OrganizerID] [int] NOT NULL,
	[StartDate] [date] NOT NULL,
	[ConferenceDescription] [nvarchar](250) NULL,
	[AddedOn] [date] NOT NULL,
 CONSTRAINT [PK_Conferences] PRIMARY KEY CLUSTERED 
(
	[ConferenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Cancelled Conferences]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Cancelled Conferences]
AS
SELECT ConferenceID, ConferenceName, StudentDiscount, Cancelled, BasePrice, PriceIncreasePerDay, AddressID, OrganizerID, StartDate
FROM     dbo.Conferences
WHERE  (Cancelled = 1)
GO
/****** Object:  Table [dbo].[Workshops]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Workshops](
	[WorkshopID] [int] NOT NULL,
	[WorkshopName] [nvarchar](100) NOT NULL,
	[WorkshopDescription] [nvarchar](250) NULL,
	[Limit] [int] NOT NULL,
	[Price] [money] NOT NULL,
	[Cancelled] [bit] NOT NULL,
	[ConferenceDayID] [int] NOT NULL,
	[OrganizerID] [int] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
 CONSTRAINT [PK_Workshops] PRIMARY KEY CLUSTERED 
(
	[WorkshopID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Cancelled Workshops]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Cancelled Workshops]
AS
SELECT WorkshopID, WorkshopName, WorkshopDescription, Cancelled, Limit, Price, ConferenceDayID, OrganizerID, WorkshopDate
FROM     dbo.Workshops
WHERE  (Cancelled = 1)
GO
/****** Object:  Table [dbo].[Conference Reservations]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Conference Reservations](
	[ReservationID] [int] NOT NULL,
	[ParticipantsNumber] [int] NOT NULL,
	[NumberOfStudents] [int] NOT NULL,
	[ConferenceDayID] [int] NOT NULL,
	[ClientID] [int] NOT NULL,
	[ReservationDate] [date] NOT NULL,
	[Cancelled] [bit] NOT NULL,
 CONSTRAINT [PK_Conference Resertvations] PRIMARY KEY CLUSTERED 
(
	[ReservationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Cancelled Conference Reservations]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Cancelled Conference Reservations]
AS
SELECT ReservationID, ParticipantsNumber, NumberOfStudents, ClientID, ReservationDate, Cancelled, ConferenceDayID
FROM     dbo.[Conference Reservations]
WHERE  (Cancelled = 1)
GO
/****** Object:  Table [dbo].[Workshop Reservations]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Workshop Reservations](
	[WorkshopReservationID] [int] NOT NULL,
	[WorkshopID] [int] NOT NULL,
	[ParticipantID] [int] NOT NULL,
	[PaymentDeadline] [date] NOT NULL,
	[Cancelled] [bit] NOT NULL,
	[ReservationDate] [date] NOT NULL,
 CONSTRAINT [PK_Workshop Reservations] PRIMARY KEY CLUSTERED 
(
	[WorkshopReservationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Cancelled Workshop Reservations]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Cancelled Workshop Reservations]
AS
SELECT WorkshopReservationID, WorkshopID, ParticipantID, PaymentDeadline, Cancelled, ReservationDate
FROM     dbo.[Workshop Reservations]
WHERE  (Cancelled = 1)
GO
/****** Object:  Table [dbo].[Companies]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Companies](
	[ClientID] [int] NOT NULL,
	[CompanyName] [nvarchar](50) NOT NULL,
	[NIP] [int] NOT NULL,
	[ContactName] [varchar](30) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Organizers]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Organizers](
	[OrganizerID] [int] NOT NULL,
	[CompanyID] [int] NOT NULL,
	[ContactInformationID] [int] NOT NULL,
 CONSTRAINT [PK_Organizers] PRIMARY KEY CLUSTERED 
(
	[OrganizerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Conference Days]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Conference Days](
	[ConferenceDayID] [int] NOT NULL,
	[Day] [date] NOT NULL,
	[Limit] [int] NOT NULL,
	[ConferenceID] [int] NOT NULL,
 CONSTRAINT [PK_Reservation Days] PRIMARY KEY CLUSTERED 
(
	[ConferenceDayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Incoming Conferences]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Incoming Conferences]
AS
SELECT dbo.Conferences.ConferenceName, dbo.Conferences.BasePrice, dbo.Conferences.Cancelled, dbo.Conferences.StudentDiscount, dbo.Conferences.PriceIncreasePerDay, dbo.Conferences.StartDate, dbo.[Conference Days].Day, 
                  dbo.[Conference Days].Limit, dbo.Companies.CompanyName AS OrganizerName
FROM     dbo.Conferences INNER JOIN
                  dbo.Organizers ON dbo.Conferences.OrganizerID = dbo.Organizers.OrganizerID INNER JOIN
                  dbo.[Conference Days] ON dbo.Conferences.ConferenceID = dbo.[Conference Days].ConferenceID INNER JOIN
                  dbo.Companies ON dbo.Organizers.CompanyID = dbo.Companies.ClientID
WHERE  (dbo.Conferences.StartDate > DATEADD(week, 2, GETDATE()))
GO
/****** Object:  Table [dbo].[Contact Information]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contact Information](
	[InformationId] [int] IDENTITY(1,1) NOT NULL,
	[Email] [nvarchar](40) NULL,
	[Phone] [varchar](15) NOT NULL,
	[AddressID] [int] NULL,
 CONSTRAINT [PK_Contact Information] PRIMARY KEY CLUSTERED 
(
	[InformationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Participants]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Participants](
	[ParticipantID] [int] NOT NULL,
	[ReservationID] [int] NOT NULL,
	[PersonID] [int] NOT NULL,
 CONSTRAINT [PK_Participants] PRIMARY KEY CLUSTERED 
(
	[ParticipantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Clients]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clients](
	[ClientID] [int] IDENTITY(1,1) NOT NULL,
	[InformationID] [int] NOT NULL,
 CONSTRAINT [PK_Clients] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Missing Client Data]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Missing Client Data]
AS
SELECT dbo.Conferences.ConferenceName, dbo.[Conference Reservations].ParticipantsNumber, COUNT(dbo.Participants.ParticipantID) AS SignedParticipants, 
                  dbo.[Conference Reservations].ParticipantsNumber - COUNT(dbo.Participants.ParticipantID) AS MissingParticipants
FROM     dbo.[Conference Reservations] INNER JOIN
                  dbo.[Conference Days] ON dbo.[Conference Reservations].ConferenceDayID = dbo.[Conference Days].ConferenceDayID INNER JOIN
                  dbo.Conferences ON dbo.[Conference Days].ConferenceID = dbo.Conferences.ConferenceID INNER JOIN
                  dbo.Clients ON dbo.[Conference Reservations].ClientID = dbo.Clients.ClientID INNER JOIN
                  dbo.[Contact Information] ON dbo.Clients.InformationID = dbo.[Contact Information].InformationId INNER JOIN
                  dbo.Participants ON dbo.[Conference Reservations].ReservationID = dbo.Participants.ReservationID
GROUP BY dbo.Conferences.ConferenceName, dbo.[Conference Reservations].ParticipantsNumber
HAVING (COUNT(dbo.Participants.ParticipantID) < dbo.[Conference Reservations].ParticipantsNumber)
GO
/****** Object:  Table [dbo].[Payments]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payments](
	[PaymentId] [int] NOT NULL,
	[ReservationId] [int] NOT NULL,
	[Payment] [money] NOT NULL,
	[PaymentDate] [date] NOT NULL,
	[IsConference] [bit] NOT NULL,
 CONSTRAINT [PK_Payments] PRIMARY KEY CLUSTERED 
(
	[PaymentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Conf Reservations Payments Balance]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Conf Reservations Payments Balance]
AS
SELECT dbo.[Conference Reservations].ReservationID, dbo.[Conference Reservations].ClientID, dbo.[Conference Reservations].Cancelled, dbo.CalculateFinalPrice(dbo.[Conference Reservations].ReservationID) AS FinalPrice, 
                  SUM(dbo.Payments.Payment) AS PaymentsSum, dbo.CalculateFinalPrice(dbo.[Conference Reservations].ReservationID) - SUM(dbo.Payments.Payment) AS ToPay, DATEADD(week, 1, dbo.[Conference Reservations].ReservationDate) 
                  AS PaymentDeadline
FROM     dbo.[Conference Reservations] INNER JOIN
                  dbo.Payments ON dbo.[Conference Reservations].ReservationID = dbo.Payments.ReservationId
WHERE  (dbo.Payments.IsConference = 1)
GROUP BY dbo.[Conference Reservations].ReservationID, dbo.[Conference Reservations].ClientID, dbo.CalculateFinalPrice(dbo.[Conference Reservations].ReservationID), DATEADD(week, 1, dbo.[Conference Reservations].ReservationDate), 
                  dbo.[Conference Reservations].Cancelled
GO
/****** Object:  View [dbo].[Workshop Reservations Payments Balance]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Workshop Reservations Payments Balance]
AS
SELECT dbo.[Workshop Reservations].WorkshopReservationID, dbo.[Workshop Reservations].ParticipantID, dbo.[Workshop Reservations].Cancelled, dbo.Workshops.Price, SUM(dbo.Payments.Payment) AS PaymentsSum, 
                  dbo.Workshops.Price - SUM(dbo.Payments.Payment) AS ToPay
FROM     dbo.[Workshop Reservations] INNER JOIN
                  dbo.Workshops ON dbo.[Workshop Reservations].WorkshopID = dbo.Workshops.WorkshopID INNER JOIN
                  dbo.Payments ON dbo.[Workshop Reservations].WorkshopReservationID = dbo.Payments.ReservationId
GROUP BY dbo.[Workshop Reservations].WorkshopReservationID, dbo.[Workshop Reservations].ParticipantID, dbo.Workshops.Price, dbo.[Workshop Reservations].Cancelled
GO
/****** Object:  View [dbo].[Conferences available spaces]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Conferences available spaces]
AS
SELECT TOP (100) PERCENT dbo.[Conference Days].ConferenceDayID, dbo.[Conference Days].Limit, COUNT(dbo.Participants.ParticipantID) AS Reserved, dbo.[Conference Days].Limit - COUNT(dbo.Participants.ParticipantID) AS Free
FROM     dbo.[Conference Days] INNER JOIN
                  dbo.[Conference Reservations] ON dbo.[Conference Days].ConferenceDayID = dbo.[Conference Reservations].ConferenceDayID INNER JOIN
                  dbo.Participants ON dbo.[Conference Reservations].ReservationID = dbo.Participants.ReservationID
WHERE  (dbo.[Conference Reservations].Cancelled = 0)
GROUP BY dbo.[Conference Days].ConferenceDayID, dbo.[Conference Days].Limit
GO
/****** Object:  View [dbo].[Workshops Available Spaces]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Workshops Available Spaces]
AS
SELECT dbo.Workshops.WorkshopID, dbo.Workshops.Limit, COUNT(dbo.Participants.ParticipantID) AS Reserved, dbo.Workshops.Limit - COUNT(dbo.[Workshop Reservations].ParticipantID) AS Free
FROM     dbo.Workshops INNER JOIN
                  dbo.[Workshop Reservations] ON dbo.Workshops.WorkshopID = dbo.[Workshop Reservations].WorkshopID INNER JOIN
                  dbo.Participants ON dbo.[Workshop Reservations].ParticipantID = dbo.Participants.ParticipantID
WHERE  (dbo.[Workshop Reservations].Cancelled = 0)
GROUP BY dbo.Workshops.WorkshopID, dbo.Workshops.Limit
GO
/****** Object:  Table [dbo].[Address]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Address](
	[AddressID] [int] NOT NULL,
	[Street] [nvarchar](40) NOT NULL,
	[Zipcode] [varchar](12) NOT NULL,
	[City] [nvarchar](40) NOT NULL,
	[Country] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[People]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[People](
	[PersonID] [int] IDENTITY(1,1) NOT NULL,
	[Firstname] [nvarchar](20) NOT NULL,
	[Lastname] [nvarchar](30) NOT NULL,
	[Student] [bit] NOT NULL,
	[CompanyID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Companies]    Script Date: 20.01.2020 18:44:02 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Companies] ON [dbo].[Companies]
(
	[ClientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Participants]    Script Date: 20.01.2020 18:44:02 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Participants] ON [dbo].[Participants]
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_People]    Script Date: 20.01.2020 18:44:02 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_People] ON [dbo].[People]
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Conferences] ADD  CONSTRAINT [DF_Conferences_AddedOn]  DEFAULT (getdate()) FOR [AddedOn]
GO
ALTER TABLE [dbo].[Clients]  WITH CHECK ADD  CONSTRAINT [FK_Clients_Contact Information] FOREIGN KEY([InformationID])
REFERENCES [dbo].[Contact Information] ([InformationId])
GO
ALTER TABLE [dbo].[Clients] CHECK CONSTRAINT [FK_Clients_Contact Information]
GO
ALTER TABLE [dbo].[Companies]  WITH CHECK ADD  CONSTRAINT [FK_Companies_Clients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[Companies] CHECK CONSTRAINT [FK_Companies_Clients]
GO
ALTER TABLE [dbo].[Conference Days]  WITH CHECK ADD  CONSTRAINT [FK_Conference Days_Conferences] FOREIGN KEY([ConferenceID])
REFERENCES [dbo].[Conferences] ([ConferenceID])
GO
ALTER TABLE [dbo].[Conference Days] CHECK CONSTRAINT [FK_Conference Days_Conferences]
GO
ALTER TABLE [dbo].[Conference Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Conference Reservations_Clients] FOREIGN KEY([ClientID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[Conference Reservations] CHECK CONSTRAINT [FK_Conference Reservations_Clients]
GO
ALTER TABLE [dbo].[Conference Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Conference Reservations_Conference Days] FOREIGN KEY([ConferenceDayID])
REFERENCES [dbo].[Conference Days] ([ConferenceDayID])
GO
ALTER TABLE [dbo].[Conference Reservations] CHECK CONSTRAINT [FK_Conference Reservations_Conference Days]
GO
ALTER TABLE [dbo].[Conferences]  WITH CHECK ADD  CONSTRAINT [FK_Conferences_Address] FOREIGN KEY([AddressID])
REFERENCES [dbo].[Address] ([AddressID])
GO
ALTER TABLE [dbo].[Conferences] CHECK CONSTRAINT [FK_Conferences_Address]
GO
ALTER TABLE [dbo].[Conferences]  WITH CHECK ADD  CONSTRAINT [FK_Conferences_Organizers] FOREIGN KEY([OrganizerID])
REFERENCES [dbo].[Organizers] ([OrganizerID])
GO
ALTER TABLE [dbo].[Conferences] CHECK CONSTRAINT [FK_Conferences_Organizers]
GO
ALTER TABLE [dbo].[Contact Information]  WITH CHECK ADD  CONSTRAINT [FK_Contact Information_Address] FOREIGN KEY([AddressID])
REFERENCES [dbo].[Address] ([AddressID])
GO
ALTER TABLE [dbo].[Contact Information] CHECK CONSTRAINT [FK_Contact Information_Address]
GO
ALTER TABLE [dbo].[Organizers]  WITH CHECK ADD  CONSTRAINT [FK_Organizers_Companies] FOREIGN KEY([CompanyID])
REFERENCES [dbo].[Companies] ([ClientID])
GO
ALTER TABLE [dbo].[Organizers] CHECK CONSTRAINT [FK_Organizers_Companies]
GO
ALTER TABLE [dbo].[Organizers]  WITH CHECK ADD  CONSTRAINT [FK_Organizers_Contact Information] FOREIGN KEY([ContactInformationID])
REFERENCES [dbo].[Contact Information] ([InformationId])
GO
ALTER TABLE [dbo].[Organizers] CHECK CONSTRAINT [FK_Organizers_Contact Information]
GO
ALTER TABLE [dbo].[Participants]  WITH CHECK ADD  CONSTRAINT [FK_Participants_Conference Resertvations] FOREIGN KEY([ReservationID])
REFERENCES [dbo].[Conference Reservations] ([ReservationID])
GO
ALTER TABLE [dbo].[Participants] CHECK CONSTRAINT [FK_Participants_Conference Resertvations]
GO
ALTER TABLE [dbo].[Participants]  WITH CHECK ADD  CONSTRAINT [FK_Participants_People] FOREIGN KEY([PersonID])
REFERENCES [dbo].[People] ([PersonID])
GO
ALTER TABLE [dbo].[Participants] CHECK CONSTRAINT [FK_Participants_People]
GO
ALTER TABLE [dbo].[Payments]  WITH CHECK ADD  CONSTRAINT [FK_Payments_Conference Resertvations] FOREIGN KEY([ReservationId])
REFERENCES [dbo].[Conference Reservations] ([ReservationID])
GO
ALTER TABLE [dbo].[Payments] CHECK CONSTRAINT [FK_Payments_Conference Resertvations]
GO
ALTER TABLE [dbo].[Payments]  WITH CHECK ADD  CONSTRAINT [FK_Payments_Workshop Reservations] FOREIGN KEY([ReservationId])
REFERENCES [dbo].[Workshop Reservations] ([WorkshopReservationID])
GO
ALTER TABLE [dbo].[Payments] CHECK CONSTRAINT [FK_Payments_Workshop Reservations]
GO
ALTER TABLE [dbo].[People]  WITH CHECK ADD  CONSTRAINT [FK_People_Clients] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Clients] ([ClientID])
GO
ALTER TABLE [dbo].[People] CHECK CONSTRAINT [FK_People_Clients]
GO
ALTER TABLE [dbo].[People]  WITH CHECK ADD  CONSTRAINT [FK_People_Companies] FOREIGN KEY([CompanyID])
REFERENCES [dbo].[Companies] ([ClientID])
GO
ALTER TABLE [dbo].[People] CHECK CONSTRAINT [FK_People_Companies]
GO
ALTER TABLE [dbo].[Workshop Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Workshop Reservations_Participants] FOREIGN KEY([ParticipantID])
REFERENCES [dbo].[Participants] ([ParticipantID])
GO
ALTER TABLE [dbo].[Workshop Reservations] CHECK CONSTRAINT [FK_Workshop Reservations_Participants]
GO
ALTER TABLE [dbo].[Workshop Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Workshop Reservations_Workshops] FOREIGN KEY([WorkshopID])
REFERENCES [dbo].[Workshops] ([WorkshopID])
GO
ALTER TABLE [dbo].[Workshop Reservations] CHECK CONSTRAINT [FK_Workshop Reservations_Workshops]
GO
ALTER TABLE [dbo].[Workshops]  WITH CHECK ADD  CONSTRAINT [FK_Workshops_Conference Days] FOREIGN KEY([ConferenceDayID])
REFERENCES [dbo].[Conference Days] ([ConferenceDayID])
GO
ALTER TABLE [dbo].[Workshops] CHECK CONSTRAINT [FK_Workshops_Conference Days]
GO
ALTER TABLE [dbo].[Workshops]  WITH CHECK ADD  CONSTRAINT [FK_Workshops_Organizers] FOREIGN KEY([OrganizerID])
REFERENCES [dbo].[Organizers] ([OrganizerID])
GO
ALTER TABLE [dbo].[Workshops] CHECK CONSTRAINT [FK_Workshops_Organizers]
GO
ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [CK_Address] CHECK  (([Zipcode] like '[0­9][0­9]­[0­9][0­9][0­9]'))
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [CK_Address]
GO
ALTER TABLE [dbo].[Conference Days]  WITH CHECK ADD  CONSTRAINT [CK_Conference Days] CHECK  (([Limit]>(0)))
GO
ALTER TABLE [dbo].[Conference Days] CHECK CONSTRAINT [CK_Conference Days]
GO
ALTER TABLE [dbo].[Conference Reservations]  WITH CHECK ADD  CONSTRAINT [CK_Conference Reservations] CHECK  (([ParticipantsNumber]>(0)))
GO
ALTER TABLE [dbo].[Conference Reservations] CHECK CONSTRAINT [CK_Conference Reservations]
GO
ALTER TABLE [dbo].[Conferences]  WITH CHECK ADD  CONSTRAINT [CK_Conferences] CHECK  (([BasePrice]>(0)))
GO
ALTER TABLE [dbo].[Conferences] CHECK CONSTRAINT [CK_Conferences]
GO
ALTER TABLE [dbo].[Workshops]  WITH CHECK ADD  CONSTRAINT [CK_Workshops] CHECK  (([EndDate]>[StartDate]))
GO
ALTER TABLE [dbo].[Workshops] CHECK CONSTRAINT [CK_Workshops]
GO
ALTER TABLE [dbo].[Workshops]  WITH CHECK ADD  CONSTRAINT [Limit] CHECK  (([Limit]>(0)))
GO
ALTER TABLE [dbo].[Workshops] CHECK CONSTRAINT [Limit]
GO
ALTER TABLE [dbo].[Workshops]  WITH CHECK ADD  CONSTRAINT [Price] CHECK  (([Price]>=(0)))
GO
ALTER TABLE [dbo].[Workshops] CHECK CONSTRAINT [Price]
GO
/****** Object:  StoredProcedure [dbo].[ClientDetails]    Script Date: 20.01.2020 18:44:02 ******/
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
GO
/****** Object:  StoredProcedure [dbo].[ConferenceDayParticipantsList]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 19.01.2020
-- Description:	Given Conference day id, shows list of its participants
-- =============================================
CREATE PROCEDURE [dbo].[ConferenceDayParticipantsList] 
	@ConferenceDayID int = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT P.PersonID, P.Firstname, P.Lastname, C.CompanyName
	FROM dbo.[Conference Days] AS CD
	INNER JOIN dbo.[Conference Reservations] AS CR 
	ON CD.ConferenceDayID = @ConferenceDayID AND CD.ConferenceDayID = CR.ConferenceDayID
	INNER JOIN dbo.Participants AS PART 
	ON CR.Cancelled = 0 AND CR.ReservationID = PART.ReservationID
	INNER JOIN PEOPLE AS P
	ON PART.PersonID = P.PersonID
	LEFT OUTER JOIN Companies AS C
	ON P.CompanyID = C.ClientID
END
GO
/****** Object:  StoredProcedure [dbo].[ConfReservationDetails]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 19.01.2020
-- Description:	Show details of certain reservation
-- =============================================
CREATE PROCEDURE [dbo].[ConfReservationDetails]
	@ReservationID int = 0
AS
BEGIN
	SET NOCOUNT ON;

	SELECT CR.ReservationID, CR.ReservationDate, CR.Cancelled,
		   CR.ParticipantsNumber, CR.NumberOfStudents, CR_BALANCE.FinalPrice,
		   CR_BALANCE.ToPay, CR_BALANCE.PaymentDeadline, CR.ClientID, CD.Day,
		   CD.Limit, C.ConferenceID, C.ConferenceName, C.Cancelled
	FROM [Conference Reservations] AS CR
	INNER JOIN [Conference Days] AS CD
	ON CR.ReservationID = @ReservationID AND CR.ConferenceDayID = CD.ConferenceDayID
	INNER JOIN Conferences AS C
	ON CD.ConferenceID = C.ConferenceID
	INNER JOIN [Conf Reservations Payments Balance] AS CR_BALANCE
	ON CR.ReservationID = CR_BALANCE.ReservationID
END
GO
/****** Object:  StoredProcedure [dbo].[MyConferences]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 19.01.2020
-- Description:	Given
-- =============================================
CREATE PROCEDURE [dbo].[MyConferences] 
	@PersonID int = 0
AS
BEGIN
	SET NOCOUNT ON;

    
	SELECT C.ConferenceID, C.ConferenceName, C.ConferenceDescription, C.StartDate,
	A.Street, A.Zipcode, A.City, COMP.CompanyName, C.Cancelled, CD.ConferenceDayID, CD.Day, CD.Limit
	FROM People AS P
	INNER JOIN Participants AS PART
	ON P.PersonID = @PersonID and P.PersonID = PART.PersonID
	INNER JOIN [Conference Reservations] AS CR
	ON PART.ReservationID = CR.ReservationID AND CR.Cancelled = 0
	INNER JOIN [Conference Days] AS CD
	ON CR.ConferenceDayID = CD.ConferenceDayID
	INNER JOIN Conferences AS C
	ON CD.ConferenceID = C.ConferenceID
	INNER JOIN Address as A
	ON C.AddressID = A.AddressID
	INNER JOIN Organizers AS O
	ON C.OrganizerID = O.OrganizerID
	INNER JOIN Companies AS COMP
	ON O.CompanyID = COMP.ClientID
END
GO
/****** Object:  StoredProcedure [dbo].[MyConfReservationsBalance]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 19.01,2020
-- Description:	Shows reservations with their payment balance for the client
-- =============================================
CREATE PROCEDURE [dbo].[MyConfReservationsBalance] 
	@ClientID int = 0
AS
BEGIN
	SET NOCOUNT ON;

    
	SELECT R.ReservationID, R.Cancelled, R.FinalPrice, R.PaymentsSum, R.ToPay, R.PaymentDeadline
	FROM [Conf Reservations Payments Balance] AS R
	WHERE R.ClientID = @ClientID
END
GO
/****** Object:  StoredProcedure [dbo].[MyWorkshopReservationsBalance]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 19.01,2020
-- Description:	Shows reservations with their payment balance for the client
-- =============================================
CREATE PROCEDURE [dbo].[MyWorkshopReservationsBalance] 
	@PersonID int = 0
AS
BEGIN
	SET NOCOUNT ON;
    
	SELECT WR.WorkshopReservationID, WR.Cancelled, WR.Price, WR.PaymentsSum, WR.ToPay
	FROM People AS P
	INNER JOIN Participants AS PART
	ON P.PersonID = @PersonID AND P.PersonID = PART.PersonID
	INNER JOIN [Workshop Reservations Payments Balance] AS WR
	ON PART.ParticipantID = WR.ParticipantID
END
GO
/****** Object:  StoredProcedure [dbo].[MyWorkshops]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 19.01.2020
-- Description:	Given person ID it shows his/her workshops
-- =============================================
CREATE PROCEDURE [dbo].[MyWorkshops]
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
/****** Object:  StoredProcedure [dbo].[TopCustomers]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TopCustomers]
	@OrganizerID int = 0
AS
BEGIN
	SET NOCOUNT ON;

	SELECT CL.ClientID, COUNT(CR.ReservationID) as 'ReservationsNumber'
	FROM Organizers AS O
	INNER JOIN Conferences AS C
	ON O.OrganizerID = @OrganizerID AND O.OrganizerID = C.OrganizerID
	INNER JOIN [Conference Days] AS CD
	ON C.ConferenceID = CD.ConferenceID
	INNER JOIN [Conference Reservations] AS CR
	ON CR.Cancelled = 0 AND CD.ConferenceDayID = CR.ConferenceDayID
	INNER JOIN Clients AS CL
	ON CR.ClientID = CL.ClientID
	GROUP BY CL.ClientID
	ORDER BY [ReservationsNumber] DESC
END 
GO
/****** Object:  StoredProcedure [dbo].[WorkshopParticipantsList]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 19.01.2020
-- Description:	Given Workshop id, shows list of its participants
-- =============================================
CREATE PROCEDURE [dbo].[WorkshopParticipantsList] 
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
/****** Object:  StoredProcedure [dbo].[WorkshopReservationDetails]    Script Date: 20.01.2020 18:44:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 19.01.2020
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[WorkshopReservationDetails]
	@ReservationID int = 0
AS
BEGIN
	SET NOCOUNT ON;

	SELECT WR.WorkshopReservationID, WR.ReservationDate, WR.Cancelled, W.Price,
		   WR.PaymentDeadline, WR.ParticipantID, W.WorkshopID, W.WorkshopName,
		   W.Cancelled, W.Limit
	FROM [Workshop Reservations] AS WR
	INNER JOIN Workshops AS W
	ON WR.WorkshopReservationID = @ReservationID AND WR.WorkshopID = W.WorkshopID
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Conference Reservations"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 274
            End
            DisplayFlags = 280
            TopColumn = 3
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Cancelled Conference Reservations'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Cancelled Conference Reservations'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[26] 2[22] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Conferences"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 289
               Right = 291
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Cancelled Conferences'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Cancelled Conferences'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Workshop Reservations"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 302
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Cancelled Workshop Reservations'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Cancelled Workshop Reservations'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[34] 2[11] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Workshops"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 286
            End
            DisplayFlags = 280
            TopColumn = 5
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Cancelled Workshops'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Cancelled Workshops'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[30] 2[18] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Conference Reservations"
            Begin Extent = 
               Top = 45
               Left = 198
               Bottom = 208
               Right = 440
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Payments"
            Begin Extent = 
               Top = 31
               Left = 562
               Bottom = 194
               Right = 756
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 3852
         Alias = 2004
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Conf Reservations Payments Balance'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Conf Reservations Payments Balance'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[53] 4[20] 2[19] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Conference Days"
            Begin Extent = 
               Top = 113
               Left = 44
               Bottom = 283
               Right = 255
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Conference Reservations"
            Begin Extent = 
               Top = 46
               Left = 372
               Bottom = 279
               Right = 598
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Participants"
            Begin Extent = 
               Top = 23
               Left = 744
               Bottom = 164
               Right = 938
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Conferences available spaces'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Conferences available spaces'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[24] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Conferences"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 233
            End
            DisplayFlags = 280
            TopColumn = 5
         End
         Begin Table = "Organizers"
            Begin Extent = 
               Top = 190
               Left = 280
               Bottom = 303
               Right = 485
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Conference Days"
            Begin Extent = 
               Top = 140
               Left = 48
               Bottom = 303
               Right = 259
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Companies"
            Begin Extent = 
               Top = 173
               Left = 565
               Bottom = 303
               Right = 738
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2352
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Incoming Conferences'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Incoming Conferences'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Conference Reservations"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 290
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Conference Days"
            Begin Extent = 
               Top = 175
               Left = 48
               Bottom = 338
               Right = 275
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Conferences"
            Begin Extent = 
               Top = 6
               Left = 490
               Bottom = 223
               Right = 685
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Clients"
            Begin Extent = 
               Top = 153
               Left = 268
               Bottom = 249
               Right = 438
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Contact Information"
            Begin Extent = 
               Top = 343
               Left = 48
               Bottom = 506
               Right = 258
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Participants"
            Begin Extent = 
               Top = 213
               Left = 63
               Bottom = 326
               Right = 233
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths =' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Missing Client Data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' 12
         Column = 4656
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 4536
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Missing Client Data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Missing Client Data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[45] 4[25] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Workshop Reservations"
            Begin Extent = 
               Top = 41
               Left = 502
               Bottom = 204
               Right = 756
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Workshops"
            Begin Extent = 
               Top = 44
               Left = 910
               Bottom = 207
               Right = 1148
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "Payments"
            Begin Extent = 
               Top = 37
               Left = 79
               Bottom = 200
               Right = 273
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 2124
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Workshop Reservations Payments Balance'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Workshop Reservations Payments Balance'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Workshops"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 286
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Workshop Reservations"
            Begin Extent = 
               Top = 7
               Left = 334
               Bottom = 170
               Right = 588
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Participants"
            Begin Extent = 
               Top = 7
               Left = 636
               Bottom = 148
               Right = 830
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Workshops Available Spaces'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Workshops Available Spaces'
GO
USE [master]
GO
ALTER DATABASE [u_jastrzab] SET  READ_WRITE 
GO
