--  ----------------------------------------------------------------------------------------------------
--  openPG Data Structures for SQLite - Gbtc
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
--  07/15/2011 - Stephen C. Wills
--       Translated MySQL script to SQLite.
--  ----------------------------------------------------------------------------------------------------

CREATE TABLE ErrorLog(
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	Source VARCHAR(200) NOT NULL,
	Message TEXT NOT NULL,
	Detail TEXT NULL,
	CreatedOn DATETIME NOT NULL DEFAULT ''
);

CREATE TABLE Runtime(
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	SourceID INTEGER NOT NULL,
	SourceTable VARCHAR(200) NOT NULL,
	CONSTRAINT IX_Runtime UNIQUE (ID)
);

CREATE TABLE AuditLog(
    ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    TableName VARCHAR(200) NOT NULL,
    PrimaryKeyColumn VARCHAR(200) NOT NULL,
    PrimaryKeyValue TEXT NOT NULL,
    ColumnName VARCHAR(200) NOT NULL,
    OriginalValue TEXT,
    NewValue TEXT,
    Deleted BOOLEAN NOT NULL DEFAULT '0',
    UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
    UpdatedOn DATETIME NOT NULL DEFAULT ''
);

CREATE TABLE Company(
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	Acronym VARCHAR(200) NOT NULL,
	MapAcronym NCHAR(10) NOT NULL,
	Name VARCHAR(200) NOT NULL,
	URL TEXT NULL,
	LoadOrder INTEGER NOT NULL DEFAULT 0,
	CreatedOn DATETIME NOT NULL DEFAULT '',
	CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
  	UpdatedOn DATETIME NOT NULL DEFAULT '',
	UpdatedBy VARCHAR(200) NOT NULL DEFAULT ''
);

CREATE TABLE ConfigurationEntity(
	SourceName VARCHAR(200) NOT NULL,
	RuntimeName VARCHAR(200) NOT NULL,
	Description TEXT NULL,
	LoadOrder INTEGER NOT NULL DEFAULT 0,
	Enabled BOOLEAN NOT NULL DEFAULT 0
);

CREATE TABLE Vendor(
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	Acronym VARCHAR(200) NULL,
	Name VARCHAR(200) NOT NULL,
	PhoneNumber VARCHAR(200) NULL,
	ContactEmail VARCHAR(200) NULL,
	URL TEXT NULL,
	CreatedOn DATETIME NOT NULL DEFAULT '',
	CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
  	UpdatedOn DATETIME NOT NULL DEFAULT '',
	UpdatedBy VARCHAR(200) NOT NULL DEFAULT ''
);

CREATE TABLE Protocol(
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	Acronym VARCHAR(200) NOT NULL,
	Name VARCHAR(200) NOT NULL,
	Type VARCHAR(200) NOT NULL DEFAULT 'Frame',
	Category VARCHAR(200) NOT NULL DEFAULT 'Phasor',
	AssemblyName VARCHAR(1024) NOT NULL DEFAULT 'TVA.PhasorProtocols.dll',
	TypeName VARCHAR(200) NOT NULL DEFAULT 'TVA.PhasorProtocols.PhasorMeasurementMapper',
	LoadOrder INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE SignalType(
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	Name VARCHAR(200) NOT NULL,
	Acronym VARCHAR(4) NOT NULL,
	Suffix VARCHAR(2) NOT NULL,
	Abbreviation VARCHAR(2) NOT NULL,
	Source VARCHAR(10) NOT NULL,
	EngineeringUnits VARCHAR(10) NULL
);

CREATE TABLE Interconnection(
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	Acronym VARCHAR(200) NOT NULL,
	Name VARCHAR(200) NOT NULL,
	LoadOrder INTEGER NULL DEFAULT 0
);

CREATE TABLE Node(
	ID NCHAR(36) NULL,
	Name VARCHAR(200) NOT NULL,
	CompanyID INTEGER NULL,
	Longitude DECIMAL(9, 6) NULL,
	Latitude DECIMAL(9, 6) NULL,
	Description TEXT NULL,
	ImagePath TEXT NULL,
	Settings TEXT NULL,
	MenuType VARCHAR(200) NOT NULL DEFAULT 'File',
	MenuData TEXT NOT NULL,
	Master BOOLEAN NOT NULL DEFAULT 0,
	LoadOrder INTEGER NOT NULL DEFAULT 0,
	Enabled BOOLEAN NOT NULL DEFAULT 0,
	CreatedOn DATETIME NOT NULL DEFAULT '',
	CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
  	UpdatedOn DATETIME NOT NULL DEFAULT '',
	UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
	CONSTRAINT PK_Node PRIMARY KEY (ID ASC),
	CONSTRAINT FK_Node_Company FOREIGN KEY(CompanyID) REFERENCES Company (ID)
);

CREATE TABLE DataOperation(
	NodeID NCHAR(36) NULL,
	Description TEXT NULL,
	AssemblyName TEXT NOT NULL,
	TypeName TEXT NOT NULL,
	MethodName VARCHAR(200) NOT NULL,
	Arguments TEXT NULL,
	LoadOrder INTEGER NOT NULL DEFAULT 0,
	Enabled BOOLEAN NOT NULL DEFAULT 0,
	CONSTRAINT FK_DataOperation_Node FOREIGN KEY(NodeID) REFERENCES Node (ID)
);

CREATE TABLE OtherDevice(
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	Acronym VARCHAR(200) NOT NULL,
	Name VARCHAR(200) NULL,
	IsConcentrator BOOLEAN NOT NULL DEFAULT 0,
	CompanyID INTEGER NULL,
	VendorDeviceID INTEGER NULL,
	Longitude DECIMAL(9, 6) NULL,
	Latitude DECIMAL(9, 6) NULL,
	InterconnectionID INTEGER NULL,
	Planned BOOLEAN NOT NULL DEFAULT 0,
	Desired BOOLEAN NOT NULL DEFAULT 0,
	InProgress BOOLEAN NOT NULL DEFAULT 0,
	CreatedOn DATETIME NOT NULL DEFAULT '',
	CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
  	UpdatedOn DATETIME NOT NULL DEFAULT '',
	UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
	CONSTRAINT FK_OtherDevice_Company FOREIGN KEY(CompanyID) REFERENCES Company (ID),
	CONSTRAINT FK_OtherDevice_Interconnection FOREIGN KEY(InterconnectionID) REFERENCES Interconnection (ID),
	CONSTRAINT FK_OtherDevice_VendorDevice FOREIGN KEY(VendorDeviceID) REFERENCES VendorDevice (ID)
);

CREATE TABLE Device(
	NodeID NCHAR(36) NOT NULL,
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	ParentID INTEGER NULL,
	UniqueID NCHAR(36) NULL,
	Acronym VARCHAR(200) NOT NULL,
	Name VARCHAR(200) NULL,
	OriginalSource VARCHAR(200) NULL,
	IsConcentrator BOOLEAN NOT NULL DEFAULT 0,
	CompanyID INTEGER NULL,
	HistorianID INTEGER NULL,
	AccessID INTEGER NOT NULL DEFAULT 0,
	VendorDeviceID INTEGER NULL,
	ProtocolID INTEGER NULL,
	Longitude DECIMAL(9, 6) NULL,
	Latitude DECIMAL(9, 6) NULL,
	InterconnectionID INTEGER NULL,
	ConnectionString TEXT NULL,
	TimeZone VARCHAR(200) NULL,
	FramesPerSecond INTEGER NULL DEFAULT 30,
	TimeAdjustmentTicks BIGINT NOT NULL DEFAULT 0,
	DataLossInterval DOUBLE NOT NULL DEFAULT 5,
	AllowedParsingExceptions INTEGER NOT NULL DEFAULT 10,
	ParsingExceptionWindow DOUBLE NOT NULL DEFAULT 5,
	DelayedConnectionInterval DOUBLE NOT NULL DEFAULT 5,
	AllowUseOfCachedConfiguration BOOLEAN NOT NULL DEFAULT 1,
	AutoStartDataParsingSequence BOOLEAN NOT NULL DEFAULT 1,
	SkipDisableRealTimeData BOOLEAN NOT NULL DEFAULT 0,
	MeasurementReportingInterval INTEGER NOT NULL DEFAULT 100000,
	ConnectOnDemand BOOLEAN NOT NULL DEFAULT 1,
	ContactList TEXT NULL,
	MeasuredLines INTEGER NULL,
	LoadOrder INTEGER NOT NULL DEFAULT 0,
	Enabled BOOLEAN NOT NULL DEFAULT 0,
	CreatedOn DATETIME NOT NULL DEFAULT '',
	CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
  	UpdatedOn DATETIME NOT NULL DEFAULT '',
	UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
	CONSTRAINT IX_Device_UniqueID UNIQUE (UniqueID ASC),
	CONSTRAINT IX_Device_NodeID_Acronym UNIQUE (NodeID ASC, Acronym ASC),
	CONSTRAINT FK_Device_Company FOREIGN KEY(CompanyID) REFERENCES Company (ID),
	CONSTRAINT FK_Device_Device FOREIGN KEY(ParentID) REFERENCES Device (ID),
	CONSTRAINT FK_Device_Historian FOREIGN KEY(HistorianID) REFERENCES Historian (ID),
	CONSTRAINT FK_Device_Interconnection FOREIGN KEY(InterconnectionID) REFERENCES Interconnection (ID),
	CONSTRAINT FK_Device_Node FOREIGN KEY(NodeID) REFERENCES Node (ID),
	CONSTRAINT FK_Device_Protocol FOREIGN KEY(ProtocolID) REFERENCES Protocol (ID),
	CONSTRAINT FK_Device_VendorDevice FOREIGN KEY(VendorDeviceID) REFERENCES VendorDevice (ID)
);

CREATE TABLE VendorDevice(
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	VendorID INTEGER NOT NULL DEFAULT 10,
	Name VARCHAR(200) NOT NULL,
	Description TEXT NULL,
	URL TEXT NULL,
	CreatedOn DATETIME NOT NULL DEFAULT '',
	CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
  	UpdatedOn DATETIME NOT NULL DEFAULT '',
	UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
	CONSTRAINT FK_VendorDevice_Vendor FOREIGN KEY(VendorID) REFERENCES Vendor (ID)
);

CREATE TABLE OutputStreamDeviceDigital(
	NodeID NCHAR(36) NOT NULL,
	OutputStreamDeviceID INTEGER NOT NULL,
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	Label TEXT NOT NULL,
	MaskValue INTEGER NOT NULL DEFAULT 0,
	LoadOrder INTEGER NOT NULL DEFAULT 0,
	CreatedOn DATETIME NOT NULL DEFAULT '',
	CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
  	UpdatedOn DATETIME NOT NULL DEFAULT '',
	UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
	CONSTRAINT FK_OutputStreamDeviceDigital_Node FOREIGN KEY(NodeID) REFERENCES Node (ID),
	CONSTRAINT FK_OutputStreamDeviceDigital_OutputStreamDevice FOREIGN KEY(OutputStreamDeviceID) REFERENCES OutputStreamDevice (ID) ON DELETE CASCADE
);

CREATE TABLE OutputStreamDevicePhasor(
	NodeID NCHAR(36) NOT NULL,
	OutputStreamDeviceID INTEGER NOT NULL,
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	Label VARCHAR(200) NOT NULL,
	Type NCHAR(1) NOT NULL DEFAULT 'V',
	Phase NCHAR(1) NOT NULL DEFAULT '+',
	ScalingValue INTEGER NOT NULL DEFAULT 0,
	LoadOrder INTEGER NOT NULL DEFAULT 0,
	CreatedOn DATETIME NOT NULL DEFAULT '',
	CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
  	UpdatedOn DATETIME NOT NULL DEFAULT '',
	UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
	CONSTRAINT FK_OutputStreamDevicePhasor_Node FOREIGN KEY(NodeID) REFERENCES Node (ID),
	CONSTRAINT FK_OutputStreamDevicePhasor_OutputStreamDevice FOREIGN KEY(OutputStreamDeviceID) REFERENCES OutputStreamDevice (ID) ON DELETE CASCADE
);

CREATE TABLE OutputStreamDeviceAnalog(
	NodeID NCHAR(36) NOT NULL,
	OutputStreamDeviceID INTEGER NOT NULL,
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	Label VARCHAR(16) NOT NULL,
	Type INTEGER NOT NULL DEFAULT 0,
	ScalingValue INTEGER NOT NULL DEFAULT 0,
	LoadOrder INTEGER NOT NULL DEFAULT 0,
	CreatedOn DATETIME NOT NULL DEFAULT '',
	CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
  	UpdatedOn DATETIME NOT NULL DEFAULT '',
	UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
	CONSTRAINT FK_OutputStreamDeviceAnalog_Node FOREIGN KEY(NodeID) REFERENCES Node (ID),
	CONSTRAINT FK_OutputStreamDeviceAnalog_OutputStreamDevice FOREIGN KEY(OutputStreamDeviceID) REFERENCES OutputStreamDevice (ID) ON DELETE CASCADE
);

CREATE TABLE Measurement(
	PointID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	SignalID NCHAR(36) NULL,
	HistorianID INTEGER NULL,
	DeviceID INTEGER NULL,
	PointTag VARCHAR(200) NOT NULL,
	AlternateTag VARCHAR(200) NULL,
	SignalTypeID INTEGER NOT NULL,
	PhasorSourceIndex INTEGER NULL,
	SignalReference VARCHAR(200) NOT NULL,
	Adder DOUBLE NOT NULL DEFAULT 0.0,
	Multiplier DOUBLE NOT NULL DEFAULT 1.0,
	Description TEXT NULL,
	Subscribed BOOLEAN NOT NULL DEFAULT 0,
	Internal BOOLEAN NOT NULL DEFAULT 1,
	Enabled BOOLEAN NOT NULL DEFAULT 0,
	CreatedOn DATETIME NOT NULL DEFAULT '',
	CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
  	UpdatedOn DATETIME NOT NULL DEFAULT '',
	UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
	CONSTRAINT IX_Measurement UNIQUE (PointID ASC),
	CONSTRAINT FK_Measurement_Device FOREIGN KEY(DeviceID) REFERENCES Device (ID) ON DELETE CASCADE,
	CONSTRAINT FK_Measurement_Historian FOREIGN KEY(HistorianID) REFERENCES Historian (ID),
	CONSTRAINT FK_Measurement_SignalType FOREIGN KEY(SignalTypeID) REFERENCES SignalType (ID)
);

CREATE TABLE ImportedMeasurement(
	NodeID NCHAR(36) NULL,
	SourceNodeID NCHAR(36) NULL,
	SignalID NCHAR(36) NULL,
	Source VARCHAR(200) NOT NULL,
	PointID INTEGER NOT NULL,
	PointTag VARCHAR(200) NOT NULL,
	AlternateTag VARCHAR(200) NULL,
	SignalTypeAcronym VARCHAR(4) NULL,
	SignalReference TEXT NOT NULL,
	FramesPerSecond INTEGER NULL,
	ProtocolAcronym VARCHAR(200) NULL,
	ProtocolType VARCHAR(200) NOT NULL DEFAULT 'Frame',
	PhasorID INTEGER NULL,
	PhasorType NCHAR(1) NULL,
	Phase NCHAR(1) NULL,
	Adder DOUBLE NOT NULL DEFAULT 0.0,
	Multiplier DOUBLE NOT NULL DEFAULT 1.0,
	CompanyAcronym VARCHAR(200) NULL,
	Longitude DECIMAL(9, 6) NULL,
	Latitude DECIMAL(9, 6) NULL,
	Description TEXT NULL,
	Enabled BOOLEAN NOT NULL DEFAULT 0,
	CONSTRAINT FK_ImportedMeasurement_Node FOREIGN KEY(NodeID) REFERENCES Node (ID)
);

CREATE TABLE Statistic(
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	Source VARCHAR(20) NOT NULL,
	SignalIndex INTEGER NOT NULL,
	Name VARCHAR(200) NOT NULL,
	Description TEXT NULL,
	AssemblyName TEXT NOT NULL,
	TypeName TEXT NOT NULL,
	MethodName VARCHAR(200) NOT NULL,
	Arguments TEXT NULL,
	Enabled BOOLEAN NOT NULL DEFAULT 0,
	DataType VARCHAR(200) NULL,
	DisplayFormat TEXT NULL,
	IsConnectedState BOOLEAN NOT NULL DEFAULT 0,
	LoadOrder INTEGER NOT NULL DEFAULT 0,
	CONSTRAINT IX_Statistic_Source_SignalIndex UNIQUE (Source ASC, SignalIndex ASC)
);

CREATE TABLE OutputStreamMeasurement(
	NodeID NCHAR(36) NOT NULL,
	AdapterID INTEGER NOT NULL,
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	HistorianID INTEGER NULL,
	PointID INTEGER NOT NULL,
	SignalReference VARCHAR(200) NOT NULL,
	CreatedOn DATETIME NOT NULL DEFAULT '',
	CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
  	UpdatedOn DATETIME NOT NULL DEFAULT '',
	UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
	CONSTRAINT FK_OutputStreamMeasurement_Historian FOREIGN KEY(HistorianID) REFERENCES Historian (ID),
	CONSTRAINT FK_OutputStreamMeasurement_Measurement FOREIGN KEY(PointID) REFERENCES Measurement (PointID) ON DELETE CASCADE,
	CONSTRAINT FK_OutputStreamMeasurement_Node FOREIGN KEY(NodeID) REFERENCES Node (ID),
	CONSTRAINT FK_OutputStreamMeasurement_OutputStream FOREIGN KEY(AdapterID) REFERENCES OutputStream (ID) ON DELETE CASCADE
);

CREATE TABLE OutputStreamDevice(
	NodeID NCHAR(36) NOT NULL,
	AdapterID INTEGER NOT NULL,
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	IDCode INTEGER NOT NULL DEFAULT 0,
	Acronym VARCHAR(200) NOT NULL,
	BpaAcronym VARCHAR(4) NULL,
	Name VARCHAR(200) NOT NULL,
	PhasorDataFormat VARCHAR(15) NULL,
	FrequencyDataFormat VARCHAR(15) NULL,
	AnalogDataFormat VARCHAR(15) NULL,
	CoordinateFormat VARCHAR(15) NULL,
	LoadOrder INTEGER NOT NULL DEFAULT 0,
	Enabled BOOLEAN NOT NULL DEFAULT 0,
	CreatedOn DATETIME NOT NULL DEFAULT '',
	CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
  	UpdatedOn DATETIME NOT NULL DEFAULT '',
	UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
	CONSTRAINT FK_OutputStreamDevice_Node FOREIGN KEY(NodeID) REFERENCES Node (ID),
	CONSTRAINT FK_OutputStreamDevice_OutputStream FOREIGN KEY(AdapterID) REFERENCES OutputStream (ID) ON DELETE CASCADE
);

CREATE TABLE Phasor(
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	DeviceID INTEGER NOT NULL,
	Label VARCHAR(200) NOT NULL,
	Type NCHAR(1) NOT NULL DEFAULT 'V',
	Phase NCHAR(1) NOT NULL DEFAULT '+',
	DestinationPhasorID INTEGER NULL,
	SourceIndex INTEGER NOT NULL DEFAULT 0,
	CreatedOn DATETIME NOT NULL DEFAULT '',
	CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
  	UpdatedOn DATETIME NOT NULL DEFAULT '',
	UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
	CONSTRAINT FK_Phasor_Device FOREIGN KEY(DeviceID) REFERENCES Device (ID) ON DELETE CASCADE,
	CONSTRAINT FK_Phasor_Phasor FOREIGN KEY(DestinationPhasorID) REFERENCES Phasor (ID)
);

CREATE TABLE CalculatedMeasurement(
	NodeID NCHAR(36) NOT NULL,
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	Acronym VARCHAR(200) NOT NULL,
	Name VARCHAR(200) NULL,
	AssemblyName TEXT NOT NULL,
	TypeName TEXT NOT NULL,
	ConnectionString TEXT NULL,
	ConfigSection VARCHAR(200) NULL,
	InputMeasurements TEXT NULL,
	OutputMeasurements TEXT NULL,
	MinimumMeasurementsToUse INTEGER NOT NULL DEFAULT -1,
	FramesPerSecond INTEGER NOT NULL DEFAULT 30,
	LagTime DOUBLE NOT NULL DEFAULT 3.0,
	LeadTime DOUBLE NOT NULL DEFAULT 1.0,
	UseLocalClockAsRealTime BOOLEAN NOT NULL DEFAULT 0,
	AllowSortsByArrival BOOLEAN NOT NULL DEFAULT 1,
	IgnoreBadTimeStamps BOOLEAN NOT NULL DEFAULT 0,
	TimeResolution INTEGER NOT NULL DEFAULT 10000,
	AllowPreemptivePublishing BOOLEAN NOT NULL DEFAULT 1,
	PerformTimeReasonabilityCheck BOOLEAN NOT NULL DEFAULT 1,
	DownsamplingMethod VARCHAR(15) NOT NULL DEFAULT 'LastReceived',
	LoadOrder INTEGER NOT NULL DEFAULT 0,
	Enabled BOOLEAN NOT NULL DEFAULT 0,
	CreatedOn DATETIME NOT NULL DEFAULT '',
	CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
  	UpdatedOn DATETIME NOT NULL DEFAULT '',
	UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
	CONSTRAINT FK_CalculatedMeasurement_Node FOREIGN KEY(NodeID) REFERENCES Node (ID)
);

CREATE TABLE CustomActionAdapter(
	NodeID NCHAR(36) NOT NULL,
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	AdapterName VARCHAR(200) NOT NULL,
	AssemblyName TEXT NOT NULL,
	TypeName TEXT NOT NULL,
	ConnectionString TEXT NULL,
	LoadOrder INTEGER NOT NULL DEFAULT 0,
	Enabled BOOLEAN NOT NULL DEFAULT 0,
	CreatedOn DATETIME NOT NULL DEFAULT '',
	CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
  	UpdatedOn DATETIME NOT NULL DEFAULT '',
	UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
	CONSTRAINT FK_CustomActionAdapter_Node FOREIGN KEY(NodeID) REFERENCES Node (ID)
);

CREATE TABLE Historian(
	NodeID NCHAR(36) NOT NULL,
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	Acronym VARCHAR(200) NOT NULL,
	Name VARCHAR(200) NULL,
	AssemblyName TEXT NULL,
	TypeName TEXT NULL,
	ConnectionString TEXT NULL,
	IsLocal BOOLEAN NOT NULL DEFAULT 1,
	MeasurementReportingInterval INTEGER NOT NULL DEFAULT 100000,
	Description TEXT NULL,
	LoadOrder INTEGER NOT NULL DEFAULT 0,
	Enabled BOOLEAN NOT NULL DEFAULT 0,
	CreatedOn DATETIME NOT NULL DEFAULT '',
	CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
  	UpdatedOn DATETIME NOT NULL DEFAULT '',
	UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
	CONSTRAINT FK_Historian_Node FOREIGN KEY(NodeID) REFERENCES Node (ID)
);

CREATE TABLE CustomInputAdapter(
	NodeID NCHAR(36) NOT NULL,
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	AdapterName VARCHAR(200) NOT NULL,
	AssemblyName TEXT NOT NULL,
	TypeName TEXT NOT NULL,
	ConnectionString TEXT NULL,
	LoadOrder INTEGER NOT NULL DEFAULT 0,
	Enabled BOOLEAN NOT NULL DEFAULT 0,
	CreatedOn DATETIME NOT NULL DEFAULT '',
	CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
  	UpdatedOn DATETIME NOT NULL DEFAULT '',
	UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
	CONSTRAINT FK_CustomInputAdapter_Node FOREIGN KEY(NodeID) REFERENCES Node (ID)
);

CREATE TABLE OutputStream(
	NodeID NCHAR(36) NOT NULL,
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	Acronym VARCHAR(200) NOT NULL,
	Name VARCHAR(200) NULL,
	Type INTEGER NOT NULL DEFAULT 0,
	ConnectionString TEXT NULL,
	DataChannel TEXT NULL,
	CommandChannel TEXT NULL,
	IDCode INTEGER NOT NULL DEFAULT 0,
	AutoPublishConfigFrame BOOLEAN NOT NULL DEFAULT 0,
	AutoStartDataChannel BOOLEAN NOT NULL DEFAULT 1,
	NominalFrequency INTEGER NOT NULL DEFAULT 60,
	FramesPerSecond INTEGER NOT NULL DEFAULT 30,
	LagTime DOUBLE NOT NULL DEFAULT 3.0,
	LeadTime DOUBLE NOT NULL DEFAULT 1.0,
	UseLocalClockAsRealTime BOOLEAN NOT NULL DEFAULT 0,
	AllowSortsByArrival BOOLEAN NOT NULL DEFAULT 1,
	IgnoreBadTimeStamps BOOLEAN NOT NULL DEFAULT 0,
	TimeResolution INTEGER NOT NULL DEFAULT 330000,
	AllowPreemptivePublishing BOOLEAN NOT NULL DEFAULT 1,
	PerformTimeReasonabilityCheck BOOLEAN NOT NULL DEFAULT 1,
	DownsamplingMethod VARCHAR(15) NOT NULL DEFAULT 'LastReceived',
	DataFormat VARCHAR(15) NOT NULL DEFAULT 'FloatingPoint',
	CoordinateFormat VARCHAR(15) NOT NULL DEFAULT 'Polar',
	CurrentScalingValue INTEGER NOT NULL DEFAULT 2423,
	VoltageScalingValue INTEGER NOT NULL DEFAULT 2725785,
	AnalogScalingValue INTEGER NOT NULL DEFAULT 1373291,
	DigitalMaskValue INTEGER NOT NULL DEFAULT -65536,
	LoadOrder INTEGER NOT NULL DEFAULT 0,
	Enabled BOOLEAN NOT NULL DEFAULT 0,
	CreatedOn DATETIME NOT NULL DEFAULT '',
	CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
  	UpdatedOn DATETIME NOT NULL DEFAULT '',
	UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
	CONSTRAINT FK_OutputStream_Node FOREIGN KEY(NodeID) REFERENCES Node (ID)
);

CREATE TABLE CustomOutputAdapter(
	NodeID NCHAR(36) NOT NULL,
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	AdapterName VARCHAR(200) NOT NULL,
	AssemblyName TEXT NOT NULL,
	TypeName TEXT NOT NULL,
	ConnectionString TEXT NULL,
	LoadOrder INTEGER NOT NULL DEFAULT 0,
	Enabled BOOLEAN NOT NULL DEFAULT 0,
	CreatedOn DATETIME NOT NULL DEFAULT '',
	CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
  	UpdatedOn DATETIME NOT NULL DEFAULT '',
	UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
	CONSTRAINT FK_CustomOutputAdapter_Node FOREIGN KEY(NodeID) REFERENCES Node (ID)
);

CREATE TABLE AccessLog (
	ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	UserName VARCHAR(200) NOT NULL,
	AccessGranted BOOLEAN NOT NULL,
	Comment TEXT,
	CreatedOn DATETIME NOT NULL DEFAULT ''
);

CREATE TABLE UserAccount (
	ID NCHAR(36) NOT NULL DEFAULT '',
	Name VARCHAR(200) NOT NULL,
	Password VARCHAR(200) DEFAULT NULL,
	FirstName VARCHAR(200) DEFAULT NULL,
	LastName VARCHAR(200) DEFAULT NULL,
	DefaultNodeID NCHAR(36) NOT NULL,
	Phone VARCHAR(200) DEFAULT NULL,
	Email VARCHAR(200) DEFAULT NULL,
	LockedOut BOOLEAN NOT NULL DEFAULT '0',
	UseADAuthentication BOOLEAN NOT NULL DEFAULT '1',
	ChangePasswordOn DATETIME DEFAULT NULL,
	CreatedOn DATETIME NOT NULL DEFAULT '',
	CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
	UpdatedOn DATETIME NOT NULL DEFAULT '',
	UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
	CONSTRAINT PK_UserAccount PRIMARY KEY (ID ASC),
	CONSTRAINT FK_useraccount FOREIGN KEY (DefaultNodeID) REFERENCES node (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE SecurityGroup (
	ID NCHAR(36) NOT NULL DEFAULT '',
	Name VARCHAR(200) NOT NULL,
	Description TEXT,
	CreatedOn DATETIME NOT NULL DEFAULT '',
	CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
	UpdatedOn DATETIME NOT NULL DEFAULT '',
	UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
	CONSTRAINT PK_SecurityGorup PRIMARY KEY (ID ASC)
);

CREATE TABLE ApplicationRole (
	ID NCHAR(36) NOT NULL DEFAULT '',
	Name VARCHAR(200) NOT NULL,
	Description TEXT,
	NodeID NCHAR(36) NOT NULL,
	CreatedOn DATETIME NOT NULL DEFAULT '',
	CreatedBy VARCHAR(200) NOT NULL DEFAULT 'Admin',
	UpdatedOn DATETIME NOT NULL DEFAULT '',
	UpdatedBy VARCHAR(200) NOT NULL DEFAULT 'Admin',
	CONSTRAINT PK_ApplicationRole PRIMARY KEY (ID ASC),
	CONSTRAINT FK_applicationrole FOREIGN KEY (NodeID) REFERENCES node (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ApplicationRoleSecurityGroup (
	ApplicationRoleID NCHAR(36) NOT NULL,
	SecurityGroupID NCHAR(36) NOT NULL,
	CONSTRAINT FK_applicationrolesecuritygroup_applicationrole FOREIGN KEY (ApplicationRoleID) REFERENCES applicationrole (ID) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FK_applicationrolesecuritygroup_securitygroup FOREIGN KEY (SecurityGroupID) REFERENCES securitygroup (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ApplicationRoleUserAccount (
	ApplicationRoleID NCHAR(36) NOT NULL,
	UserAccountID NCHAR(36) NOT NULL,
	CONSTRAINT FK_applicationroleuseraccount_useraccount FOREIGN KEY (UserAccountID) REFERENCES useraccount (ID) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FK_applicationroleuseraccount_applicationrole FOREIGN KEY (ApplicationRoleID) REFERENCES applicationrole (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE SecurityGroupUserAccount (
	SecurityGroupID NCHAR(36) NOT NULL,
	UserAccountID NCHAR(36) NOT NULL,
	CONSTRAINT FK_securitygroupuseraccount_useraccount FOREIGN KEY (UserAccountID) REFERENCES useraccount (ID) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FK_securitygroupuseraccount_securitygroup FOREIGN KEY (SecurityGroupID) REFERENCES securitygroup (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ----------------------------------------------------------------------------

CREATE TABLE Subscriber (
    NodeID NCHAR(36) NOT NULL,
    ID NCHAR(36) NOT NULL DEFAULT '',
    Acronym VARCHAR(200) NOT NULL,
    Name VARCHAR(200) NULL,
    SharedSecret VARCHAR(200) NOT NULL,
    AuthKey TEXT NOT NULL,
    ValidIPAddresses TEXT NOT NULL,
    Enabled BOOLEAN NOT NULL DEFAULT 0,
    CreatedOn DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
    CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
    UpdatedOn DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
    UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
    CONSTRAINT PK_Subscriber PRIMARY KEY (NodeID ASC, ID ASC),
    CONSTRAINT IX_Subscriber_NodeID_Acronym UNIQUE (NodeID ASC, Acronym ASC),
	CONSTRAINT FK_Subscriber_Node FOREIGN KEY(NodeID) REFERENCES Node (ID)
);

CREATE TABLE SubscriberMeasurement(
    NodeID NCHAR(36) NOT NULL,
    SubscriberID NCHAR(36) NOT NULL,
    SignalID NCHAR(36) NOT NULL,
    Allowed BOOLEAN NOT NULL DEFAULT 0,
    CreatedOn DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
    CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
    UpdatedOn DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
    UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
    CONSTRAINT PK_SubscriberMeasurement PRIMARY KEY (NodeID ASC, SubscriberID ASC, SignalID ASC),
	CONSTRAINT FK_SubscriberMeasurement_Node FOREIGN KEY(NodeID) REFERENCES Node (ID),
	CONSTRAINT FK_SubscriberMeasurement_Measurement FOREIGN KEY(SignalID) REFERENCES Measurement (SignalID),
	CONSTRAINT FK_SubscriberMeasurement_Subscriber FOREIGN KEY(NodeID, SubscriberID) REFERENCES Subscriber (NodeID, ID)
);

CREATE TABLE SubscriberMeasurementGroup (
    NodeID NCHAR(36) NOT NULL,
    SubscriberID NCHAR(36) NOT NULL,
    MeasurementGroupID INTEGER NOT NULL,
    Allowed BOOLEAN NOT NULL DEFAULT 0,
    CreatedOn DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
    CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
    UpdatedOn DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
    UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
    CONSTRAINT PK_SubscriberMeasurementGroup PRIMARY KEY (NodeID ASC, SubscriberID ASC, MeasurementGroupID ASC),
	CONSTRAINT FK_SubscriberMeasurementGroup_Node FOREIGN KEY(NodeID) REFERENCES Node (ID),
	CONSTRAINT FK_SubscriberMeasurementGroup_Subscriber FOREIGN KEY(NodeID, SubscriberID) REFERENCES Subscriber (NodeID, ID),
	CONSTRAINT FK_SubscriberMeasurementGroup_MeasurementGroup FOREIGN KEY(MeasurementGroupID) REFERENCES MeasurementGroup (ID)
);

CREATE TABLE MeasurementGroup (
    NodeID NCHAR(36) NOT NULL,
    ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    Name VARCHAR(200) NOT NULL,
    Description TEXT,
    CreatedOn DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
    CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
    UpdatedOn DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
    UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
	CONSTRAINT FK_MeasurementGroup_Node FOREIGN KEY(NodeID) REFERENCES Node (ID)
);

CREATE TABLE MeasurementGroupMeasurement (
    NodeID NCHAR(36) NOT NULL,
    MeasurementGroupID INTEGER NOT NULL,
    SignalID NCHAR(36) NOT NULL,
    CreatedOn DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
    CreatedBy VARCHAR(200) NOT NULL DEFAULT '',
    UpdatedOn DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
    UpdatedBy VARCHAR(200) NOT NULL DEFAULT '',
    CONSTRAINT PK_MeasurementGroupMeasurement PRIMARY KEY (NodeID ASC, MeasurementGroupID ASC, SignalID ASC),
	CONSTRAINT FK_MeasurementGroupMeasurement_Node FOREIGN KEY(NodeID) REFERENCES Node (ID),
	CONSTRAINT FK_MeasurementGroupMeasurement_Measurement FOREIGN KEY(SignalID) REFERENCES Measurement (SignalID),
	CONSTRAINT FK_MeasurementGroupMeasurement_MeasurementGroup FOREIGN KEY(MeasurementGroupID) REFERENCES MeasurementGroup (ID)
);

-- ----------------------------------------------------------------------------

CREATE UNIQUE INDEX PK_Runtime ON Runtime (SourceID ASC, SourceTable ASC);

CREATE UNIQUE INDEX PK_Measurement ON Measurement (SignalID ASC);

CREATE VIEW RuntimeOutputStreamMeasurement
AS
SELECT OutputStreamMeasurement.NodeID, Runtime.ID AS AdapterID, Historian.Acronym AS Historian, 
 OutputStreamMeasurement.PointID, OutputStreamMeasurement.SignalReference
FROM OutputStreamMeasurement LEFT OUTER JOIN
 Historian ON OutputStreamMeasurement.HistorianID = Historian.ID LEFT OUTER JOIN
 Runtime ON OutputStreamMeasurement.AdapterID = Runtime.SourceID AND Runtime.SourceTable = 'OutputStream'
ORDER BY OutputStreamMeasurement.HistorianID, OutputStreamMeasurement.PointID;

CREATE VIEW RuntimeHistorian
AS
SELECT Historian.NodeID, Runtime.ID, Historian.Acronym AS AdapterName,
 COALESCE(NULLIF(TRIM(Historian.AssemblyName), ''), 'HistorianAdapters.dll') AS AssemblyName, 
 COALESCE(NULLIF(TRIM(Historian.TypeName), ''), CASE WHEN IsLocal = 1 THEN 'HistorianAdapters.LocalOutputAdapter' ELSE 'HistorianAdapters.RemoteOutputAdapter' END) AS TypeName, 
 Historian.ConnectionString || ';' || ('instanceName=' || Historian.Acronym) || ';' || ('sourceids=' || Historian.Acronym) || ';' ||
 ('measurementReportingInterval=' || Historian.MeasurementReportingInterval) AS ConnectionString
FROM Historian LEFT OUTER JOIN
 Runtime ON Historian.ID = Runtime.SourceID AND Runtime.SourceTable = 'Historian'
WHERE (Historian.Enabled <> 0)
ORDER BY Historian.LoadOrder;

CREATE VIEW RuntimeDevice
AS
SELECT Device.NodeID, Runtime.ID, Device.Acronym AS AdapterName, Protocol.AssemblyName, Protocol.TypeName,
 Device.ConnectionString || ';' || ('isConcentrator=' || Device.IsConcentrator) || ';' ||
 ('accessID=' || Device.AccessID) || ';' ||
 CASE WHEN Device.TimeZone IS NULL THEN '' ELSE 'timeZone=' || Device.TimeZone END || ';' ||
 ('timeAdjustmentTicks=' || Device.TimeAdjustmentTicks) || ';' ||
 CASE WHEN Protocol.Acronym IS NULL THEN '' ELSE 'phasorProtocol=' || Protocol.Acronym END || ';' ||
 ('dataLossInterval=' || Device.DataLossInterval) || ';' ||
 ('allowedParsingExceptions=' || Device.AllowedParsingExceptions) || ';' ||
 ('parsingExceptionWindow=' || Device.ParsingExceptionWindow) || ';' ||
 ('delayedConnectionInterval=' || Device.DelayedConnectionInterval) || ';' ||
 ('allowUseOfCachedConfiguration=' || Device.AllowUseOfCachedConfiguration) || ';' ||
 ('autoStartDataParsingSequence=' || Device.AutoStartDataParsingSequence) || ';' ||
 ('skipDisableRealTimeData=' || Device.SkipDisableRealTimeData) || ';' ||
 ('measurementReportingInterval=' || Device.MeasurementReportingInterval) AS ConnectionString
FROM Device LEFT OUTER JOIN
 Protocol ON Device.ProtocolID = Protocol.ID LEFT OUTER JOIN
 Runtime ON Device.ID = Runtime.SourceID AND Runtime.SourceTable = 'Device'
WHERE (Device.Enabled <> 0 AND Device.ParentID IS NULL)
ORDER BY Device.LoadOrder;

CREATE VIEW RuntimeCustomOutputAdapter
AS
SELECT CustomOutputAdapter.NodeID, Runtime.ID, CustomOutputAdapter.AdapterName, 
 TRIM(CustomOutputAdapter.AssemblyName) AS AssemblyName, TRIM(CustomOutputAdapter.TypeName) AS TypeName, CustomOutputAdapter.ConnectionString
FROM CustomOutputAdapter LEFT OUTER JOIN
 Runtime ON CustomOutputAdapter.ID = Runtime.SourceID AND Runtime.SourceTable = 'CustomOutputAdapter'
WHERE (CustomOutputAdapter.Enabled <> 0)
ORDER BY CustomOutputAdapter.LoadOrder;

CREATE VIEW RuntimeInputStreamDevice
AS
SELECT Device.NodeID, Runtime_P.ID AS ParentID, Runtime.ID, Device.Acronym, Device.Name, Device.AccessID
FROM Device LEFT OUTER JOIN
 Runtime ON Device.ID = Runtime.SourceID AND Runtime.SourceTable = 'Device' LEFT OUTER JOIN
 Runtime AS Runtime_P ON Device.ParentID = Runtime_P.SourceID AND Runtime_P.SourceTable = 'Device'
WHERE (Device.IsConcentrator = 0) AND (Device.Enabled <> 0) AND (Device.ParentID IS NOT NULL)
ORDER BY Device.LoadOrder;

CREATE VIEW RuntimeCustomInputAdapter
AS
SELECT CustomInputAdapter.NodeID, Runtime.ID, CustomInputAdapter.AdapterName, 
 TRIM(CustomInputAdapter.AssemblyName) AS AssemblyName, TRIM(CustomInputAdapter.TypeName) AS TypeName, CustomInputAdapter.ConnectionString
FROM CustomInputAdapter LEFT OUTER JOIN
 Runtime ON CustomInputAdapter.ID = Runtime.SourceID AND Runtime.SourceTable = 'CustomInputAdapter'
WHERE (CustomInputAdapter.Enabled <> 0)
ORDER BY CustomInputAdapter.LoadOrder;

CREATE VIEW RuntimeOutputStreamDevice
AS
SELECT OutputStreamDevice.NodeID, Runtime.ID AS ParentID, OutputStreamDevice.ID, OutputStreamDevice.IDCode, OutputStreamDevice.Acronym, 
 OutputStreamDevice.BpaAcronym, OutputStreamDevice.Name, NULLIF(OutputStreamDevice.PhasorDataFormat, '') AS PhasorDataFormat, NULLIF(OutputStreamDevice.FrequencyDataFormat, '') AS FrequencyDataFormat,
 NULLIF(OutputStreamDevice.AnalogDataFormat, '') AS AnalogDataFormat, NULLIF(OutputStreamDevice.CoordinateFormat, '') AS CoordinateFormat, OutputStreamDevice.LoadOrder
FROM OutputStreamDevice LEFT OUTER JOIN
 Runtime ON OutputStreamDevice.AdapterID = Runtime.SourceID AND Runtime.SourceTable = 'OutputStream'
WHERE (OutputStreamDevice.Enabled <> 0)
ORDER BY OutputStreamDevice.LoadOrder;

CREATE VIEW RuntimeOutputStream
AS
SELECT OutputStream.NodeID, Runtime.ID, OutputStream.Acronym AS AdapterName, 
 'TVA.PhasorProtocols.dll' AS AssemblyName, 
 CASE WHEN Type = 1 THEN 'TVA.PhasorProtocols.BpaPdcStream.Concentrator' ELSE 'TVA.PhasorProtocols.IeeeC37_118.Concentrator' END AS TypeName,
 OutputStream.ConnectionString || ';' ||
 CASE WHEN OutputStream.DataChannel IS NULL THEN '' ELSE ('dataChannel={' || OutputStream.DataChannel || '}') END || ';' ||
 CASE WHEN OutputStream.CommandChannel IS NULL THEN '' ELSE ('commandChannel={' || OutputStream.CommandChannel || '}') END || ';' ||
 ('idCode=' || OutputStream.IDCode) || ';' ||
 ('autoPublishConfigFrame=' || OutputStream.AutoPublishConfigFrame) || ';' ||
 ('autoStartDataChannel=' || OutputStream.AutoStartDataChannel) || ';' ||
 ('nominalFrequency=' || OutputStream.NominalFrequency) || ';' ||
 ('lagTime=' || OutputStream.LagTime) || ';' ||
 ('leadTime=' || OutputStream.LeadTime) || ';' ||
 ('framesPerSecond=' || OutputStream.FramesPerSecond) || ';' ||
 ('useLocalClockAsRealTime=' || OutputStream.UseLocalClockAsRealTime) || ';' ||
 ('allowSortsByArrival=' || OutputStream.AllowSortsByArrival) || ';' ||
 ('ignoreBadTimestamps=' || OutputStream.IgnoreBadTimeStamps) || ';' ||
 ('timeResolution=' || OutputStream.TimeResolution) || ';' ||
 ('allowPreemptivePublishing=' || OutputStream.AllowPreemptivePublishing) || ';' ||
 ('downsamplingMethod=' || OutputStream.DownsamplingMethod) || ';' ||
 ('dataFormat=' || OutputStream.DataFormat) || ';' ||
 ('coordinateFormat=' || OutputStream.CoordinateFormat) || ';' ||
 ('currentScalingValue=' || OutputStream.CurrentScalingValue) || ';' ||
 ('voltageScalingValue=' || OutputStream.VoltageScalingValue) || ';' ||
 ('analogScalingValue=' || OutputStream.AnalogScalingValue) || ';' ||
 ('performTimestampReasonabilityCheck=' || OutputStream.PerformTimeReasonabilityCheck) || ';' ||
 ('digitalMaskValue=' || OutputStream.DigitalMaskValue) AS ConnectionString
FROM OutputStream LEFT OUTER JOIN
 Runtime ON OutputStream.ID = Runtime.SourceID AND Runtime.SourceTable = 'OutputStream'
WHERE (OutputStream.Enabled <> 0)
ORDER BY OutputStream.LoadOrder;

CREATE VIEW RuntimeCustomActionAdapter
AS
SELECT CustomActionAdapter.NodeID, Runtime.ID, CustomActionAdapter.AdapterName, 
 TRIM(CustomActionAdapter.AssemblyName) AS AssemblyName, TRIM(CustomActionAdapter.TypeName) AS TypeName, CustomActionAdapter.ConnectionString
FROM CustomActionAdapter LEFT OUTER JOIN
 Runtime ON CustomActionAdapter.ID = Runtime.SourceID AND Runtime.SourceTable = 'CustomActionAdapter'
WHERE (CustomActionAdapter.Enabled <> 0)
ORDER BY CustomActionAdapter.LoadOrder;

CREATE VIEW RuntimeCalculatedMeasurement
AS
SELECT CalculatedMeasurement.NodeID, Runtime.ID, CalculatedMeasurement.Acronym AS AdapterName, 
 TRIM(CalculatedMeasurement.AssemblyName) AS AssemblyName, TRIM(CalculatedMeasurement.TypeName) AS TypeName,
 CalculatedMeasurement.ConnectionString || ';' ||
 CASE WHEN ConfigSection IS NULL THEN '' ELSE ('configurationSection=' || ConfigSection) END || ';' ||
 ('minimumMeasurementsToUse=' || CalculatedMeasurement.MinimumMeasurementsToUse) || ';' ||
 ('framesPerSecond=' || CalculatedMeasurement.FramesPerSecond) || ';' ||
 ('lagTime=' || CalculatedMeasurement.LagTime) || ';' ||
 ('leadTime=' || CalculatedMeasurement.LeadTime) || ';' ||
 CASE WHEN InputMeasurements IS NULL THEN '' ELSE ('inputMeasurementKeys={' || InputMeasurements || '}') END || ';' ||
 CASE WHEN OutputMeasurements IS NULL THEN '' ELSE ('outputMeasurements={' || OutputMeasurements || '}') END || ';' ||
 ('ignoreBadTimestamps=' || CalculatedMeasurement.IgnoreBadTimeStamps) || ';' ||
 ('timeResolution=' || CalculatedMeasurement.TimeResolution) || ';' ||
 ('allowPreemptivePublishing=' || CalculatedMeasurement.AllowPreemptivePublishing) || ';' ||
 ('performTimestampReasonabilityCheck=' || CalculatedMeasurement.PerformTimeReasonabilityCheck) || ';' ||
 ('downsamplingMethod=' || CalculatedMeasurement.DownsamplingMethod) || ';' ||
 ('useLocalClockAsRealTime=' || CalculatedMeasurement.UseLocalClockAsRealTime) AS ConnectionString
FROM CalculatedMeasurement LEFT OUTER JOIN
 Runtime ON CalculatedMeasurement.ID = Runtime.SourceID AND Runtime.SourceTable = 'CalculatedMeasurement'
WHERE (CalculatedMeasurement.Enabled <> 0)
ORDER BY CalculatedMeasurement.LoadOrder;

CREATE VIEW ActiveMeasurement
AS
SELECT COALESCE(Historian.NodeID, Device.NodeID) AS NodeID,
 COALESCE(Device.NodeID, Historian.NodeID) AS SourceNodeID,
 COALESCE(Historian.Acronym, Device.Acronym, '__') || ':' || Measurement.PointID AS ID,
 Measurement.SignalID, Measurement.PointTag, Measurement.AlternateTag, Measurement.SignalReference,
 Measurement.Internal, Measurement.Subscribed, Device.Acronym AS Device,
 CASE WHEN Device.IsConcentrator = 0 AND Device.ParentID IS NOT NULL THEN RuntimeP.ID ELSE Runtime.ID END AS DeviceID,
 COALESCE(Device.FramesPerSecond, 30) AS FramesPerSecond,
 Protocol.Acronym AS Protocol, Protocol.Type AS ProtocolType, Measurement.SignalType, Phasor.ID AS PhasorID,
 Phasor.Type AS PhasorType, Phasor.Phase, Measurement.Adder, Measurement.Multiplier,
 Device.CompanyAcronym AS Company, Device.Longitude, Device.Latitude, Measurement.Description
FROM (SELECT *, SignalType.Acronym AS SignalType FROM Measurement LEFT OUTER JOIN
	 SignalType ON Measurement.SignalTypeID = SignalType.ID) AS Measurement LEFT OUTER JOIN
	(SELECT *, Company.Acronym AS CompanyAcronym FROM Device LEFT OUTER JOIN
	 Company ON Device.CompanyID = Company.ID) AS Device ON Device.ID = Measurement.DeviceID LEFT OUTER JOIN
	Phasor ON Measurement.DeviceID = Phasor.DeviceID AND Measurement.PhasorSourceIndex = Phasor.SourceIndex LEFT OUTER JOIN
	Protocol ON Device.ProtocolID = Protocol.ID LEFT OUTER JOIN
	Historian ON Measurement.HistorianID = Historian.ID LEFT OUTER JOIN
	Runtime ON Device.ID = Runtime.SourceID AND Runtime.SourceTable = 'Device' LEFT OUTER JOIN
	Runtime AS RuntimeP ON RuntimeP.SourceID = Device.ParentID AND RuntimeP.SourceTable = 'Device'
WHERE (Device.Enabled <> 0 OR Device.Enabled IS NULL) AND (Measurement.Enabled <> 0)
UNION ALL
SELECT NodeID, SourceNodeID, (Source || ':' || PointID) AS ID, SignalID, PointTag,
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
UNION
SELECT NodeID, ID, AdapterName, AssemblyName, TypeName, ConnectionString
FROM RuntimeCustomOutputAdapter;

CREATE VIEW IaonInputAdapter
AS
SELECT NodeID, ID, AdapterName, AssemblyName, TypeName, ConnectionString
FROM RuntimeDevice
UNION
SELECT NodeID, ID, AdapterName, AssemblyName, TypeName, ConnectionString
FROM RuntimeCustomInputAdapter;

CREATE VIEW IaonActionAdapter
AS
SELECT Node.ID AS NodeID, 0 AS ID, 'PHASOR!SERVICES' AS AdapterName, 'TVA.PhasorProtocols.dll' AS AssemblyName, 'TVA.PhasorProtocols.CommonPhasorServices' AS TypeName, '' AS ConnectionString
FROM Node
UNION
SELECT NodeID, ID, AdapterName, AssemblyName, TypeName, ConnectionString
FROM RuntimeOutputStream
UNION
SELECT NodeID, ID, AdapterName, AssemblyName, TypeName, ConnectionString
FROM RuntimeCalculatedMeasurement
UNION
SELECT NodeID, ID, AdapterName, AssemblyName, TypeName, ConnectionString
FROM RuntimeCustomActionAdapter;
      
CREATE VIEW MeasurementDetail
AS
SELECT     Device.CompanyID, Device.CompanyAcronym, Device.CompanyName, Measurement.SignalID, 
                      Measurement.HistorianID, Historian.Acronym AS HistorianAcronym, Historian.ConnectionString AS HistorianConnectionString, 
                      Measurement.PointID, Measurement.PointTag, Measurement.AlternateTag, Measurement.DeviceID,  COALESCE (Device.NodeID, Historian.NodeID) AS NodeID, 
                      Device.Acronym AS DeviceAcronym, Device.Name AS DeviceName, COALESCE(Device.FramesPerSecond, 30) AS FramesPerSecond, Device.Enabled AS DeviceEnabled, Device.ContactList, 
                      Device.VendorDeviceID, VendorDevice.Name AS VendorDeviceName, VendorDevice.Description AS VendorDeviceDescription, 
                      Device.ProtocolID, Protocol.Acronym AS ProtocolAcronym, Protocol.Name AS ProtocolName, Measurement.SignalTypeID, 
                      Measurement.PhasorSourceIndex, Phasor.Label AS PhasorLabel, Phasor.Type AS PhasorType, Phasor.Phase, 
                      Measurement.SignalReference, Measurement.Adder, Measurement.Multiplier, Measurement.Description, Measurement.Subscribed, Measurement.Internal, Measurement.Enabled, 
                      COALESCE (Measurement.EngineeringUnits, '') AS EngineeringUnits, Measurement.Source, Measurement.SignalAcronym, 
                      Measurement.SignalName, Measurement.SignalTypeSuffix, Device.Longitude, Device.Latitude,
					  (COALESCE(Historian.Acronym, Device.Acronym, '__') || ':' || Measurement.PointID) AS ID
FROM         (SELECT *, SignalType.Acronym AS SignalAcronym, SignalType.Name AS SignalName, SignalType.Suffix AS SignalTypeSuffix FROM Measurement LEFT OUTER JOIN
					   SignalType ON Measurement.SignalTypeID = SignalType.ID) AS Measurement LEFT OUTER JOIN
					  (SELECT *, Company.Acronym AS CompanyAcronym, Company.Name AS CompanyName FROM Device LEFT OUTER JOIN
                       Company ON Device.CompanyID = Company.ID) AS Device ON Device.ID = Measurement.DeviceID LEFT OUTER JOIN
                      Phasor ON Measurement.DeviceID = Phasor.DeviceID AND 
                      Measurement.PhasorSourceIndex = Phasor.SourceIndex LEFT OUTER JOIN
                      VendorDevice ON Device.VendorDeviceID = VendorDevice.ID LEFT OUTER JOIN
                      Protocol ON Device.ProtocolID = Protocol.ID LEFT OUTER JOIN
                      Historian ON Measurement.HistorianID = Historian.ID;

CREATE VIEW HistorianMetadata
AS
SELECT PointID AS HistorianID, CASE WHEN SignalAcronym = 'DIGI' THEN 1 ELSE 0 END AS DataType, PointTag AS Name, SignalReference AS Synonym1, 
SignalAcronym AS Synonym2, AlternateTag AS Synonym3, Description, VendorDeviceDescription AS HardwareInfo, '' AS Remarks, 
HistorianAcronym AS PlantCode, 1 AS UnitNumber, DeviceAcronym AS SystemName, ProtocolID AS SourceID, Enabled, 1.0 / FramesPerSecond AS ScanRate, 
0 AS CompressionMinTime, 0 AS CompressionMaxTime, EngineeringUnits,
CASE SignalAcronym WHEN 'FREQ' THEN 59.95 WHEN 'VPHM' THEN 475000 WHEN 'IPHM' THEN 0 WHEN 'VPHA' THEN -181 WHEN 'IPHA' THEN -181 ELSE 0 END AS LowWarning,
CASE SignalAcronym WHEN 'FREQ' THEN 60.05 WHEN 'VPHM' THEN 525000 WHEN 'IPHM' THEN 3150 WHEN 'VPHA' THEN 181 WHEN 'IPHA' THEN 181 ELSE 0 END AS HighWarning,
CASE SignalAcronym WHEN 'FREQ' THEN 59.90 WHEN 'VPHM' THEN 450000 WHEN 'IPHM' THEN 0 WHEN 'VPHA' THEN -181 WHEN 'IPHA' THEN -181 ELSE 0 END AS LowAlarm,
CASE SignalAcronym WHEN 'FREQ' THEN 60.10 WHEN 'VPHM' THEN 550000 WHEN 'IPHM' THEN 3300 WHEN 'VPHA' THEN 181 WHEN 'IPHA' THEN 181 ELSE 0 END AS HighAlarm,
CASE SignalAcronym WHEN 'FREQ' THEN 59.95 WHEN 'VPHM' THEN 475000 WHEN 'IPHM' THEN 0 WHEN 'VPHA' THEN -180 WHEN 'IPHA' THEN -180 ELSE 0 END AS LowRange,
CASE SignalAcronym WHEN 'FREQ' THEN 60.05 WHEN 'VPHM' THEN 525000 WHEN 'IPHM' THEN 3000 WHEN 'VPHA' THEN 180 WHEN 'IPHA' THEN 180 ELSE 0 END AS HighRange,
0.0 AS CompressionLimit, 0.0 AS ExceptionLimit, CASE SignalAcronym WHEN 'DIGI' THEN 0 ELSE 7 END AS DisplayDigits, '' AS SetDescription,
'' AS ClearDescription, 0 AS AlarmState, 5 AS ChangeSecurity, 0 AS AccessSecurity, 0 AS StepCheck, 0 AS AlarmEnabled, 0 AS AlarmFlags, 0 AS AlarmDelay,
0 AS AlarmToFile, 0 AS AlarmByEmail, 0 AS AlarmByPager, 0 AS AlarmByPhone, ContactList AS AlarmEmails, '' AS AlarmPagers, '' AS AlarmPhones
FROM MeasurementDetail;

CREATE VIEW CalculatedMeasurementDetail
AS
SELECT CM.NodeID, CM.ID, CM.Acronym, COALESCE(CM.Name, '') AS Name, CM.AssemblyName, CM.TypeName, COALESCE(CM.ConnectionString, '') AS ConnectionString,
		COALESCE(CM.ConfigSection, '') AS ConfigSection, COALESCE(CM.InputMeasurements, '') AS InputMeasurements, COALESCE(CM.OutputMeasurements, '') AS OutputMeasurements,
		CM.MinimumMeasurementsToUse, CM.FramesPerSecond, CM.LagTime, CM.LeadTime, CM.UseLocalClockAsRealTime, CM.AllowSortsByArrival, CM.LoadOrder, CM.Enabled,
		N.Name AS NodeName, CM.IgnoreBadTimeStamps, CM.TimeResolution, CM.AllowPreemptivePublishing, COALESCE(CM.DownsamplingMethod, '') AS DownsamplingMethod, CM.PerformTimeReasonabilityCheck
FROM CalculatedMeasurement CM, Node N
WHERE CM.NodeID = N.ID;

CREATE VIEW HistorianDetail
AS
SELECT H.NodeID, H.ID, H.Acronym, COALESCE(H.Name, '') AS Name, COALESCE(H.AssemblyName, '') AS AssemblyName, COALESCE(H.TypeName, '') AS TypeName, 
	COALESCE(H.ConnectionString, '') AS ConnectionString, H.IsLocal, COALESCE(H.Description, '') AS Description, H.LoadOrder, H.Enabled, N.Name AS NodeName, H.MeasurementReportingInterval 
FROM Historian AS H INNER JOIN Node AS N ON H.NodeID = N.ID;

CREATE VIEW NodeDetail
AS
SELECT N.ID, N.Name, N.CompanyID AS CompanyID, COALESCE(N.Longitude, 0) AS Longitude, COALESCE(N.Latitude, 0) AS Latitude, 
		COALESCE(N.Description, '') AS Description, COALESCE(N.ImagePath, '') AS ImagePath, COALESCE(N.Settings, '') AS Settings, N.MenuType, N.MenuData, N.Master, N.LoadOrder, N.Enabled, COALESCE(C.Name, '') AS CompanyName
FROM Node N LEFT JOIN Company C 
ON N.CompanyID = C.ID;

CREATE VIEW VendorDetail
AS
Select ID, COALESCE(Acronym, '') AS Acronym, Name, COALESCE(PhoneNumber, '') AS PhoneNumber, COALESCE(ContactEmail, '') AS ContactEmail, COALESCE(URL, '') AS URL 
FROM Vendor;

CREATE VIEW CustomActionAdapterDetail AS
SELECT     CA.NodeID, CA.ID, CA.AdapterName, CA.AssemblyName, CA.TypeName, COALESCE(CA.ConnectionString, '') AS ConnectionString, CA.LoadOrder, 
                      CA.Enabled, N.Name AS NodeName
FROM         CustomActionAdapter AS CA INNER JOIN Node AS N ON CA.NodeID = N.ID;
 
CREATE VIEW CustomInputAdapterDetail AS
SELECT     CA.NodeID, CA.ID, CA.AdapterName, CA.AssemblyName, CA.TypeName, COALESCE(CA.ConnectionString, '') AS ConnectionString, CA.LoadOrder, 
                      CA.Enabled, N.Name AS NodeName
FROM         CustomInputAdapter AS CA INNER JOIN Node AS N ON CA.NodeID = N.ID;
 
CREATE VIEW CustomOutputAdapterDetail AS
SELECT     CA.NodeID, CA.ID, CA.AdapterName, CA.AssemblyName, CA.TypeName, COALESCE(CA.ConnectionString, '') AS ConnectionString, CA.LoadOrder, 
                      CA.Enabled, N.Name AS NodeName
FROM         CustomOutputAdapter AS CA INNER JOIN Node AS N ON CA.NodeID = N.ID;
 
CREATE VIEW IaonTreeView AS
SELECT     'Action Adapters' AS AdapterType, NodeID, ID, AdapterName, AssemblyName, TypeName, COALESCE(ConnectionString, '') AS ConnectionString
FROM         IaonActionAdapter
UNION ALL
SELECT     'Input Adapters' AS AdapterType, NodeID, ID, AdapterName, AssemblyName, TypeName, COALESCE(ConnectionString, '') AS ConnectionString
FROM         IaonInputAdapter
UNION ALL
SELECT     'Output Adapters' AS AdapterType, NodeID, ID, AdapterName, AssemblyName, TypeName, COALESCE(ConnectionString, '') AS ConnectionString
FROM         IaonOutputAdapter;
 
CREATE VIEW OtherDeviceDetail AS
SELECT     OD.ID, OD.Acronym, COALESCE(OD.Name, '') AS Name, OD.IsConcentrator, OD.CompanyID, OD.VendorDeviceID, OD.Longitude, OD.Latitude, 
                      OD.InterconnectionID, OD.Planned, OD.Desired, OD.InProgress, COALESCE(C.Name, '') AS CompanyName, COALESCE(C.Acronym, '') AS CompanyAcronym, 
                      COALESCE(C.MapAcronym, '') AS CompanyMapAcronym, COALESCE(VD.Name, '') AS VendorDeviceName, COALESCE(I.Name, '') AS InterconnectionName
FROM         OtherDevice AS OD LEFT OUTER JOIN
                      Company AS C ON OD.CompanyID = C.ID LEFT OUTER JOIN
                      VendorDevice AS VD ON OD.VendorDeviceID = VD.ID LEFT OUTER JOIN
                      Interconnection AS I ON OD.InterconnectionID = I.ID;
 
CREATE VIEW VendorDeviceDistribution AS
SELECT Device.NodeID, Vendor.Name AS VendorName, COUNT(*) AS DeviceCount 
FROM Device  LEFT OUTER JOIN
	VendorDevice ON Device.VendorDeviceID = VendorDevice.ID INNER JOIN
	Vendor ON VendorDevice.VendorID = Vendor.ID
GROUP BY Device.NodeID, Vendor.Name;

CREATE VIEW VendorDeviceDetail
AS
SELECT     VD.ID, VD.VendorID, VD.Name, COALESCE(VD.Description, '') AS Description, COALESCE(VD.URL, '') AS URL, V.Name AS VendorName, 
                      V.Acronym AS VendorAcronym
FROM         VendorDevice AS VD INNER JOIN Vendor AS V ON VD.VendorID = V.ID;
                      
CREATE VIEW DeviceDetail
AS
SELECT     D.NodeID, D.ID, D.ParentID, D.UniqueID, D.Acronym, COALESCE(D.Name, '') AS Name, D.OriginalSource, D.IsConcentrator, D.CompanyID, D.HistorianID, D.AccessID, D.VendorDeviceID, 
                      D.ProtocolID, D.Longitude, D.Latitude, D.InterconnectionID, COALESCE(D.ConnectionString, '') AS ConnectionString, COALESCE(D.TimeZone, '') AS TimeZone, 
                      COALESCE(D.FramesPerSecond, 30) AS FramesPerSecond, D.TimeAdjustmentTicks, D.DataLossInterval, D.ConnectOnDemand, COALESCE(D.ContactList, '') AS ContactList, D.MeasuredLines, D.LoadOrder, D.Enabled, COALESCE(C.Name, '') 
                      AS CompanyName, COALESCE(C.Acronym, '') AS CompanyAcronym, COALESCE(C.MapAcronym, '') AS CompanyMapAcronym, COALESCE(H.Acronym, '') 
                      AS HistorianAcronym, COALESCE(VD.VendorAcronym, '') AS VendorAcronym, COALESCE(VD.Name, '') AS VendorDeviceName, COALESCE(P.Name, '') 
                      AS ProtocolName, P.Type AS ProtocolType, P.Category, COALESCE(I.Name, '') AS InterconnectionName, N.Name AS NodeName, COALESCE(PD.Acronym, '') AS ParentAcronym, D.CreatedOn, D.AllowedParsingExceptions, 
                      D.ParsingExceptionWindow, D.DelayedConnectionInterval, D.AllowUseOfCachedConfiguration, D.AutoStartDataParsingSequence, D.SkipDisableRealTimeData, 
                      D.MeasurementReportingInterval
FROM         Device AS D LEFT OUTER JOIN
                      Company AS C ON C.ID = D.CompanyID LEFT OUTER JOIN
                      Historian AS H ON H.ID = D.HistorianID LEFT OUTER JOIN
                      VendorDeviceDetail AS VD ON VD.ID = D.VendorDeviceID LEFT OUTER JOIN
                      Protocol AS P ON P.ID = D.ProtocolID LEFT OUTER JOIN
                      Interconnection AS I ON I.ID = D.InterconnectionID LEFT OUTER JOIN
                      Node AS N ON N.ID = D.NodeID LEFT OUTER JOIN
                      Device AS PD ON PD.ID = D.ParentID;
 
CREATE VIEW MapData AS
SELECT     'Device' AS DeviceType, NodeID, ID, Acronym, COALESCE(Name, '') AS Name, CompanyMapAcronym, CompanyName, VendorDeviceName, Longitude, 
                      Latitude, 1 AS Reporting, 0 AS Inprogress, 0 AS Planned, 0 AS Desired
FROM         DeviceDetail AS D
UNION ALL
SELECT     'OtherDevice' AS DeviceType, NULL AS NodeID, ID, Acronym, COALESCE(Name, '') AS Name, CompanyMapAcronym, CompanyName, VendorDeviceName, 
                      Longitude, Latitude, 0 AS Reporting, 1 AS Inprogress, 1 AS Planned, 1 AS Desired
FROM         OtherDeviceDetail AS OD;

CREATE VIEW OutputStreamDetail AS
SELECT     OS.NodeID, OS.ID, OS.Acronym, COALESCE(OS.Name, '') AS Name, OS.Type, COALESCE(OS.ConnectionString, '') AS ConnectionString, OS.IDCode, 
                      COALESCE(OS.CommandChannel, '') AS CommandChannel, COALESCE(OS.DataChannel, '') AS DataChannel, OS.AutoPublishConfigFrame, 
                      OS.AutoStartDataChannel, OS.NominalFrequency, OS.FramesPerSecond, OS.LagTime, OS.LeadTime, OS.UseLocalClockAsRealTime, 
                      OS.AllowSortsByArrival, OS.LoadOrder, OS.Enabled, N.Name AS NodeName, OS.DigitalMaskValue, OS.AnalogScalingValue, 
                      OS.VoltageScalingValue, OS.CurrentScalingValue, OS.CoordinateFormat, OS.DataFormat, OS.DownsamplingMethod, 
                      OS.AllowPreemptivePublishing, OS.TimeResolution, OS.IgnoreBadTimeStamps, OS.PerformTimeReasonabilityCheck
FROM         OutputStream AS OS INNER JOIN Node AS N ON OS.NodeID = N.ID;
                      
CREATE VIEW OutputStreamMeasurementDetail AS
SELECT     OSM.NodeID, OSM.AdapterID, OSM.ID, OSM.HistorianID, OSM.PointID, OSM.SignalReference, M.PointTag AS SourcePointTag, COALESCE(H.Acronym, '') 
                      AS HistorianAcronym
FROM         OutputStreamMeasurement AS OSM INNER JOIN
                      Measurement AS M ON M.PointID = OSM.PointID LEFT OUTER JOIN
                      Historian AS H ON H.ID = OSM.HistorianID;
      
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
SELECT     MeasurementDetail.CompanyID, MeasurementDetail.CompanyAcronym, MeasurementDetail.CompanyName, MeasurementDetail.SignalID, MeasurementDetail.HistorianID, MeasurementDetail.HistorianAcronym, MeasurementDetail.HistorianConnectionString, MeasurementDetail.PointID, MeasurementDetail.PointTag, MeasurementDetail.AlternateTag, MeasurementDetail.DeviceID, 
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

CREATE VIEW NEW_GUID AS
SELECT lower(
	hex(randomblob(4)) || '-' ||
	hex(randomblob(2)) || '-' ||
	'4' || substr(hex(randomblob(2)), 2) || '-' ||
	substr('AB89', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(2)), 2) || '-' ||
	hex(randomblob(6))
);
	   

CREATE TRIGGER CustomActionAdapter_RuntimeSync_Insert AFTER INSERT ON CustomActionAdapter
FOR EACH ROW BEGIN INSERT INTO Runtime (SourceID, SourceTable) VALUES(NEW.ID, 'CustomActionAdapter'); END;

CREATE TRIGGER CustomActionAdapter_RuntimeSync_Delete BEFORE DELETE ON CustomActionAdapter
FOR EACH ROW BEGIN DELETE FROM Runtime WHERE SourceID = OLD.ID AND SourceTable = 'CustomActionAdapter'; END;

CREATE TRIGGER CustomInputAdapter_RuntimeSync_Insert AFTER INSERT ON CustomInputAdapter
FOR EACH ROW BEGIN INSERT INTO Runtime (SourceID, SourceTable) VALUES(NEW.ID, 'CustomInputAdapter'); END;

CREATE TRIGGER CustomInputAdapter_RuntimeSync_Delete BEFORE DELETE ON CustomInputAdapter
FOR EACH ROW BEGIN DELETE FROM Runtime WHERE SourceID = OLD.ID AND SourceTable = 'CustomInputAdapter'; END;

CREATE TRIGGER CustomOutputAdapter_RuntimeSync_Insert AFTER INSERT ON CustomOutputAdapter
FOR EACH ROW BEGIN INSERT INTO Runtime (SourceID, SourceTable) VALUES(NEW.ID, 'CustomOutputAdapter'); END;

CREATE TRIGGER CustomOutputAdapter_RuntimeSync_Delete BEFORE DELETE ON CustomOutputAdapter
FOR EACH ROW BEGIN DELETE FROM Runtime WHERE SourceID = OLD.ID AND SourceTable = 'CustomOutputAdapter'; END;

CREATE TRIGGER Device_RuntimeSync_Insert AFTER INSERT ON Device
FOR EACH ROW BEGIN INSERT INTO Runtime (SourceID, SourceTable) VALUES(NEW.ID, 'Device'); END;

CREATE TRIGGER Device_RuntimeSync_Delete BEFORE DELETE ON Device
FOR EACH ROW BEGIN DELETE FROM Runtime WHERE SourceID = OLD.ID AND SourceTable = 'Device'; END;

CREATE TRIGGER CalculatedMeasurement_RuntimeSync_Insert AFTER INSERT ON CalculatedMeasurement
FOR EACH ROW BEGIN INSERT INTO Runtime (SourceID, SourceTable) VALUES(NEW.ID, 'CalculatedMeasurement'); END;

CREATE TRIGGER CalculatedMeasurement_RuntimeSync_Delete BEFORE DELETE ON CalculatedMeasurement
FOR EACH ROW BEGIN DELETE FROM Runtime WHERE SourceID = OLD.ID AND SourceTable = 'CalculatedMeasurement'; END;

CREATE TRIGGER OutputStream_RuntimeSync_Insert AFTER INSERT ON OutputStream
FOR EACH ROW BEGIN INSERT INTO Runtime (SourceID, SourceTable) VALUES(NEW.ID, 'OutputStream'); END;

CREATE TRIGGER OutputStream_RuntimeSync_Delete BEFORE DELETE ON OutputStream
FOR EACH ROW BEGIN DELETE FROM Runtime WHERE SourceID = OLD.ID AND SourceTable = 'OutputStream'; END;

CREATE TRIGGER Historian_RuntimeSync_Insert AFTER INSERT ON Historian
FOR EACH ROW BEGIN INSERT INTO Runtime (SourceID, SourceTable) VALUES(NEW.ID, 'Historian'); END;

CREATE TRIGGER Historian_RuntimeSync_Delete BEFORE DELETE ON Historian
FOR EACH ROW BEGIN DELETE FROM Runtime WHERE SourceID = OLD.ID AND SourceTable = 'Historian'; END;

CREATE TRIGGER AccessLog_InsertDefault AFTER INSERT ON AccessLog 
FOR EACH ROW BEGIN UPDATE AccessLog SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = ''; END;

CREATE TRIGGER ApplicationRole_InsertDefault AFTER INSERT ON ApplicationRole 
FOR EACH ROW
  BEGIN
    UPDATE ApplicationRole SET ID = (SELECT * FROM NEW_GUID) WHERE ROWID = NEW.ROWID AND ID = '';
	UPDATE ApplicationRole SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE ApplicationRole SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;

CREATE TRIGGER SecurityGroup_InsertDefault AFTER INSERT ON SecurityGroup 
FOR EACH ROW
  BEGIN
    UPDATE SecurityGroup SET ID = (SELECT * FROM NEW_GUID) WHERE ROWID = NEW.ROWID AND ID = '';
	UPDATE SecurityGroup SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE SecurityGroup SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;

CREATE TRIGGER UserAccount_InsertDefault AFTER INSERT ON UserAccount 
FOR EACH ROW
  BEGIN
    UPDATE UserAccount SET ID = (SELECT * FROM NEW_GUID) WHERE ROWID = NEW.ROWID AND ID = '';
	UPDATE UserAccount SET ChangePasswordOn = strftime('%Y-%m-%d %H:%M:%f', 'now', '+90 days') WHERE ROWID = NEW.ROWID AND ChangePasswordOn IS NULL;
	UPDATE UserAccount SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE UserAccount SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;

CREATE TRIGGER CalculatedMeasurement_InsertDefault AFTER INSERT ON CalculatedMeasurement
FOR EACH ROW
  BEGIN
    UPDATE CalculatedMeasurement SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE CalculatedMeasurement SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;

CREATE TRIGGER Company_InsertDefault AFTER INSERT ON Company
FOR EACH ROW
  BEGIN
    UPDATE Company SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE Company SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;

CREATE TRIGGER CustomActionAdapter_InsertDefault AFTER INSERT ON CustomActionAdapter
FOR EACH ROW
  BEGIN
    UPDATE CustomActionAdapter SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE CustomActionAdapter SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;

CREATE TRIGGER CustomInputAdapter_InsertDefault AFTER INSERT ON CustomInputAdapter
FOR EACH ROW
  BEGIN
    UPDATE CustomInputAdapter SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE CustomInputAdapter SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;

CREATE TRIGGER CustomOutputAdapter_InsertDefault AFTER INSERT ON CustomOutputAdapter
FOR EACH ROW
  BEGIN
    UPDATE CustomOutputAdapter SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE CustomOutputAdapter SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;

CREATE TRIGGER Device_InsertDefault AFTER INSERT ON Device
FOR EACH ROW
  BEGIN
	UPDATE Device SET UniqueID = (SELECT * FROM NEW_GUID) WHERE ROWID = NEW.ROWID AND UniqueID IS NULL;
    UPDATE Device SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE Device SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;

CREATE TRIGGER Historian_InsertDefault AFTER INSERT ON Historian
FOR EACH ROW
  BEGIN
    UPDATE Historian SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE Historian SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;
  
CREATE TRIGGER Subscriber_InsertDefault AFTER INSERT ON Subscriber
FOR EACH ROW
  BEGIN
    UPDATE Subscriber SET ID = (SELECT * FROM NEW_GUID) WHERE ROWID = NEW.ROWID AND ID = '';
	UPDATE Subscriber SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE Subscriber SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;

CREATE TRIGGER Measurement_InsertDefault AFTER INSERT ON Measurement
FOR EACH ROW
  BEGIN
    UPDATE Measurement SET SignalID = (SELECT * FROM NEW_GUID) WHERE ROWID = NEW.ROWID AND SignalID IS NULL;
	UPDATE Measurement SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE Measurement SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;

CREATE TRIGGER Node_InsertDefault AFTER INSERT ON Node
FOR EACH ROW
  BEGIN
    UPDATE Node SET ID = (SELECT * FROM NEW_GUID) WHERE ROWID = NEW.ROWID AND ID IS NULL;
	UPDATE Node SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE Node SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;

CREATE TRIGGER OtherDevice_InsertDefault AFTER INSERT ON OtherDevice
FOR EACH ROW
  BEGIN
    UPDATE OtherDevice SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE OtherDevice SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;

CREATE TRIGGER OutputStream_InsertDefault AFTER INSERT ON OutputStream
FOR EACH ROW
  BEGIN
    UPDATE OutputStream SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE OutputStream SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;

CREATE TRIGGER OutputStreamDevice_InsertDefault AFTER INSERT ON OutputStreamDevice
FOR EACH ROW
  BEGIN
    UPDATE OutputStreamDevice SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE OutputStreamDevice SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;

CREATE TRIGGER OutputStreamDeviceAnalog_InsertDefault AFTER INSERT ON OutputStreamDeviceAnalog
FOR EACH ROW
  BEGIN
    UPDATE OutputStreamDeviceAnalog SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE OutputStreamDeviceAnalog SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;

CREATE TRIGGER OutputStreamDeviceDigital_InsertDefault AFTER INSERT ON OutputStreamDeviceDigital
FOR EACH ROW
  BEGIN
    UPDATE OutputStreamDeviceDigital SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE OutputStreamDeviceDigital SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;

CREATE TRIGGER OutputStreamDevicePhasor_InsertDefault AFTER INSERT ON OutputStreamDevicePhasor
FOR EACH ROW
  BEGIN
    UPDATE OutputStreamDevicePhasor SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE OutputStreamDevicePhasor SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;

CREATE TRIGGER OutputStreamMeasurement_InsertDefault AFTER INSERT ON OutputStreamMeasurement
FOR EACH ROW
  BEGIN
    UPDATE OutputStreamMeasurement SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE OutputStreamMeasurement SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;

CREATE TRIGGER Phasor_InsertDefault AFTER INSERT ON Phasor
FOR EACH ROW
  BEGIN
    UPDATE Phasor SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE Phasor SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;

CREATE TRIGGER Vendor_InsertDefault AFTER INSERT ON Vendor
FOR EACH ROW
  BEGIN
    UPDATE Vendor SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE Vendor SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;

CREATE TRIGGER VendorDevice_InsertDefault AFTER INSERT ON VendorDevice
FOR EACH ROW
  BEGIN
    UPDATE VendorDevice SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = '';
	UPDATE VendorDevice SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = '';
  END;

CREATE TRIGGER ErrorLog_InsertDefault AFTER INSERT ON ErrorLog FOR EACH ROW
BEGIN UPDATE ErrorLog SET CreatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND CreatedOn = ''; END;

CREATE TRIGGER AuditLog_InsertDefault AFTER INSERT ON AuditLog FOR EACH ROW
BEGIN UPDATE AuditLog SET UpdatedOn = strftime('%Y-%m-%d %H:%M:%f') WHERE ROWID = NEW.ROWID AND UpdatedOn = ''; END;