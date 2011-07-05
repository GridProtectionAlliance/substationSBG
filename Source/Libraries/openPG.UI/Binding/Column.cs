﻿//******************************************************************************************************
//  Column.cs - Gbtc
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
//  04/12/2011 - mthakkar
//       Generated original version of source code.
//
//******************************************************************************************************

using System.Windows.Data;

namespace openPG.UI.Binding
{
    /// <summary>
    /// Represents a custom <see cref="Binding"/> class.
    /// </summary>
    public class Column : System.Windows.Data.Binding
    {
        #region [ Constructor ]

        /// <summary>
        /// Creates a new instance of <see cref="Column"/> class.
        /// </summary>
        public Column()
        {
            ValidatesOnDataErrors = true;
            ValidatesOnExceptions = true;
            Mode = BindingMode.TwoWay;
            UpdateSourceTrigger = UpdateSourceTrigger.PropertyChanged;
            BindingGroupName = "input";
            NotifyOnSourceUpdated = true;
            NotifyOnTargetUpdated = true;
        }

        #endregion
    }
}
