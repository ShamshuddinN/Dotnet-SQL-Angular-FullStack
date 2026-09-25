CREATE TABLE Procedure_Errors (
    Proc_Err_ID INT IDENTITY(1,1) PRIMARY KEY,
    Error_State INT,
    Error_Procedure VARCHAR(80),
    Error_Line INT,
    Error_Message VARCHAR(4000),
    Error_Time DATETIME DEFAULT GETDATE()
);


