﻿//******************************************************************************************************
//  SqlServerDatabaseSetupScreen.xaml.cs - Gbtc
//
//  Copyright © 2011, Grid Protection Alliance.  All Rights Reserved.
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
//  09/09/2010 - Stephen C. Wills
//       Generated original version of source code.
//  01/21/2011 - J. Ritchie Carroll
//       Modified next page to be admin user account credentials setup.
//
//******************************************************************************************************

using System;
using System.Collections.Generic;
using System.Data;
using System.Reflection;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using TVA;
using TVA.Data;

namespace ConfigurationSetupUtility.Screens
{
    /// <summary>
    /// Interaction logic for SqlServerDatabaseSetupScreen.xaml
    /// </summary>
    public partial class SqlServerDatabaseSetupScreen : UserControl, IScreen
    {
        #region [ Members ]

        // Fields
        private SqlServerSetup m_sqlServerSetup;
        private Dictionary<string, object> m_state;
        private Button m_advancedButton;

        #endregion

        #region [ Constructors ]

        /// <summary>
        /// Creates a new instance of the <see cref="SqlServerDatabaseSetupScreen"/> class.
        /// </summary>
        public SqlServerDatabaseSetupScreen()
        {
            m_sqlServerSetup = new SqlServerSetup();
            InitializeComponent();
            this.Loaded += new RoutedEventHandler(SqlServerDatabaseSetupScreen_Loaded);
        }

        #endregion

        #region [ Properties ]

        /// <summary>
        /// Gets the screen to be displayed when the user clicks the "Next" button.
        /// </summary>
        public IScreen NextScreen
        {
            get
            {
                IScreen nextScreen;
                bool securityUpgrade = false;

                if (m_state.ContainsKey("securityUpgrade"))
                    securityUpgrade = Convert.ToBoolean(m_state["securityUpgrade"]);

                if (Convert.ToBoolean(m_state["existing"]) && !securityUpgrade)
                {
                    if (!m_state.ContainsKey("applyChangesScreen"))
                        m_state.Add("applyChangesScreen", new ApplyConfigurationChangesScreen());

                    nextScreen = m_state["applyChangesScreen"] as IScreen;
                }
                else
                {
                    if (!m_state.ContainsKey("userAccountSetupScreen"))
                        m_state.Add("userAccountSetupScreen", new UserAccountCredentialsSetupScreen());

                    nextScreen = m_state["userAccountSetupScreen"] as IScreen;
                }

                return nextScreen;
            }
        }

        /// <summary>
        /// Gets a boolean indicating whether the user can advance to
        /// the next screen from the current screen.
        /// </summary>
        public bool CanGoForward
        {
            get
            {
                return true;
            }
        }

        /// <summary>
        /// Gets a boolean indicating whether the user can return to
        /// the previous screen from the current screen.
        /// </summary>
        public bool CanGoBack
        {
            get
            {
                return true;
            }
        }

        /// <summary>
        /// Gets a boolean indicating whether the user can cancel the
        /// setup process from the current screen.
        /// </summary>
        public bool CanCancel
        {
            get
            {
                return true;
            }
        }

        /// <summary>
        /// Gets a boolean indicating whether the user input is valid on the current page.
        /// </summary>
        public bool UserInputIsValid
        {
            get
            {
                if (string.IsNullOrEmpty(m_hostNameTextBox.Text))
                {
                    MessageBox.Show("Please enter a valid host name for the SQL Server instance.");
                    m_hostNameTextBox.Focus();
                    return false;
                }

                if (string.IsNullOrEmpty(m_databaseNameTextBox.Text))
                {
                    MessageBox.Show("Please enter a valid database name.");
                    m_databaseNameTextBox.Focus();
                    return false;
                }

                if (m_createNewUserCheckBox.IsChecked.Value && string.IsNullOrEmpty(m_newUserNameTextBox.Text))
                {
                    MessageBox.Show("Please enter a valid user name for the new user.");
                    m_newUserNameTextBox.Focus();
                    return false;
                }

                bool existing = Convert.ToBoolean(m_state["existing"]);
                bool migrate = existing && Convert.ToBoolean(m_state["updateConfiguration"]);

                if (existing && !migrate)
                {
                    IDbConnection connection = null;

                    try
                    {
                        OpenConnection(ref connection);
                        if ((int)connection.ExecuteScalar("SELECT COUNT(*) FROM UserAccount") > 0)
                            m_state["securityUpgrade"] = false;
                        else
                            m_state["securityUpgrade"] = true;
                    }
                    catch (Exception ex)
                    {
                        string failMessage = "Database connection issue. " + ex.Message +
                        " Check your username and password." +
                        " Additionally, you may need to modify your connection under advanced settings.";

                        MessageBox.Show(failMessage);
                        m_newUserNameTextBox.Focus();
                        return false;
                    }
                    finally
                    {
                        if (connection != null)
                            connection.Dispose();
                    }
                }

                return true;
            }
        }

        /// <summary>
        /// Collection shared among screens that represents the state of the setup.
        /// </summary>
        public Dictionary<string, object> State
        {
            get
            {
                return m_state;
            }
            set
            {
                m_state = value;
                InitializeState();
            }
        }

        /// <summary>
        /// Allows the screen to update the navigation buttons after a change is made
        /// that would affect the user's ability to navigate to other screens.
        /// </summary>
        public Action UpdateNavigation
        {
            get;
            set;
        }

        #endregion

        #region [ Methods ]

        // Set focus on the admin user name textbox onload.
        private void SqlServerDatabaseSetupScreen_Loaded(object sender, RoutedEventArgs e)
        {
            if (string.IsNullOrEmpty(m_adminUserNameTextBox.Text))
                m_adminUserNameTextBox.Focus();
            else if (string.IsNullOrEmpty(m_adminPasswordTextBox.Password))
                m_adminPasswordTextBox.Focus();
        }

        // Initialize the state keys to their default values.
        private void InitializeState()
        {
            if (m_state != null)
            {
                bool existing = Convert.ToBoolean(m_state["existing"]);
                bool migrate = existing && Convert.ToBoolean(m_state["updateConfiguration"]);
                Visibility newUserVisibility = (existing && !migrate) ? Visibility.Collapsed : Visibility.Visible;
                string newDatabaseMessage = "Please enter the needed information about the\r\nSQL Server database you would like to create.";
                string oldDatabaseMessage = "Please enter the needed information about\r\nyour existing SQL Server database.";

                m_state["sqlServerSetup"] = m_sqlServerSetup;
                m_sqlServerSetup.HostName = m_hostNameTextBox.Text;
                m_sqlServerSetup.DatabaseName = m_databaseNameTextBox.Text;
                m_createNewUserCheckBox.Visibility = newUserVisibility;
                m_newUserNameLabel.Visibility = newUserVisibility;
                m_newUserPasswordLabel.Visibility = newUserVisibility;
                m_newUserNameTextBox.Visibility = newUserVisibility;
                m_newUserPasswordTextBox.Visibility = newUserVisibility;
                m_sqlServerDatabaseInstructionTextBlock.Text = (!existing || migrate) ? newDatabaseMessage : oldDatabaseMessage;

                // If connecting to existing database, user name and password need not be admin user:
                if (existing && !migrate)
                {
                    m_userNameLabel.Content = "User name:";
                    m_passwordLabel.Content = "Password:";
                }
                else
                {
                    m_userNameLabel.Content = "Admin user name:";
                    m_passwordLabel.Content = "Admin password:";
                }

                if (!m_state.ContainsKey("sqlServerDataProviderString"))
                    m_state.Add("sqlServerDataProviderString", "AssemblyName={System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089}; ConnectionType=System.Data.SqlClient.SqlConnection; AdapterType=System.Data.SqlClient.SqlDataAdapter");

                if (!m_state.ContainsKey("createNewSqlServerUser"))
                    m_state.Add("createNewSqlServerUser", m_createNewUserCheckBox.IsChecked.Value);

                if (!m_state.ContainsKey("newSqlServerUserName"))
                    m_state.Add("newSqlServerUserName", m_newUserNameTextBox.Text);

                if (!m_state.ContainsKey("newSqlServerUserPassword"))
                    m_state.Add("newSqlServerUserPassword", m_newUserPasswordTextBox.Password);

                if (!m_state.ContainsKey("encryptSqlServerConnectionStrings"))
                    m_state.Add("encryptSqlServerConnectionStrings", false);

                if (!m_state.ContainsKey("useSqlServerIntegratedSecurity"))
                    m_state.Add("useSqlServerIntegratedSecurity", false);

                m_databaseNameTextBox.Text = migrate ? "openPGv2" : "openPG";
            }
        }

        // Occurs when the screen is made visible or invisible.
        private void SqlServerDatabaseSetupScreen_IsVisibleChanged(object sender, DependencyPropertyChangedEventArgs e)
        {
            if (m_advancedButton == null)
            {
                DependencyObject parent = VisualTreeHelper.GetParent(this);
                Window mainWindow;

                while (parent != null && !(parent is Window))
                    parent = VisualTreeHelper.GetParent(parent);

                mainWindow = parent as Window;
                m_advancedButton = (mainWindow == null) ? null : mainWindow.FindName("m_advancedButton") as Button;
            }

            if (m_advancedButton != null)
            {
                if (IsVisible)
                {
                    m_advancedButton.Visibility = Visibility.Visible;
                    m_advancedButton.Click += AdvancedButton_Click;
                }
                else
                {
                    m_advancedButton.Visibility = Visibility.Collapsed;
                    m_advancedButton.Click -= AdvancedButton_Click;
                }
            }
        }

        // Occurs when the user changes the host name of the SQL Server instance.
        private void HostNameTextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            m_hostNameTextBox.Text = m_hostNameTextBox.Text.Trim();
            m_sqlServerSetup.HostName = m_hostNameTextBox.Text;
        }

        // Occurs when the user changes the name of the database.
        private void DatabaseNameTextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            m_sqlServerSetup.DatabaseName = m_databaseNameTextBox.Text;
        }

        // Occurs when the user changes the administrator user name.
        private void AdminUserNameTextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            string adminUserName = m_adminUserNameTextBox.Text;
            m_sqlServerSetup.UserName = adminUserName;
        }

        // Occurs when the user changes the administrator password.
        private void AdminPasswordTextBox_PasswordChanged(object sender, RoutedEventArgs e)
        {
            string adminPassword = m_adminPasswordTextBox.Password;
            m_sqlServerSetup.Password = adminPassword;
        }

        // Occurs when the user chooses to test their database connection.
        private void TestConnectionButton_Click(object sender, RoutedEventArgs e)
        {
            IDbConnection connection = null;
            string databaseName = null;

            try
            {
                databaseName = m_sqlServerSetup.DatabaseName;
                m_sqlServerSetup.DatabaseName = null;
                OpenConnection(ref connection);
                MessageBox.Show("Database connection succeeded.");
            }
            catch
            {
                string failMessage = "Database connection failed."
                    + " Please check your username and password."
                    + " Additionally, you may need to modify your connection under advanced settings.";

                MessageBox.Show(failMessage);
            }
            finally
            {
                if (connection != null)
                    connection.Dispose();

                if (databaseName != null)
                    m_sqlServerSetup.DatabaseName = databaseName;
            }
        }

        private void OpenConnection(ref IDbConnection connection)
        {
            Dictionary<string, string> settings;
            string assemblyName, connectionTypeName, adapterTypeName;
            Assembly assembly;
            Type connectionType, adapterType;
            string dataProviderString;
            bool useIntegratedSecurity = false;

            dataProviderString = m_state["sqlServerDataProviderString"].ToString();
            settings = dataProviderString.ParseKeyValuePairs();
            assemblyName = settings["AssemblyName"].ToNonNullString();
            connectionTypeName = settings["ConnectionType"].ToNonNullString();
            adapterTypeName = settings["AdapterType"].ToNonNullString();

            if (string.IsNullOrEmpty(connectionTypeName))
                throw new InvalidOperationException("Database connection type was not defined.");

            if (string.IsNullOrEmpty(adapterTypeName))
                throw new InvalidOperationException("Database adapter type was not defined.");

            assembly = Assembly.Load(new AssemblyName(assemblyName));
            connectionType = assembly.GetType(connectionTypeName);
            adapterType = assembly.GetType(adapterTypeName);

            connection = (IDbConnection)Activator.CreateInstance(connectionType);

            if (m_state.ContainsKey("useSqlServerIntegratedSecurity"))
                useIntegratedSecurity = Convert.ToBoolean(m_state["useSqlServerIntegratedSecurity"]);

            // Force use of non-pooled connection string such that database can later be deleted if needed
            if (useIntegratedSecurity)
                connection.ConnectionString = m_sqlServerSetup.IntegratedSecurityConnectionString + "; pooling=false";
            else
                connection.ConnectionString = m_sqlServerSetup.PooledConnectionString + "; pooling=false";

            connection.Open();
        }

        // Occurs when the user chooses to create a new database user.
        private void CreateNewUserCheckBox_Checked(object sender, RoutedEventArgs e)
        {
            if (m_state != null)
                m_state["createNewSqlServerUser"] = true;
        }

        // Occurs when the user chooses not to create a new database user.
        private void CreateNewUserCheckBox_Unchecked(object sender, RoutedEventArgs e)
        {
            if (m_state != null)
                m_state["createNewSqlServerUser"] = false;
        }

        // Occurs when the user chooses to use pass-through authentication.
        private void UseIntegratedSecurity_Checked(object sender, RoutedEventArgs e)
        {
            if (m_state != null)
                m_state["useSqlServerIntegratedSecurity"] = true;

            m_userNameLabel.IsEnabled = false;
            m_passwordLabel.IsEnabled = false;
            m_adminUserNameTextBox.Text = "";
            m_adminPasswordTextBox.Password = "";
            m_adminUserNameTextBox.IsEnabled = false;
            m_adminPasswordTextBox.IsEnabled = false;
        }

        // Occurs when the user chooses to not use pass-through authentication.
        private void UseIntegratedSecurity_Unchecked(object sender, RoutedEventArgs e)
        {
            if (m_state != null)
                m_state["useSqlServerIntegratedSecurity"] = false;

            m_userNameLabel.IsEnabled = true;
            m_passwordLabel.IsEnabled = true;
            m_adminUserNameTextBox.IsEnabled = true;
            m_adminPasswordTextBox.IsEnabled = true;
        }

        // Occurs when the user changes the user name of the new database user.
        private void NewUserNameTextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (m_state != null)
                m_state["newSqlServerUserName"] = m_newUserNameTextBox.Text;
        }

        // Occurs when the user changes the password of the new database user.
        private void NewUserPasswordTextBox_PasswordChanged(object sender, RoutedEventArgs e)
        {
            if (m_state != null)
                m_state["newSqlServerUserPassword"] = m_newUserPasswordTextBox.Password;
        }

        // Occurs when the user clicks the "Advanced..." button.
        private void AdvancedButton_Click(object sender, RoutedEventArgs e)
        {
            if (m_state != null)
            {
                string password = m_sqlServerSetup.Password;
                string dataProviderString = m_state["sqlServerDataProviderString"].ToString();
                bool encrypt = Convert.ToBoolean(m_state["encryptSqlServerConnectionStrings"]);
                bool useIntegratedSecurity = false;
                string connectionString;
                AdvancedSettingsWindow advancedWindow;

                m_sqlServerSetup.Password = null;

                if (m_state.ContainsKey("useSqlServerIntegratedSecurity"))
                    useIntegratedSecurity = Convert.ToBoolean(m_state["useSqlServerIntegratedSecurity"]);

                if (useIntegratedSecurity)
                    connectionString = m_sqlServerSetup.IntegratedSecurityConnectionString;
                else
                    connectionString = m_sqlServerSetup.PooledConnectionString;

                advancedWindow = new AdvancedSettingsWindow(connectionString, dataProviderString, encrypt);
                advancedWindow.Owner = App.Current.MainWindow;

                if (advancedWindow.ShowDialog() == true)
                {
                    // Force use of non-pooled connection string such that database can later be deleted if needed
                    Dictionary<string, string> settings = advancedWindow.ConnectionString.ParseKeyValuePairs();
                    settings.Remove("Integrated Security");
                    m_sqlServerSetup.ConnectionString = settings.JoinKeyValuePairs() + "; pooling=false";
                    m_state["sqlServerDataProviderString"] = advancedWindow.DataProviderString;
                    m_state["encryptSqlServerConnectionStrings"] = advancedWindow.Encrypt;
                }

                if (string.IsNullOrEmpty(m_sqlServerSetup.Password))
                    m_sqlServerSetup.Password = password;

                m_hostNameTextBox.Text = m_sqlServerSetup.HostName;
                m_databaseNameTextBox.Text = m_sqlServerSetup.DatabaseName;
                m_adminUserNameTextBox.Text = m_sqlServerSetup.UserName;
                m_adminPasswordTextBox.Password = m_sqlServerSetup.Password;
            }
        }

        #endregion
    }
}
