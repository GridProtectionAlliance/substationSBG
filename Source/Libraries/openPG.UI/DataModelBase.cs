﻿//******************************************************************************************************
//  DataModelBase.cs - Gbtc
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
//  03/25/2011 - Mehulbhai P Thakkar
//       Generated original version of source code.
//  04/08/2011 - J. Ritchie Carroll
//       Modified class to use reflection to load default values and use entity property attributes.
//
//******************************************************************************************************

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Reflection;
using System.Windows;
using TVA;
using TVA.Collections;
using TVA.Data;
using TVA.Reflection;

namespace openPG.UI
{
    /// <summary>
    /// Represents an abstract base class for all entity model objects.
    /// </summary>
    public abstract class DataModelBase : IDataModel
    {
        #region [ Members ]

        // Constants

        /// <summary>
        /// The default timeout duration used for executing SQL statements.
        /// </summary>
        public const int DefaultTimeout = DataExtensions.DefaultTimeoutDuration;

        // Events

        /// <summary>
        /// Raised when a property on this object has a new value.
        /// </summary>
        public event PropertyChangedEventHandler PropertyChanged;

        // Fields
        private Dictionary<string, string> m_propertyErrors;
        private BindingFlags m_memberAccessBindingFlags;
        private bool m_requireEntityPropertyAttribute;
        private bool m_lastIsValidState;

        #endregion

        #region [ Constructors ]

        /// <summary>
        /// Creates a new instance of the <see cref="DataModelBase"/> class.
        /// </summary>
        protected DataModelBase()
            : this(false)
        {
        }

        /// <summary>
        /// Creates a new instance of the <see cref="DataModelBase"/> class.
        /// </summary>
        /// <param name="requireEntityPropertyAttribute">
        /// Assigns flag that determines if <see cref="EntityPropertyAttribute"/> is required
        /// to exist before a property is included as a field in the data model.
        /// </param>
        protected DataModelBase(bool requireEntityPropertyAttribute)
        {
            m_propertyErrors = new Dictionary<string, string>(StringComparer.InvariantCultureIgnoreCase);
            m_memberAccessBindingFlags = BindingFlags.Public | BindingFlags.Instance | BindingFlags.DeclaredOnly;
            m_requireEntityPropertyAttribute = requireEntityPropertyAttribute;

            // Load all default values for properties
            ExecuteActionForProperties(property =>
            {
                object defaultValue = DeriveDefaultValue(property.Name, property.GetValue(this, null));

                if (!Common.IsDefaultValue(defaultValue))
                    property.SetValue(this, defaultValue, null);

                OnPropertyChanged(property.Name);

            }, BindingFlags.SetProperty);
        }

        #endregion

        #region [ Properties ]

        /// <summary>
        /// Indicates if the values associated with this object are valid.
        /// </summary>
        [EntityProperty(false)]
        public bool IsValid
        {
            get
            {
                // If any of the properties have errors, values are not valid
                m_lastIsValidState = m_propertyErrors.All(kvPair => string.IsNullOrWhiteSpace(kvPair.Value));
                return m_lastIsValidState;
            }
        }

        /// <summary>
        /// Gets an error message indicating what is wrong with this object.
        /// </summary>
        /// <remarks>
        /// An error message indicating what is wrong with this object. The default is an empty string ("").
        /// </remarks>
        [EntityProperty(false)]
        public string Error
        {
            get
            {
                // Cumulate any properties with errors using line feed as delimeter
                return m_propertyErrors.Where(kvPair => !string.IsNullOrWhiteSpace(kvPair.Value)).ToDelimitedString(Environment.NewLine);
            }
        }

        /// <summary>
        /// Gets the error message for the property with the given name.
        /// </summary>
        /// <param name="propertyName">The name of the property whose error message to get.</param>
        /// <returns>The error message for the property. The default is an empty string ("").</returns>
        public string this[string propertyName]
        {
            get
            {
                string error;

                if (!m_propertyErrors.TryGetValue(propertyName, out error))
                    error = "";

                return error;
            }
        }

        /// <summary>
        /// Gets or sets flag that determines if <see cref="EntityPropertyAttribute"/> is
        /// required to exist before a property is included as a field in the data model;
        /// defaults to <c>false</c>.
        /// </summary>
        [Browsable(false), EntityProperty(false)]
        public bool RequireEntityPropertyAttribute
        {
            get
            {
                return m_requireEntityPropertyAttribute;
            }
            set
            {
                m_requireEntityPropertyAttribute = value;
            }
        }

        /// <summary>
        /// Gets or sets <see cref="BindingFlags"/> used to access properties of dervied class.
        /// </summary>
        /// <remarks>
        /// Value defaults to <c><see cref="BindingFlags.Public"/> | <see cref="BindingFlags.Instance"/> | <see cref="BindingFlags.DeclaredOnly"/></c>.
        /// </remarks>
        [EditorBrowsable(EditorBrowsableState.Advanced), EntityProperty(false)]
        protected virtual BindingFlags MemberAccessBindingFlags
        {
            get
            {
                return m_memberAccessBindingFlags;
            }
            set
            {
                m_memberAccessBindingFlags = value;
            }
        }

        #endregion

        #region [ Methods ]

        /// <summary>
        /// Raises the <see cref="PropertyChanged"/> event.
        /// </summary>
        /// <param name="propertyName">Property name that has changed.</param>
        protected virtual void OnPropertyChanged(string propertyName)
        {
            if (PropertyChanged != null)
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));

            if (string.Compare(propertyName, "IsValid", true) != 0)
                ValidateProperty(propertyName);
        }

        /// <summary>
        /// Validates current instance properties using Data Annotations.
        /// </summary>
        /// <param name="propertyName">This instance property to validate.</param>
        /// <returns>Relevant error string on validation failure or <see cref="String.Empty"/> on validation success.</returns>
        protected virtual void ValidateProperty(string propertyName)
        {
            if (string.IsNullOrEmpty(propertyName))
                throw new ArgumentException("Invalid property name", propertyName);

            string error = "";
            object value = GetType().GetProperty(propertyName).GetValue(this, null);
            List<ValidationResult> results = new List<ValidationResult>(1);

            ValidationContext validationContext = new ValidationContext(this, null, null)
            {
                MemberName = propertyName
            };

            if (!Validator.TryValidateProperty(value, validationContext, results))
            {
                ValidationResult validationResult = results.First();
                error = validationResult.ErrorMessage;
            }

            m_propertyErrors[propertyName] = error;

            if (m_lastIsValidState != IsValid)
                OnPropertyChanged("IsValid");
        }

        /// <summary>
        /// Gets the default value specified by <see cref="DefaultValueAttribute"/>, if any, applied to the specified property. 
        /// </summary>
        /// <param name="propertyName">Property name.</param>
        /// <returns>Default value applied to specified property; or null if one does not exist.</returns>
        /// <exception cref="ArgumentException"><paramref name="propertyName"/> cannot be null or empty.</exception>
        public object GetDefaultValue(string propertyName)
        {
            if (string.IsNullOrEmpty(propertyName))
                throw new ArgumentException("name cannot be null or empty");

            return GetAttributeValue<DefaultValueAttribute, object>(propertyName, null, attribute => attribute.Value);
        }

        /// <summary>
        /// Attempts to get best default value for given member.
        /// </summary>
        /// <param name="propertyName">Property name.</param>
        /// <param name="value">Current property value.</param>
        /// <remarks>
        /// If <paramref name="value"/> is equal to its default(type) value, then any value derived from <see cref="DefaultValueAttribute"/> will be used instead.
        /// </remarks>
        /// <returns>The object that is the best default value.</returns>
        [EditorBrowsable(EditorBrowsableState.Advanced)]
        protected object DeriveDefaultValue(string propertyName, object value)
        {
            // See if value is equal to its default value (i.e., uninitialized)
            if (Common.IsDefaultValue(value))
            {
                // See if any value exists in a DefaultValueAttribute
                object defaultValue = GetDefaultValue(propertyName);
                if (defaultValue != null)
                    return defaultValue;
            }

            return value;
        }

        /// <summary>
        /// Executes specified action over all public dervied class properties.
        /// </summary>
        /// <param name="propertyAction">Action to execute for all properties.</param>
        /// <param name="isGetOrSet"><see cref="BindingFlags.GetProperty"/> or <see cref="BindingFlags.SetProperty"/>.</param>
        [EditorBrowsable(EditorBrowsableState.Advanced)]
        protected void ExecuteActionForProperties(Action<PropertyInfo> propertyAction, BindingFlags isGetOrSet)
        {
            ExecuteActionForMembers(property =>
            {
                // Make sure only non-indexer properties are used for settings
                if (property.GetIndexParameters().Length == 0)
                    propertyAction(property);
            }, GetType().GetProperties(m_memberAccessBindingFlags | isGetOrSet));
        }

        // Execute specified action over specified members
        private void ExecuteActionForMembers<T>(Action<T> memberAction, T[] members) where T : MemberInfo
        {
            EntityPropertyAttribute attribute;

            // Execute action for each member
            foreach (T member in members)
            {
                // See if serialize setting attribute exists
                if (member.TryGetAttribute(out attribute))
                {
                    // Found entity property attribute, perform action if include is true
                    if (attribute.Include)
                        memberAction(member);
                }
                else if (!m_requireEntityPropertyAttribute)
                {
                    // Didn't find entity property attribute and it's not required, so we perform action (i.e., assume include)
                    memberAction(member);
                }
            }
        }

        /// <summary>
        /// Attempts to find specified attribute and return specified value.
        /// </summary>
        /// <typeparam name="TAttribute">Type of <see cref="Attribute"/> to find.</typeparam>
        /// <typeparam name="TValue">Type of value attribute delegate returns.</typeparam>
        /// <param name="propertyName">Name of property to search for attribute.</param>
        /// <param name="defaultValue">Default value to return if attribute doesn't exist.</param>
        /// <param name="attributeValue">Function delegate used to return desired attribute property.</param>
        /// <returns>Specified attribute value if it exists; otherwise default value.</returns>
        [EditorBrowsable(EditorBrowsableState.Advanced)]
        protected TValue GetAttributeValue<TAttribute, TValue>(string propertyName, TValue defaultValue, Func<TAttribute, TValue> attributeValue) where TAttribute : Attribute
        {
            TAttribute attribute;

            // See if property exists with specified name
            PropertyInfo property = this.GetType().GetProperty(propertyName, m_memberAccessBindingFlags);

            if (property != null)
            {
                // See if attribute exists on property
                if (property.TryGetAttribute(out attribute))
                {
                    // Return value as specified by delegate
                    return attributeValue(attribute);
                }

                // Attribute wasn't found, return default value
                return defaultValue;
            }

            // Return default value
            return defaultValue;
        }

        #endregion

        #region [ Static ]

        // Static Methods

        /// <summary>
        /// Creates and instance of <see cref="AdoDataConnection"/> if it is null.
        /// </summary>
        /// <param name="database">Reference parameter representing <see cref="AdoDataConnection"/> object.</param>
        /// <returns>Boolean, true if new instance of <see cref="AdoDataConnection"/> is created otherwise false.</returns>
        public static bool CreateConnection(ref AdoDataConnection database)
        {
            if (database == null)
            {
                try
                {
                    database = new AdoDataConnection(CommonFunctions.DefaultSettingsCategory);
                    return true;
                }
                catch (Exception ex)
                {
                    MessageBox.Show("ERROR: " + ex.Message, "Create Database Connection", MessageBoxButton.OK);
                    return false;
                }
            }
            else
                return false;
        }

        #endregion
    }
}
