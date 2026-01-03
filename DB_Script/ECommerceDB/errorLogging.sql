DROP TABLE IF EXISTS ErrorLog;
GO
-- =============================================
-- Error Logging Table for Database Operations
-- =============================================

CREATE TABLE ErrorLog (
    ErrorLogId INT IDENTITY(1,1) PRIMARY KEY,
    ErrorTime DATETIME DEFAULT GETDATE(),
    ErrorMessage NVARCHAR(4000) NOT NULL,
    ErrorSeverity INT NOT NULL,
    ErrorState INT NOT NULL,
    ErrorProcedure NVARCHAR(128) NULL,
    ErrorLine INT NULL,
    UserName NVARCHAR(128) DEFAULT SUSER_SNAME(),
    HostName NVARCHAR(128) DEFAULT HOST_NAME()
);
GO

-- Index for error log queries
CREATE INDEX IX_ErrorLog_ErrorTime ON ErrorLog(ErrorTime);
CREATE INDEX IX_ErrorLog_ErrorProcedure ON ErrorLog(ErrorProcedure);
GO