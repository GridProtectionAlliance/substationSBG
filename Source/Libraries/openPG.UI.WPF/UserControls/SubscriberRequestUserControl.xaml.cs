﻿//******************************************************************************************************
//  SubscriberRequestUserControl.xaml.cs - Gbtc
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
//  05/18/2011 - Magdiel Lorenzo
//       Generated original version of source code.
//
//******************************************************************************************************

using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
using System.Windows;
using System.Windows.Controls;
using openPDC.UI.DataModels;
using TimeSeriesFramework.UI;
using TVA;
using TVA.Collections;
using TVA.Data;
using TVA.Security.Cryptography;

namespace openPG.UI.UserControls
{
    /// <summary>
    /// Interaction logic for SubscriberRequestUserControl.xaml
    /// </summary>
    public partial class SubscriberRequestUserControl : UserControl
    {
        #region [ Constructor ]

        /// <summary>
        /// Creates an instance of <see cref="SubscriberRequestUserControl"/> class.
        /// </summary>     
        public SubscriberRequestUserControl()
        {
            InitializeComponent();
            this.Loaded += SubscriberRequestUserControl_Loaded;
        }

        #endregion

        #region [ Methods ]

        /// <summary>
        /// Populates screen fields on load.
        /// </summary>
        /// <param name="sender">Source of the event.</param>
        /// <param name="e">Arguments of the event.</param>
        void SubscriberRequestUserControl_Loaded(object sender, RoutedEventArgs e)
        {
            // Connect to database to retrieve company information for current node
            AdoDataConnection database = new AdoDataConnection(CommonFunctions.DefaultSettingsCategory);
            try
            {
                string query = database.ParameterizedQueryString("SELECT Company.Acronym, Company.Name FROM Company, Node WHERE Company.ID = Node.CompanyID AND Node.ID = {0}", "id");
                DataRow row = database.Connection.RetrieveRow(database.AdapterType, query, database.CurrentNodeID());

                m_acronymField.Text = row.Field<string>("Acronym");
                m_nameField.Text = row.Field<string>("Name");

                // Generate a default shared secret password for subscriber key and initialization vector
                byte[] buffer = new byte[4];
                TVA.Security.Cryptography.Random.GetBytes(buffer);

                string generatedSecret = Convert.ToBase64String(buffer).RemoveCrLfs();

                if (generatedSecret.Contains("="))
                    generatedSecret = generatedSecret.Split('=')[0];

                m_sharedSecretField.Text = generatedSecret;

                // Generate an identity for this subscriber
                AesManaged sa = new AesManaged();
                sa.GenerateKey();
                m_authenticationIDField.Text = Convert.ToBase64String(sa.Key);

                // Generate valid local IP addresses for this connection
                IEnumerable<IPAddress> addresses = Dns.GetHostAddresses(Dns.GetHostName()).OrderBy(key => key.AddressFamily);
                m_validIpAddressesField.Text = addresses.ToDelimitedString("; ");
            }
            catch (Exception ex)
            {
                MessageBox.Show("ERROR: " + ex.Message, "Subscriber Request", MessageBoxButton.OK);
            }
            finally
            {
                if (database != null)
                    database.Dispose();
            }
        }

        /// <summary>
        /// Click Event for Export button.
        /// </summary>
        /// <param name="sender">Source of the event.</param>
        /// <param name="e">Arguments of the event</param>
        private void Button_Click(object sender, RoutedEventArgs e)
        {
            if ((bool)m_createAdapter.IsChecked)
            {
                Device device = Device.GetDevice(null, " WHERE Acronym = '" + m_acronymField.Text.Replace(" ", "") + "'");
                bool continueSave = true;

                if (device != null)
                {
                    if (MessageBox.Show(string.Format("Data subscription adapter \"{0}\" already exists. Do you want to update the existing adapter with the new keys?", device.Acronym), "Create Subscription Request", MessageBoxButton.YesNo) == MessageBoxResult.Yes)
                        continueSave = true;
                    else
                        continueSave = false;
                }

                if (continueSave)
                {
                    if (device == null)
                    {
                        device = new Device();
                        device.Enabled = false;
                        device.IsConcentrator = true;
                        device.ProtocolID = 8;
                        device.ConnectionString = "port=9500; interface=0.0.0.0; compression=false; autoConnect=true; commandChannel={server=127.0.0.1:6170; interface=0.0.0.0}";
                    }

                    device.Acronym = m_acronymField.Text.Replace(" ", "");
                    device.Name = m_nameField.Text;
                    Device.Save(null, device);
                }
            }

            if (string.IsNullOrWhiteSpace(m_keyField.Text) && string.IsNullOrWhiteSpace(m_ivField.Text))
                m_generateButton_Click(this, null);

            string filename = "";

            System.Windows.Forms.SaveFileDialog saveFileDialog = new System.Windows.Forms.SaveFileDialog();

            saveFileDialog.Filter = "XML Files (*.xml)|*.xml|All Files (*.*)|*.*";
            saveFileDialog.DefaultExt = ".xml";
            System.Windows.Forms.DialogResult res = saveFileDialog.ShowDialog();
            if (res != System.Windows.Forms.DialogResult.Cancel)
            {
                filename = saveFileDialog.FileName;
                AuthenticationRequest request = new AuthenticationRequest();

                request.Acronym = m_acronymField.Text;
                request.Name = m_nameField.Text;
                request.SharedSecret = m_sharedSecretField.Text;
                request.AuthenticationID = m_authenticationIDField.Text;
                request.Key = m_keyField.Text;
                request.IV = m_ivField.Text;
                request.ValidIPAddresses = m_validIpAddressesField.Text;

                File.WriteAllBytes(filename, Serialization.Serialize(request, TVA.SerializationFormat.Xml));
            }
            else
            {
                e.Handled = true;
            }
        }

        /// <summary>
        /// Click Event for Generate button.
        /// </summary>
        /// <param name="sender">Source of the event.</param>
        /// <param name="e">Arguments of the event.</param>
        private void m_generateButton_Click(object sender, RoutedEventArgs e)
        {
            string keyIV = Cipher.ExportKeyIV(m_sharedSecretField.Text, 256);
            string[] parts = keyIV.Split('|');
            m_keyField.Text = parts[0];
            m_ivField.Text = parts[1];
        }

        #endregion
    }
}
