﻿//******************************************************************************************************
//  SecurityGroup.cs - Gbtc
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
//  04/13/2011 - Aniket Salver
//       Generated original version of source code.
//  05/02/2011 - J. Ritchie Carroll
//       Updated for coding consistency.
//  05/03/2011 - Mehulbhai P Thakkar
//       Guid field related changes as well as static functions update.
//  05/05/2011 - Mehulbhai P Thakkar
//       Added NULL handling for Save() operation.
//  05/13/2011 - Aniket Salver
//                  Modified the way Guid is retrived from the Data Base.
//
//******************************************************************************************************

using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Data;
using TVA.Data;

namespace openPG.UI.DataModels
{
    /// <summary>
    /// Represents a record of <see cref="SecurityGroup"/> information as defined in the database.
    /// </summary>
    public class SecurityGroup : DataModelBase
    {
        #region [ Members ]

        //Fileds
        private Guid m_id;
        private string m_name;
        private string m_description;
        private DateTime m_createdOn;
        private string m_createdBy;
        private DateTime m_updatedOn;
        private string m_updatedBy;
        private Dictionary<Guid, string> m_currentUsers;
        private Dictionary<Guid, string> m_possibleUsers;

        #endregion

        #region [properties]

        /// <summary>
        /// Gets or sets the current SecurityGroup ID
        /// </summary>
        // Field is populated by database via auto-increment and has no screen interaction, so no validation attributes are applied
        public Guid ID
        {
            get
            {
                return m_id;
            }
            set
            {
                m_id = value;
                OnPropertyChanged("ID");
            }
        }

        /// <summary>
        /// Gets or sets the current SecurityGroup Name
        /// </summary>
        [Required(ErrorMessage = " Security group name is a required field, please provide value.")]
        [StringLength(200, ErrorMessage = "Security group name cannot exceed 200 characters.")]
        [DefaultValue("Add New Group")]
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
        /// Gets or sets the current SecurityGroup Description
        /// </summary>
        // Because of database design no validation attributes are applied.
        public string Description
        {
            get
            {
                return m_description;
            }
            set
            {
                m_description = value;
                OnPropertyChanged("Description");
            }
        }

        /// <summary>
        /// Gets or sets the current SecurityGroup CreatedOn
        /// </summary>
        // Field is populated by database via trigger and has no screen interaction, so no validation attributes are applied
        public DateTime CreatedOn
        {
            get
            {
                return m_createdOn;
            }
            set
            {
                m_createdOn = value;
                OnPropertyChanged("CreatedOn");
            }
        }

        /// <summary>
        /// Gets or sets the current SecurityGroup CreatedBy
        /// </summary>
        // Field is populated by database via trigger and has no screen interaction, so no validation attributes are applied
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
        /// Gets or sets the current SecurityGroup UpdatedOn
        /// </summary>
        // Field is populated by database via trigger and has no screen interaction, so no validation attributes are applied
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
        /// Gets or sets the current SecurityGroup UpdatedBy
        /// </summary>
        // Field is populated by database via trigger and has no screen interaction, so no validation attributes are applied
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

        /// <summary>
        /// Gets or sets the current <see cref="SecurityGroup"/>'s CurrentGroupUsers.
        /// </summary>
        // Field is populated by database via trigger and has no screen interaction, so no validation attributes are applied
        public Dictionary<Guid, string> CurrentUsers
        {
            get
            {
                return m_currentUsers;
            }
            set
            {
                m_currentUsers = value;
                OnPropertyChanged("CurrentUsers");
            }
        }

        /// <summary>
        /// Gets or sets the current <see cref="SecurityGroup"/>'s PossibleGroupUsers.
        /// </summary>
        // Field is populated by database via trigger and has no screen interaction, so no validation attributes are applied
        public Dictionary<Guid, string> PossibleUsers
        {
            get
            {
                return m_possibleUsers;
            }
            set
            {
                m_possibleUsers = value;
                OnPropertyChanged("PossibleUsers");
            }
        }

        #endregion

        #region [ Static ]

        // Static Methods

        /// <summary>
        /// Loads <see cref="Company"/> information as an <see cref="ObservableCollection{T}"/> style list.
        /// </summary>
        /// <param name="database"><see cref="AdoDataConnection"/> to connection to database.</param>
        /// <returns>Collection of <see cref="Company"/>.</returns>
        public static ObservableCollection<SecurityGroup> Load(AdoDataConnection database)
        {
            bool createdConnection = false;

            try
            {
                createdConnection = CreateConnection(ref database);

                ObservableCollection<SecurityGroup> securityGroupList = new ObservableCollection<SecurityGroup>();
                DataTable securityGroupTable = database.Connection.RetrieveData(database.AdapterType, "SELECT * FROM SecurityGroup ORDER BY Name");

                foreach (DataRow row in securityGroupTable.Rows)
                {
                    securityGroupList.Add(new SecurityGroup()
                    {
                        ID = database.Guid(row, "ID"),
                        Name = row.Field<string>("Name"),
                        Description = row.Field<object>("Description") == null ? string.Empty : row.Field<string>("Description"),
                        CreatedOn = Convert.ToDateTime(row.Field<object>("CreatedOn")),
                        CreatedBy = row.Field<string>("CreatedBy"),
                        UpdatedOn = Convert.ToDateTime(row.Field<object>("UpdatedOn")),
                        UpdatedBy = row.Field<string>("UpdatedBy"),
                        CurrentUsers = GetCurrentUsers(database, Guid.Parse(row.Field<object>("ID").ToString())),
                        PossibleUsers = GetPossibleUsers(database, Guid.Parse(row.Field<object>("ID").ToString()))
                    });
                }

                securityGroupList.Insert(0, new SecurityGroup() { ID = Guid.Empty });

                return securityGroupList;
            }
            finally
            {
                if (createdConnection && database != null)
                    database.Dispose();
            }
        }

        /// <summary>
        /// Retrieves collection of <see cref="UserAccount"/>s currently assinged to security group.
        /// </summary>
        /// <param name="database"><see cref="AdoDataConnection"/> to connection to database.</param>
        /// <param name="groupID">ID of <see cref="SecurityGroup"/> to filter users.</param>
        /// <returns><see cref="Dictionary{T1,T2}"/> type collection of <see cref="UserAccount"/>s currently assigned to <see cref="SecurityGroup"/>.</returns>
        public static Dictionary<Guid, string> GetCurrentUsers(AdoDataConnection database, Guid groupID)
        {
            bool createdConnection = false;
            try
            {
                createdConnection = CreateConnection(ref database);

                Dictionary<Guid, string> currentUsers = new Dictionary<Guid, string>();
                DataTable currentUsersTable = database.Connection.RetrieveData(database.AdapterType, "SELECT * FROM SecurityGroupUserAccountDetail WHERE SecurityGroupID = @groupID ORDER BY UserName", groupID);

                foreach (DataRow row in currentUsersTable.Rows)
                    currentUsers[database.Guid(row, "UserAccountID")] = row.Field<string>("UserName");

                return currentUsers;
            }
            finally
            {
                if (createdConnection && database != null)
                    database.Dispose();
            }
        }

        /// <summary>
        /// Retrieves collection of <see cref="UserAccount"/>s currently NOT assinged to security group.
        /// </summary>
        /// <param name="database"><see cref="AdoDataConnection"/> to connection to database.</param>
        /// <param name="groupID">ID of <see cref="SecurityGroup"/> to filter users.</param>
        /// <returns><see cref="Dictionary{T1,T2}"/> type collection of <see cref="UserAccount"/>s currently NOT assigned to <see cref="SecurityGroup"/>.</returns>
        public static Dictionary<Guid, string> GetPossibleUsers(AdoDataConnection database, Guid groupID)
        {
            bool createdConnection = false;
            try
            {
                createdConnection = CreateConnection(ref database);
                Dictionary<Guid, string> possibleGroupUsers = new Dictionary<Guid, string>();
                DataTable possibleUsersTable = database.Connection.RetrieveData(database.AdapterType, "SELECT ID, Name FROM UserAccount WHERE ID NOT IN (SELECT UserAccountID FROM SecurityGroupUserAccount WHERE SecurityGroupID = @groupID) ORDER BY Name", DefaultTimeout, groupID);

                foreach (DataRow row in possibleUsersTable.Rows)
                    possibleGroupUsers[database.Guid(row, "ID")] = row.Field<string>("Name");

                return possibleGroupUsers;
            }
            finally
            {
                if (createdConnection && database != null)
                    database.Dispose();
            }
        }

        /// <summary>
        /// Adds <see cref="UserAccount"/> to <see cref="SecurityGroup"/>.
        /// </summary>
        /// <param name="database"><see cref="AdoDataConnection"/> to connection to database.</param>
        /// <param name="groupID">ID of <see cref="SecurityGroup"/> to which <see cref="UserAccount"/>s are being added.</param>
        /// <param name="usersToBeAdded">List of <see cref="UserAccount"/> IDs to be added.</param>
        /// <returns>string, for display use, indicating success.</returns>
        public static string AddUsers(AdoDataConnection database, Guid groupID, List<Guid> usersToBeAdded)
        {
            bool createdConnection = false;
            try
            {
                createdConnection = CreateConnection(ref database);
                foreach (Guid id in usersToBeAdded)
                {
                    database.Connection.ExecuteNonQuery("INSERT INTO SecurityGroupUserAccount (SecurityGroupID, UserAccountID) VALUES (@groupID, @userID)", DefaultTimeout,
                        database.Guid(groupID), database.Guid(id));
                }

                return "User accounts added to group successfully";
            }
            finally
            {
                if (createdConnection && database != null)
                    database.Dispose();
            }
        }

        /// <summary>
        /// Deletes <see cref="UserAccount"/> from <see cref="SecurityGroup"/>.
        /// </summary>
        /// <param name="database"><see cref="AdoDataConnection"/> to connection to database.</param>
        /// <param name="groupID">ID of <see cref="SecurityGroup"/> from which <see cref="UserAccount"/>s are being deleted.</param>
        /// <param name="usersToBeDeleted">List of <see cref="UserAccount"/> IDs to be deleted.</param>
        /// <returns>string, for display use, indicating success.</returns>
        public static string RemoveUsers(AdoDataConnection database, Guid groupID, List<Guid> usersToBeDeleted)
        {
            bool createdConnection = false;
            try
            {
                createdConnection = CreateConnection(ref database);
                foreach (Guid id in usersToBeDeleted)
                {
                    database.Connection.ExecuteNonQuery("DELETE FROM SecurityGroupUserAccount WHERE SecurityGroupID = @groupID AND UserAccountID = @userID", DefaultTimeout,
                        database.Guid(groupID), database.Guid(id));
                }

                return "User accounts deleted from group successfully";
            }
            finally
            {
                if (createdConnection && database != null)
                    database.Dispose();
            }
        }

        /// <summary>
        /// Gets a <see cref="Dictionary{T1,T2}"/> style list of <see cref="SecurityGroup"/> information.
        /// </summary>
        /// <param name="database"><see cref="AdoDataConnection"/> to connection to database.</param>
        /// <param name="isOptional">Indicates if selection on UI is optional for this collection.</param>
        /// <returns><see cref="Dictionary{T1,T2}"/> containing ID and Name of security groups defined in the database.</returns>
        public static Dictionary<int, string> GetLookupList(AdoDataConnection database, bool isOptional = false)
        {
            bool createdConnection = false;

            try
            {
                createdConnection = CreateConnection(ref database);

                Dictionary<int, string> securityGroupList = new Dictionary<int, string>();

                if (isOptional)
                    securityGroupList.Add(0, "Select Security Group");

                DataTable securityGroupTable = database.Connection.RetrieveData(database.AdapterType, "SELECT ID, Name FROM SecurityGroup ORDER BY Name");

                foreach (DataRow row in securityGroupTable.Rows)
                    securityGroupList[row.Field<int>("ID")] = row.Field<string>("Name");

                return securityGroupList;
            }
            finally
            {
                if (createdConnection && database != null)
                    database.Dispose();
            }
        }

        /// <summary>
        /// Saves <see cref="SecurityGroup"/> information to database.
        /// </summary>
        /// <param name="database"><see cref="AdoDataConnection"/> to connection to database.</param>
        /// <param name="securityGroup">Information about <see cref="SecurityGroup"/>.</param>
        /// <returns>String, for display use, indicating success.</returns>
        public static string Save(AdoDataConnection database, SecurityGroup securityGroup)
        {
            bool createdConnection = false;

            try
            {
                createdConnection = CreateConnection(ref database);

                if (securityGroup.ID == Guid.Empty)
                    database.Connection.ExecuteNonQuery("INSERT INTO SecurityGroup (Name, Description, UpdatedBy, UpdatedOn, CreatedBy, CreatedOn) VALUES (@name, @description, " +
                        "@updatedBy, @updatedOn, @createdBy, @createdOn)", DefaultTimeout, securityGroup.Name, securityGroup.Description.ToNotNull(),
                        CommonFunctions.CurrentUser, database.UtcNow(), CommonFunctions.CurrentUser, database.UtcNow());
                else
                    database.Connection.ExecuteNonQuery("UPDATE SecurityGroup SET Name = @name, Description = @description, UpdatedBy = @updatedBy, UpdatedOn = @updatedOn WHERE ID = @id", DefaultTimeout,
                             securityGroup.Name, securityGroup.Description.ToNotNull(), CommonFunctions.CurrentUser, database.UtcNow(), database.Guid(securityGroup.ID));

                return "Security group information saved successfully";
            }
            finally
            {
                if (createdConnection && database != null)
                    database.Dispose();
            }
        }

        /// <summary>
        /// Deletes specified <see cref="SecurityGroup"/> record from database.
        /// </summary>
        /// <param name="database"><see cref="AdoDataConnection"/> to connection to database.</param>
        /// <param name="securityGroupID">ID of the record to be deleted.</param>
        /// <returns>String, for display use, indicating success.</returns>
        public static string Delete(AdoDataConnection database, Guid securityGroupID)
        {
            bool createdConnection = false;

            try
            {
                createdConnection = CreateConnection(ref database);

                // Setup current user context for any delete triggers
                CommonFunctions.SetCurrentUserContext(database);

                database.Connection.ExecuteNonQuery("DELETE FROM SecurityGroup WHERE ID = @securityGroupID", DefaultTimeout, database.Guid(securityGroupID));

                return "Security group deleted successfully";
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
