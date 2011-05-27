﻿//******************************************************************************************************
//  App.xaml.cs - Gbtc
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
//  09/07/2010 - Stephen C. Wills
//       Generated original version of source code.
//  03/02/2011 - J. Ritchie Carroll
//       Added unhandled exception logger with dialog for better end user problem diagnosis.
//
//******************************************************************************************************

using System;
using System.IO;
using System.Security.Principal;
using System.Windows;
using TVA.ErrorManagement;
using TVA.IO;
using TVA.Security.Cryptography;

namespace ConfigurationSetupUtility
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        #region [ Members ]

        // Constants
        public const CipherStrength CryptoStrength = CipherStrength.Aes256;
        public const string CipherLookupKey = "0679d9ae-aca5-4702-a3f5-604415096987";
        public const string ApplicationExe = "openPG.exe";
        public const string ApplicationConfig = "openPG.exe.config";
        public const string Manager = "TsfManager";
        public const string ManagerExe = "TsfManager.exe";
        public const string ManagerConfig = "TsfManager.exe.config";
        public const string BaseAccessConfig = "openPG.mdb";
        public const string AccessConfigv2 = "openPGv2.mdb";
        public const string AccessSampleData = "openPG-SampleDataSet.mdb";
        public const string AccessInitialData = "openPG-InitialDataSet.mdb";
        private ErrorLogger m_errorLogger;
        private Func<string> m_defaultErrorText;

        #endregion

        #region [ Constructors ]

        public App()
        {
            AppDomain.CurrentDomain.SetPrincipalPolicy(PrincipalPolicy.WindowsPrincipal);

            m_errorLogger = new ErrorLogger();
            m_defaultErrorText = m_errorLogger.ErrorTextMethod;
            m_errorLogger.ErrorTextMethod = ErrorText;
            m_errorLogger.ExitOnUnhandledException = false;
            m_errorLogger.HandleUnhandledException = true;
            m_errorLogger.LogToEmail = false;
            m_errorLogger.LogToEventLog = true;
            m_errorLogger.LogToFile = true;
            m_errorLogger.LogToScreenshot = true;
            m_errorLogger.LogToUI = true;
            m_errorLogger.Initialize();

            // When run from the installer the current directory may not be the directory where this application is running
            Directory.SetCurrentDirectory(FilePath.GetAbsolutePath(""));
        }

        #endregion

        #region [ Methods ]

        private string ErrorText()
        {
            string errorMessage = m_defaultErrorText();
            Exception ex = m_errorLogger.LastException;

            if (ex != null)
            {
                if (string.Compare(ex.Message, "UnhandledException", true) == 0 && ex.InnerException != null)
                    ex = ex.InnerException;

                errorMessage = string.Format("{0}\r\n\r\nError details: {1}", errorMessage, ex.Message);
            }

            return errorMessage;
        }

        #endregion
    }
}
