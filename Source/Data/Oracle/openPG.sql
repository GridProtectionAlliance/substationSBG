--  ----------------------------------------------------------------------------------------------------
--  openPG Data Structures for MySQL - Gbtc
--
--  Copyright � 2011, Grid Protection Alliance.  All Rights Reserved.
--
--  Licensed to the Grid Protection Alliance (GPA) under one or more contributor license agreements. See
--  the NOTICE file distributed with this work for additional information regarding copyright ownership.
--  The GPA licenses this file to you under the Eclipse Public License -v 1.0 (the "License"); you may
--  not use this file except in compliance with the License. You may obtain a copy of the License at:
--
--      http://www.opensource.org/licenses/eclipse-1.0.php
--
--  Unless agreed to in writing, the subject software distributed under the License is distributed on an
--  "AS-IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. Refer to the
--  License for the specific language governing permissions and limitations.
--
--  Schema Modification History:
--  ----------------------------------------------------------------------------------------------------
--  05/07/2011 - J. Ritchie Carroll
--       Generated original version of schema.
--  ----------------------------------------------------------------------------------------------------

-- The following statements are used to create a tablespace, user, and schema.
-- Be sure to change the password.
-- CREATE TABLESPACE openPG_TS DATAFILE 'openPG.dbf' SIZE 20M AUTOEXTEND ON;
-- CREATE USER openPG IDENTIFIED BY MyPassword DEFAULT TABLESPACE openPG_TS;
-- GRANT UNLIMITED TABLESPACE TO openPG;
-- GRANT CREATE SESSION TO openPG;
-- ALTER SESSION SET CURRENT_SCHEMA = openPG;

CREATE TABLE ErrorLog(
    ID INT NOT NULL,
    Source VARCHAR2(200) NOT NULL,
    Message CLOB NOT NULL,
    Detail CLOB NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_ErrorLog_ID ON ErrorLog (ID ASC);
ALTER TABLE ErrorLog ADD CONSTRAINT PK_ErrorLog PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_ErrorLog START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_ErrorLog BEFORE INSERT ON ErrorLog
	FOR EACH ROW BEGIN SELECT SEQ_ErrorLog.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE Runtime(
    ID INT NOT NULL,
    SourceID INT NOT NULL,
    SourceTable VARCHAR2(200) NOT NULL
);

CREATE UNIQUE INDEX IX_Runtime_Source ON Runtime (SourceID ASC, SourceTable ASC);
CREATE UNIQUE INDEX IX_Runtime_ID ON Runtime (ID ASC);
ALTER TABLE Runtime ADD CONSTRAINT PK_Runtime PRIMARY KEY (SourceID, SourceTable);
CREATE SEQUENCE SEQ_Runtime START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_Runtime BEFORE INSERT ON Runtime
	FOR EACH ROW BEGIN SELECT SEQ_Runtime.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE AuditLog(
    ID INT NOT NULL,
    TableName VARCHAR2(200) NOT NULL,
    PrimaryKeyColumn VARCHAR2(200) NOT NULL,
    PrimaryKeyValue CLOB NOT NULL,
    ColumnName VARCHAR2(200) NOT NULL,
    OriginalValue CLOB,
    NewValue CLOB,
    Deleted NUMBER(3,0) DEFAULT 0 NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    PRIMARY KEY (ID)
);

CREATE SEQUENCE SEQ_AuditLog START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_AuditLog BEFORE INSERT ON AuditLog
	FOR EACH ROW BEGIN SELECT SEQ_AuditLog.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE Company(
    ID INT NOT NULL,
    Acronym VARCHAR2(200) NOT NULL,
    MapAcronym NCHAR(10) NOT NULL,
    Name VARCHAR2(200) NOT NULL,
    URL CLOB NULL,
    LoadOrder INT DEFAULT 0 NOT NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_Company_ID ON Company (ID ASC);
ALTER TABLE Company ADD CONSTRAINT PK_Company PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_Company START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_Company BEFORE INSERT ON Company
	FOR EACH ROW BEGIN SELECT SEQ_Company.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE ConfigurationEntity(
    SourceName VARCHAR2(200) NOT NULL,
    RuntimeName VARCHAR2(200) NOT NULL,
    Description CLOB NULL,
    LoadOrder INT DEFAULT 0 NOT NULL,
    Enabled NUMBER(3,0) DEFAULT 0 NOT NULL
);

CREATE TABLE Vendor(
    ID INT NOT NULL,
    Acronym VARCHAR2(200) NULL,
    Name VARCHAR2(200) NOT NULL,
    PhoneNumber VARCHAR2(200) NULL,
    ContactEmail VARCHAR2(200) NULL,
    URL CLOB NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_Vendor_ID ON Vendor (ID ASC);
ALTER TABLE Vendor ADD CONSTRAINT PK_Vendor PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_Vendor START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_Vendor BEFORE INSERT ON Vendor
	FOR EACH ROW BEGIN SELECT SEQ_Vendor.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE Protocol(
    ID INT NOT NULL,
    Acronym VARCHAR2(200) NOT NULL,
    Name VARCHAR2(200) NOT NULL,
    Type VARCHAR2(200) DEFAULT N'Frame' NOT NULL,
    Category VARCHAR2(200) DEFAULT N'Phasor' NOT NULL,
    AssemblyName VARCHAR2(1024) DEFAULT N'TVA.PhasorProtocols.dll' NOT NULL,
    TypeName VARCHAR2(200) DEFAULT N'TVA.PhasorProtocols.PhasorMeasurementMapper' NOT NULL,
    LoadOrder INT DEFAULT 0 NOT NULL
);

CREATE UNIQUE INDEX IX_Protocol_ID ON Protocol (ID ASC);
ALTER TABLE Protocol ADD CONSTRAINT PK_Protocol PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_Protocol START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_Protocol BEFORE INSERT ON Protocol
	FOR EACH ROW BEGIN SELECT SEQ_Protocol.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE SignalType(
    ID INT NOT NULL,
    Name VARCHAR2(200) NOT NULL,
    Acronym VARCHAR2(4) NOT NULL,
    Suffix VARCHAR2(2) NOT NULL,
    Abbreviation VARCHAR2(2) NOT NULL,
    Source VARCHAR2(10) NOT NULL,
    EngineeringUnits VARCHAR2(10) NULL
);

CREATE UNIQUE INDEX IX_SignalType_ID ON SignalType (ID ASC);
ALTER TABLE SignalType ADD CONSTRAINT PK_SignalType PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_SignalType START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_SignalType BEFORE INSERT ON SignalType
	FOR EACH ROW BEGIN SELECT SEQ_SignalType.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE Interconnection(
    ID INT NOT NULL,
    Acronym VARCHAR2(200) NOT NULL,
    Name VARCHAR2(200) NOT NULL,
    LoadOrder INT DEFAULT 0 NULL
);

CREATE UNIQUE INDEX IX_Interconnection_ID ON Interconnection (ID ASC);
ALTER TABLE Interconnection ADD CONSTRAINT PK_Interconnection PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_Interconnection START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_Interconnection BEFORE INSERT ON Interconnection
	FOR EACH ROW BEGIN SELECT SEQ_Interconnection.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE Node(
    ID NCHAR(36) NULL,
    Name VARCHAR2(200) NOT NULL,
    CompanyID INT NULL,
    Longitude DECIMAL(9, 6) NULL,
    Latitude DECIMAL(9, 6) NULL,
    Description CLOB NULL,
    ImagePath CLOB NULL,
    Settings CLOB NULL,
    MenuType VARCHAR2(200) DEFAULT N'File' NOT NULL,
    MenuData CLOB NOT NULL,
    Master NUMBER(3,0) DEFAULT 0 NOT NULL,
    LoadOrder INT DEFAULT 0 NOT NULL,
    Enabled NUMBER(3,0) DEFAULT 0 NOT NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_Node_ID ON Node (ID ASC);
ALTER TABLE Node ADD CONSTRAINT PK_Node PRIMARY KEY (ID);

CREATE TABLE DataOperation(
    NodeID NCHAR(36) NULL,
    Description CLOB NULL,
    AssemblyName CLOB NOT NULL,
    TypeName CLOB NOT NULL,
    MethodName VARCHAR2(200) NOT NULL,
    Arguments CLOB NULL,
    LoadOrder INT DEFAULT 0 NOT NULL,
    Enabled NUMBER(3,0) DEFAULT 0 NOT NULL
);

CREATE TABLE OtherDevice(
    ID INT NOT NULL,
    Acronym VARCHAR2(200) NOT NULL,
    Name VARCHAR2(200) NULL,
    IsConcentrator NUMBER(3,0) DEFAULT 0 NOT NULL,
    CompanyID INT NULL,
    VendorDeviceID INT NULL,
    Longitude DECIMAL(9, 6) NULL,
    Latitude DECIMAL(9, 6) NULL,
    InterconnectionID INT NULL,
    Planned NUMBER(3,0) DEFAULT 0 NOT NULL,
    Desired NUMBER(3,0) DEFAULT 0 NOT NULL,
    InProgress NUMBER(3,0) DEFAULT 0 NOT NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_OtherDevice_ID ON OtherDevice (ID ASC);
ALTER TABLE OtherDevice ADD CONSTRAINT PK_OtherDevice PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_OtherDevice START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_OtherDevice BEFORE INSERT ON OtherDevice
	FOR EACH ROW BEGIN SELECT SEQ_OtherDevice.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE Device(
    NodeID NCHAR(36) NOT NULL,
    ID INT NOT NULL,
    ParentID INT NULL,
    UniqueID NCHAR(36) NULL,
    Acronym VARCHAR2(200) NOT NULL,
    Name VARCHAR2(200) NULL,
	OriginalSource VARCHAR2(200) NULL,
    IsConcentrator NUMBER(3,0) DEFAULT 0 NOT NULL,
    CompanyID INT NULL,
    HistorianID INT NULL,
    AccessID INT DEFAULT 0 NOT NULL,
    VendorDeviceID INT NULL,
    ProtocolID INT NULL,
    Longitude DECIMAL(9, 6) NULL,
    Latitude DECIMAL(9, 6) NULL,
    InterconnectionID INT NULL,
    ConnectionString CLOB NULL,
    TimeZone VARCHAR2(200) NULL,
    FramesPerSecond INT DEFAULT 30 NULL,
    TimeAdjustmentTicks NUMBER(19,0) DEFAULT 0 NOT NULL,
    DataLossInterval FLOAT(24) DEFAULT 5 NOT NULL,
    AllowedParsingExceptions INT DEFAULT 10 NOT NULL,
    ParsingExceptionWindow FLOAT(24) DEFAULT 5 NOT NULL,
    DelayedConnectionInterval FLOAT(24) DEFAULT 5 NOT NULL,
    AllowUseOfCachedConfiguration NUMBER(3,0) DEFAULT 1 NOT NULL,
    AutoStartDataParsingSequence NUMBER(3,0) DEFAULT 1 NOT NULL,
    SkipDisableRealTimeData NUMBER(3,0) DEFAULT 0 NOT NULL,
    MeasurementReportingInterval INT DEFAULT 100000 NOT NULL,
    ConnectOnDemand NUMBER(3,0) DEFAULT 1 NOT NULL,
    ContactList CLOB NULL,
    MeasuredLines INT NULL,
    LoadOrder INT DEFAULT 0 NOT NULL,
    Enabled NUMBER(3,0) DEFAULT 0 NOT NULL,	
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_Device_ID ON Device (ID ASC);
CREATE UNIQUE INDEX IX_Device_UniqueID ON Device (UniqueID ASC);
CREATE UNIQUE INDEX IX_Device_NodeID_Acronym ON Device (NodeID ASC, Acronym ASC);
ALTER TABLE Device ADD CONSTRAINT PK_Device PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_Device START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_Device BEFORE INSERT ON Device
	FOR EACH ROW BEGIN SELECT SEQ_Device.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE VendorDevice(
    ID INT NOT NULL,
    VendorID INT DEFAULT 10 NOT NULL,
    Name VARCHAR2(200) NOT NULL,
    Description CLOB NULL,
    URL CLOB NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_VendorDevice_ID ON VendorDevice (ID ASC);
ALTER TABLE VendorDevice ADD CONSTRAINT PK_VendorDevice PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_VendorDevice START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_VendorDevice BEFORE INSERT ON VendorDevice
	FOR EACH ROW BEGIN SELECT SEQ_VendorDevice.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE OutputStreamDeviceDigital(
    NodeID NCHAR(36) NOT NULL,
    OutputStreamDeviceID INT NOT NULL,
    ID INT NOT NULL,
    Label CLOB NOT NULL,
    MaskValue INT DEFAULT 0 NOT NULL,
    LoadOrder INT DEFAULT 0 NOT NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_OutStreamDevDigital_ID ON OutputStreamDeviceDigital (ID ASC);
ALTER TABLE OutputStreamDeviceDigital ADD CONSTRAINT PK_OutStreamDevDigital PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_OutStreamDevDigital START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_OutStreamDevDigital BEFORE INSERT ON OutputStreamDeviceDigital
	FOR EACH ROW BEGIN SELECT SEQ_OutStreamDevDigital.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE OutputStreamDevicePhasor(
    NodeID NCHAR(36) NOT NULL,
    OutputStreamDeviceID INT NOT NULL,
    ID INT NOT NULL,
    Label VARCHAR2(200) NOT NULL,
    Type NCHAR(1) DEFAULT N'V' NOT NULL,
    Phase NCHAR(1) DEFAULT N'+' NOT NULL,
    ScalingValue INT DEFAULT 0 NOT NULL,
    LoadOrder INT DEFAULT 0 NOT NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_OutStreamDevPhasor ON OutputStreamDevicePhasor (ID ASC);
ALTER TABLE OutputStreamDevicePhasor ADD CONSTRAINT PK_OutStreamDevPhasor PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_OutStreamDevPhasor START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_OutStreamDevPhasor BEFORE INSERT ON OutputStreamDevicePhasor
	FOR EACH ROW BEGIN SELECT SEQ_OutStreamDevPhasor.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE OutputStreamDeviceAnalog(
    NodeID NCHAR(36) NOT NULL,
    OutputStreamDeviceID INT NOT NULL,
    ID INT NOT NULL,
    Label VARCHAR2(16) NOT NULL,
    Type INT DEFAULT 0 NOT NULL,
    ScalingValue INT DEFAULT 0 NOT NULL,
    LoadOrder INT DEFAULT 0 NOT NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_OutStreamDevAnalog ON OutputStreamDeviceAnalog (ID ASC);
ALTER TABLE OutputStreamDeviceAnalog ADD CONSTRAINT PK_OutStreamDevAnalog PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_OutStreamDevAnalog START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_OutStreamDevAnalog BEFORE INSERT ON OutputStreamDeviceAnalog
	FOR EACH ROW BEGIN SELECT SEQ_OutStreamDevAnalog.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE Measurement(
    PointID INT NOT NULL,
    SignalID NCHAR(36) NULL,
    HistorianID INT NULL,
    DeviceID INT NULL,
    PointTag VARCHAR2(200) NOT NULL,
    AlternateTag VARCHAR2(200) NULL,
    SignalTypeID INT NOT NULL,
    PhasorSourceIndex INT NULL,
    SignalReference VARCHAR2(200) NOT NULL,
    Adder FLOAT(24) DEFAULT 0.0 NOT NULL,
    Multiplier FLOAT(24) DEFAULT 1.0 NOT NULL,
    Description CLOB NULL,
    Subscribed NUMBER(3,0) DEFAULT 0 NOT NULL,
    Internal NUMBER(3,0) DEFAULT 1 NOT NULL,
    Enabled NUMBER(3,0) DEFAULT 0 NOT NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_Measurement_SignalID ON Measurement (SignalID ASC);
CREATE UNIQUE INDEX IX_Measurement_PointID ON Measurement (PointID ASC);
ALTER TABLE Measurement ADD CONSTRAINT PK_Measurement PRIMARY KEY (SignalID);
ALTER TABLE Measurement ADD CONSTRAINT UQ_Measurement_PointID UNIQUE (PointID);
CREATE SEQUENCE SEQ_Measurement START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_Measurement BEFORE INSERT ON Measurement
	FOR EACH ROW BEGIN SELECT SEQ_Measurement.nextval INTO :NEW.PointID FROM dual;
END;
/

CREATE TABLE ImportedMeasurement(
    NodeID NCHAR(36) NULL,
    SourceNodeID NCHAR(36) NULL,
    SignalID NCHAR(36) NULL,
    Source VARCHAR2(200) NOT NULL,
    PointID INT NOT NULL,
    PointTag VARCHAR2(200) NOT NULL,
    AlternateTag VARCHAR2(200) NULL,
    SignalTypeAcronym VARCHAR2(4) NULL,
    SignalReference CLOB NOT NULL,
    FramesPerSecond INT NULL,
    ProtocolAcronym VARCHAR2(200) NULL,
    ProtocolType VARCHAR2(200) DEFAULT 'Frame' NOT NULL,
    PhasorID INT NULL,
    PhasorType NCHAR(1) NULL,
    Phase NCHAR(1) NULL,
    Adder FLOAT(24) DEFAULT 0.0 NOT NULL,
    Multiplier FLOAT(24) DEFAULT 1.0 NOT NULL,
    CompanyAcronym VARCHAR2(200) NULL,
    Longitude DECIMAL(9, 6) NULL,
    Latitude DECIMAL(9, 6) NULL,
    Description CLOB NULL,
    Enabled NUMBER(3,0) DEFAULT 0 NOT NULL
);

CREATE TABLE Statistic(
    ID INT NOT NULL,
    Source VARCHAR2(20) NOT NULL,
    SignalIndex INT NOT NULL,
    Name VARCHAR2(200) NOT NULL,
    Description CLOB NULL,
    AssemblyName CLOB NOT NULL,
    TypeName CLOB NOT NULL,
    MethodName VARCHAR2(200) NOT NULL,
    Arguments CLOB NULL,
    Enabled NUMBER(3,0) DEFAULT 0 NOT NULL,
    DataType VARCHAR2(200) NULL,
    DisplayFormat VARCHAR2(200) NULL,
    IsConnectedState NUMBER(3,0) DEFAULT 0 NOT NULL,
    LoadOrder INT DEFAULT 0 NOT NULL
);

CREATE UNIQUE INDEX IX_Statistic_ID ON Statistic (ID ASC);
CREATE UNIQUE INDEX IX_Statistic_Source_SigIndex ON Statistic (Source ASC, SignalIndex ASC);
ALTER TABLE Statistic ADD CONSTRAINT PK_Statistic PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_Statistic START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_Statistic BEFORE INSERT ON Statistic
	FOR EACH ROW BEGIN SELECT SEQ_Statistic.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE OutputStreamMeasurement(
    NodeID NCHAR(36) NOT NULL,
    AdapterID INT NOT NULL,
    ID INT NOT NULL,
    HistorianID INT NULL,
    PointID INT NOT NULL,
    SignalReference VARCHAR2(200) NOT NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_OutputStreamMeasurement_ID ON OutputStreamMeasurement (ID ASC);
ALTER TABLE OutputStreamMeasurement ADD CONSTRAINT PK_OutputStreamMeasurement PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_OutputStreamMeasurement START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_OutputStreamMeasurement BEFORE INSERT ON OutputStreamMeasurement
	FOR EACH ROW BEGIN SELECT SEQ_OutputStreamMeasurement.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE OutputStreamDevice(
    NodeID NCHAR(36) NOT NULL,
    AdapterID INT NOT NULL,
    ID INT NOT NULL,
    IDCode INT DEFAULT 0 NOT NULL,
    Acronym VARCHAR2(200) NOT NULL,
    BpaAcronym VARCHAR2(4) NULL,
    Name VARCHAR2(200) NOT NULL,
    PhasorDataFormat VARCHAR2(15) NULL,
    FrequencyDataFormat VARCHAR2(15) NULL,
    AnalogDataFormat VARCHAR2(15) NULL,
    CoordinateFormat VARCHAR2(15) NULL,
    LoadOrder INT DEFAULT 0 NOT NULL,
    Enabled NUMBER(3,0) DEFAULT 0 NOT NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_OutputStreamDevice_ID ON OutputStreamDevice (ID ASC);
ALTER TABLE OutputStreamDevice ADD CONSTRAINT PK_OutputStreamDevice PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_OutputStreamDevice START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_OutputStreamDevice BEFORE INSERT ON OutputStreamDevice
	FOR EACH ROW BEGIN SELECT SEQ_OutputStreamDevice.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE Phasor(
    ID INT NOT NULL,
    DeviceID INT NOT NULL,
    Label VARCHAR2(200) NOT NULL,
    Type NCHAR(1) DEFAULT N'V' NOT NULL,
    Phase NCHAR(1) DEFAULT N'+' NOT NULL,
    DestinationPhasorID INT NULL,
    SourceIndex INT DEFAULT 0 NOT NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_Phasor_ID ON Phasor (ID ASC);
ALTER TABLE Phasor ADD CONSTRAINT PK_Phasor PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_Phasor START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_Phasor BEFORE INSERT ON Phasor
	FOR EACH ROW BEGIN SELECT SEQ_Phasor.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE CalculatedMeasurement(
    NodeID NCHAR(36) NOT NULL,
    ID INT NOT NULL,
    Acronym VARCHAR2(200) NOT NULL,
    Name VARCHAR2(200) NULL,
    AssemblyName CLOB NOT NULL,
    TypeName CLOB NOT NULL,
    ConnectionString CLOB NULL,
    ConfigSection VARCHAR2(200) NULL,
    InputMeasurements CLOB NULL,
    OutputMeasurements CLOB NULL,
    MinimumMeasurementsToUse INT DEFAULT -1 NOT NULL,
    FramesPerSecond INT DEFAULT 30 NOT NULL,
    LagTime FLOAT(24) DEFAULT 3.0 NOT NULL,
    LeadTime FLOAT(24) DEFAULT 1.0 NOT NULL,
    UseLocalClockAsRealTime NUMBER(3,0) DEFAULT 0 NOT NULL,
    AllowSortsByArrival NUMBER(3,0) DEFAULT 1 NOT NULL,
    IgnoreBadTimeStamps NUMBER(3,0) DEFAULT 0 NOT NULL,
    TimeResolution INT DEFAULT 10000 NOT NULL,
    AllowPreemptivePublishing NUMBER(3,0) DEFAULT 1 NOT NULL,
    PerformTimeReasonabilityCheck NUMBER(3,0) DEFAULT 1 NOT NULL,
    DownsamplingMethod VARCHAR2(15) DEFAULT N'LastReceived' NOT NULL,
    LoadOrder INT DEFAULT 0 NOT NULL,
    Enabled NUMBER(3,0) DEFAULT 0 NOT NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_CalculatedMeasurement_ID ON CalculatedMeasurement (ID ASC);
ALTER TABLE CalculatedMeasurement ADD CONSTRAINT PK_CalculatedMeasurement PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_CalculatedMeasurement START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_CalculatedMeasurement BEFORE INSERT ON CalculatedMeasurement
	FOR EACH ROW BEGIN SELECT SEQ_CalculatedMeasurement.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE CustomActionAdapter(
    NodeID NCHAR(36) NOT NULL,
    ID INT NOT NULL,
    AdapterName VARCHAR2(200) NOT NULL,
    AssemblyName CLOB NOT NULL,
    TypeName CLOB NOT NULL,
    ConnectionString CLOB NULL,
    LoadOrder INT DEFAULT 0 NOT NULL,
    Enabled NUMBER(3,0) DEFAULT 0 NOT NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_CustomActionAdapter_ID ON CustomActionAdapter (ID ASC);
ALTER TABLE CustomActionAdapter ADD CONSTRAINT PK_CustomActionAdapter PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_CustomActionAdapter START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_CustomActionAdapter BEFORE INSERT ON CustomActionAdapter
	FOR EACH ROW BEGIN SELECT SEQ_CustomActionAdapter.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE Historian(
    NodeID NCHAR(36) NOT NULL,
    ID INT NOT NULL,
    Acronym VARCHAR2(200) NOT NULL,
    Name VARCHAR2(200) NULL,
    AssemblyName CLOB NULL,
    TypeName CLOB NULL,
    ConnectionString CLOB NULL,
    IsLocal NUMBER(3,0) DEFAULT 1 NOT NULL,
    MeasurementReportingInterval INT DEFAULT 100000 NOT NULL,
    Description CLOB NULL,
    LoadOrder INT DEFAULT 0 NOT NULL,
    Enabled NUMBER(3,0) DEFAULT 0 NOT NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_Historian_ID ON Historian (ID ASC);
ALTER TABLE Historian ADD CONSTRAINT PK_Historian PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_Historian START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_Historian BEFORE INSERT ON Historian
	FOR EACH ROW BEGIN SELECT SEQ_Historian.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE CustomInputAdapter(
    NodeID NCHAR(36) NOT NULL,
    ID INT NOT NULL,
    AdapterName VARCHAR2(200) NOT NULL,
    AssemblyName CLOB NOT NULL,
    TypeName CLOB NOT NULL,
    ConnectionString CLOB NULL,
    LoadOrder INT DEFAULT 0 NOT NULL,
    Enabled NUMBER(3,0) DEFAULT 0 NOT NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_CustomInputAdapter ON CustomInputAdapter (ID ASC);
ALTER TABLE CustomInputAdapter ADD CONSTRAINT PK_CustomInputAdapter PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_CustomInputAdapter START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_CustomInputAdapter BEFORE INSERT ON CustomInputAdapter
	FOR EACH ROW BEGIN SELECT SEQ_CustomInputAdapter.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE OutputStream(
    NodeID NCHAR(36) NOT NULL,
    ID INT NOT NULL,
    Acronym VARCHAR2(200) NOT NULL,
    Name VARCHAR2(200) NULL,
    Type INT DEFAULT 0 NOT NULL,
    ConnectionString CLOB NULL,
    DataChannel CLOB NULL,
    CommandChannel CLOB NULL,
    IDCode INT DEFAULT 0 NOT NULL,
    AutoPublishConfigFrame NUMBER(3,0) DEFAULT 0 NOT NULL,
    AutoStartDataChannel NUMBER(3,0) DEFAULT 1 NOT NULL,
    NominalFrequency INT DEFAULT 60 NOT NULL,
    FramesPerSecond INT DEFAULT 30 NOT NULL,
    LagTime FLOAT(24) DEFAULT 3.0 NOT NULL,
    LeadTime FLOAT(24) DEFAULT 1.0 NOT NULL,
    UseLocalClockAsRealTime NUMBER(3,0) DEFAULT 0 NOT NULL,
    AllowSortsByArrival NUMBER(3,0) DEFAULT 1 NOT NULL,
    IgnoreBadTimeStamps NUMBER(3,0) DEFAULT 0 NOT NULL,
    TimeResolution INT DEFAULT 330000 NOT NULL,
    AllowPreemptivePublishing NUMBER(3,0) DEFAULT 1 NOT NULL,
    PerformTimeReasonabilityCheck NUMBER(3,0) DEFAULT 1 NOT NULL,
    DownsamplingMethod VARCHAR2(15) DEFAULT N'LastReceived' NOT NULL,
    DataFormat VARCHAR2(15) DEFAULT N'FloatingPoint' NOT NULL,
    CoordinateFormat VARCHAR2(15) DEFAULT N'Polar' NOT NULL,
    CurrentScalingValue INT DEFAULT 2423 NOT NULL,
    VoltageScalingValue INT DEFAULT 2725785 NOT NULL,
    AnalogScalingValue INT DEFAULT 1373291 NOT NULL,
    DigitalMaskValue INT DEFAULT -65536 NOT NULL,
    LoadOrder INT DEFAULT 0 NOT NULL,
    Enabled NUMBER(3,0) DEFAULT 0 NOT NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_OutputStream_ID ON OutputStream (ID ASC);
ALTER TABLE OutputStream ADD CONSTRAINT PK_OutputStream PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_OutputStream START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_OutputStream BEFORE INSERT ON OutputStream
	FOR EACH ROW BEGIN SELECT SEQ_OutputStream.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE CustomOutputAdapter(
    NodeID NCHAR(36) NOT NULL,
    ID INT NOT NULL,
    AdapterName VARCHAR2(200) NOT NULL,
    AssemblyName CLOB NOT NULL,
    TypeName CLOB NOT NULL,
    ConnectionString CLOB NULL,
    LoadOrder INT DEFAULT 0 NOT NULL,
    Enabled NUMBER(3,0) DEFAULT 0 NOT NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_CustomOutputAdapter_ID ON CustomOutputAdapter (ID ASC);
ALTER TABLE CustomOutputAdapter ADD CONSTRAINT PK_CustomOutputAdapter PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_CustomOutputAdapter START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_CustomOutputAdapter BEFORE INSERT ON CustomOutputAdapter
	FOR EACH ROW BEGIN SELECT SEQ_CustomOutputAdapter.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE AccessLog (
    ID NUMBER(11, 0) NOT NULL,
    UserName VARCHAR2(200) NOT NULL,
    AccessGranted NUMBER(3,0) NOT NULL,
    "Comment" CLOB,
    CreatedOn DATE DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_AccessLog_ID ON AccessLog (ID ASC);
ALTER TABLE AccessLog ADD CONSTRAINT PK_AccessLog PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_AccessLog START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_AccessLog BEFORE INSERT ON AccessLog
	FOR EACH ROW BEGIN SELECT SEQ_AccessLog.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE UserAccount (
    ID NCHAR(36) DEFAULT N'' NOT NULL,
    Name VARCHAR2(200) NOT NULL,
    Password VARCHAR2(200) DEFAULT NULL,
    FirstName VARCHAR2(200) DEFAULT NULL,
    LastName VARCHAR2(200) DEFAULT NULL,
    DefaultNodeID NCHAR(36) NOT NULL,
    Phone VARCHAR2(200) DEFAULT NULL,
    Email VARCHAR2(200) DEFAULT NULL,
    LockedOut NUMBER(3,0) DEFAULT 0 NOT NULL,
    UseADAuthentication NUMBER(3,0) DEFAULT 1 NOT NULL,
    ChangePasswordOn DATE DEFAULT NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_UserAccount_ID ON UserAccount (ID ASC);
ALTER TABLE UserAccount ADD CONSTRAINT PK_UserAccount PRIMARY KEY (ID);

CREATE TABLE SecurityGroup (
    ID NCHAR(36) DEFAULT N'' NOT NULL,
    Name VARCHAR2(200) NOT NULL,
    Description CLOB,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_SecurityGroup_ID ON SecurityGroup (ID ASC);
ALTER TABLE SecurityGroup ADD CONSTRAINT PK_SecurityGroup PRIMARY KEY (ID);

CREATE TABLE ApplicationRole (
    ID NCHAR(36) DEFAULT N'' NOT NULL,
    Name VARCHAR2(200) NOT NULL,
    Description CLOB,
    NodeID NCHAR(36) NOT NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_ApplicationRole ON ApplicationRole (ID ASC);
ALTER TABLE ApplicationRole ADD CONSTRAINT PK_ApplicationRole PRIMARY KEY (ID);

CREATE TABLE ApplicationRoleSecurityGroup (
    ApplicationRoleID NCHAR(36) NOT NULL,
    SecurityGroupID NCHAR(36) NOT NULL  
);

CREATE TABLE ApplicationRoleUserAccount (
    ApplicationRoleID NCHAR(36) NOT NULL,
    UserAccountID NCHAR(36) NOT NULL  
);

CREATE TABLE SecurityGroupUserAccount (
    SecurityGroupID NCHAR(36) NOT NULL,
    UserAccountID NCHAR(36) NOT NULL  
);

-- ----------------------------------------------------------------------------

CREATE TABLE Subscriber (
    NodeID NCHAR(36) NOT NULL,
    ID NCHAR(36) DEFAULT N'' NOT NULL,
    Acronym VARCHAR2(200) NOT NULL,
    Name VARCHAR2(200) NULL,
    SharedSecret VARCHAR2(200) NOT NULL,
    AuthKey CLOB NOT NULL,
    ValidIPAddresses CLOB NOT NULL,
    Enabled NUMBER(3,0) DEFAULT 0 NOT NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_Subscriber_NodeID_ID ON Subscriber (NodeID ASC, ID ASC);
CREATE UNIQUE INDEX IX_Subscriber_NodeID_Acronym ON Subscriber (NodeID ASC, Acronym ASC);
ALTER TABLE Subscriber ADD CONSTRAINT PK_Subscriber PRIMARY KEY (NodeID, ID);

CREATE TABLE SubscriberMeasurement(
    NodeID NCHAR(36) NOT NULL,
    SubscriberID NCHAR(36) NOT NULL,
    SignalID NCHAR(36) NOT NULL,
    Allowed NUMBER(3,0) DEFAULT 0 NOT NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_SubscriberMeasurement ON SubscriberMeasurement (NodeID ASC, SubscriberID ASC, SignalID ASC);
ALTER TABLE SubscriberMeasurement ADD CONSTRAINT PK_SubscriberMeasurement PRIMARY KEY (NodeID, SubscriberID, SignalID);

CREATE TABLE SubscriberMeasurementGroup (
    NodeID NCHAR(36) NOT NULL,
    SubscriberID NCHAR(36) NOT NULL,
    MeasurementGroupID INT NOT NULL,
    Allowed NUMBER(3,0) DEFAULT 0 NOT NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_SubscriberMeasurementGroup ON SubscriberMeasurementGroup (NodeID ASC, SubscriberID ASC, MeasurementGroupID ASC);
ALTER TABLE SubscriberMeasurementGroup ADD CONSTRAINT PK_SubscriberMeasurementGroup PRIMARY KEY (NodeID, SubscriberID, MeasurementGroupID);

CREATE TABLE MeasurementGroup (
    NodeID NCHAR(36) NOT NULL,
    ID INT NOT NULL,
    Name VARCHAR2(200) NOT NULL,
    Description CLOB,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_MeasurementGroup_ID ON MeasurementGroup (ID ASC);
ALTER TABLE MeasurementGroup ADD CONSTRAINT PK_MeasurementGroup PRIMARY KEY (ID);
CREATE SEQUENCE SEQ_MeasurementGroup START WITH 1 INCREMENT BY 1;
CREATE TRIGGER AI_MeasurementGroup BEFORE INSERT ON MeasurementGroup
	FOR EACH ROW BEGIN SELECT SEQ_MeasurementGroup.nextval INTO :NEW.ID FROM dual;
END;
/

CREATE TABLE MeasurementGroupMeasurement (
    NodeID NCHAR(36) NOT NULL,
    MeasurementGroupID INT NOT NULL,
    SignalID NCHAR(36) NOT NULL,
    CreatedOn DATE DEFAULT N'' NOT NULL,
    CreatedBy VARCHAR2(200) DEFAULT N'' NOT NULL,
    UpdatedOn DATE DEFAULT N'' NOT NULL,
    UpdatedBy VARCHAR2(200) DEFAULT N'' NOT NULL
);

CREATE UNIQUE INDEX IX_MeasurementGroupMeasurement ON MeasurementGroupMeasurement (NodeID ASC, MeasurementGroupID ASC, SignalID ASC);
ALTER TABLE MeasurementGroupMeasurement ADD CONSTRAINT PK_MeasurementGroupMeasurement PRIMARY KEY (NodeID, MeasurementGroupID, SignalID);

ALTER TABLE Subscriber ADD CONSTRAINT FK_Subscriber_Node FOREIGN KEY(NodeID) REFERENCES Node (ID);

ALTER TABLE SubscriberMeasurement ADD CONSTRAINT FK_SubscriberMeasurement_Node FOREIGN KEY(NodeID) REFERENCES Node (ID);

ALTER TABLE SubscriberMeasurement ADD CONSTRAINT FK_SubscriberMeasure_Measure FOREIGN KEY(SignalID) REFERENCES Measurement (SignalID);

ALTER TABLE SubscriberMeasurement ADD CONSTRAINT FK_SubscribeMeasure_Subscribe FOREIGN KEY(NodeID, SubscriberID) REFERENCES Subscriber (NodeID, ID);

ALTER TABLE SubscriberMeasurementGroup ADD CONSTRAINT FK_SubscriberMeasureGrp_Node FOREIGN KEY(NodeID) REFERENCES Node (ID);

ALTER TABLE SubscriberMeasurementGroup ADD CONSTRAINT FK_SubscribMeasureGrp_Subscrib FOREIGN KEY(NodeID, SubscriberID) REFERENCES Subscriber (NodeID, ID);

ALTER TABLE SubscriberMeasurementGroup ADD CONSTRAINT FK_SubscribMeasurGrp_MeasurGrp FOREIGN KEY(MeasurementGroupID) REFERENCES MeasurementGroup (ID);

ALTER TABLE MeasurementGroup ADD CONSTRAINT FK_MeasurementGroup_Node FOREIGN KEY(NodeID) REFERENCES Node (ID);

ALTER TABLE MeasurementGroupMeasurement ADD CONSTRAINT FK_MeasureGrpMeasure_Node FOREIGN KEY(NodeID) REFERENCES Node (ID);

ALTER TABLE MeasurementGroupMeasurement ADD CONSTRAINT FK_MeasureGrpMeasure_Measure FOREIGN KEY(SignalID) REFERENCES Measurement (SignalID);

ALTER TABLE MeasurementGroupMeasurement ADD CONSTRAINT FK_MeasurGrpMeasur_MeasurGrp FOREIGN KEY(MeasurementGroupID) REFERENCES MeasurementGroup (ID);

-- ----------------------------------------------------------------------------

ALTER TABLE Node ADD CONSTRAINT FK_Node_Company FOREIGN KEY(CompanyID) REFERENCES Company (ID);

ALTER TABLE DataOperation ADD CONSTRAINT FK_DataOperation_Node FOREIGN KEY(NodeID) REFERENCES Node (ID);

ALTER TABLE OtherDevice ADD CONSTRAINT FK_OtherDevice_Company FOREIGN KEY(CompanyID) REFERENCES Company (ID);

ALTER TABLE OtherDevice ADD CONSTRAINT FK_OtherDevice_Interconnection FOREIGN KEY(InterconnectionID) REFERENCES Interconnection (ID);

ALTER TABLE OtherDevice ADD CONSTRAINT FK_OtherDevice_VendorDevice FOREIGN KEY(VendorDeviceID) REFERENCES VendorDevice (ID);

ALTER TABLE Device ADD CONSTRAINT FK_Device_Company FOREIGN KEY(CompanyID) REFERENCES Company (ID);

ALTER TABLE Device ADD CONSTRAINT FK_Device_Device FOREIGN KEY(ParentID) REFERENCES Device (ID);

ALTER TABLE Device ADD CONSTRAINT FK_Device_Historian FOREIGN KEY(HistorianID) REFERENCES Historian (ID);

ALTER TABLE Device ADD CONSTRAINT FK_Device_Interconnection FOREIGN KEY(InterconnectionID) REFERENCES Interconnection (ID);

ALTER TABLE Device ADD CONSTRAINT FK_Device_Node FOREIGN KEY(NodeID) REFERENCES Node (ID);

ALTER TABLE Device ADD CONSTRAINT FK_Device_Protocol FOREIGN KEY(ProtocolID) REFERENCES Protocol (ID);

ALTER TABLE Device ADD CONSTRAINT FK_Device_VendorDevice FOREIGN KEY(VendorDeviceID) REFERENCES VendorDevice (ID);

ALTER TABLE VendorDevice ADD CONSTRAINT FK_VendorDevice_Vendor FOREIGN KEY(VendorID) REFERENCES Vendor (ID);

ALTER TABLE OutputStreamDeviceDigital ADD CONSTRAINT FK_OutStreamDeviceDigital_Node FOREIGN KEY(NodeID) REFERENCES Node (ID);

ALTER TABLE OutputStreamDeviceDigital ADD CONSTRAINT FK_OutStrDevDigital_OutStrDev FOREIGN KEY(OutputStreamDeviceID) REFERENCES OutputStreamDevice (ID) ON DELETE CASCADE;

ALTER TABLE OutputStreamDevicePhasor ADD CONSTRAINT FK_OutStreamDevicePhasor_Node FOREIGN KEY(NodeID) REFERENCES Node (ID);

ALTER TABLE OutputStreamDevicePhasor ADD CONSTRAINT FK_OutStrDevPhasor_OutStrDev FOREIGN KEY(OutputStreamDeviceID) REFERENCES OutputStreamDevice (ID) ON DELETE CASCADE;

ALTER TABLE OutputStreamDeviceAnalog ADD CONSTRAINT FK_OutStreamDeviceAnalog_Node FOREIGN KEY(NodeID) REFERENCES Node (ID);

ALTER TABLE OutputStreamDeviceAnalog ADD CONSTRAINT FK_OutStrDevAnalog_OutStDev FOREIGN KEY(OutputStreamDeviceID) REFERENCES OutputStreamDevice (ID) ON DELETE CASCADE;

ALTER TABLE Measurement ADD CONSTRAINT FK_Measurement_Device FOREIGN KEY(DeviceID) REFERENCES Device (ID) ON DELETE CASCADE;

ALTER TABLE Measurement ADD CONSTRAINT FK_Measurement_Historian FOREIGN KEY(HistorianID) REFERENCES Historian (ID);

ALTER TABLE Measurement ADD CONSTRAINT FK_Measurement_SignalType FOREIGN KEY(SignalTypeID) REFERENCES SignalType (ID);

ALTER TABLE ImportedMeasurement ADD CONSTRAINT FK_ImportedMeasurement_Node FOREIGN KEY(NodeID) REFERENCES Node (ID);

ALTER TABLE OutputStreamMeasurement ADD CONSTRAINT FK_OutStrMeasurement_Historian FOREIGN KEY(HistorianID) REFERENCES Historian (ID);

ALTER TABLE OutputStreamMeasurement ADD CONSTRAINT FK_OutStrMeasure_Measure FOREIGN KEY(PointID) REFERENCES Measurement (PointID) ON DELETE CASCADE;

ALTER TABLE OutputStreamMeasurement ADD CONSTRAINT FK_OutStreamMeasurement_Node FOREIGN KEY(NodeID) REFERENCES Node (ID);

ALTER TABLE OutputStreamMeasurement ADD CONSTRAINT FK_OutStrMeasurement_OutStr FOREIGN KEY(AdapterID) REFERENCES OutputStream (ID) ON DELETE CASCADE;

ALTER TABLE OutputStreamDevice ADD CONSTRAINT FK_OutputStreamDevice_Node FOREIGN KEY(NodeID) REFERENCES Node (ID);

ALTER TABLE OutputStreamDevice ADD CONSTRAINT FK_OutStreamDevice_OutStream FOREIGN KEY(AdapterID) REFERENCES OutputStream (ID) ON DELETE CASCADE;

ALTER TABLE Phasor ADD CONSTRAINT FK_Phasor_Device FOREIGN KEY(DeviceID) REFERENCES Device (ID) ON DELETE CASCADE;

ALTER TABLE Phasor ADD CONSTRAINT FK_Phasor_Phasor FOREIGN KEY(DestinationPhasorID) REFERENCES Phasor (ID);

ALTER TABLE CalculatedMeasurement ADD CONSTRAINT FK_CalculatedMeasurement_Node FOREIGN KEY(NodeID) REFERENCES Node (ID);

ALTER TABLE CustomActionAdapter ADD CONSTRAINT FK_CustomActionAdapter_Node FOREIGN KEY(NodeID) REFERENCES Node (ID);

ALTER TABLE Historian ADD CONSTRAINT FK_Historian_Node FOREIGN KEY(NodeID) REFERENCES Node (ID);

ALTER TABLE CustomInputAdapter ADD CONSTRAINT FK_CustomInputAdapter_Node FOREIGN KEY(NodeID) REFERENCES Node (ID);

ALTER TABLE OutputStream ADD CONSTRAINT FK_OutputStream_Node FOREIGN KEY(NodeID) REFERENCES Node (ID);

ALTER TABLE CustomOutputAdapter ADD CONSTRAINT FK_CustomOutputAdapter_Node FOREIGN KEY(NodeID) REFERENCES Node (ID);

ALTER TABLE ApplicationRoleSecurityGroup ADD CONSTRAINT FK_AppRoleSecurityGrp_AppRole FOREIGN KEY (ApplicationRoleID) REFERENCES applicationrole (ID) ON DELETE CASCADE;

ALTER TABLE ApplicationRoleSecurityGroup ADD CONSTRAINT FK_AppRoleSecurGrp_SecurGrp FOREIGN KEY (SecurityGroupID) REFERENCES securitygroup (ID) ON DELETE CASCADE;

ALTER TABLE UserAccount ADD CONSTRAINT FK_useraccount FOREIGN KEY (DefaultNodeID) REFERENCES node (ID) ON DELETE CASCADE;

ALTER TABLE ApplicationRole ADD CONSTRAINT FK_applicationrole FOREIGN KEY (NodeID) REFERENCES node (ID) ON DELETE CASCADE;

ALTER TABLE ApplicationRoleUserAccount ADD CONSTRAINT FK_AppRoleUserAcct_UserAcct FOREIGN KEY (UserAccountID) REFERENCES useraccount (ID) ON DELETE CASCADE;

ALTER TABLE ApplicationRoleUserAccount ADD CONSTRAINT FK_AppRoleUserAccount_AppRole FOREIGN KEY (ApplicationRoleID) REFERENCES applicationrole (ID) ON DELETE CASCADE;

ALTER TABLE SecurityGroupUserAccount ADD CONSTRAINT FK_SecurityGrpUsrAcct_UsrAcct FOREIGN KEY (UserAccountID) REFERENCES useraccount (ID) ON DELETE CASCADE;

ALTER TABLE SecurityGroupUserAccount ADD CONSTRAINT FK_SecurGrpUsrAcct_SecurGrp FOREIGN KEY (SecurityGroupID) REFERENCES securitygroup (ID) ON DELETE CASCADE;

CREATE VIEW RuntimeOutputStreamMeasurement
AS
SELECT OutputStreamMeasurement.NodeID, Runtime.ID AS AdapterID, Historian.Acronym AS Historian, 
    OutputStreamMeasurement.PointID, OutputStreamMeasurement.SignalReference
FROM OutputStreamMeasurement LEFT OUTER JOIN
    Historian ON OutputStreamMeasurement.HistorianID = Historian.ID LEFT OUTER JOIN
    Runtime ON OutputStreamMeasurement.AdapterID = Runtime.SourceID AND Runtime.SourceTable = N'OutputStream'
ORDER BY OutputStreamMeasurement.HistorianID, OutputStreamMeasurement.PointID;

CREATE VIEW RuntimeHistorian
AS
SELECT Historian.NodeID, Runtime.ID, Historian.Acronym AS AdapterName,
    CASE DBMS_LOB.COMPARE(TRIM(Historian.AssemblyName || EMPTY_CLOB()), EMPTY_CLOB()) WHEN 0 THEN TO_CLOB(N'HistorianAdapters.dll') ELSE Historian.AssemblyName END AS AssemblyName,
    CASE DBMS_LOB.COMPARE(TRIM(Historian.TypeName || EMPTY_CLOB()), EMPTY_CLOB()) WHEN 0 THEN (CASE IsLocal WHEN 1 THEN TO_CLOB(N'HistorianAdapters.LocalOutputAdapter') ELSE TO_CLOB(N'HistorianAdapters.RemoteOutputAdapter') END) ELSE Historian.TypeName END AS TypeName,
    (Historian.ConnectionString || N';' ||
	(N'instanceName=' || Historian.Acronym) || (N'sourceids=' || Historian.Acronym) || N';' ||
    N'measurementReportingInterval=' || Historian.MeasurementReportingInterval) AS ConnectionString
FROM Historian LEFT OUTER JOIN
    Runtime ON Historian.ID = Runtime.SourceID AND Runtime.SourceTable = N'Historian'
WHERE (Historian.Enabled <> 0)
ORDER BY Historian.LoadOrder;

CREATE VIEW RuntimeDevice
AS
SELECT Device.NodeID, Runtime.ID, Device.Acronym AS AdapterName, TO_CLOB(Protocol.AssemblyName) AS AssemblyName, TO_CLOB(Protocol.TypeName) AS TypeName,
    Device.ConnectionString || N';' ||
	N'isConcentrator=' || Device.IsConcentrator || N';' ||
    N'accessID=' || Device.AccessID || N';' ||
    NVL2(Device.TimeZone, N'timeZone=' || Device.TimeZone, N'') || N';' ||
    N'timeAdjustmentTicks=' || Device.TimeAdjustmentTicks || N';' ||
    NVL2(Protocol.Acronym, N'phasorProtocol=' || Protocol.Acronym, N'') || N';' ||
    N'dataLossInterval=' || Device.DataLossInterval || N';' ||
    N'allowedParsingExceptions=' || Device.AllowedParsingExceptions || N';' ||
    N'parsingExceptionWindow=' || Device.ParsingExceptionWindow || N';' ||
    N'delayedConnectionInterval=' || Device.DelayedConnectionInterval || N';' ||
    N'allowUseOfCachedConfiguration=' || Device.AllowUseOfCachedConfiguration || N';' ||
    N'autoStartDataParsingSequence=' || Device.AutoStartDataParsingSequence || N';' ||
    N'skipDisableRealTimeData=' || Device.SkipDisableRealTimeData || N';' ||
    N'measurementReportingInterval=' || Device.MeasurementReportingInterval AS ConnectionString
FROM Device LEFT OUTER JOIN
    Protocol ON Device.ProtocolID = Protocol.ID LEFT OUTER JOIN
    Runtime ON Device.ID = Runtime.SourceID AND Runtime.SourceTable = N'Device'
WHERE (Device.Enabled <> 0 AND Device.ParentID IS NULL)
ORDER BY Device.LoadOrder;

CREATE VIEW RuntimeCustomOutputAdapter
AS
SELECT CustomOutputAdapter.NodeID, Runtime.ID, CustomOutputAdapter.AdapterName, 
    TRIM(CustomOutputAdapter.AssemblyName) AS AssemblyName, TRIM(CustomOutputAdapter.TypeName) AS TypeName, CustomOutputAdapter.ConnectionString
FROM CustomOutputAdapter LEFT OUTER JOIN
    Runtime ON CustomOutputAdapter.ID = Runtime.SourceID AND Runtime.SourceTable = N'CustomOutputAdapter'
WHERE (CustomOutputAdapter.Enabled <> 0)
ORDER BY CustomOutputAdapter.LoadOrder;

CREATE VIEW RuntimeInputStreamDevice
AS
SELECT Device.NodeID, Runtime_P.ID AS ParentID, Runtime.ID, Device.Acronym, Device.Name, Device.AccessID
FROM Device LEFT OUTER JOIN
    Runtime ON Device.ID = Runtime.SourceID AND Runtime.SourceTable = N'Device' LEFT OUTER JOIN
    Runtime Runtime_P ON Device.ParentID = Runtime_P.SourceID AND Runtime_P.SourceTable = N'Device'
WHERE (Device.IsConcentrator = 0) AND (Device.Enabled <> 0) AND (Device.ParentID IS NOT NULL)
ORDER BY Device.LoadOrder;

CREATE VIEW RuntimeCustomInputAdapter
AS
SELECT CustomInputAdapter.NodeID, Runtime.ID, CustomInputAdapter.AdapterName, 
    TRIM(CustomInputAdapter.AssemblyName) AS AssemblyName, TRIM(CustomInputAdapter.TypeName) AS TypeName, CustomInputAdapter.ConnectionString
FROM CustomInputAdapter LEFT OUTER JOIN
    Runtime ON CustomInputAdapter.ID = Runtime.SourceID AND Runtime.SourceTable = N'CustomInputAdapter'
WHERE (CustomInputAdapter.Enabled <> 0)
ORDER BY CustomInputAdapter.LoadOrder;

CREATE VIEW RuntimeOutputStreamDevice
AS
SELECT OutputStreamDevice.NodeID, Runtime.ID AS ParentID, OutputStreamDevice.ID, OutputStreamDevice.IDCode, OutputStreamDevice.Acronym, 
    OutputStreamDevice.BpaAcronym, OutputStreamDevice.Name, NULLIF(OutputStreamDevice.PhasorDataFormat, '') AS PhasorDataFormat, NULLIF(OutputStreamDevice.FrequencyDataFormat, '') AS FrequencyDataFormat,
    NULLIF(OutputStreamDevice.AnalogDataFormat, '') AS AnalogDataFormat, NULLIF(OutputStreamDevice.CoordinateFormat, '') AS CoordinateFormat, OutputStreamDevice.LoadOrder
FROM OutputStreamDevice LEFT OUTER JOIN
    Runtime ON OutputStreamDevice.AdapterID = Runtime.SourceID AND Runtime.SourceTable = N'OutputStream'
WHERE (OutputStreamDevice.Enabled <> 0)
ORDER BY OutputStreamDevice.LoadOrder;

CREATE VIEW RuntimeOutputStream
AS
SELECT OutputStream.NodeID, Runtime.ID, OutputStream.Acronym AS AdapterName, 
    TO_CLOB(N'TVA.PhasorProtocols.dll') AS AssemblyName, 
    CASE Type WHEN 1 THEN TO_CLOB(N'TVA.PhasorProtocols.BpaPdcStream.Concentrator') ELSE TO_CLOB(N'TVA.PhasorProtocols.IeeeC37_118.Concentrator') END AS TypeName,
    OutputStream.ConnectionString || N';' ||
    NVL2(OutputStream.DataChannel, N'dataChannel={' || OutputStream.DataChannel || N'}', N'') || N';' ||
    NVL2(OutputStream.CommandChannel, N'commandChannel={' || OutputStream.CommandChannel || N'}', N'') || N';' ||
    N'idCode=' || OutputStream.IDCode || N';' ||
    N'autoPublishConfigFrame=' || OutputStream.AutoPublishConfigFrame || N';' ||
    N'autoStartDataChannel=' || OutputStream.AutoStartDataChannel || N';' ||
    N'nominalFrequency=' || OutputStream.NominalFrequency || N';' ||
    N'lagTime=' || OutputStream.LagTime || N';' ||
    N'leadTime=' || OutputStream.LeadTime || N';' ||
    N'framesPerSecond=' || OutputStream.FramesPerSecond || N';' ||
    N'useLocalClockAsRealTime=' || OutputStream.UseLocalClockAsRealTime || N';' ||
    N'allowSortsByArrival=' || OutputStream.AllowSortsByArrival || N';' ||
    N'ignoreBadTimestamps=' || OutputStream.IgnoreBadTimeStamps || N';' ||
    N'timeResolution=' || OutputStream.TimeResolution || N';' ||
    N'allowPreemptivePublishing=' || OutputStream.AllowPreemptivePublishing || N';' ||
    N'downsamplingMethod=' || OutputStream.DownsamplingMethod || N';' ||
    N'dataFormat=' || OutputStream.DataFormat || N';' ||
    N'coordinateFormat=' || OutputStream.CoordinateFormat || N';' ||
    N'currentScalingValue=' || OutputStream.CurrentScalingValue || N';' ||
    N'voltageScalingValue=' || OutputStream.VoltageScalingValue || N';' ||
    N'analogScalingValue=' || OutputStream.AnalogScalingValue || N';' ||
    N'performTimestampReasonabilityCheck=' || OutputStream.PerformTimeReasonabilityCheck || N';' ||
    N'digitalMaskValue=' || OutputStream.DigitalMaskValue AS ConnectionString
FROM OutputStream LEFT OUTER JOIN
    Runtime ON OutputStream.ID = Runtime.SourceID AND Runtime.SourceTable = N'OutputStream'
WHERE (OutputStream.Enabled <> 0)
ORDER BY OutputStream.LoadOrder;

CREATE VIEW RuntimeCustomActionAdapter
AS
SELECT CustomActionAdapter.NodeID, Runtime.ID, CustomActionAdapter.AdapterName, 
    TRIM(CustomActionAdapter.AssemblyName) AS AssemblyName, TRIM(CustomActionAdapter.TypeName) AS TypeName, CustomActionAdapter.ConnectionString
FROM CustomActionAdapter LEFT OUTER JOIN
    Runtime ON CustomActionAdapter.ID = Runtime.SourceID AND Runtime.SourceTable = N'CustomActionAdapter'
WHERE (CustomActionAdapter.Enabled <> 0)
ORDER BY CustomActionAdapter.LoadOrder;

CREATE VIEW RuntimeCalculatedMeasurement
AS
SELECT CalculatedMeasurement.NodeID, Runtime.ID, CalculatedMeasurement.Acronym AS AdapterName, 
    TRIM(CalculatedMeasurement.AssemblyName) AS AssemblyName, TRIM(CalculatedMeasurement.TypeName) AS TypeName,
    CalculatedMeasurement.ConnectionString || N';' ||
	NVL2(ConfigSection, N'configurationSection=' || ConfigSection, N'') || N';' ||
    N'minimumMeasurementsToUse=' || CalculatedMeasurement.MinimumMeasurementsToUse || N';' ||
    N'framesPerSecond=' || CalculatedMeasurement.FramesPerSecond || N';' ||
    N'lagTime=' || CalculatedMeasurement.LagTime || N';' ||
    N'leadTime=' || CalculatedMeasurement.LeadTime || N';' ||
    NVL2(InputMeasurements, N'inputMeasurementKeys={' || InputMeasurements || N'}', N'') || N';' ||
    NVL2(OutputMeasurements, N'outputMeasurements={' || OutputMeasurements || N'}', N'') || N';' ||
    N'ignoreBadTimestamps=' || CalculatedMeasurement.IgnoreBadTimeStamps || N';' ||
    N'timeResolution=' || CalculatedMeasurement.TimeResolution || N';' ||
    N'allowPreemptivePublishing=' || CalculatedMeasurement.AllowPreemptivePublishing || N';' ||
    N'performTimestampReasonabilityCheck=' || CalculatedMeasurement.PerformTimeReasonabilityCheck || N';' ||
    N'downsamplingMethod=' || CalculatedMeasurement.DownsamplingMethod || N';' ||
    N'useLocalClockAsRealTime=' || CalculatedMeasurement.UseLocalClockAsRealTime AS ConnectionString
FROM CalculatedMeasurement LEFT OUTER JOIN
    Runtime ON CalculatedMeasurement.ID = Runtime.SourceID AND Runtime.SourceTable = N'CalculatedMeasurement'
WHERE (CalculatedMeasurement.Enabled <> 0)
ORDER BY CalculatedMeasurement.LoadOrder;

CREATE VIEW ActiveMeasurement
AS
SELECT COALESCE(Historian.NodeID, Device.NodeID) AS NodeID, COALESCE(Device.NodeID, Historian.NodeID) AS SourceNodeID, COALESCE(Historian.Acronym, Device.Acronym, '__') || ':' ||
    Measurement.PointID AS ID, Measurement.SignalID, Measurement.PointTag, Measurement.AlternateTag, TO_CLOB(Measurement.SignalReference) AS SignalReference, Measurement.Internal, Measurement.Subscribed,
    Device.Acronym AS Device, CASE WHEN Device.IsConcentrator = 0 AND Device.ParentID IS NOT NULL THEN RuntimeP.ID ELSE Runtime.ID END AS DeviceID, COALESCE(Device.FramesPerSecond, 30) AS FramesPerSecond, 
    Protocol.Acronym AS Protocol, Protocol.Type AS ProtocolType, SignalType.Acronym AS SignalType, Phasor.ID AS PhasorID, Phasor.Type AS PhasorType, Phasor.Phase, Measurement.Adder, 
    Measurement.Multiplier, Company.Acronym AS Company, Device.Longitude, Device.Latitude, Measurement.Description
FROM Company RIGHT OUTER JOIN
    Device ON Company.ID = Device.CompanyID RIGHT OUTER JOIN
    Measurement LEFT OUTER JOIN
    SignalType ON Measurement.SignalTypeID = SignalType.ID ON Device.ID = Measurement.DeviceID LEFT OUTER JOIN
    Phasor ON Measurement.DeviceID = Phasor.DeviceID AND 
    Measurement.PhasorSourceIndex = Phasor.SourceIndex LEFT OUTER JOIN
    Protocol ON Device.ProtocolID = Protocol.ID LEFT OUTER JOIN
    Historian ON Measurement.HistorianID = Historian.ID LEFT OUTER JOIN
    Runtime ON Device.ID = Runtime.SourceID AND Runtime.SourceTable = N'Device' LEFT OUTER JOIN
    Runtime RuntimeP ON RuntimeP.SourceID = Device.ParentID AND RuntimeP.SourceTable = N'Device'
WHERE (Device.Enabled <> 0 OR Device.Enabled IS NULL) AND (Measurement.Enabled <> 0)
UNION ALL
SELECT NodeID, SourceNodeID, Source || ':' || PointID AS ID, SignalID, PointTag,
    AlternateTag, SignalReference, 0 AS Internal, 1 AS Subscribed, NULL AS Device, NULL AS DeviceID,
    FramesPerSecond, ProtocolAcronym AS Protocol, ProtocolType, SignalTypeAcronym AS SignalType, PhasorID, PhasorType, Phase, Adder, Multiplier,
    CompanyAcronym AS Company, Longitude, Latitude, Description
FROM ImportedMeasurement
WHERE ImportedMeasurement.Enabled <> 0;

CREATE VIEW RuntimeStatistic
AS
SELECT Node.ID AS NodeID, Statistic.ID AS ID, Statistic.Source, Statistic.SignalIndex, Statistic.Name, Statistic.Description,
    Statistic.AssemblyName, Statistic.TypeName, Statistic.MethodName, Statistic.Arguments, Statistic.Enabled
FROM Statistic, Node;

CREATE VIEW IaonOutputAdapter
AS
SELECT NodeID, ID, AdapterName, AssemblyName, TypeName, ConnectionString
FROM RuntimeHistorian
UNION ALL
SELECT NodeID, ID, AdapterName, AssemblyName, TypeName, ConnectionString
FROM RuntimeCustomOutputAdapter;

CREATE VIEW IaonInputAdapter
AS
SELECT NodeID, ID, AdapterName, AssemblyName, TypeName, ConnectionString
FROM RuntimeDevice
UNION ALL
SELECT NodeID, ID, AdapterName, AssemblyName, TypeName, ConnectionString
FROM RuntimeCustomInputAdapter;

CREATE VIEW IaonActionAdapter
AS
SELECT Node.ID AS NodeID, 0 AS ID, 'PHASOR!SERVICES' AS AdapterName, TO_CLOB(N'TVA.PhasorProtocols.dll') AS AssemblyName, TO_CLOB(N'TVA.PhasorProtocols.CommonPhasorServices') AS TypeName, TO_CLOB(N'') AS ConnectionString
FROM Node
UNION ALL
SELECT NodeID, ID, AdapterName, AssemblyName, TypeName, ConnectionString
FROM RuntimeOutputStream
UNION ALL
SELECT NodeID, ID, AdapterName, AssemblyName, TypeName, ConnectionString
FROM RuntimeCalculatedMeasurement
UNION ALL
SELECT NodeID, ID, AdapterName, AssemblyName, TypeName, ConnectionString
FROM RuntimeCustomActionAdapter;
      
CREATE VIEW MeasurementDetail
AS
SELECT     Device.CompanyID, Company.Acronym AS CompanyAcronym, Company.Name AS CompanyName, Measurement.SignalID, 
    Measurement.HistorianID, Historian.Acronym AS HistorianAcronym, Historian.ConnectionString AS HistorianConnectionString, 
    Measurement.PointID, Measurement.PointTag, Measurement.AlternateTag, Measurement.DeviceID,  COALESCE (Device.NodeID, Historian.NodeID) AS NodeID, 
    Device.Acronym AS DeviceAcronym, Device.Name AS DeviceName, COALESCE(Device.FramesPerSecond, 30) AS FramesPerSecond, Device.Enabled AS DeviceEnabled, Device.ContactList, 
    Device.VendorDeviceID, VendorDevice.Name AS VendorDeviceName, VendorDevice.Description AS VendorDeviceDescription, 
    Device.ProtocolID, Protocol.Acronym AS ProtocolAcronym, Protocol.Name AS ProtocolName, Measurement.SignalTypeID, 
    Measurement.PhasorSourceIndex, Phasor.Label AS PhasorLabel, Phasor.Type AS PhasorType, Phasor.Phase, 
    Measurement.SignalReference, Measurement.Adder, Measurement.Multiplier, Measurement.Description, Measurement.Subscribed, Measurement.Internal, Measurement.Enabled, 
    COALESCE (SignalType.EngineeringUnits, '') AS EngineeringUnits, SignalType.Source, SignalType.Acronym AS SignalAcronym, 
    SignalType.Name AS SignalName, SignalType.Suffix AS SignalTypeSuffix, Device.Longitude, Device.Latitude,
    COALESCE(Historian.Acronym, Device.Acronym, '__') || ':' || Measurement.PointID AS ID
FROM Company RIGHT OUTER JOIN
    Device ON Company.ID = Device.CompanyID RIGHT OUTER JOIN
    Measurement LEFT OUTER JOIN
    SignalType ON Measurement.SignalTypeID = SignalType.ID ON Device.ID = Measurement.DeviceID LEFT OUTER JOIN
    Phasor ON Measurement.DeviceID = Phasor.DeviceID AND 
    Measurement.PhasorSourceIndex = Phasor.SourceIndex LEFT OUTER JOIN
    VendorDevice ON Device.VendorDeviceID = VendorDevice.ID LEFT OUTER JOIN
    Protocol ON Device.ProtocolID = Protocol.ID LEFT OUTER JOIN
    Historian ON Measurement.HistorianID = Historian.ID;

CREATE VIEW HistorianMetadata
AS
SELECT PointID AS HistorianID, CASE SignalAcronym WHEN 'DIGI' THEN 1 ELSE 0 END AS DataType, PointTag AS Name, SignalReference AS Synonym1, 
    SignalAcronym AS Synonym2, AlternateTag AS Synonym3, Description, VendorDeviceDescription AS HardwareInfo, N'' AS Remarks, 
    HistorianAcronym AS PlantCode, 1 AS UnitNumber, DeviceAcronym AS SystemName, ProtocolID AS SourceID, Enabled, 1 / FramesPerSecond AS ScanRate, 
    0 AS CompressionMinTime, 0 AS CompressionMaxTime, EngineeringUnits,
    CASE SignalAcronym WHEN 'FREQ' THEN 59.95 WHEN 'VPHM' THEN 475000 WHEN 'IPHM' THEN 0 WHEN 'VPHA' THEN -181 WHEN 'IPHA' THEN -181 ELSE 0 END AS LowWarning,
    CASE SignalAcronym WHEN 'FREQ' THEN 60.05 WHEN 'VPHM' THEN 525000 WHEN 'IPHM' THEN 3150 WHEN 'VPHA' THEN 181 WHEN 'IPHA' THEN 181 ELSE 0 END AS HighWarning,
    CASE SignalAcronym WHEN 'FREQ' THEN 59.90 WHEN 'VPHM' THEN 450000 WHEN 'IPHM' THEN 0 WHEN 'VPHA' THEN -181 WHEN 'IPHA' THEN -181 ELSE 0 END AS LowAlarm,
    CASE SignalAcronym WHEN 'FREQ' THEN 60.10 WHEN 'VPHM' THEN 550000 WHEN 'IPHM' THEN 3300 WHEN 'VPHA' THEN 181 WHEN 'IPHA' THEN 181 ELSE 0 END AS HighAlarm,
    CASE SignalAcronym WHEN 'FREQ' THEN 59.95 WHEN 'VPHM' THEN 475000 WHEN 'IPHM' THEN 0 WHEN 'VPHA' THEN -180 WHEN 'IPHA' THEN -180 ELSE 0 END AS LowRange,
    CASE SignalAcronym WHEN 'FREQ' THEN 60.05 WHEN 'VPHM' THEN 525000 WHEN 'IPHM' THEN 3000 WHEN 'VPHA' THEN 180 WHEN 'IPHA' THEN 180 ELSE 0 END AS HighRange,
    0.0 AS CompressionLimit, 0.0 AS ExceptionLimit, CASE SignalAcronym WHEN 'DIGI' THEN 0 ELSE 7 END AS DisplayDigits, N'' AS SetDescription,
    '' AS ClearDescription, 0 AS AlarmState, 5 AS ChangeSecurity, 0 AS AccessSecurity, 0 AS StepCheck, 0 AS AlarmEnabled, 0 AS AlarmFlags, 0 AS AlarmDelay,
    0 AS AlarmToFile, 0 AS AlarmByEmail, 0 AS AlarmByPager, 0 AS AlarmByPhone, ContactList AS AlarmEmails, N'' AS AlarmPagers, N'' AS AlarmPhones
FROM MeasurementDetail;

CREATE VIEW CalculatedMeasurementDetail
AS
SELECT CM.NodeID, CM.ID, CM.Acronym, COALESCE(CM.Name, '') AS Name, CM.AssemblyName, CM.TypeName, CM.ConnectionString || EMPTY_CLOB() AS ConnectionString,
    COALESCE(CM.ConfigSection, '') AS ConfigSection, CM.InputMeasurements || EMPTY_CLOB() AS InputMeasurements, CM.OutputMeasurements || EMPTY_CLOB() AS OutputMeasurements,
    CM.MinimumMeasurementsToUse, CM.FramesPerSecond, CM.LagTime, CM.LeadTime, CM.UseLocalClockAsRealTime, CM.AllowSortsByArrival, CM.LoadOrder, CM.Enabled,
    N.Name AS NodeName, CM.IgnoreBadTimeStamps, CM.TimeResolution, CM.AllowPreemptivePublishing, COALESCE(CM.DownsamplingMethod, '') AS DownsamplingMethod, CM.PerformTimeReasonabilityCheck
FROM CalculatedMeasurement CM, Node N
WHERE CM.NodeID = N.ID;

CREATE VIEW HistorianDetail
AS
SELECT H.NodeID, H.ID, H.Acronym, COALESCE(H.Name, '') AS Name, H.AssemblyName || EMPTY_CLOB() AS AssemblyName, H.TypeName || EMPTY_CLOB() AS TypeName, 
    H.ConnectionString || EMPTY_CLOB() AS ConnectionString, H.IsLocal, H.Description || EMPTY_CLOB() AS Description, H.LoadOrder, H.Enabled, N.Name AS NodeName, H.MeasurementReportingInterval 
FROM Historian H INNER JOIN Node N ON H.NodeID = N.ID;

CREATE VIEW NodeDetail
AS
SELECT N.ID, N.Name, N.CompanyID AS CompanyID, COALESCE(N.Longitude, 0) AS Longitude, COALESCE(N.Latitude, 0) AS Latitude, 
    N.Description || EMPTY_CLOB() AS Description, N.ImagePath || EMPTY_CLOB() AS ImagePath, N.Settings || EMPTY_CLOB() AS Settings, N.MenuType, N.MenuData, N.Master, N.LoadOrder, N.Enabled, COALESCE(C.Name, '') AS CompanyName
FROM Node N LEFT JOIN Company C 
ON N.CompanyID = C.ID;

CREATE VIEW VendorDetail
AS
SELECT ID, COALESCE(Acronym, '') AS Acronym, Name, COALESCE(PhoneNumber, '') AS PhoneNumber, COALESCE(ContactEmail, '') AS ContactEmail, URL || EMPTY_CLOB() AS URL 
FROM Vendor;

CREATE VIEW CustomActionAdapterDetail AS
SELECT CA.NodeID, CA.ID, CA.AdapterName, CA.AssemblyName, CA.TypeName, CA.ConnectionString || EMPTY_CLOB() AS ConnectionString, CA.LoadOrder, 
    CA.Enabled, N.Name AS NodeName
FROM CustomActionAdapter CA INNER JOIN Node N ON CA.NodeID = N.ID;
 
CREATE VIEW CustomInputAdapterDetail AS
SELECT CA.NodeID, CA.ID, CA.AdapterName, CA.AssemblyName, CA.TypeName, CA.ConnectionString || EMPTY_CLOB() AS ConnectionString, CA.LoadOrder, 
    CA.Enabled, N.Name AS NodeName
FROM CustomInputAdapter CA INNER JOIN Node N ON CA.NodeID = N.ID;
 
CREATE VIEW CustomOutputAdapterDetail AS
SELECT CA.NodeID, CA.ID, CA.AdapterName, CA.AssemblyName, CA.TypeName, CA.ConnectionString || EMPTY_CLOB() AS ConnectionString, CA.LoadOrder, 
    CA.Enabled, N.Name AS NodeName
FROM CustomOutputAdapter CA INNER JOIN Node N ON CA.NodeID = N.ID;
 
CREATE VIEW IaonTreeView AS
SELECT 'Action Adapters' AS AdapterType, NodeID, ID, AdapterName, AssemblyName, TypeName, ConnectionString || EMPTY_CLOB() AS ConnectionString
FROM IaonActionAdapter
UNION ALL
SELECT 'Input Adapters' AS AdapterType, NodeID, ID, AdapterName, AssemblyName, TypeName, ConnectionString || EMPTY_CLOB() AS ConnectionString
FROM IaonInputAdapter
UNION ALL
SELECT 'Output Adapters' AS AdapterType, NodeID, ID, AdapterName, AssemblyName, TypeName, ConnectionString || EMPTY_CLOB() AS ConnectionString
FROM IaonOutputAdapter;
 
CREATE VIEW OtherDeviceDetail AS
SELECT OD.ID, OD.Acronym, COALESCE(OD.Name, '') AS Name, OD.IsConcentrator, OD.CompanyID, OD.VendorDeviceID, OD.Longitude, OD.Latitude, 
    OD.InterconnectionID, OD.Planned, OD.Desired, OD.InProgress, COALESCE(C.Name, '') AS CompanyName, COALESCE(C.Acronym, '') AS CompanyAcronym, 
    COALESCE(C.MapAcronym, N'') AS CompanyMapAcronym, COALESCE(VD.Name, '') AS VendorDeviceName, COALESCE(I.Name, '') AS InterconnectionName
FROM OtherDevice OD LEFT OUTER JOIN
    Company C ON OD.CompanyID = C.ID LEFT OUTER JOIN
    VendorDevice VD ON OD.VendorDeviceID = VD.ID LEFT OUTER JOIN
    Interconnection I ON OD.InterconnectionID = I.ID;
 
CREATE VIEW VendorDeviceDistribution AS
SELECT Device.NodeID, Vendor.Name AS VendorName, COUNT(*) AS DeviceCount 
FROM Device LEFT OUTER JOIN 
    VendorDevice ON Device.VendorDeviceID = VendorDevice.ID INNER JOIN
    Vendor ON VendorDevice.VendorID = Vendor.ID
GROUP BY Device.NodeID, Vendor.Name;

CREATE VIEW VendorDeviceDetail
AS
SELECT VD.ID, VD.VendorID, VD.Name, VD.Description || EMPTY_CLOB() AS Description, VD.URL || EMPTY_CLOB() AS URL, V.Name AS VendorName, 
    V.Acronym AS VendorAcronym
FROM VendorDevice VD INNER JOIN Vendor V ON VD.VendorID = V.ID;
                      
CREATE VIEW DeviceDetail
AS
SELECT D.NodeID, D.ID, D.ParentID, D.UniqueID, D.Acronym, COALESCE(D.Name, '') AS Name, D.OriginalSource, D.IsConcentrator, D.CompanyID, D.HistorianID, D.AccessID, D.VendorDeviceID, 
    D.ProtocolID, D.Longitude, D.Latitude, D.InterconnectionID, D.ConnectionString || EMPTY_CLOB() AS ConnectionString, COALESCE(D.TimeZone, '') AS TimeZone, 
    COALESCE(D.FramesPerSecond, 30) AS FramesPerSecond, D.TimeAdjustmentTicks, D.DataLossInterval, D.ConnectOnDemand, D.ContactList || EMPTY_CLOB() AS ContactList, D.MeasuredLines, D.LoadOrder, D.Enabled, COALESCE(C.Name, '') 
    AS CompanyName, COALESCE(C.Acronym, '') AS CompanyAcronym, COALESCE(C.MapAcronym, N'') AS CompanyMapAcronym, COALESCE(H.Acronym, '') 
    AS HistorianAcronym, COALESCE(VD.VendorAcronym, '') AS VendorAcronym, COALESCE(VD.Name, '') AS VendorDeviceName, COALESCE(P.Name, '') 
    AS ProtocolName, P.Type AS ProtocolType, P.Category, COALESCE(I.Name, '') AS InterconnectionName, N.Name AS NodeName, COALESCE(PD.Acronym, '') AS ParentAcronym, D.CreatedOn, D.AllowedParsingExceptions, 
    D.ParsingExceptionWindow, D.DelayedConnectionInterval, D.AllowUseOfCachedConfiguration, D.AutoStartDataParsingSequence, D.SkipDisableRealTimeData, 
    D.MeasurementReportingInterval
FROM Device D LEFT OUTER JOIN
    Company C ON C.ID = D.CompanyID LEFT OUTER JOIN
    Historian H ON H.ID = D.HistorianID LEFT OUTER JOIN
    VendorDeviceDetail VD ON VD.ID = D.VendorDeviceID LEFT OUTER JOIN
    Protocol P ON P.ID = D.ProtocolID LEFT OUTER JOIN
    Interconnection I ON I.ID = D.InterconnectionID LEFT OUTER JOIN
    Node N ON N.ID = D.NodeID LEFT OUTER JOIN
    Device PD ON PD.ID = D.ParentID;
 
CREATE VIEW MapData AS
SELECT 'Device' AS DeviceType, NodeID, ID, Acronym, COALESCE(Name, '') AS Name, CompanyMapAcronym, CompanyName, VendorDeviceName, Longitude, 
    Latitude, 1 AS Reporting, 0 AS Inprogress, 0 AS Planned, 0 AS Desired
FROM DeviceDetail D
UNION ALL
SELECT 'OtherDevice' AS DeviceType, NULL AS NodeID, ID, Acronym, COALESCE(Name, '') AS Name, CompanyMapAcronym, CompanyName, VendorDeviceName, 
    Longitude, Latitude, 0 AS Reporting, 1 AS Inprogress, 1 AS Planned, 1 AS Desired
FROM OtherDeviceDetail OD;

CREATE VIEW OutputStreamDetail AS
SELECT OS.NodeID, OS.ID, OS.Acronym, COALESCE(OS.Name, '') AS Name, OS.Type, OS.ConnectionString || EMPTY_CLOB() AS ConnectionString, OS.IDCode, 
    OS.CommandChannel || EMPTY_CLOB() AS CommandChannel, OS.DataChannel || EMPTY_CLOB() AS DataChannel, OS.AutoPublishConfigFrame, 
    OS.AutoStartDataChannel, OS.NominalFrequency, OS.FramesPerSecond, OS.LagTime, OS.LeadTime, OS.UseLocalClockAsRealTime, 
    OS.AllowSortsByArrival, OS.LoadOrder, OS.Enabled, N.Name AS NodeName, OS.DigitalMaskValue, OS.AnalogScalingValue, 
    OS.VoltageScalingValue, OS.CurrentScalingValue, OS.CoordinateFormat, OS.DataFormat, OS.DownsamplingMethod, 
    OS.AllowPreemptivePublishing, OS.TimeResolution, OS.IgnoreBadTimeStamps, OS.PerformTimeReasonabilityCheck
FROM OutputStream OS INNER JOIN Node N ON OS.NodeID = N.ID;
                      
CREATE VIEW OutputStreamMeasurementDetail AS
SELECT OSM.NodeID, OSM.AdapterID, OSM.ID, OSM.HistorianID, OSM.PointID, OSM.SignalReference, M.PointTag AS SourcePointTag, COALESCE(H.Acronym, '') 
    AS HistorianAcronym
FROM OutputStreamMeasurement OSM INNER JOIN
    Measurement M ON M.PointID = OSM.PointID LEFT OUTER JOIN
    Historian H ON H.ID = OSM.HistorianID;
      
CREATE VIEW OutputStreamDeviceDetail AS
SELECT OSD.NodeID, OSD.AdapterID, OSD.ID, OSD.Acronym, COALESCE(OSD.BpaAcronym, '') AS BpaAcronym, OSD.Name, OSD.LoadOrder, OSD.Enabled, 
    COALESCE(PhasorDataFormat, '') AS PhasorDataFormat, COALESCE(FrequencyDataFormat, '') AS FrequencyDataFormat, 
    COALESCE(AnalogDataFormat, '') AS AnalogDataFormat, COALESCE(CoordinateFormat, '') AS CoordinateFormat, IDCode,
            CASE 
                WHEN EXISTS (Select Acronym From Device Where Acronym = OSD.Acronym) THEN 0 
                ELSE 1 
            END AS Virtual
FROM OutputStreamDevice OSD;
                      
CREATE VIEW PhasorDetail AS
SELECT P.*, COALESCE(DP.Label, '') AS DestinationPhasorLabel, D.Acronym AS DeviceAcronym
FROM Phasor P LEFT OUTER JOIN Phasor DP ON P.DestinationPhasorID = DP.ID
LEFT OUTER JOIN Device D ON P.DeviceID = D.ID;

CREATE VIEW StatisticMeasurement AS
SELECT MeasurementDetail.CompanyID, MeasurementDetail.CompanyAcronym, MeasurementDetail.CompanyName, MeasurementDetail.SignalID, MeasurementDetail.HistorianID, MeasurementDetail.HistorianAcronym, MeasurementDetail.HistorianConnectionString, MeasurementDetail.PointID, MeasurementDetail.PointTag, MeasurementDetail.AlternateTag, MeasurementDetail.DeviceID, 
    MeasurementDetail.NodeID, MeasurementDetail.DeviceAcronym, MeasurementDetail.DeviceName, MeasurementDetail.FramesPerSecond, MeasurementDetail.DeviceEnabled, MeasurementDetail.ContactList, MeasurementDetail.VendorDeviceID, MeasurementDetail.VendorDeviceName, MeasurementDetail.VendorDeviceDescription, MeasurementDetail.ProtocolID, 
    MeasurementDetail.ProtocolAcronym, MeasurementDetail.ProtocolName, MeasurementDetail.SignalTypeID, MeasurementDetail.PhasorSourceIndex, MeasurementDetail.PhasorLabel, MeasurementDetail.PhasorType, MeasurementDetail.Phase, MeasurementDetail.SignalReference, MeasurementDetail.Adder, MeasurementDetail.Multiplier, MeasurementDetail.Description, 
    MeasurementDetail.Subscribed, MeasurementDetail.Internal, MeasurementDetail.Enabled, MeasurementDetail.EngineeringUnits, MeasurementDetail.Source, MeasurementDetail.SignalAcronym, MeasurementDetail.SignalName, MeasurementDetail.SignalTypeSuffix, MeasurementDetail.Longitude, MeasurementDetail.Latitude
FROM MeasurementDetail 
WHERE MeasurementDetail.SignalAcronym = 'STAT';

CREATE VIEW AppRoleSecurityGroupDetail AS 
SELECT ApplicationRoleSecurityGroup.ApplicationRoleID AS ApplicationRoleID,ApplicationRoleSecurityGroup.SecurityGroupID AS SecurityGroupID,ApplicationRole.Name AS ApplicationRoleName,ApplicationRole.Description AS ApplicationRoleDescription,SecurityGroup.Name AS SecurityGroupName,SecurityGroup.Description AS SecurityGroupDescription 
FROM ((ApplicationRoleSecurityGroup JOIN ApplicationRole ON((ApplicationRoleSecurityGroup.ApplicationRoleID = ApplicationRole.ID))) 
JOIN SecurityGroup ON((ApplicationRoleSecurityGroup.SecurityGroupID = SecurityGroup.ID)));

CREATE VIEW AppRoleUserAccountDetail AS 
SELECT ApplicationRoleUserAccount.ApplicationRoleID AS ApplicationRoleID,ApplicationRoleUserAccount.UserAccountID AS UserAccountID,UserAccount.Name AS UserName,UserAccount.FirstName AS FirstName,UserAccount.LastName AS LastName,UserAccount.Email AS Email,ApplicationRole.Name AS ApplicationRoleName,ApplicationRole.Description AS ApplicationRoleDescription 
FROM ((ApplicationRoleUserAccount JOIN ApplicationRole ON((ApplicationRoleUserAccount.ApplicationRoleID = ApplicationRole.ID))) JOIN UserAccount ON((ApplicationRoleUserAccount.UserAccountID = UserAccount.ID)));

CREATE VIEW SecurityGroupUserAccountDetail AS 
SELECT SecurityGroupUserAccount.SecurityGroupID AS SecurityGroupID,SecurityGroupUserAccount.UserAccountID AS UserAccountID,UserAccount.Name AS UserName,UserAccount.FirstName AS FirstName,UserAccount.LastName AS LastName,UserAccount.Email AS Email,SecurityGroup.Name AS SecurityGroupName,SecurityGroup.Description AS SecurityGroupDescription 
FROM ((SecurityGroupUserAccount JOIN SecurityGroup ON((SecurityGroupUserAccount.SecurityGroupID = SecurityGroup.ID))) JOIN UserAccount ON((SecurityGroupUserAccount.UserAccountID = UserAccount.ID)));

CREATE VIEW SubscriberMeasurementDetail AS 
SELECT SubscriberMeasurement.NodeID AS NodeID, SubscriberMeasurement.SubscriberID AS SubscriberID, Subscriber.Acronym AS SubscriberAcronym, COALESCE(Subscriber.Name, '') AS SubscriberName, 
SubscriberMeasurement.SignalID AS SignalID, SubscriberMeasurement.Allowed AS Allowed, Measurement.PointID AS PointID, Measurement.PointTag AS PointTag, Measurement.SignalReference AS SignalReference
FROM ((SubscriberMeasurement JOIN Subscriber ON (SubscriberMeasurement.SubscriberID = Subscriber.ID)) JOIN Measurement ON (SubscriberMeasurement.SignalID = Measurement.SignalID));

CREATE VIEW SubscriberMeasGroupDetail AS 
SELECT SubscriberMeasurementGroup.NodeID AS NodeID, SubscriberMeasurementGroup.SubscriberID AS SubscriberID, Subscriber.Acronym AS SubscriberAcronym, COALESCE(Subscriber.Name, '') AS SubscriberName, 
SubscriberMeasurementGroup.MeasurementGroupID AS MeasurementGroupID, SubscriberMeasurementGroup.Allowed AS Allowed, MeasurementGroup.Name AS MeasurementGroupName
FROM ((SubscriberMeasurementGroup JOIN Subscriber ON (SubscriberMeasurementGroup.SubscriberID = Subscriber.ID)) JOIN MeasurementGroup ON (SubscriberMeasurementGroup.MeasurementGroupID = MeasurementGroup.ID));

CREATE VIEW MeasurementGroupMeasDetail AS 
SELECT MeasurementGroupMeasurement.MeasurementGroupID AS MeasurementGroupID, MeasurementGroup.Name AS MeasurementGroupName,
MeasurementGroupMeasurement.SignalID AS SignalID, Measurement.PointID AS PointID, Measurement.PointTag AS PointTag, Measurement.SignalReference AS SignalReference
FROM ((MeasurementGroupMeasurement JOIN MeasurementGroup ON (MeasurementGroupMeasurement.MeasurementGroupID = MeasurementGroup.ID)) JOIN Measurement ON (MeasurementGroupMeasurement.SignalID = Measurement.SignalID));

CREATE FUNCTION NEW_GUID RETURN NCHAR AS
	guid NVARCHAR2(36);
BEGIN
	SELECT SYS_GUID() INTO guid FROM dual;
	
	guid :=
        SUBSTR(guid,  1, 8) || '-' ||
        SUBSTR(guid,  9, 4) || '-' ||
        SUBSTR(guid, 13, 4) || '-' ||
        SUBSTR(guid, 17, 4) || '-' ||
        SUBSTR(guid, 21);
		
	RETURN guid;
END;
/

CREATE TRIGGER CustActAdaptr_RuntimSync_Insrt AFTER INSERT ON CustomActionAdapter
	FOR EACH ROW BEGIN INSERT INTO Runtime (SourceID, SourceTable) VALUES(:NEW.ID, 'CustomActionAdapter');
END;
/

CREATE TRIGGER CustActAdaptr_RuntimeSync_Del BEFORE DELETE ON CustomActionAdapter
	FOR EACH ROW BEGIN DELETE FROM Runtime WHERE SourceID = :OLD.ID AND SourceTable = N'CustomActionAdapter';
END;
/

CREATE TRIGGER CustInAdaptr_RuntimeSync_Insrt AFTER INSERT ON CustomInputAdapter
	FOR EACH ROW BEGIN INSERT INTO Runtime (SourceID, SourceTable) VALUES(:NEW.ID, N'CustomInputAdapter');
END;
/

CREATE TRIGGER CustInAdaptr_RuntimeSync_Del BEFORE DELETE ON CustomInputAdapter
	FOR EACH ROW BEGIN DELETE FROM Runtime WHERE SourceID = :OLD.ID AND SourceTable = N'CustomInputAdapter';
END;
/

CREATE TRIGGER CustOutAdaptr_RuntimSync_Insrt AFTER INSERT ON CustomOutputAdapter
	FOR EACH ROW BEGIN INSERT INTO Runtime (SourceID, SourceTable) VALUES(:NEW.ID, N'CustomOutputAdapter');
END;
/

CREATE TRIGGER CustOutAdaptr_RuntimeSync_Del BEFORE DELETE ON CustomOutputAdapter
	FOR EACH ROW BEGIN DELETE FROM Runtime WHERE SourceID = :OLD.ID AND SourceTable = N'CustomOutputAdapter';
END;
/

CREATE TRIGGER Device_RuntimeSync_Insert AFTER INSERT ON Device
	FOR EACH ROW BEGIN INSERT INTO Runtime (SourceID, SourceTable) VALUES(:NEW.ID, N'Device');
END;
/

CREATE TRIGGER Device_RuntimeSync_Delete BEFORE DELETE ON Device
	FOR EACH ROW BEGIN DELETE FROM Runtime WHERE SourceID = :OLD.ID AND SourceTable = N'Device';
END;
/

CREATE TRIGGER CalcMeasure_RuntimeSync_Insrt AFTER INSERT ON CalculatedMeasurement
	FOR EACH ROW BEGIN INSERT INTO Runtime (SourceID, SourceTable) VALUES(:NEW.ID, N'CalculatedMeasurement');
END;
/

CREATE TRIGGER CalcMeasure_RuntimeSync_Del BEFORE DELETE ON CalculatedMeasurement
	FOR EACH ROW BEGIN DELETE FROM Runtime WHERE SourceID = :OLD.ID AND SourceTable = N'CalculatedMeasurement';
END;
/

CREATE TRIGGER OutputStream_RuntimeSync_Insrt AFTER INSERT ON OutputStream
	FOR EACH ROW BEGIN INSERT INTO Runtime (SourceID, SourceTable) VALUES(:NEW.ID, N'OutputStream');
END;
/

CREATE TRIGGER OutputStream_RuntimeSync_Del BEFORE DELETE ON OutputStream
	FOR EACH ROW BEGIN DELETE FROM Runtime WHERE SourceID = :OLD.ID AND SourceTable = N'OutputStream';
END;
/

CREATE TRIGGER Historian_RuntimeSync_Insert AFTER INSERT ON Historian
	FOR EACH ROW BEGIN INSERT INTO Runtime (SourceID, SourceTable) VALUES(:NEW.ID, N'Historian');
END;
/

CREATE TRIGGER Historian_RuntimeSync_Delete BEFORE DELETE ON Historian
	FOR EACH ROW BEGIN DELETE FROM Runtime WHERE SourceID = :OLD.ID AND SourceTable = N'Historian';
END;
/

CREATE TRIGGER AccessLog_InsertDefault BEFORE INSERT ON AccessLog 
	FOR EACH ROW BEGIN SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
END;
/

CREATE TRIGGER ApplicationRole_InsertDefault BEFORE INSERT ON ApplicationRole FOR EACH ROW BEGIN
	SELECT NEW_GUID() INTO :NEW.ID FROM dual;
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER SecurityGroup_InsertDefault BEFORE INSERT ON SecurityGroup FOR EACH ROW BEGIN
	SELECT NEW_GUID() INTO :NEW.ID FROM dual;
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER UserAccount_InsertDefault BEFORE INSERT ON UserAccount FOR EACH ROW BEGIN
	SELECT NEW_GUID() INTO :NEW.ID FROM dual;
	SELECT SYSDATE + 90 INTO :NEW.ChangePasswordOn FROM dual;
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER CalcMeasurement_InsertDefault BEFORE INSERT ON CalculatedMeasurement FOR EACH ROW BEGIN
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER Company_InsertDefault BEFORE INSERT ON Company FOR EACH ROW BEGIN
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER CustomActAdapter_InsertDefault BEFORE INSERT ON CustomActionAdapter FOR EACH ROW BEGIN
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER CustInputAdapter_InsertDefault BEFORE INSERT ON CustomInputAdapter FOR EACH ROW BEGIN
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER CustomOutAdapter_InsertDefault BEFORE INSERT ON CustomOutputAdapter FOR EACH ROW BEGIN
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER Device_InsertDefault BEFORE INSERT ON Device FOR EACH ROW BEGIN
	SELECT NEW_GUID() INTO :NEW.UniqueID FROM dual;
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER Historian_InsertDefault BEFORE INSERT ON Historian FOR EACH ROW BEGIN
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER Subscriber_InsertDefault BEFORE INSERT ON Subscriber FOR EACH ROW BEGIN
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER Measurement_InsertDefault BEFORE INSERT ON Measurement FOR EACH ROW BEGIN
	SELECT NEW_GUID() INTO :NEW.SignalID FROM dual;
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER Node_InsertDefault BEFORE INSERT ON Node FOR EACH ROW BEGIN
	SELECT NEW_GUID() INTO :NEW.ID FROM dual;
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER OtherDevice_InsertDefault BEFORE INSERT ON OtherDevice FOR EACH ROW BEGIN
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER OutputStream_InsertDefault BEFORE INSERT ON OutputStream FOR EACH ROW BEGIN
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER OutStreamDevice_InsertDefault BEFORE INSERT ON OutputStreamDevice FOR EACH ROW BEGIN
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER OutStrDevAnalog_InsrtDefault BEFORE INSERT ON OutputStreamDeviceAnalog FOR EACH ROW BEGIN
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER OutStrDevDigital_InsrtDefault BEFORE INSERT ON OutputStreamDeviceDigital FOR EACH ROW BEGIN
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER OutStrDevPhasor_InsrtDefault BEFORE INSERT ON OutputStreamDevicePhasor FOR EACH ROW BEGIN
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER OutStrMeasurement_InsrtDefault BEFORE INSERT ON OutputStreamMeasurement FOR EACH ROW BEGIN
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER Phasor_InsertDefault BEFORE INSERT ON Phasor FOR EACH ROW BEGIN
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER Vendor_InsertDefault BEFORE INSERT ON Vendor FOR EACH ROW BEGIN
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER VendorDevice_InsertDefault BEFORE INSERT ON VendorDevice FOR EACH ROW BEGIN
	SELECT USER INTO :NEW.CreatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
	SELECT USER INTO :NEW.UpdatedBy FROM dual;
	SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE TRIGGER ErrorLog_InsertDefault BEFORE INSERT ON ErrorLog
	FOR EACH ROW BEGIN SELECT SYSDATE INTO :NEW.CreatedOn FROM dual;
END;
/

CREATE TRIGGER AuditLog_InsertDefault BEFORE INSERT ON AuditLog
	FOR EACH ROW BEGIN SELECT SYSDATE INTO :NEW.UpdatedOn FROM dual;
END;
/

CREATE PACKAGE context AS
	PROCEDURE set_current_user(
		new_current_user IN VARCHAR2);
	FUNCTION get_current_user RETURN VARCHAR2;
END;
/

CREATE PACKAGE BODY context AS
	current_user VARCHAR2(200);
	
	PROCEDURE set_current_user(new_current_user IN VARCHAR2) IS
	BEGIN
		current_user := new_current_user;
	END;
	
	FUNCTION get_current_user RETURN VARCHAR2 IS
	BEGIN
		RETURN current_user;
	END;
END;
/

/*
CREATE FUNCTION StringToGuid(str CHAR(36)) RETURNS BINARY(16)
RETURN CONCAT(UNHEX(LEFT(str, 8)), UNHEX(MID(str, 10, 4)), UNHEX(MID(str, 15, 4)), UNHEX(MID(str, 20, 4)), UNHEX(RIGHT(str, 12)));

CREATE FUNCTION GuidToString(guid BINARY(16)) RETURNS CHAR(36) 
RETURN CONCAT(HEX(LEFT(guid, 4)), '-', HEX(MID(guid, 5, 2)), '-', HEX(MID(guid, 7, 2)), '-', HEX(MID(guid, 9, 2)), '-', HEX(RIGHT(guid, 6)));

CREATE FUNCTION NewGuid() RETURNS BINARY(16) 
RETURN StringToGuid(UUID());

DELIMITER $$
CREATE PROCEDURE GetFormattedMeasurements(measurementSql CLOB, includeAdjustments NUMBER(3,0), OUT measurements CLOB)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE measurementID INT;
    DECLARE archiveSource VARCHAR2(50);
    DECLARE adder FLOAT DEFAULT 0.0;
    DECLARE multiplier FLOAT DEFAULT 1.1;	
    DECLARE selectedMeasurements CURSOR FOR SELECT * FROM temp;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    CREATE TEMPORARY TABLE temp
    (
        MeasurementID INT,
        ArchiveSource VARCHAR2(50),
        Adder FLOAT,
        Multiplier FLOAT
    )
    TABLESPACE MEMORY;
    
    SET @insertSQL = CONCAT('INSERT INTO temp ', measurementSql);
    PREPARE stmt FROM @insertSQL;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    OPEN selectedMeasurements;	
    SET measurements = '';
    
    -- Step through selected measurements
    REPEAT
        -- Get next row from measurements SQL
        FETCH selectedMeasurements INTO measurementID, archiveSource, adder, multiplier;

        IF NOT done THEN
            IF LENGTH(measurements) > 0 THEN
                SET measurements = CONCAT(measurements, ';');
            END IF;
            
            IF includeAdjustments <> 0 AND (adder <> 0.0 OR multiplier <> 1.0) THEN
                SET measurements = CONCAT(measurements, archiveSource, ':', measurementID, ',', adder, ',', multiplier);
            ELSE
                SET measurements = CONCAT(measurements, archiveSource, ':', measurementID);
            END IF;

        END IF;
    UNTIL done END REPEAT;

    CLOSE selectedMeasurements;
    DROP TABLE temp;
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION FormatMeasurements(measurementSql CLOB, includeAdjustments NUMBER(3,0))
RETURNS CLOB 
BEGIN
  DECLARE measurements CLOB; 

    CALL GetFormattedMeasurements(measurementSql, includeAdjustments, measurements);

    IF LENGTH(measurements) > 0 THEN
        SET measurements = CONCAT('{', measurements, '}');
    ELSE
        SET measurements = NULL;
    END IF;
        
    RETURN measurements;
END$$
DELIMITER ;
*/