USE master
GO
DROP MASTER KEY
CREATE MASTER KEY
    ENCRYPTION BY PASSWORD = '25600you_should_not_share__this_password!';
GO

ALTER MASTER KEY
    ADD ENCRYPTION BY SERVICE MASTER KEY;
GO

USE master
GO
DROP LOGIN SSFunctionLogin
DROP ASYMMETRIC KEY SSFunctionKey
CREATE ASYMMETRIC KEY SSFunctionKey
    FROM EXECUTABLE FILE = 'C:\SSFunction\SSFunction\bin\Debug\SSFunction.dll';

GO
CREATE LOGIN SSFunctionLogin FROM ASYMMETRIC KEY SSFunctionKey;
GO
GRANT UNSAFE ASSEMBLY TO SSFunctionLogin;
GO

USE Household
GO

DROP FUNCTION IF EXISTS dbo.RemoveNumbersWithRust
DROP ASSEMBLY IF EXISTS SSFunctionAssembly
CREATE ASSEMBLY SSFunctionAssembly
    FROM 'C:\SSFunction\SSFunction\bin\Debug\SSFunction.dll'
    WITH PERMISSION_SET = UNSAFE;
GO


DROP FUNCTION IF EXISTS dbo.RemoveNumbersWithRust
GO
CREATE FUNCTION dbo.RemoveNumbersWithRust(@input NVARCHAR(MAX))
    RETURNS NVARCHAR(MAX)
AS
    EXTERNAL NAME SSFunctionAssembly.[SSFunction.FunctionDefinitions].RemoveNumbersWithRust
GO


USE Household
GO

SELECT dbo.RemoveNumbersWithRust(N'The leading prime numbers are: 1, 2, 3, 5') AS result;
GO

USE Household
GO
/* The ALTER ASSEMBLY statement will fail if the .dll file has not changes since it was created or last altered. */
ALTER ASSEMBLY SSFunctionAssembly
    FROM 'C:\SSFunction\SSFunction\bin\Debug\SSFunction.dll'
    WITH PERMISSION_SET = UNSAFE;

GO

SELECT dbo.RemoveNumbersWithRust(N'Cleaned output says: "The leading prime numbers are: 1, 2, 3, 5"') AS result;