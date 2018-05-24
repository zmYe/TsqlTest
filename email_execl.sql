USE [ITTOOLS]
GO
/****** 物件:  StoredProcedure [dbo].[SP_JBINFO_SendEmail_VCP1660F]    指令碼日期: 05/24/2018 10:25:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[SP_JBINFO_SendEmail_VCP1660F](@RASFO varchar(35),@USERNAME varchar(20))

--  EXEC dbo.[SP_JBINFO_SendEmail] ''
AS


---先處理營業員的郵件
DECLARE @EmailList NVARCHAR(2000)   --當前相關的N個郵件地址　
DECLARE @SqlStr    NVARCHAR(2000)
DECLARE @CFNUM       Int
DECLARE @Email     NVARCHAR(200)
declare @RESULT int  
DECLARE @subject1   NVARCHAR(50)

Set   @CFNUM = 0

Set @EmailList=''
Select @CFNUM =  count(*) from OuterWeavingFactory where RASFO=@RASFO
IF @CFNUM > 0
   Select @EmailList=MailAdr +';toy21@163.com' from OuterWeavingFactory where RASFO=@RASFO
ELSE
   Select @EmailList='toy21@163.com'
SELECT @CFNUM =  count(*)   FROM  ITTOOLS.dbo.vcp1660f where [KPLFCT] = @RASFO and kissnd = 0 and KUSERNAME = @USERNAME

IF @CFNUM > 0
Begin

 
	  
       exec @RESULT= master..xp_cmdshell 'COPY D:\VCP1660F.xlsx   D:\外發匯總通知表.xlsx'
       insert into OPENROWSET('Microsoft.ACE.OLEDB.12.0','Excel 12.0;Database=D:\外發匯總通知表.xlsx','select * FROM [Sheet1$]')
		select [KCDORD],[KCDDIS],[K23DSC],[KPRICE],convert(varchar(13), cast([KDISQY] as float)) [KDISQY],
		[KZCSHU],REPLACE(REPLACE([KGYARN],'''',''''),' ','') [KGYARN],[KDDATE],'' 
	   FROM [ITTOOLS].[dbo].[vcp1660f] where [KPLFCT] = @RASFO and kissnd = 0 and KUSERNAME = @USERNAME
                      
   select  top 1 @subject1='外發匯總通知單_'+ KPLFCT FROM [ITTOOLS].[dbo].[vcp1660f] where [KPLFCT] = @RASFO and KUSERNAME = @USERNAME

   EXEC msdb.dbo.sp_send_dbmail  @recipients = @EmailList                                                                                                                                                                              
         , @body = '請查看附件 , 預2~3天送紗時間 , 幫忙夾回機位'
         , @file_attachments = 'D:\外發匯總通知表.xlsx'
--         , @subject = '外發匯總通知單'
		 , @subject = @subject1
         , @profile_name ='VCERP'

 update [ITTOOLS].[dbo].[VCP1660F] set kissnd = 1  where [KPLFCT] = @RASFO and kissnd = 0

 
End    



