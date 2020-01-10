USE [master]
GO
/****** Object:  Database [u_jastrzab]    Script Date: 10.01.2020 12:32:19 ******/
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
/****** Object:  Table [dbo].[Address]    Script Date: 10.01.2020 12:32:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Address](
	[AddressID] [int] NOT NULL,
	[Street] [nvarchar](50) NULL,
	[Zipcode] [varchar](50) NULL,
	[City] [nvarchar](50) NULL,
	[Country] [nvarchar](50) NULL,
 CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Clients]    Script Date: 10.01.2020 12:32:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clients](
	[ClientID] [int] IDENTITY(1,1) NOT NULL,
	[InformationID] [int] NULL,
 CONSTRAINT [PK_Clients] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Companies]    Script Date: 10.01.2020 12:32:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Companies](
	[ClientID] [int] NOT NULL,
	[CompanyName] [nvarchar](50) NULL,
	[NIP] [int] NULL,
	[ContactName] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Conference Resertvations]    Script Date: 10.01.2020 12:32:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Conference Resertvations](
	[ReservationID] [int] NOT NULL,
	[ParticipantsNumber] [int] NULL,
	[ConferenceID] [int] NULL,
	[ClientID] [int] NULL,
	[DateID] [int] NULL,
	[PaymentDetailsID] [int] NULL,
 CONSTRAINT [PK_Conference Resertvations] PRIMARY KEY CLUSTERED 
(
	[ReservationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Conferences]    Script Date: 10.01.2020 12:32:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Conferences](
	[ConferenceID] [int] NOT NULL,
	[ConferenceName] [nvarchar](50) NULL,
	[StudentDiscount] [float] NULL,
	[Limit] [int] NULL,
	[Canceled] [bit] NULL,
	[BasePrice] [money] NULL,
	[PriceIncreasePerDay] [float] NULL,
	[AddressID] [int] NULL,
	[OrganizerID] [int] NULL,
	[DateID] [int] NULL,
 CONSTRAINT [PK_Conferences] PRIMARY KEY CLUSTERED 
(
	[ConferenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Contact Information]    Script Date: 10.01.2020 12:32:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contact Information](
	[InformationId] [int] IDENTITY(1,1) NOT NULL,
	[Email] [nvarchar](50) NULL,
	[Phone] [varchar](50) NULL,
	[AddressID] [int] NULL,
 CONSTRAINT [PK_Contact Information] PRIMARY KEY CLUSTERED 
(
	[InformationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dates]    Script Date: 10.01.2020 12:32:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dates](
	[DateID] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Dates] PRIMARY KEY CLUSTERED 
(
	[DateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[nowa_tabela]    Script Date: 10.01.2020 12:32:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[nowa_tabela](
	[PersonID] [int] NULL,
	[LastName] [varchar](255) NULL,
	[FirstName] [varchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Organizers]    Script Date: 10.01.2020 12:32:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Organizers](
	[OrganizerID] [int] NOT NULL,
	[CompanyName] [nvarchar](50) NULL,
	[NIP] [varchar](50) NULL,
	[ContactName] [varchar](50) NULL,
	[ContactInformationID] [int] NULL,
 CONSTRAINT [PK_Organizers] PRIMARY KEY CLUSTERED 
(
	[OrganizerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Participants]    Script Date: 10.01.2020 12:32:19 ******/
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
/****** Object:  Table [dbo].[Payment Details]    Script Date: 10.01.2020 12:32:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payment Details](
	[PaymentDetailsID] [int] NOT NULL,
	[Paid] [bit] NULL,
	[PaymentDate] [date] NULL,
	[PaymentDeadline] [date] NULL,
	[FinalPrice] [money] NULL,
 CONSTRAINT [PK_Payment Details] PRIMARY KEY CLUSTERED 
(
	[PaymentDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[People]    Script Date: 10.01.2020 12:32:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[People](
	[PersonID] [int] IDENTITY(1,1) NOT NULL,
	[Firstname] [nvarchar](50) NULL,
	[Lastname] [nvarchar](50) NULL,
	[Student] [bit] NULL,
	[CompanyID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Workshop Reservations]    Script Date: 10.01.2020 12:32:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Workshop Reservations](
	[WorkshopReservationID] [int] NOT NULL,
	[WorkshopID] [int] NOT NULL,
	[ParticipantID] [int] NOT NULL,
	[PaymentDetailsID] [int] NULL,
 CONSTRAINT [PK_Workshop Reservations] PRIMARY KEY CLUSTERED 
(
	[WorkshopReservationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Workshops]    Script Date: 10.01.2020 12:32:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Workshops](
	[WorkshopID] [int] NOT NULL,
	[WorkshopName] [nvarchar](50) NULL,
	[WorkshopDescription] [nvarchar](50) NULL,
	[Limit] [int] NULL,
	[Price] [money] NULL,
	[Cancelled] [bit] NULL,
	[ConferenceID] [int] NULL,
	[OrganizerID] [int] NULL,
	[DateID] [int] NULL,
 CONSTRAINT [PK_Workshops] PRIMARY KEY CLUSTERED 
(
	[WorkshopID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Companies]    Script Date: 10.01.2020 12:32:19 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Companies] ON [dbo].[Companies]
(
	[ClientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Participants]    Script Date: 10.01.2020 12:32:19 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Participants] ON [dbo].[Participants]
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_People]    Script Date: 10.01.2020 12:32:19 ******/
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
ALTER TABLE [dbo].[Conference Resertvations]  WITH CHECK ADD  CONSTRAINT [FK_Conference Resertvations_Conferences] FOREIGN KEY([ConferenceID])
REFERENCES [dbo].[Conferences] ([ConferenceID])
GO
ALTER TABLE [dbo].[Conference Resertvations] CHECK CONSTRAINT [FK_Conference Resertvations_Conferences]
GO
ALTER TABLE [dbo].[Conference Resertvations]  WITH CHECK ADD  CONSTRAINT [FK_Conference Resertvations_Dates] FOREIGN KEY([DateID])
REFERENCES [dbo].[Dates] ([DateID])
GO
ALTER TABLE [dbo].[Conference Resertvations] CHECK CONSTRAINT [FK_Conference Resertvations_Dates]
GO
ALTER TABLE [dbo].[Conference Resertvations]  WITH CHECK ADD  CONSTRAINT [FK_Conference Resertvations_Payment Details] FOREIGN KEY([PaymentDetailsID])
REFERENCES [dbo].[Payment Details] ([PaymentDetailsID])
GO
ALTER TABLE [dbo].[Conference Resertvations] CHECK CONSTRAINT [FK_Conference Resertvations_Payment Details]
GO
ALTER TABLE [dbo].[Conferences]  WITH CHECK ADD  CONSTRAINT [FK_Conferences_Address] FOREIGN KEY([AddressID])
REFERENCES [dbo].[Address] ([AddressID])
GO
ALTER TABLE [dbo].[Conferences] CHECK CONSTRAINT [FK_Conferences_Address]
GO
ALTER TABLE [dbo].[Conferences]  WITH CHECK ADD  CONSTRAINT [FK_Conferences_Dates] FOREIGN KEY([DateID])
REFERENCES [dbo].[Dates] ([DateID])
GO
ALTER TABLE [dbo].[Conferences] CHECK CONSTRAINT [FK_Conferences_Dates]
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
ALTER TABLE [dbo].[Organizers]  WITH CHECK ADD  CONSTRAINT [FK_Organizers_Contact Information] FOREIGN KEY([ContactInformationID])
REFERENCES [dbo].[Contact Information] ([InformationId])
GO
ALTER TABLE [dbo].[Organizers] CHECK CONSTRAINT [FK_Organizers_Contact Information]
GO
ALTER TABLE [dbo].[Participants]  WITH CHECK ADD  CONSTRAINT [FK_Participants_Conference Resertvations] FOREIGN KEY([ReservastionID])
REFERENCES [dbo].[Conference Resertvations] ([ReservationID])
GO
ALTER TABLE [dbo].[Participants] CHECK CONSTRAINT [FK_Participants_Conference Resertvations]
GO
ALTER TABLE [dbo].[Participants]  WITH CHECK ADD  CONSTRAINT [FK_Participants_People] FOREIGN KEY([PersonID])
REFERENCES [dbo].[People] ([PersonID])
GO
ALTER TABLE [dbo].[Participants] CHECK CONSTRAINT [FK_Participants_People]
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
ALTER TABLE [dbo].[Workshop Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Workshop Reservations_Payment Details] FOREIGN KEY([PaymentDetailsID])
REFERENCES [dbo].[Payment Details] ([PaymentDetailsID])
GO
ALTER TABLE [dbo].[Workshop Reservations] CHECK CONSTRAINT [FK_Workshop Reservations_Payment Details]
GO
ALTER TABLE [dbo].[Workshop Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Workshop Reservations_Workshops] FOREIGN KEY([WorkshopID])
REFERENCES [dbo].[Workshops] ([WorkshopID])
GO
ALTER TABLE [dbo].[Workshop Reservations] CHECK CONSTRAINT [FK_Workshop Reservations_Workshops]
GO
ALTER TABLE [dbo].[Workshops]  WITH CHECK ADD  CONSTRAINT [FK_Workshops_Conferences] FOREIGN KEY([ConferenceID])
REFERENCES [dbo].[Conferences] ([ConferenceID])
GO
ALTER TABLE [dbo].[Workshops] CHECK CONSTRAINT [FK_Workshops_Conferences]
GO
ALTER TABLE [dbo].[Workshops]  WITH CHECK ADD  CONSTRAINT [FK_Workshops_Dates] FOREIGN KEY([DateID])
REFERENCES [dbo].[Dates] ([DateID])
GO
ALTER TABLE [dbo].[Workshops] CHECK CONSTRAINT [FK_Workshops_Dates]
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
