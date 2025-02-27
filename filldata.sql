Declare @Id int, @IdDB int
Declare @DB varchar(10), @USEDBquery varchar(20)
Declare @query varchar(max), @addQuery varchar(max), @insertDataQuery nvarchar(max)
SET @Id=0
SET @IdDB = 1

While @IdDB <= 10
BEGIN
    Set @DB = 'MYDB' + CAST(@IdDB as varchar(10))
    SET @query = FORMATMESSAGE(N'CREATE DATABASE %s', @DB)
    SET @USEDBquery = FORMATMESSAGE('USE %s', @DB)
    -- Create Tables
    BEGIN TRY
        EXEC(@query)
        PRINT 'RUN QUERY FOR Adding Table '
        SET @addQuery = '
         CREATE Table tblAuthors
            (
                    Id int identity primary key,
                    Author_name nvarchar(50),
                    country nvarchar(50)
            )
        '
        SET @query = FORMATMESSAGE('%s %s', @USEDBquery, @addQuery)
        PRINT @query
        EXEC(@query)
        PRINT @DB + ' insert on ' + CAST(@Id as varchar(10))
    END TRY
    BEGIN CATCH
        PRINT 'ERROR on ' + @DB + ' : ' +  cast (ERROR_LINE() as varchar(10))
            + ' MSG:' + ERROR_MESSAGE()
    END CATCH

    -- INSERT DATA INTO TABLE
    SET @insertDataQuery = '
        Insert Into tblAuthors values (''Author - '' + CAST(@Id as nvarchar(10)),
        ''Country - '' + CAST(@Id as nvarchar(10)) + '' name'')
       '
    SET @insertDataQuery = FORMATMESSAGE('%s %s', @USEDBquery ,@insertDataQuery);
    PRINT @insertDataQuery
    While @Id <= 10
        Begin
            Begin TRY
                EXECUTE sp_executesql
                    @insertDataQuery,
                    N'@Id int',
                    @Id = @Id;

                SET @Id = @Id+1
            END TRY
            BEGIN CATCH
                PRINT 'ERROR on INSERT ' + @DB + ' : ' +  cast (ERROR_LINE() as varchar(10))
                    + ' MSG: ' + ERROR_MESSAGE()
                SET @Id = @Id+1
            END CATCH
        End
    SET @Id = 0
    SET @IdDB = @IdDB + 1
END

--CREATE TESTDB

CREATE DATABASE testdb
GO
USE testdb
CREATE Table tblUsers( Id int identity primary key, name nvarchar(50), email nvarchar(100) )
GO
Insert Into tblUsers values ('User1','email1@smt.com'),('User2','email2@smt.com'),('User3','email3@smt.com')
GO
CREATE PROCEDURE sp_selectAllUsers	AS	SELECT * FROM tblUsers
GO
CREATE PROCEDURE sp_selectIdUser @Id int AS SELECT * FROM tblUsers WHERE Id = @Id
GO

-- END 
SELECT name FROM master.dbo.sysdatabases
SELECT TOP 10 * FROM MYDB10.dbo.tblAuthors
GO