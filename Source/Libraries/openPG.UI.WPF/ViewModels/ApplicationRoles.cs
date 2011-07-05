﻿//******************************************************************************************************
//  ApplicationRoles.cs - Gbtc
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
//  05/10/2011 - Mehulbhai P Thakkar
//       Generated original version of source code.
//
//******************************************************************************************************

using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Windows;
using System.Windows.Input;
using openPG.UI.WPF.Commands;
using openPG.UI.DataModels;

namespace openPG.UI.WPF.ViewModels
{
    /// <summary>
    /// Class to hold bindable <see cref="ApplicationRole"/> collection.3
    /// </summary>
    internal class ApplicationRoles : PagedViewModelBase<ApplicationRole, Guid>
    {
        #region [ Members ]

        // Fields
        private RelayCommand m_addUserCommand;
        private RelayCommand m_removeUserCommand;
        private RelayCommand m_addGroupCommand;
        private RelayCommand m_removeGroupCommand;

        #endregion

        #region [ Properties ]

        /// <summary>
        /// Gets flag that determines if <see cref="PagedViewModelBase{T1, T2}.CurrentItem"/> is a new record.
        /// </summary>
        public override bool IsNewRecord
        {
            get
            {
                return (CurrentItem.ID == null || CurrentItem.ID == Guid.Empty);
            }
        }

        /// <summary>
        /// Gets <see cref="ICommand"/> for add users to role operation.
        /// </summary>
        public ICommand AddUserCommand
        {
            get
            {
                if (m_addUserCommand == null)
                    m_addUserCommand = new RelayCommand(AddUser, (param) => CanSave);

                return m_addUserCommand;
            }
        }

        /// <summary>
        /// Gets <see cref="ICommand"/> to remove users from role operation.
        /// </summary>
        public ICommand RemoveUserCommand
        {
            get
            {
                if (m_removeUserCommand == null)
                    m_removeUserCommand = new RelayCommand(RemoveUser, (param) => CanSave);

                return m_removeUserCommand;
            }
        }

        /// <summary>
        /// Gets <see cref="ICommand"/> for add groups to role operation.
        /// </summary>
        public ICommand AddGroupCommand
        {
            get
            {
                if (m_addGroupCommand == null)
                    m_addGroupCommand = new RelayCommand(AddGroup, (param) => CanSave);

                return m_addGroupCommand;
            }
        }

        /// <summary>
        /// Gets <see cref="ICommand"/> to remove groups from role operation.
        /// </summary>
        public ICommand RemoveGroupCommand
        {
            get
            {
                if (m_removeGroupCommand == null)
                    m_removeGroupCommand = new RelayCommand(RemoveGroup, (param) => CanSave);

                return m_removeGroupCommand;
            }
        }

        #endregion

        #region [ Constructor ]

        /// <summary>
        /// Creates an instance of <see cref="ApplicationRoles"/> class.
        /// </summary>
        /// <param name="itemsPerPage">Integer value to determine number of items per page.</param>
        /// <param name="autoSave">Boolean value to determine is user changes should be saved automatically.</param>
        public ApplicationRoles(int itemsPerPage, bool autoSave = true)
            : base(itemsPerPage, autoSave)
        {
        }

        #endregion

        #region [ Methods ]

        /// <summary>
        /// Gets the primary key value of the <see cref="PagedViewModelBase{T1, T2}.CurrentItem"/>.
        /// </summary>
        /// <returns>The primary key value of the <see cref="PagedViewModelBase{T1, T2}.CurrentItem"/>.</returns>
        public override Guid GetCurrentItemKey()
        {
            return CurrentItem.ID;
        }

        /// <summary>
        /// Gets the string based named identifier of the <see cref="PagedViewModelBase{T1, T2}.CurrentItem"/>.
        /// </summary>
        /// <returns>The string based named identifier of the <see cref="PagedViewModelBase{T1, T2}.CurrentItem"/>.</returns>
        public override string GetCurrentItemName()
        {
            return CurrentItem.Name;
        }

        /// <summary>
        /// Handles <see cref="AddUserCommand"/>.
        /// </summary>
        /// <param name="parameter">Collection of users to be added to <see cref="SecurityGroup"/>.</param>
        private void AddUser(object parameter)
        {
            ObservableCollection<object> usersToBeAdded = (ObservableCollection<object>)parameter;

            if (usersToBeAdded.Count > 0)
            {
                List<Guid> userIDs = new List<Guid>();

                foreach (object item in usersToBeAdded)
                    userIDs.Add(((KeyValuePair<Guid, string>)item).Key);

                string result = ApplicationRole.AddUsers(null, CurrentItem.ID, userIDs);

                Popup(result, "Add Role Users", MessageBoxImage.Information);

                CurrentItem.CurrentUsers = ApplicationRole.GetCurrentUsers(null, CurrentItem.ID);
                CurrentItem.PossibleUsers = ApplicationRole.GetPossibleUsers(null, CurrentItem.ID);
            }
        }

        /// <summary>
        /// Handles <see cref="RemoveUserCommand"/>.
        /// </summary>
        /// <param name="parameter">Collection of users to be removed from <see cref="SecurityGroup"/>.</param>
        private void RemoveUser(object parameter)
        {
            ObservableCollection<object> usersToBeRemoved = (ObservableCollection<object>)parameter;

            if (usersToBeRemoved.Count > 0)
            {
                List<Guid> userIDs = new List<Guid>();

                foreach (object item in usersToBeRemoved)
                    userIDs.Add(((KeyValuePair<Guid, string>)item).Key);

                string result = ApplicationRole.RemoveUsers(null, CurrentItem.ID, userIDs);

                Popup(result, "Remove Role Users", MessageBoxImage.Information);

                CurrentItem.CurrentUsers = ApplicationRole.GetCurrentUsers(null, CurrentItem.ID);
                CurrentItem.PossibleUsers = ApplicationRole.GetPossibleUsers(null, CurrentItem.ID);
            }
        }

        private void AddGroup(object parameter)
        {
            ObservableCollection<object> groupsToBeAdded = (ObservableCollection<object>)parameter;

            if (groupsToBeAdded.Count > 0)
            {
                List<Guid> groupIDs = new List<Guid>();

                foreach (object item in groupsToBeAdded)
                    groupIDs.Add(((KeyValuePair<Guid, string>)item).Key);

                string result = ApplicationRole.AddGroups(null, CurrentItem.ID, groupIDs);

                Popup(result, "Add Role Groups", MessageBoxImage.Information);

                CurrentItem.CurrentGroups = ApplicationRole.GetCurrentGroups(null, CurrentItem.ID);
                CurrentItem.PossibleGroups = ApplicationRole.GetPossibleGroups(null, CurrentItem.ID);
            }
        }

        private void RemoveGroup(object parameter)
        {
            ObservableCollection<object> groupsToBeRemoved = (ObservableCollection<object>)parameter;

            if (groupsToBeRemoved.Count > 0)
            {
                List<Guid> groupIDs = new List<Guid>();

                foreach (object item in groupsToBeRemoved)
                    groupIDs.Add(((KeyValuePair<Guid, string>)item).Key);

                string result = ApplicationRole.RemoveGroups(null, CurrentItem.ID, groupIDs);

                Popup(result, "Remove Role Groups", MessageBoxImage.Information);

                CurrentItem.CurrentGroups = ApplicationRole.GetCurrentGroups(null, CurrentItem.ID);
                CurrentItem.PossibleGroups = ApplicationRole.GetPossibleGroups(null, CurrentItem.ID);
            }
        }

        #endregion
    }
}
