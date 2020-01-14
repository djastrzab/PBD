USE [master]
GO
/****** Object:  Database [u_jastrzab]    Script Date: 14.01.2020 23:35:20 ******/
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
/****** Object:  Table [dbo].[Address]    Script Date: 14.01.2020 23:35:21 ******/
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
/****** Object:  Table [dbo].[Clients]    Script Date: 14.01.2020 23:35:21 ******/
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
/****** Object:  Table [dbo].[Companies]    Script Date: 14.01.2020 23:35:21 ******/
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
/****** Object:  Table [dbo].[Conference Days]    Script Date: 14.01.2020 23:35:21 ******/
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
/****** Object:  Table [dbo].[Conference Reservations]    Script Date: 14.01.2020 23:35:21 ******/
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
/****** Object:  Table [dbo].[Conferences]    Script Date: 14.01.2020 23:35:21 ******/
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
 CONSTRAINT [PK_Conferences] PRIMARY KEY CLUSTERED 
(
	[ConferenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Contact Information]    Script Date: 14.01.2020 23:35:21 ******/
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
/****** Object:  Table [dbo].[Organizers]    Script Date: 14.01.2020 23:35:21 ******/
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
/****** Object:  Table [dbo].[Participants]    Script Date: 14.01.2020 23:35:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Participants](
	[ParticipantID] [int] NOT NULL,
	[ReservastionID] [int] NOT NULL,
	[PersonID] [int] NOT NULL,
 CONSTRAINT [PK_Participants] PRIMARY KEY CLUSTERED 
(
	[ParticipantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payments]    Script Date: 14.01.2020 23:35:21 ******/
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
/****** Object:  Table [dbo].[People]    Script Date: 14.01.2020 23:35:21 ******/
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
/****** Object:  Table [dbo].[Workshop Reservations]    Script Date: 14.01.2020 23:35:21 ******/
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
/****** Object:  Table [dbo].[Workshops]    Script Date: 14.01.2020 23:35:21 ******/
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
	[WorkshopDate] [date] NOT NULL,
 CONSTRAINT [PK_Workshops] PRIMARY KEY CLUSTERED 
(
	[WorkshopID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Companies]    Script Date: 14.01.2020 23:35:21 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Companies] ON [dbo].[Companies]
(
	[ClientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Participants]    Script Date: 14.01.2020 23:35:21 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Participants] ON [dbo].[Participants]
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_People]    Script Date: 14.01.2020 23:35:21 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_People] ON [dbo].[People]
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
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
ALTER TABLE [dbo].[Participants]  WITH CHECK ADD  CONSTRAINT [FK_Participants_Conference Resertvations] FOREIGN KEY([ReservastionID])
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
USE [master]
GO
ALTER DATABASE [u_jastrzab] SET  READ_WRITE 
GO
