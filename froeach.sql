USE [MvcWeb]
GO
/****** 物件:  StoredProcedure [dbo].[Namelist_test]    指令碼日期: 05/24/2018 10:37:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Namelist_test]

AS

DECLARE @NameList NVARCHAR(max),
		@count int,
		@row int,
		@uname nvarchar(20)
 

BEGIN
--	SET NOCOUNT ON;

	set @row = 1
	SELECT @count=COUNT(*) From users;
	
	SELECT ROW_NUMBER() OVER (ORDER BY id ASC) rowid, * into #mytemp  from users;

	set @NameList = ''
	while @row <= @count
	BEGIN
		SELECT @uname = Uname FROM #mytemp where rowid = @row
		set @row=@row +1
		set @NameList = @NameList+ @uname + ';'
	END

	SELECT @NameList as nl
END

-- exec Namelist_test