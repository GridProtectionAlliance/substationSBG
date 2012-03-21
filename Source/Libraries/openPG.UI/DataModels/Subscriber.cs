﻿//******************************************************************************************************
//  Subscriber.cs - Gbtc
//
//  Copyright © 2010, Grid Protection Alliance.  All Rights Reserved.
//
//  Licensed to the Grid Protection Alliance (GPA) under one or more contributor license agreements. See
//  the NOTICE file distributed with this work for additional information regarding copyright ownership.
//  The GPA licenses this file to you under the Eclipse Public License -v 1.0 (the "License"); you may
//  not use this file except in compliance with the License. You may obtain a copy of the License at:
//
//      http://www.opensource.org/licenses/eclipse-1.0.php
//
//  Unless agreed to in writing, the subject software distributed under the License is distributed on an
//  "AS-IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. Refer to the
//  License for the specific language governing permissions and limitations.
//
//  Code Modification History:
//  ----------------------------------------------------------------------------------------------------
//  05/10/2011 - Magdiel Lorenzo
//       Generated original version of source code.
// 05/13/2011 - Aniket Salver
//       Modified the way Guid is retrived from the Data Base.
// 05/20/2011 - Mehulbhai P Thakkar
//       Added methods to retrieve, add and remove measurements and measurement groups.
//
//******************************************************************************************************

using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Data;
using TimeSeriesFramework.UI;
using TimeSeriesFramework.UI.DataModels;
using TVA.Data;

namespace openPG.UI.DataModels
{
    /// <summary>
    /// Represents a record of <see cref="Subscriber"/> information as defined in the database.
    /// </summary>
    public class Subscriber : DataModelBase
    {
        #region [ Members ]

        // Fields

        private Guid m_nodeID;
        private Guid m_id;
        private string m_acronym;
        private string m_name;
        private string m_sharedSecret;
        private string m_authKey;
        private string m_validIpAddresses;
        private bool m_enabled;
        private DateTime m_createdOn;
        private string m_createdBy;
        private DateTime m_updatedOn;
        private string m_updatedBy;

        // Fields below are used only for Subscriber Measurements screen.
        private Dictionary<Guid, string> m_allowedMeasurements;
        private Dictionary<Guid, string> m_deniedMeasurements;
        private ObservableCollection<Measurement> m_availableMeasurements;
        private Dictionary<int, string> m_allowedMeasurementGroups;
        private Dictionary<int, string> m_deniedMeasurementGroups;
        private Dictionary<int, string> m_availableMeasurementGroups;

        // Fields below are used only for Subscriber Status screen.
        private string m_statusColor;
        private string m_version;

        #endregion

        #region [ Properties ]

        /// <summary>
        /// Gets or sets <see cref="Subscriber"/>'s status color.
        /// </summary>
        public string StatusColor
        {
            get
            {
                return m_statusColor;
            }
            set
            {
                m_statusColor = value;
                OnPropertyChanged("StatusColor");
            }
        }

        /// <summary>
        /// Gets or sets version information for <see cref="Subscriber"/>.
        /// </summary>
        public string Version
        {
            get
            {
                return m_version;
            }
            set
            {
                m_version = value;
                OnPropertyChanged("Version");
            }
        }

        /// <summary>
        /// Gets or sets <see cref="Subscriber"/>'s allowed measurements.
        /// </summary>
        // Field is populated by many to many database relationship with measurement table, so no validation applied.
        public Dictionary<Guid, string> AllowedMeasurements
        {
            get
            {
                return m_allowedMeasurements;
            }
            set
            {
                m_allowedMeasurements = value;
                OnPropertyChanged("AllowedMeasurements");
            }
        }

        /// <summary>
        /// Gets or sets <see cref="Subscriber"/>'s denied measurements.
        /// </summary>
        // Field is populated by many to many database relationship with measurement table, so no validation applied.
        public Dictionary<Guid, string> DeniedMeasurements
        {
            get
            {
                return m_deniedMeasurements;
            }
            set
            {
                m_deniedMeasurements = value;
                OnPropertyChanged("DeniedMeasurements");
            }
        }

        /// <summary>
        /// Gets or sets <see cref="Subscriber"/>'s available measurements.
        /// </summary>
        public ObservableCollection<Measurement> AvailableMeasurements
        {
            get
            {
                return m_availableMeasurements;
            }
            set
            {
                m_availableMeasurements = value;
                OnPropertyChanged("AvailableMeasurements");
            }
        }

        /// <summary>
        /// Gets or sets <see cref="Subscriber"/>'s allowed measurement groups.
        /// </summary>
        // Field is populated by many to many database relationship with measurementgroup table, so no validation applied.
        public Dictionary<int, string> AllowedMeasurementGroups
        {
            get
            {
                return m_allowedMeasurementGroups;
            }
            set
            {
                m_allowedMeasurementGroups = value;
                OnPropertyChanged("AllowedMeasurementGroups");
            }
        }

        /// <summary>
        /// Gets or sets <see cref="Subscriber"/>'s denied measurement groups.
        /// </summary>
        // Field is populated by many to many database relationship with measurementgroup table, so no validation applied.
        public Dictionary<int, string> DeniedMeasurementGroups
        {
            get
            {
                return m_deniedMeasurementGroups;
            }
            set
            {
                m_deniedMeasurementGroups = value;
                OnPropertyChanged("DeniedMeasurementGroups");
            }
        }

        /// <summary>
        /// Gets or sets <see cref="Subscriber"/>'s available measurement groups.
        /// </summary>
        // Field is populated by many to many database relationship with measurementgroup table, so no validation applied.
        public Dictionary<int, string> AvailableMeasurementGroups
        {
            get
            {
                return m_availableMeasurementGroups;
            }
            set
            {
                m_availableMeasurementGroups = value;
                OnPropertyChanged("AvailableMeasurementGroups");
            }
        }

        /// <summary>
        /// Gets or sets the current <see cref="Subscriber"/>'s node ID.
        /// </summary>
        [Required(ErrorMessage = "The Subscriber node ID is required, please provide value.")]
        public Guid NodeID
        {
            get
            {
                return m_nodeID;
            }
            set
            {
                m_nodeID = value;
                OnPropertyChanged("NodeID");
            }
        }

        /// <summary>
        /// Gets or sets the current <see cref="Subscriber"/>'s ID.
        /// </summary>
        public Guid ID
        {
            get
            {
                return m_id;
            }
            set
            {
                m_id = value;
            }
        }

        /// <summary>
        /// Gets or sets the current <see cref="Subscriber"/>'s acronym.
        /// </summary>
        [Required(ErrorMessage = "The Subscriber acronym is a required field, please provide a value.")]
        [StringLength(200, ErrorMessage = "The subscriber acronym cannot exceed 200 characters.")]
        [RegularExpression("^[A-Z0-9-'!'_'@#\\$]+$", ErrorMessage = "Only upper case letters, numbers, '!', '-', '@', '#', '_' and '$' are allowed.")]
        public string Acronym
        {
            get
            {
                return m_acronym;
            }
            set
            {
                m_acronym = value;
                OnPropertyChanged("Acronym");
            }
        }

        /// <summary>
        /// Gets or sets the current <see cref="Subscriber"/> name.
        /// </summary>
        [StringLength(200, ErrorMessage = "The subscriber name cannot exceed 200 characters.")]
        public string Name
        {
            get
            {
                return m_name;
            }
            set
            {
                m_name = value;
                OnPropertyChanged("Name");
            }
        }

        /// <summary>
        /// Gets or sets the current <see cref="Subscriber"/>'s shared secret.
        /// </summary>
        [Required(ErrorMessage = "The Subscriber shared secret is a required field, please provide a value.")]
        public string SharedSecret
        {
            get
            {
                return m_sharedSecret;
            }
            set
            {
                m_sharedSecret = value;
                OnPropertyChanged("SharedSecret");
            }
        }

        /// <summary>
        /// Gets or sets the authorization key for the current <see cref="Subscriber"/>.
        /// </summary>
        [Required(ErrorMessage = "The subscriber authorization key is a required field, please provide value.")]
        public string AuthKey
        {
            get
            {
                return m_authKey;
            }
            set
            {
                m_authKey = value;
                OnPropertyChanged("AuthKey");
            }
        }

        /// <summary>
        /// Gets or sets the valid IP addresses of the current <see cref="Subscriber"/>.
        /// </summary>
        [Required(ErrorMessage = "Subscriber valid IP addresses is a required field, please provide a value.")]
        public string ValidIPAddresses
        {
            get
            {
                return m_validIpAddresses;
            }
            set
            {
                m_validIpAddresses = value;
                OnPropertyChanged("ValidIPAddresses");
            }
        }

        /// <summary>
        /// Gets or sets whether the current <see cref="Subscriber"/> is enabled.
        /// </summary>
        public bool Enabled
        {
            get
            {
                return m_enabled;
            }
            set
            {
                m_enabled = value;
                OnPropertyChanged("Enabled");
            }
        }

        /// <summary>
        /// Gets or sets when the current <see cref="Subscriber"/> was created.
        /// </summary>
        // Field is populated by trigger and has no screen interaction, so no validation attributes are applied.
        public DateTime CreatedOn
        {
            get
            {
                return m_createdOn;
            }
            set
            {
                m_createdOn = value;
            }
        }

        /// <summary>
        /// Gets or sets who the current <see cref="Subscriber"/> was created by.
        /// </summary>
        // Field is populated by trigger and has no screen interaction, so no validation attributes are applied.
        public string CreatedBy
        {
            get
            {
                return m_createdBy;
            }
            set
            {
                m_createdBy = value;
            }
        }

        /// <summary>
        /// Gets or sets when the current <see cref="Subscriber"/> was updated last.
        /// </summary>
        // Field is populated by trigger and has no screen interaction, so no validation attributes are applied.
        public DateTime UpdatedOn
        {
            get
            {
                return m_updatedOn;
            }
            set
            {
                m_updatedOn = value;
            }
        }

        /// <summary>
        /// Gets or sets who the current <see cref="Subscriber"/> was updated by.
        /// </summary>
        // Field is populated by trigger and has no screen interaction, so no validation attributes are applied.
        public string UpdatedBy
        {
            get
            {
                return m_updatedBy;
            }
            set
            {
                m_updatedBy = value;
            }
        }

        #endregion

        #region [ Static ]

        /// <summary>
        /// Loads <see cref="Node"/> information as an <see cref="ObservableCollection{T}"/> style list.
        /// </summary>
        /// <param name="database"><see cref="AdoDataConnection"/> to connection to database.</param>        
        /// <returns>Collection of <see cref="Subscriber"/>.</returns>
        public static ObservableCollection<Subscriber> Load(AdoDataConnection database)
        {
            bool createdConnection = false;

            try
            {
                createdConnection = CreateConnection(ref database);

                ObservableCollection<Subscriber> subscriberList = new ObservableCollection<Subscriber>();
                DataTable subscriberTable;
                string query;

                query = database.ParameterizedQueryString("SELECT ID, NodeID, Acronym, Name, SharedSecret, AuthKey, ValidIPAddresses, " +
                    "Enabled FROM Subscriber WHERE NodeID = {0} ORDER BY Name", "nodeID");

                subscriberTable = database.Connection.RetrieveData(database.AdapterType, query, DefaultTimeout, database.CurrentNodeID());

                foreach (DataRow row in subscriberTable.Rows)
                {
                    subscriberList.Add(new Subscriber()
                    {
                        ID = database.Guid(row, "ID"),
                        NodeID = database.Guid(row, "NodeID"),
                        Acronym = row.Field<string>("Acronym"),
                        Name = row.Field<string>("Name"),
                        SharedSecret = row.Field<string>("SharedSecret"),
                        AuthKey = row.Field<string>("AuthKey"),
                        ValidIPAddresses = row.Field<string>("ValidIPAddresses"),
                        Enabled = Convert.ToBoolean(row.Field<object>("Enabled")),
                        AllowedMeasurements = GetAllowedMeasurements(database, database.Guid(row, "ID")),
                        DeniedMeasurements = GetDeniedMeasurements(database, database.Guid(row, "ID")),
                        AvailableMeasurements = GetAvailableMeasurements(database, database.Guid(row, "ID")),
                        AllowedMeasurementGroups = GetAllowedMeasurementGroups(database, database.Guid(row, "ID")),
                        DeniedMeasurementGroups = GetDeniedMeasurementGroups(database, database.Guid(row, "ID")),
                        AvailableMeasurementGroups = GetAvailableMeasurementGroups(database, database.Guid(row, "ID")),
                        StatusColor = "gray",
                        Version = ""
                    });
                }

                return subscriberList;
            }
            finally
            {
                if (createdConnection && database != null)
                    database.Dispose();
            }
        }

        /// <summary>
        /// Retrieves <see cref="Dictionary{T1,T2}"/> type collection of <see cref="Measurement"/> allowed for <see cref="Subscriber"/>.
        /// </summary>
        /// <param name="database"><see cref="AdoDataConnection"/> to connection to database.</param>
        /// <param name="subscriberID">ID of the <see cref="Subscriber"/> to filter data.</param>
        /// <returns><see cref="Dictionary{T1,T2}"/> type collection of SignalID and PointTag of <see cref="Measurement"/>.</returns>
        public static Dictionary<Guid, string> GetAllowedMeasurements(AdoDataConnection database, Guid subscriberID)
        {
            bool createdConnection = false;

            try
            {
                createdConnection = CreateConnection(ref database);

                Dictionary<Guid, string> allowedMeasurements = new Dictionary<Guid, string>();
                string query = database.ParameterizedQueryString("SELECT SignalID, PointTag FROM SubscriberMeasurementDetail WHERE SubscriberID = {0} AND Allowed = {1} ORDER BY PointTag", "subscriberID", "allowed");
                DataTable allowedMeasurementTable = database.Connection.RetrieveData(database.AdapterType, query, DefaultTimeout, database.Guid(subscriberID), database.Bool(true));

                foreach (DataRow row in allowedMeasurementTable.Rows)
                    allowedMeasurements[database.Guid(row, "SignalID")] = row.Field<string>("PointTag");

                return allowedMeasurements;
            }
            finally
            {
                if (createdConnection && database != null)
                    database.Dispose();
            }
        }

        /// <summary>
        /// Retrieves <see cref="Dictionary{T1,T2}"/> type collection of <see cref="Measurement"/> denied for <see cref="Subscriber"/>.
        /// </summary>
        /// <param name="database"><see cref="AdoDataConnection"/> to connection to database.</param>
        /// <param name="subscriberID">ID of the <see cref="Subscriber"/> to filter data.</param>
        /// <returns><see cref="Dictionary{T1,T2}"/> type collection of SignalID and PointTag of <see cref="Measurement"/>.</returns>
        public static Dictionary<Guid, string> GetDeniedMeasurements(AdoDataConnection database, Guid subscriberID)
        {
            bool createdConnection = false;

            try
            {
                createdConnection = CreateConnection(ref database);

                Dictionary<Guid, string> deniedMeasurements = new Dictionary<Guid, string>();
                string query = database.ParameterizedQueryString("SELECT SignalID, PointTag FROM SubscriberMeasurementDetail WHERE SubscriberID = {0} AND Allowed = {1} ORDER BY PointTag", "subscriberID", "allowed");
                DataTable deniedMeasurementTable = database.Connection.RetrieveData(database.AdapterType, query, DefaultTimeout, database.Guid(subscriberID), database.Bool(false));

                foreach (DataRow row in deniedMeasurementTable.Rows)
                    deniedMeasurements[database.Guid(row, "SignalID")] = row.Field<string>("PointTag");

                return deniedMeasurements;
            }
            finally
            {
                if (createdConnection && database != null)
                    database.Dispose();
            }
        }

        /// <summary>
        /// Retrieves <see cref="Measurement"/> collection which are not assigned to <see cref="Subscriber"/>.
        /// </summary>
        /// <param name="database"><see cref="AdoDataConnection"/> to connection to database.</param>
        /// <param name="subscriberID">ID of the <see cref="Subscriber"/> to filter data.</param>
        /// <returns><see cref="ObservableCollection{T}"/> style list of <see cref="Measurement"/>.</returns>
        public static ObservableCollection<Measurement> GetAvailableMeasurements(AdoDataConnection database, Guid subscriberID)
        {
            return Measurement.GetMeasurementsBySubscriber(database, subscriberID);
        }

        /// <summary>
        /// Retrieves <see cref="Dictionary{T1,T2}"/> type collection of <see cref="MeasurementGroup"/> allowed for <see cref="Subscriber"/>.
        /// </summary>
        /// <param name="database"><see cref="AdoDataConnection"/> to connection to database.</param>
        /// <param name="subscriberID">ID of the <see cref="Subscriber"/> to filter data.</param>
        /// <returns><see cref="Dictionary{T1,T2}"/> type collection of ID and Name of <see cref="MeasurementGroup"/>.</returns>
        public static Dictionary<int, string> GetAllowedMeasurementGroups(AdoDataConnection database, Guid subscriberID)
        {
            bool createdConnection = false;

            try
            {
                createdConnection = CreateConnection(ref database);

                Dictionary<int, string> allowedMeasurementGroups = new Dictionary<int, string>();
                string query = database.ParameterizedQueryString("SELECT MeasurementGroupID, MeasurementGroupName FROM SubscriberMeasGroupDetail WHERE SubscriberID = {0} AND Allowed = {1} ORDER BY MeasurementGroupName", "subscriberID", "allowed");
                DataTable allowedMeasurementGroupTable = database.Connection.RetrieveData(database.AdapterType, query, DefaultTimeout, database.Guid(subscriberID), database.Bool(true));

                foreach (DataRow row in allowedMeasurementGroupTable.Rows)
                    allowedMeasurementGroups[row.ConvertField<int>("MeasurementGroupID")] = row.Field<string>("MeasurementGroupName");

                return allowedMeasurementGroups;
            }
            finally
            {
                if (createdConnection && database != null)
                    database.Dispose();
            }
        }

        /// <summary>
        /// Retrieves <see cref="Dictionary{T1,T2}"/> type collection of <see cref="MeasurementGroup"/> denied for <see cref="Subscriber"/>.
        /// </summary>
        /// <param name="database"><see cref="AdoDataConnection"/> to connection to database.</param>
        /// <param name="subscriberID">ID of the <see cref="Subscriber"/> to filter data.</param>
        /// <returns><see cref="Dictionary{T1,T2}"/> type collection of ID and Name of <see cref="MeasurementGroup"/>.</returns>
        public static Dictionary<int, string> GetDeniedMeasurementGroups(AdoDataConnection database, Guid subscriberID)
        {
            bool createdConnection = false;

            try
            {
                createdConnection = CreateConnection(ref database);

                Dictionary<int, string> deniedMeasurementGroups = new Dictionary<int, string>();
                string query = database.ParameterizedQueryString("SELECT MeasurementGroupID, MeasurementGroupName FROM SubscriberMeasGroupDetail WHERE SubscriberID = {0} AND Allowed = {1} ORDER BY MeasurementGroupName", "subscriberID", "allowed");
                DataTable deniedMeasurementGroupTable = database.Connection.RetrieveData(database.AdapterType, query, DefaultTimeout, database.Guid(subscriberID), database.Bool(false));

                foreach (DataRow row in deniedMeasurementGroupTable.Rows)
                    deniedMeasurementGroups[row.ConvertField<int>("MeasurementGroupID")] = row.Field<string>("MeasurementGroupName");

                return deniedMeasurementGroups;
            }
            finally
            {
                if (createdConnection && database != null)
                    database.Dispose();
            }
        }

        /// <summary>
        /// Retrieves <see cref="Dictionary{T1,T2}"/> type collection of <see cref="MeasurementGroup"/> neither allowed nor denied for <see cref="Subscriber"/>.
        /// </summary>
        /// <param name="database"><see cref="AdoDataConnection"/> to connection to database.</param>
        /// <param name="subscriberID">ID of the <see cref="Subscriber"/> to filter data.</param>
        /// <returns><see cref="Dictionary{T1,T2}"/> type collection of ID and Name of <see cref="MeasurementGroup"/>.</returns>
        public static Dictionary<int, string> GetAvailableMeasurementGroups(AdoDataConnection database, Guid subscriberID)
        {
            bool createdConnection = false;

            try
            {
                createdConnection = CreateConnection(ref database);

                Dictionary<int, string> availableMeasurementGroups = new Dictionary<int, string>();
                string query = database.ParameterizedQueryString("SELECT ID, Name FROM MeasurementGroup WHERE " +
                    "ID NOT IN (SELECT MeasurementGroupID FROM SubscriberMeasurementGroup WHERE SubscriberID = {0}) ORDER BY Name", "subscriberID");
                DataTable availableMeasurementGroupTable = database.Connection.RetrieveData(database.AdapterType, query, DefaultTimeout, database.Guid(subscriberID));

                foreach (DataRow row in availableMeasurementGroupTable.Rows)
                    availableMeasurementGroups[row.ConvertField<int>("ID")] = row.Field<string>("Name");

                return availableMeasurementGroups;
            }
            finally
            {
                if (createdConnection && database != null)
                    database.Dispose();
            }
        }

        /// <summary>
        /// Adds measurements to <see cref="Subscriber"/>.
        /// </summary>
        /// <param name="database"><see cref="AdoDataConnection"/> to connection to database.</param>
        /// <param name="subscriberID">ID of the <see cref="Subscriber"/> to which measurements to be added.</param>
        /// <param name="measurementsToBeAdded">List of <see cref="Measurement"/> IDs to be added.</param>
        /// <param name="allowed">boolean flag to indicate if measurements are allowed or denied.</param>
        /// <returns>string, indicating success for UI display.</returns>
        public static string AddMeasurements(AdoDataConnection database, Guid subscriberID, List<Guid> measurementsToBeAdded, bool allowed)
        {
            bool createdConnection = false;
            string query;

            try
            {
                createdConnection = CreateConnection(ref database);

                foreach (Guid id in measurementsToBeAdded)
                {
                    query = database.ParameterizedQueryString("INSERT INTO SubscriberMeasurement (NodeID, SubscriberID, SignalID, Allowed, UpdatedOn, UpdatedBy, " +
                        "CreatedOn, CreatedBy) VALUES ({0}, {1}, {2}, {3}, {4}, {5}, {6}, {7})", "nodeID", "subscriberID", "signalID", "allowed", "updatedOn",
                        "updatedBy", "createdOn", "createdBy");

                    database.Connection.ExecuteNonQuery(query, DefaultTimeout, database.CurrentNodeID(), database.Guid(subscriberID), database.Guid(id),
                        database.Bool(allowed), database.UtcNow(), CommonFunctions.CurrentUser, database.UtcNow(), CommonFunctions.CurrentUser);
                }

                if (allowed)
                    return "Measurements added to allowed measurements list for subscriber successfully";
                else
                    return "Measurements added to denied measurements list for subscriber successfully";
            }
            finally
            {
                if (createdConnection && database != null)
                    database.Dispose();
            }
        }

        /// <summary>
        /// Removes measurements from <see cref="Subscriber"/>.
        /// </summary>
        /// <param name="database"><see cref="AdoDataConnection"/> to connection to database.</param>
        /// <param name="subscriberID">ID of the <see cref="Subscriber"/> from which measurements to be removed.</param>
        /// <param name="measurementsToBeRemoved">List of <see cref="Measurement"/> IDs to be removed.</param>
        /// <returns>string, indicating success for UI display.</returns>
        public static string RemoveMeasurements(AdoDataConnection database, Guid subscriberID, List<Guid> measurementsToBeRemoved)
        {
            bool createdConnection = false;
            string query;

            try
            {
                createdConnection = CreateConnection(ref database);

                foreach (Guid id in measurementsToBeRemoved)
                {
                    query = database.ParameterizedQueryString("DELETE FROM SubscriberMeasurement WHERE SubscriberID = {0} AND SignalID = {1}", "subscriberID", "signalID");
                    database.Connection.ExecuteNonQuery(query, DefaultTimeout, database.Guid(subscriberID), database.Guid(id));
                }

                return "Selected measurements removed successfully";
            }
            finally
            {
                if (createdConnection && database != null)
                    database.Dispose();
            }
        }

        /// <summary>
        /// Adds measurement groups to <see cref="Subscriber"/>.
        /// </summary>
        /// <param name="database"><see cref="AdoDataConnection"/> to connection to database.</param>
        /// <param name="subscriberID">ID of the <see cref="Subscriber"/> to which measurements to be added.</param>
        /// <param name="measurementGroupsToBeAdded">List of <see cref="MeasurementGroup"/> IDs to be added.</param>
        /// <param name="allowed">boolean flag to indicate if measurement groups are allowed or denied.</param>
        /// <returns>string, indicating success for UI display.</returns>
        public static string AddMeasurementGroups(AdoDataConnection database, Guid subscriberID, List<int> measurementGroupsToBeAdded, bool allowed)
        {
            bool createdConnection = false;
            string query;

            try
            {
                createdConnection = CreateConnection(ref database);

                foreach (int id in measurementGroupsToBeAdded)
                {
                    query = database.ParameterizedQueryString("INSERT INTO SubscriberMeasurementGroup (NodeID, SubscriberID, MeasurementGroupID, Allowed, UpdatedOn, " +
                        "UpdatedBy, CreatedOn, CreatedBy) VALUES ({0}, {1}, {2}, {3}, {4}, {5}, {6}, {7})", "nodeID", "subscriberID", "measurementGroupID",
                        "allowed", "updatedOn", "updatedBy", "createdOn", "createdBy");

                    database.Connection.ExecuteNonQuery(query, DefaultTimeout, database.CurrentNodeID(), database.Guid(subscriberID), id, database.Bool(allowed),
                        database.UtcNow(), CommonFunctions.CurrentUser, database.UtcNow(), CommonFunctions.CurrentUser);
                }

                if (allowed)
                    return "Measurement groups added to allowed measurement groups list for subscriber successfully";
                else
                    return "Measurement groups added to denied measurement groups list for subscriber successfully";
            }
            finally
            {
                if (createdConnection && database != null)
                    database.Dispose();
            }
        }

        /// <summary>
        /// Removed measurement groups from <see cref="Subscriber"/>.
        /// </summary>
        /// <param name="database"><see cref="AdoDataConnection"/> to connection to database.</param>
        /// <param name="subscriberID">ID of the <see cref="Subscriber"/> to which measurement groups to be removed.</param>
        /// <param name="measurementGroupsToBeRemoved">List of <see cref="MeasurementGroup"/> IDs to be removed.</param>
        /// <returns>string, indicating success for UI display.</returns>
        public static string RemoveMeasurementGroups(AdoDataConnection database, Guid subscriberID, List<int> measurementGroupsToBeRemoved)
        {
            bool createdConnection = false;
            string query;

            try
            {
                createdConnection = CreateConnection(ref database);

                foreach (int id in measurementGroupsToBeRemoved)
                {
                    query = database.ParameterizedQueryString("DELETE FROM SubscriberMeasurementGroup WHERE SubscriberID = {0} AND MeasurementGroupID = {1}", "subscriberID", "measurementGroupID");
                    database.Connection.ExecuteNonQuery(query, DefaultTimeout, database.Guid(subscriberID), id);
                }

                return "Measurement groups removed from allowed measurement groups list for subscriber successfully";
            }
            finally
            {
                if (createdConnection && database != null)
                    database.Dispose();
            }
        }

        /// <summary>
        /// Gets a <see cref="Dictionary{T1,T2}"/> style list of <see cref="Subscriber"/> information.
        /// </summary>
        /// <param name="database"><see cref="AdoDataConnection"/> to connection to database.</param>
        /// <param name="isOptional">Indicates if selection on UI is optional for this collection.</param>
        /// <returns><see cref="Dictionary{T1,T2}"/> containing ID and Name of subscribers defined in the database.</returns>
        public static Dictionary<Guid, string> GetLookupList(AdoDataConnection database, bool isOptional = false)
        {
            bool createdConnection = false;

            try
            {
                createdConnection = CreateConnection(ref database);

                Dictionary<Guid, string> subscriberList = new Dictionary<Guid, string>();

                if (isOptional)
                    subscriberList.Add(Guid.Empty, "Select Subscriber");

                string query = database.ParameterizedQueryString("SELECT ID, Acronym FROM Subscriber WHERE Enabled = {0} AND NodeID = {1} ORDER BY Name", "enabled", "nodeID");
                DataTable subscriberTable = database.Connection.RetrieveData(database.AdapterType, query, DefaultTimeout, database.Bool(true), database.CurrentNodeID());

                foreach (DataRow row in subscriberTable.Rows)
                {
                    subscriberList[database.Guid(row, "ID")] = row.Field<string>("Acronym");
                }

                return subscriberList;
            }
            finally
            {
                if (createdConnection && database != null)
                    database.Dispose();
            }
        }

        /// <summary>
        /// Saves <see cref="Subscriber"/> information to database.
        /// </summary>
        /// <param name="database"><see cref="AdoDataConnection"/> to connection to database.</param>
        /// <param name="subscriber">Information about <see cref="Subscriber"/>.</param>        
        /// <returns>String, for display use, indicating success.</returns>
        public static string Save(AdoDataConnection database, Subscriber subscriber)
        {
            bool createdConnection = false;
            string query;

            try
            {
                createdConnection = CreateConnection(ref database);

                if (subscriber.ID == Guid.Empty || subscriber.ID == null)
                {
                    query = database.ParameterizedQueryString("INSERT INTO Subscriber (NodeID, Acronym, Name, SharedSecret, AuthKey, ValidIPAddresses, Enabled, " +
                        "UpdatedBy, UpdatedOn, CreatedBy, CreatedOn) VALUES ({0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}, {9}, {10})", "nodeID", "acronym", "name",
                        "sharedSecret", "authKey", "validIPAddresses", "enabled", "updatedBy", "updatedOn", "createdBy", "createdOn");

                    database.Connection.ExecuteNonQuery(query, DefaultTimeout,
                        database.CurrentNodeID(), subscriber.Acronym,
                        subscriber.Name.ToNotNull(), subscriber.SharedSecret, subscriber.AuthKey, subscriber.ValidIPAddresses, database.Bool(subscriber.Enabled),
                        CommonFunctions.CurrentUser, database.UtcNow(), CommonFunctions.CurrentUser, database.UtcNow());
                }
                else
                {
                    query = database.ParameterizedQueryString("UPDATE Subscriber SET NodeID = {0}, Acronym = {1}, Name = {2}, SharedSecret = {3}, AuthKey = {4}, " +
                        "ValidIPAddresses = {5}, Enabled = {6}, UpdatedBy = {7}, UpdatedOn = {8} WHERE ID = {9}", "nodeID", "acronym", "name", "sharedSecret", "authKey",
                        "validIPAddresses", "enabled", "updatedBy", "updatedOn", "id");

                    database.Connection.ExecuteNonQuery(query, DefaultTimeout, database.Guid(subscriber.NodeID), subscriber.Acronym, subscriber.Name.ToNotNull(),
                        subscriber.SharedSecret, subscriber.AuthKey, subscriber.ValidIPAddresses, database.Bool(subscriber.Enabled), CommonFunctions.CurrentUser,
                        database.UtcNow(), database.Guid(subscriber.ID));
                }

                try
                {
                    CommonFunctions.SendCommandToService("Initialize");
                }
                catch (Exception ex)
                {
                    return "Subscriber information saved successfully. Failed to send Initialize command to backend service." + Environment.NewLine + ex.Message;
                }

                return "Subscriber information saved successfully";
            }
            finally
            {
                if (createdConnection && database != null)
                    database.Dispose();
            }
        }

        /// <summary>
        /// Deletes specified <see cref="Subscriber"/> record from database.
        /// </summary>
        /// <param name="database"><see cref="AdoDataConnection"/> to connection to database.</param>
        /// <param name="id">ID of the record to be deleted.</param>
        /// <returns>String, for display use, indicating success.</returns>
        public static string Delete(AdoDataConnection database, Guid id)
        {
            bool createdConnection = false;

            try
            {
                createdConnection = CreateConnection(ref database);

                // Setup current user context for any delete triggers
                CommonFunctions.SetCurrentUserContext(database);

                database.Connection.ExecuteNonQuery(database.ParameterizedQueryString("DELETE FROM Subscriber WHERE ID = {0}", "id"), DefaultTimeout, database.Guid(id));

                return "Subscriber deleted successfully";
            }
            finally
            {
                if (createdConnection && database != null)
                    database.Dispose();
            }
        }

        #endregion

    }
}
