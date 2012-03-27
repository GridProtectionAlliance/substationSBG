﻿//******************************************************************************************************
//  HomeUserControl.xaml.cs - Gbtc
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
//  07/27/2011 - Mehulbhai P Thakkar
//       Generated original version of source code.
// 1/24/2011 - Aniket Salver
//             Added Current Configuration group, System health and also ChartPlotter.
//
//******************************************************************************************************

using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Threading;
using System.Xml;
using System.Xml.Serialization;
using Microsoft.Research.DynamicDataDisplay;
using Microsoft.Research.DynamicDataDisplay.Charts;
using Microsoft.Research.DynamicDataDisplay.DataSources;
using openPDC.UI.DataModels;
using TimeSeriesFramework;
using TimeSeriesFramework.Transport;
using TimeSeriesFramework.UI;
using TVA;
using TVA.Configuration;
using TVA.Data;
using TVA.IO;
using TVA.Reflection;
using TVA.ServiceProcess;


namespace openPG.UI.UserControls
{
    /// <summary>
    /// Interaction logic for HomeUserControl.xaml
    /// </summary>
    public partial class HomeUserControl : UserControl
    {
        #region [ Members ]

        // Fields
        private ObservableCollection<MenuDataItem> m_menuDataItems;
        private WindowsServiceClient m_windowsServiceClient = null;
        private DispatcherTimer m_refreshTimer;

        // Subscription Fields
        private DataSubscriber m_unsynchronizedSubscriber;
        private bool m_subscribedUnsynchronized;
        private string m_signalID;
        private int m_processingUnsynchronizedMeasurements = 0;
        private double m_refreshInterval = 0.25;
        private bool m_restartConnectionCycle = true;
        private int[] m_xAxisDataCollection;                                // Source data for the binding collection.
        private EnumerableDataSource<int> m_xAxisBindingCollection;         // Values plotted on X-Axis.        
        private ConcurrentQueue<double> m_yAxisDataCollection;              // Source data for the binding collection. Format is <signalID, collection of values from subscription API>.
        private EnumerableDataSource<double> m_yAxisBindingCollection;      // Values plotted on Y-Axis.
        private LineGraph m_lineGraph;
        private int m_numberOfPointsToPlot = 60;
        private bool m_eventHandlerRegistered = false;

        #endregion

        #region [ Constructors ]

        /// <summary>
        /// Creates an instance of <see cref="HomeUserControl"/>.
        /// </summary>
        public HomeUserControl()
        {
            InitializeComponent();
            this.Loaded += new RoutedEventHandler(HomeUserControl_Loaded);
            this.Unloaded += new RoutedEventHandler(HomeUserControl_Unloaded);

            // Load Menu
            XmlRootAttribute xmlRootAttribute = new XmlRootAttribute("MenuDataItems");
            XmlSerializer serializer = new XmlSerializer(typeof(ObservableCollection<MenuDataItem>), xmlRootAttribute);

            using (XmlReader reader = XmlReader.Create(FilePath.GetAbsolutePath("Menu.xml")))
            {
                m_menuDataItems = (ObservableCollection<MenuDataItem>)serializer.Deserialize(reader);
            }
        }


        #endregion

        #region [ Methods ]

        private void HomeUserControl_Unloaded(object sender, RoutedEventArgs e)
        {
            try
            {
                if (m_windowsServiceClient != null && m_windowsServiceClient.Helper != null)
                {
                    m_windowsServiceClient.Helper.ReceivedServiceResponse -= Helper_ReceivedServiceResponse;
                }

                if (m_refreshTimer != null)
                    m_refreshTimer.Stop();

                UnsubscribeUnsynchronizedData();
            }
            finally
            {
                m_refreshTimer = null;
                m_unsynchronizedSubscriber = null;
            }
        }

        private void HomeUserControl_Loaded(object sender, RoutedEventArgs e)
        {
            // if (!CommonFunctions.CurrentPrincipal.IsInRole("Administrator"))
            //ButtonRestart.IsEnabled = false;

            // if (!CommonFunctions.CurrentPrincipal.IsInRole("Administrator,Editor"))
            //ButtonInputWizard.IsEnabled = false;

            m_windowsServiceClient = CommonFunctions.GetWindowsServiceClient();

            if (m_windowsServiceClient == null || m_windowsServiceClient.Helper.RemotingClient.CurrentState != TVA.Communication.ClientState.Connected)
            {
                //ButtonRestart.IsEnabled = false;
            }
            else
            {
                m_windowsServiceClient.Helper.ReceivedServiceResponse += new EventHandler<EventArgs<ServiceResponse>>(Helper_ReceivedServiceResponse);
                CommonFunctions.SendCommandToService("Health -actionable");
                CommonFunctions.SendCommandToService("Version -actionable");
                CommonFunctions.SendCommandToService("Status -actionable");
                CommonFunctions.SendCommandToService("Time -actionable");
                m_eventHandlerRegistered = true;
            }

            m_refreshTimer = new DispatcherTimer();
            m_refreshTimer.Interval = TimeSpan.FromSeconds(10);
            m_refreshTimer.Tick += new EventHandler(m_refreshTimer_Tick);
            m_refreshTimer.Start();

            if (IntPtr.Size == 8)
                TextBlockInstance.Text = "64-bit";
            else
                TextBlockInstance.Text = "32-bit";

            TextBlockLocalTime.Text = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff");

            Version appVersion = AssemblyInfo.EntryAssembly.Version;
            TextBlockManagerVersion.Text = appVersion.Major + "." + appVersion.Minor + "." + appVersion.Build + ".0";

            using (AdoDataConnection database = new AdoDataConnection(CommonFunctions.DefaultSettingsCategory))
            {
                TextBlockDatabaseType.Text = database.DatabaseType.ToString();

                if (database.DatabaseType == DatabaseType.SQLite || database.DatabaseType == DatabaseType.Access)
                {
                    try
                    {
                        // Extract database file name from connection string for file centric databases
                        TextBlockDatabaseName.Text = FilePath.GetFileName(ConfigurationFile.Current.Settings[CommonFunctions.DefaultSettingsCategory]["ConnectionString"].Value.ParseKeyValuePairs()["Data Source"]);
                    }
                    catch
                    {
                        // Fall back on database name if file name extraction fails
                        TextBlockDatabaseName.Text = database.Connection.Database;
                    }
                }
                else
                {
                    TextBlockDatabaseName.Text = database.Connection.Database;
                }
            }

            TextBlockUser.Text = CommonFunctions.CurrentUser;

            ((HorizontalAxis)ChartPlotterDynamic.MainHorizontalAxis).LabelProvider.LabelStringFormat = "";

            //Remove legend on the right.
            Panel legendParent = (Panel)ChartPlotterDynamic.Legend.ContentGrid.Parent;
            if (legendParent != null)
                legendParent.Children.Remove(ChartPlotterDynamic.Legend.ContentGrid);

            ChartPlotterDynamic.NewLegendVisible = false;

            m_xAxisDataCollection = new int[m_numberOfPointsToPlot];
            for (int i = 0; i < m_numberOfPointsToPlot; i++)
                m_xAxisDataCollection[i] = i;
            m_xAxisBindingCollection = new EnumerableDataSource<int>(m_xAxisDataCollection);
            m_xAxisBindingCollection.SetXMapping(x => x);

            ComboBoxDevice.ItemsSource = Device.GetLookupList(null);
            if (ComboBoxDevice.Items.Count > 0)
                ComboBoxDevice.SelectedIndex = 0;
        }

        void m_refreshTimer_Tick(object sender, EventArgs e)
        {
            if (m_windowsServiceClient != null && m_windowsServiceClient.Helper != null &&
                   m_windowsServiceClient.Helper.RemotingClient != null && m_windowsServiceClient.Helper.RemotingClient.CurrentState == TVA.Communication.ClientState.Connected)
            {
                try
                {

                    if (!m_eventHandlerRegistered)
                    {
                        m_windowsServiceClient.Helper.ReceivedServiceResponse += new EventHandler<EventArgs<ServiceResponse>>(Helper_ReceivedServiceResponse);
                        CommonFunctions.SendCommandToService("Version -actionable");
                    }

                    CommonFunctions.SendCommandToService("Health -actionable");
                    CommonFunctions.SendCommandToService("Time -actionable");
                    if (PopupStatus.IsOpen)
                        CommonFunctions.SendCommandToService("Status -actionable");
                }
                catch
                {
                }
            }
            TextBlockLocalTime.Text = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff");
        }

        //private void ButtonQuickLink_Click(object sender, RoutedEventArgs e)
        //{
        //    MenuDataItem item = new MenuDataItem();
        //    string stringToMatch = ((Button)sender).Tag.ToString();

        //    if (!string.IsNullOrEmpty(stringToMatch))
        //    {
        //        if (stringToMatch == "Restart")
        //        {
        //            RestartService();
        //        }
        //        else
        //        {
        //            GetMenuDataItem(m_menuDataItems, stringToMatch, ref item);

        //            if (item.MenuText != null)
        //            {
        //                item.Command.Execute(null);
        //            }
        //        }
        //    }
        //}

        /// <summary>
        /// Recursively finds menu item to navigate to when a button is clicked on the UI.
        /// </summary>
        /// <param name="items">Collection of menu items.</param>
        /// <param name="stringToMatch">Item to search for in menu items collection.</param>
        /// <param name="item">Returns a menu item.</param>
        private void GetMenuDataItem(ObservableCollection<MenuDataItem> items, string stringToMatch, ref MenuDataItem item)
        {
            for (int i = 0; i < items.Count; i++)
            {
                if (items[i].UserControlPath.ToLower() == stringToMatch.ToLower())
                {
                    item = items[i];
                    break;
                }
                else
                {
                    if (items[i].SubMenuItems.Count > 0)
                    {
                        GetMenuDataItem(items[i].SubMenuItems, stringToMatch, ref item);
                    }
                }
            }
        }

        private void RestartService()
        {
            if (MessageBox.Show("Do you want to restart openpG service?", "Restart openPG Service", MessageBoxButton.YesNo, MessageBoxImage.Question) == MessageBoxResult.Yes)
            {
                if (m_windowsServiceClient != null && m_windowsServiceClient.Helper.RemotingClient.CurrentState == TVA.Communication.ClientState.Connected)
                {
                    CommonFunctions.SendCommandToService("Restart");
                    MessageBox.Show("Successfully sent RESTART command to openPG service.", "Restart openPG Service", MessageBoxButton.OK, MessageBoxImage.Information);
                }
                else
                {
                    MessageBox.Show("Failed sent RESTART command to openPG service." + Environment.NewLine + "openPG service is either offline or disconnected.", "Restart openPG Service", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

        /// <summary>
        /// Handles ReceivedServiceResponse event.
        /// </summary>
        /// <param name="sender">Source of the event.</param>
        /// <param name="e">Event arguments.</param>
        private void Helper_ReceivedServiceResponse(object sender, EventArgs<ServiceResponse> e)
        {
            string sourceCommand;
            bool responseSuccess;

            if (ClientHelper.TryParseActionableResponse(e.Argument, out sourceCommand, out responseSuccess))
            {
                if (sourceCommand.ToLower() == "health")
                {
                    this.Dispatcher.BeginInvoke((Action)delegate()
                    {
                        TextBlockSystemHealth.Text = e.Argument.Message.TrimEnd();
                        GroupBoxSystemHealth.Header = "System Health (Last Refreshed: " + DateTime.Now.ToString("HH:mm:ss.fff") + ")";
                    });
                }
                else if (sourceCommand.ToLower() == "status")
                {
                    this.Dispatcher.BeginInvoke((Action)delegate()
                    {
                        GroupBoxStatus.Header = "System Status (Last Refreshed: " + DateTime.Now.ToString("HH:mm:ss.fff") + ")";
                        TextBlockStatus.Text = e.Argument.Message.TrimEnd();
                    });
                }
                else if (sourceCommand.ToLower() == "version")
                {
                    this.Dispatcher.BeginInvoke((Action)delegate()
                    {
                        TextBlockVersion.Text = e.Argument.Message.Substring(e.Argument.Message.ToLower().LastIndexOf("version:") + 8).Trim();
                    });
                }
                else if (sourceCommand.ToLower() == "time")
                {
                    this.Dispatcher.BeginInvoke((Action)delegate()
                    {
                        string[] times = Regex.Split(e.Argument.Message, "\r\n");
                        if (times.Count() > 0)
                        {
                            string[] currentTimes = Regex.Split(times[0], ",");
                            if (currentTimes.Count() > 0)
                                TextBlockServerTime.Text = currentTimes[0].Substring(currentTimes[0].ToLower().LastIndexOf("system time:") + 12).Trim();
                        }
                    });
                }
            }
        }

        private void ButtonStatus_Click(object sender, RoutedEventArgs e)
        {
            PopupStatus.IsOpen = true;
            if (m_windowsServiceClient != null && m_windowsServiceClient.Helper != null &&
                   m_windowsServiceClient.Helper.RemotingClient != null && m_windowsServiceClient.Helper.RemotingClient.CurrentState == TVA.Communication.ClientState.Connected)
                CommonFunctions.SendCommandToService("Status -actionable");
        }

        private void ButtonClose_Click(object sender, RoutedEventArgs e)
        {
            PopupStatus.IsOpen = false;
        }

        private void ComboBoxMeasurement_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (ComboBoxMeasurement.Items.Count > 0)
            {
                TimeSeriesFramework.UI.DataModels.Measurement selectedMeasurement = (TimeSeriesFramework.UI.DataModels.Measurement)ComboBoxMeasurement.SelectedItem;
                if (selectedMeasurement != null)
                {
                    m_signalID = selectedMeasurement.SignalID.ToString();

                    if (selectedMeasurement.SignalSuffix == "PA")
                        ChartPlotterDynamic.Visible = DataRect.Create(0, -180, m_numberOfPointsToPlot, 180);
                    else if (selectedMeasurement.SignalSuffix == "FQ")
                        ChartPlotterDynamic.Visible = DataRect.Create(0, Convert.ToDouble(IsolatedStorageManager.ReadFromIsolatedStorage("FrequencyRangeMin")), m_numberOfPointsToPlot, Convert.ToDouble(IsolatedStorageManager.ReadFromIsolatedStorage("FrequencyRangeMax")));
                }
            }
            else
                m_signalID = string.Empty;

            SubscribeUnsynchronizedData();
        }

        private void ComboBoxDevice_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            ObservableCollection<TimeSeriesFramework.UI.DataModels.Measurement> measurements = TimeSeriesFramework.UI.DataModels.Measurement.Load(null, ((KeyValuePair<int, string>)ComboBoxDevice.SelectedItem).Key);
            ComboBoxMeasurement.ItemsSource = new ObservableCollection<TimeSeriesFramework.UI.DataModels.Measurement>(measurements.Where(m => m.SignalSuffix == "PA" || m.SignalSuffix == "FQ"));
            if (ComboBoxMeasurement.Items.Count > 0)
                ComboBoxMeasurement.SelectedIndex = 0;
        }

        #region [ Unsynchronized Subscription ]

        private void m_unsynchronizedSubscriber_ConnectionTerminated(object sender, EventArgs e)
        {
            m_subscribedUnsynchronized = false;
            UnsubscribeUnsynchronizedData();
            try
            {
                ChartPlotterDynamic.Dispatcher.BeginInvoke((Action)delegate()
                {
                    ChartPlotterDynamic.Children.Remove((IPlotterElement)m_lineGraph);
                });
            }
            catch
            {
            }
            if (m_restartConnectionCycle)
                InitializeUnsynchronizedSubscription();
        }

        private void m_unsynchronizedSubscriber_NewMeasurements(object sender, EventArgs<ICollection<IMeasurement>> e)
        {
            if (0 == Interlocked.Exchange(ref m_processingUnsynchronizedMeasurements, 1))
            {
                try
                {
                    foreach (IMeasurement measurement in e.Argument)
                    {
                        double tempValue = measurement.Value;

                        if (!double.IsNaN(tempValue) && !double.IsInfinity(tempValue)) // Process data only if it is not NaN or infinity.
                        {
                            ChartPlotterDynamic.Dispatcher.Invoke(DispatcherPriority.Normal, (Action)delegate()
                            {
                                if (m_yAxisDataCollection.Count == 0)
                                {
                                    for (int i = 0; i < m_numberOfPointsToPlot; i++)
                                        m_yAxisDataCollection.Enqueue(tempValue);

                                    m_yAxisBindingCollection = new EnumerableDataSource<double>(m_yAxisDataCollection);
                                    m_yAxisBindingCollection.SetYMapping(y => y);

                                    m_lineGraph = ChartPlotterDynamic.AddLineGraph(new CompositeDataSource(m_xAxisBindingCollection, m_yAxisBindingCollection), Color.FromArgb(255, 25, 25, 200), 1, "");

                                }
                                else
                                {
                                    double oldValue;
                                    if (m_yAxisDataCollection.TryDequeue(out oldValue))
                                        m_yAxisDataCollection.Enqueue(tempValue);
                                }
                                m_yAxisBindingCollection.RaiseDataChanged();
                            });
                        }
                    }
                }
                finally
                {
                    Interlocked.Exchange(ref m_processingUnsynchronizedMeasurements, 0);
                }
            }
        }

        private void m_unsynchronizedSubscriber_ConnectionEstablished(object sender, EventArgs e)
        {
            m_subscribedUnsynchronized = true;
            SubscribeUnsynchronizedData();
        }

        private void m_unsynchronizedSubscriber_ProcessException(object sender, EventArgs<Exception> e)
        {

        }

        private void m_unsynchronizedSubscriber_StatusMessage(object sender, EventArgs<string> e)
        {

        }

        private void InitializeUnsynchronizedSubscription()
        {
            try
            {
                using (AdoDataConnection database = new AdoDataConnection(CommonFunctions.DefaultSettingsCategory))
                {
                    m_unsynchronizedSubscriber = new DataSubscriber();
                    m_unsynchronizedSubscriber.StatusMessage += m_unsynchronizedSubscriber_StatusMessage;
                    m_unsynchronizedSubscriber.ProcessException += m_unsynchronizedSubscriber_ProcessException;
                    m_unsynchronizedSubscriber.ConnectionEstablished += m_unsynchronizedSubscriber_ConnectionEstablished;
                    m_unsynchronizedSubscriber.NewMeasurements += m_unsynchronizedSubscriber_NewMeasurements;
                    m_unsynchronizedSubscriber.ConnectionTerminated += m_unsynchronizedSubscriber_ConnectionTerminated;
                    m_unsynchronizedSubscriber.ConnectionString = database.DataPublisherConnectionString();
                    m_unsynchronizedSubscriber.Initialize();
                    m_unsynchronizedSubscriber.Start();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Failed to initialize subscription." + Environment.NewLine + ex.Message, "Failed to Subscribe", MessageBoxButton.OK);
            }
        }

        private void StopUnsynchronizedSubscription()
        {
            if (m_unsynchronizedSubscriber != null)
            {
                m_unsynchronizedSubscriber.StatusMessage -= m_unsynchronizedSubscriber_StatusMessage;
                m_unsynchronizedSubscriber.ProcessException -= m_unsynchronizedSubscriber_ProcessException;
                m_unsynchronizedSubscriber.ConnectionEstablished -= m_unsynchronizedSubscriber_ConnectionEstablished;
                m_unsynchronizedSubscriber.NewMeasurements -= m_unsynchronizedSubscriber_NewMeasurements;
                m_unsynchronizedSubscriber.ConnectionTerminated -= m_unsynchronizedSubscriber_ConnectionTerminated;
                m_unsynchronizedSubscriber.Stop();
                m_unsynchronizedSubscriber.Dispose();
                m_unsynchronizedSubscriber = null;
            }
        }

        private void SubscribeUnsynchronizedData()
        {
            if (m_unsynchronizedSubscriber == null)
                InitializeUnsynchronizedSubscription();
            try
            {
                ChartPlotterDynamic.Dispatcher.BeginInvoke((Action)delegate()
                {
                    ChartPlotterDynamic.Children.Remove((IPlotterElement)m_lineGraph);
                });
            }
            catch
            {
            }
            m_yAxisDataCollection = new ConcurrentQueue<double>();

            if (m_subscribedUnsynchronized && !string.IsNullOrEmpty(m_signalID))
                m_unsynchronizedSubscriber.UnsynchronizedSubscribe(true, true, m_signalID, null, true, m_refreshInterval);
        }

        /// <summary>
        /// Unsubscribes data from the service.
        /// </summary>
        public void UnsubscribeUnsynchronizedData()
        {
            try
            {
                if (m_unsynchronizedSubscriber != null)
                {
                    m_unsynchronizedSubscriber.Unsubscribe();
                    StopUnsynchronizedSubscription();
                }
            }
            catch
            {
                m_unsynchronizedSubscriber = null;
            }
        }


        /// <summary>
        /// Handles click event of the buttons on the screen.
        /// </summary>
        /// <param name="sender">Source of the event.</param>
        /// <param name="e">Event arguments.</param>
        private void CommonClickHandler(object sender, RoutedEventArgs e)
        {
            MenuDataItem item = new MenuDataItem();
            string stringToMatch = ((Button)sender).Tag.ToString();

            if (!string.IsNullOrEmpty(stringToMatch))
                GetMenuDataItem(m_menuDataItems, stringToMatch, ref item);

            if (item.MenuText != null)
            {
                item.Command.Execute(null);
            }
        }

        ///// <summary>
        ///// Recursively finds menu item to navigate to when a button is clicked on the UI.
        ///// </summary>
        ///// <param name="items">Collection of menu items.</param>
        ///// <param name="stringToMatch">Item to search for in menu items collection.</param>
        ///// <param name="item">Returns a menu item.</param>
        //private void GetMenuDataItems(ObservableCollection<MenuDataItem> items, string stringToMatch, ref MenuDataItem item)
        //{
        //    for (int i = 0; i < items.Count; i++)
        //    {
        //        if (items[i].MenuText.Replace("_", "").ToLower().Contains(stringToMatch.ToLower()))
        //        {
        //            item = items[i];
        //            break;
        //        }
        //        else
        //        {
        //            if (items[i].SubMenuItems.Count > 0)
        //            {
        //                GetMenuDataItems(items[i].SubMenuItems, stringToMatch, ref item);
        //            }
        //        }
        //    }
        //}

        #endregion

        #endregion
    }
}
