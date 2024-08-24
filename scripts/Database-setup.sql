-- Create the database
CREATE DATABASE EmployeeTrainingDB;
GO

-- Use the created database
USE EmployeeTrainingDB;
GO

-- Enable Change Data Capture (CDC) on the database
EXEC sys.sp_cdc_enable_db;
GO

-- Create the Employees table
CREATE TABLE Employees (
    EmployeeId INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Department NVARCHAR(100),
    DateOfJoining DATE
);
GO

-- Create the Trainings table
CREATE TABLE Trainings (
    TrainingId INT IDENTITY(1,1) PRIMARY KEY,
    TrainingName NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX),
    DurationHours INT,
    DateCreated DATE DEFAULT GETDATE()
);
GO

-- Create the Certifications table
CREATE TABLE Certifications (
    CertificationId INT IDENTITY(1,1) PRIMARY KEY,
    CertificationName NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX),
    ValidityYears INT,
    DateCreated DATE DEFAULT GETDATE()
);
GO

-- Create the TrainingRecords table
CREATE TABLE TrainingRecords (
    RecordId INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeId INT,
    TrainingId INT,
    CertificationId INT,
    CompletionDate DATE,
    Status NVARCHAR(50),
    FOREIGN KEY (EmployeeId) REFERENCES Employees(EmployeeId),
    FOREIGN KEY (TrainingId) REFERENCES Trainings(TrainingId),
    FOREIGN KEY (CertificationId) REFERENCES Certifications(CertificationId)
);
GO

-- Enable CDC on the tables
EXEC sys.sp_cdc_enable_table
    @source_schema = 'dbo',
    @source_name = 'Employees',
    @role_name = NULL;
GO

EXEC sys.sp_cdc_enable_table
    @source_schema = 'dbo',
    @source_name = 'Trainings',
    @role_name = NULL;
GO

EXEC sys.sp_cdc_enable_table
    @source_schema = 'dbo',
    @source_name = 'Certifications',
    @role_name = NULL;
GO

EXEC sys.sp_cdc_enable_table
    @source_schema = 'dbo',
    @source_name = 'TrainingRecords',
    @role_name = NULL;
GO

-- Insert sample data into the Employees table
INSERT INTO Employees (FirstName, LastName, Department, DateOfJoining)
VALUES 
('John', 'Doe', 'Engineering', '2021-03-15'),
('Jane', 'Smith', 'Human Resources', '2019-07-23'),
('Alice', 'Johnson', 'Finance', '2020-01-10');
GO

-- Insert sample data into the Trainings table
INSERT INTO Trainings (TrainingName, Description, DurationHours)
VALUES 
('Safety Training', 'Basic safety procedures and guidelines.', 8),
('Leadership Training', 'Developing leadership skills.', 16),
('Data Security', 'Understanding data protection and privacy.', 4);
GO

-- Insert sample data into the Certifications table
INSERT INTO Certifications (CertificationName, Description, ValidityYears)
VALUES 
('First Aid Certification', 'Basic first aid certification.', 2),
('Project Management', 'Certification in project management.', 3),
('Data Protection Officer', 'Certification for data protection officers.', 5);
GO

-- Insert sample data into the TrainingRecords table
INSERT INTO TrainingRecords (EmployeeId, TrainingId, CertificationId, CompletionDate, Status)
VALUES 
(1, 1, 1, '2022-06-01', 'Completed'),
(2, 2, 2, '2021-11-15', 'Completed'),
(3, 3, 3, '2022-01-20', 'In Progress');
GO
