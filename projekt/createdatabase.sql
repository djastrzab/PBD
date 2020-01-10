USE [master]
GO

/****** Object:  Database [u_jastrzab]    Script Date: 10.01.2020 10:21:12 ******/
CREATE DATABASE [u_jastrzab]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'u_jastrzab', FILENAME = N'/var/opt/mssql/data/u_jastrzab.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'u_jastrzab_log', FILENAME = N'/var/opt/mssql/data/u_jastrzab_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
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

ALTER DATABASE [u_jastrzab] SET  READ_WRITE 
GO

