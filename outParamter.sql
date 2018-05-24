USE [ITTOOLS]
GO
/****** 物件:  StoredProcedure [dbo].[SaveS_SCANELEMS_app]    指令碼日期: 05/24/2018 10:31:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER  proc [dbo].[SaveS_SCANELEMS_app]   
@KCDEL0 varchar(15),   
@KTECU5 varchar(10) ,  
@KUSRNM nvarchar(10),   
@KTECU3 varchar(5) ,  
@DBLELE  numeric(9,2),  
@updatetime DateTime, 
@error int out 
as   
IF Exists(Select 1 from S_SCANELEMS where KCDEL0=@KCDEL0)
set @error=1
else
begin
insert into S_SCANELEMS(KCDEL0,KTECU5,KUSRNM,KTECU3,DBLELE,updatetime) values(@KCDEL0,@KTECU5,@KUSRNM,@KTECU3,@DBLELE,@updatetime)
set @error=2
end
