/* Create tables for the processed data */
/* This file creates tables using corrected normalisation tables */

CREATE TABLE MONNIT_APPLICATIONS(
	applicationID INT NOT NULL,
	applicationName NVARCHAR(20) NULL,
	CONSTRAINT PK_MONNIT_APPLICATIONS PRIMARY KEY (applicationID)
);

CREATE TABLE MONNIT_NETWORKS(
	networkID INT NOT NULL,
	networkName NVARCHAR(20) NULL,
	CONSTRAINT PK_MONNIT_NETWORKS PRIMARY KEY (networkID)
);

CREATE TABLE MONNIT_SENSORS(
	sensorID UNIQUEIDENTIFIER NOT NULL,
	applicationID INT NOT NULL,
	networkID INT NOT NULL,
	sensorName NVARCHAR(MAX),
	CONSTRAINT PK_MONNIT_SENSORS PRIMARY KEY (sensorID),
	CONSTRAINT FK_MONNIT_SENSORS_APPLICATIONS FOREIGN KEY (applicationID)
	REFERENCES MONNIT_APPLICATIONS (applicationID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT FK_MONNIT_SENSORS_NETWORKS FOREIGN KEY (networkID)
	REFERENCES MONNIT_NETWORKS (networkID)
	ON DELETE CASCADE
	on UPDATE CASCADE
);

CREATE TABLE MONNIT_DATA_TYPES(
	dataTypeID UNIQUEIDENTIFIER NOT NULL,
	dataType NVARCHAR(20) NOT NULL,
	CONSTRAINT PK_MONNIT_DATA_TYPES PRIMARY KEY (dataTypeID)
);

CREATE TABLE MONNIT_PLOT_LABELS(
	plotLabelID UNIQUEIDENTIFIER NOT NULL,
	plotLabel NVARCHAR(20) NOT NULL,
	CONSTRAINT PK_MONNIT_PLOT_LABELS PRIMARY KEY (plotLabelID)
);

CREATE TABLE MONNIT_READINGS(
	readingID UNIQUEIDENTIFIER NOT NULL,
	dataMessageGUID UNIQUEIDENTIFIER NOT NULL,
	sensorID UNIQUEIDENTIFIER NOT NULL,
	dataTypeID UNIQUEIDENTIFIER NOT NULL,
	plotLabelID UNIQUEIDENTIFIER NOT NULL,
	messageDate DATETIME NOT NULL,
	rawData NVARCHAR(10) NULL,
	dataValue NVARCHAR(10) NOT NULL,
	plotValue NVARCHAR(10) NOT NULL,
	CONSTRAINT PK_MONNIT_READINGS PRIMARY KEY (readingID, dataMessageGUID),
	CONSTRAINT FK_MONNIT_READINGS_SENSORID FOREIGN KEY (sensorID)
	REFERENCES MONNIT_SENSORS (sensorID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT FK_MONNIT_READINGS_DTYPE FOREIGN KEY (dataTypeID)
	REFERENCES MONNIT_DATA_TYPES (dataTypeID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT FK_MONNIT_READINGS_PLABEL FOREIGN KEY (plotLabelID)
	REFERENCES MONNIT_PLOT_LABELS (plotLabelID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE MONNIT_SIGNAL_STATUS(
	readingID UNIQUEIDENTIFIER NOT NULL,
	dataMessageGUID UNIQUEIDENTIFIER NOT NULL,
	signalStrength FLOAT,
	CONSTRAINT FK_MONNIT_SIGNAL_STATUS FOREIGN KEY (readingID, dataMessageGUID)
	REFERENCES MONNIT_READINGS (readingID, dataMessageGUID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE MONNIT_BATTERY_STATUS(
	readingID UNIQUEIDENTIFIER NOT NULL,
	dataMessageGUID UNIQUEIDENTIFIER NOT NULL,
	batteryLevel INT,
	CONSTRAINT FK_MONNIT_BATTERY_STATUS FOREIGN KEY (readingID, dataMessageGUID)
	REFERENCES MONNIT_READINGS (readingID, dataMessageGUID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE MONNIT_PENDING_CHANGES(
	readingID UNIQUEIDENTIFIER NOT NULL,
	dataMessageGUID UNIQUEIDENTIFIER NOT NULL,
	pendingChange BIT,
	CONSTRAINT FK_MONNIT_PENDING_CHANGES FOREIGN KEY (readingID, dataMessageGUID)
	REFERENCES MONNIT_READINGS (readingID, dataMessageGUID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE MONNIT_SENSOR_VOLTAGE(
	readingID UNIQUEIDENTIFIER NOT NULL,
	dataMessageGUID UNIQUEIDENTIFIER NOT NULL,
	voltage FLOAT,
	CONSTRAINT FK_MONNIT_SENSOR_VOLTAGE FOREIGN KEY (readingID, dataMessageGUID)
	REFERENCES MONNIT_READINGS (readingID, dataMessageGUID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

GO