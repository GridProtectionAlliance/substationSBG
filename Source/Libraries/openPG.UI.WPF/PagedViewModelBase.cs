﻿//******************************************************************************************************
//  PagedViewModelBase.cs - Gbtc
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
//  04/07/2011 - Mehulbhai P Thakkar
//       Generated original version of source code.
//  05/13/2011 - Mehulbhai P Thakkar
//       Modified CurrentItem.PropertyChanged event handler to virtual so that it can 
//       be overloaded by the derived classes for special handling such as by Measurements.cs
//  05/25/2011 - J. Ritchie Carroll
//       Added load/save/delete event operations to allow for user control interception.
//
//******************************************************************************************************

using System;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Reflection;
using System.Windows;
using System.Windows.Input;
using openPG.UI.WPF.Commands;
using TVA.Data;

namespace openPG.UI.WPF
{
    /// <summary>
    /// Represents an abstract class with paging support which all ViewModel objects derive from.
    /// </summary>
    public abstract class PagedViewModelBase<TDataModel, TPrimaryKey> : IViewModel where TDataModel : IDataModel, new()
    {
        #region [ Members ]

        // Events

        /// <summary>
        /// Raised when a property on this object has a new value.
        /// </summary>
        public event PropertyChangedEventHandler PropertyChanged;

        /// <summary>
        /// Raised before record load is executed.
        /// </summary>
        public event CancelEventHandler BeforeLoad;

        /// <summary>
        /// Raised when record has been loaded.
        /// </summary>
        public event EventHandler Loaded;

        /// <summary>
        /// Raised before record save is executed.
        /// </summary>
        public event CancelEventHandler BeforeSave;

        /// <summary>
        /// Raised when record has been saved.
        /// </summary>
        public event EventHandler Saved;

        /// <summary>
        /// Raised before record delete is executed.
        /// </summary>
        public event CancelEventHandler BeforeDelete;

        /// <summary>
        /// Raised when record has been deleted.
        /// </summary>
        public event EventHandler Deleted;

        // Fields
        private int m_pageCount, m_currentPageNumber, m_itemsPerPage;
        private ObservableCollection<TDataModel> m_currentPage, m_itemsSource;
        private ObservableCollection<ObservableCollection<TDataModel>> m_pages;
        private ICommand m_firstCommand, m_previousCommand, m_nextCommand, m_lastCommand;
        private RelayCommand m_saveCommand, m_deleteCommand, m_clearCommand;
        private TDataModel m_currentItem;
        private bool m_propertyChanged;
        private bool m_autoSave;
        private bool m_hideMessages;

        #endregion

        #region [ Constructors ]

        /// <summary>
        /// Creates a new instance of the <see cref="PagedViewModelBase{T1,T2}"/> class.
        /// </summary>
        /// <param name="itemsPerPage">Integer value to determine number of items per page.</param>
        /// <param name="autoSave">Boolean value to determine is user changes should be saved automatically.</param>
        protected PagedViewModelBase(int itemsPerPage, bool autoSave = true)
        {
            m_itemsPerPage = itemsPerPage;
            m_autoSave = autoSave;
            if (itemsPerPage > 0)   // i.e. User wants to display list along with input form so we call Load() method.
                Load();
            else                    // otherwise, user does not want to display list and just dealing with form alone.
                ItemsSource = null;
        }

        #endregion

        #region [ Properties ]

        /// <summary>
        /// Gets or sets if user changes should be saved automatically.
        /// </summary>
        public bool AutoSave
        {
            get
            {
                return m_autoSave;
            }
            set
            {
                m_autoSave = value;
            }
        }

        /// <summary>
        /// Gets a message box to display message to users.
        /// </summary>
        public Action<string, string, MessageBoxImage> Popup
        {
            get
            {
                return (Action<string, string, MessageBoxImage>)((message, caption, messageBoxImage) => MessageBox.Show(Application.Current.MainWindow, message, caption, MessageBoxButton.OK, messageBoxImage));
            }
        }

        /// <summary>
        /// Gets message box to request confirmation from users.
        /// </summary>
        public Func<string, string, bool> Confirm
        {
            get
            {
                return (Func<string, string, bool>)((message, caption) => MessageBox.Show(Application.Current.MainWindow, message, caption, MessageBoxButton.YesNo) == MessageBoxResult.Yes);
            }
        }

        /// <summary>
        /// Gets or sets number of items to be displayed per page.
        /// </summary>
        public int ItemsPerPage
        {
            get
            {
                return m_itemsPerPage;
            }
            set
            {
                m_itemsPerPage = value;
            }
        }

        /// <summary>
        /// Gets or sets the entire collection retrieved from the database.
        /// </summary>
        public ObservableCollection<TDataModel> ItemsSource
        {
            get
            {
                return m_itemsSource;
            }
            set
            {
                m_itemsSource = value;
                OnPropertyChanged("ItemsSource");
                GeneratePages();
            }
        }

        /// <summary>
        /// Gets or sets the current item displayed in a form for edit.
        /// </summary>
        public TDataModel CurrentItem
        {
            get
            {
                return m_currentItem;
            }
            set
            {
                if (m_currentItem != null)
                {
                    ProcessPropertyChange();
                    m_currentItem.PropertyChanged -= m_currentItem_PropertyChanged;
                }

                m_currentItem = value;

                if (m_currentItem != null)
                    m_currentItem.PropertyChanged += m_currentItem_PropertyChanged;

                OnPropertyChanged("CurrentItem");

                // If CurrentItem changes then raise OnPropertyChanged on CanDelete property.
                // This will help us display or hide certain item based on IsNewItem property value.                
                OnPropertyChanged("CanDelete");

                // If CurrentItem changes then raise OnPropertyChanged on IsNewRecord property.
                // This will help us enable or disable Initialize button where applicable.
                if (m_currentItem != null)
                    OnPropertyChanged("IsNewRecord");
            }
        }

        /// <summary>
        /// Gets or sets collection displayed on the current page.
        /// </summary>
        public ObservableCollection<TDataModel> CurrentPage
        {
            get
            {
                return m_currentPage;
            }
            set
            {
                if (m_currentPage != null)
                    m_currentPage.CollectionChanged -= new NotifyCollectionChangedEventHandler(m_currentPage_CollectionChanged);

                m_currentPage = value;

                OnPropertyChanged("CurrentPage");

                if (m_currentPage != null)
                {
                    m_currentPage.CollectionChanged += new NotifyCollectionChangedEventHandler(m_currentPage_CollectionChanged);

                    if (m_currentPage.Count > 0)
                        CurrentItem = m_currentPage[0];
                }
            }
        }

        /// <summary>
        /// Gets or sets an index of <see cref="CurrentPage"/> to be displayed.
        /// </summary>
        public int CurrentPageNumber
        {
            get
            {
                return m_currentPageNumber;
            }
            set
            {
                m_currentPageNumber = value;
                OnPropertyChanged("CurrentPageNumber");
            }
        }

        /// <summary>
        /// Gets or sets total number of pages.
        /// </summary>
        public int PageCount
        {
            get
            {
                return m_pageCount;
            }
            set
            {
                m_pageCount = value;
                OnPropertyChanged("PageCount");
            }
        }

        /// <summary>
        /// Gets <see cref="ICommand"/> for moving to the first page.
        /// </summary>
        public ICommand FirstCommand
        {
            get
            {
                if (m_firstCommand == null)
                {
                    m_firstCommand = new RelayCommand
                    (
                        () =>
                        {
                            if (m_pages != null)
                            {
                                CurrentPage = m_pages[0];
                                CurrentPageNumber = 1;
                            }

                        },
                        () =>
                        {
                            return (CurrentPageNumber - 1) < 1 ? false : true;
                        }
                    );
                }
                return m_firstCommand;
            }
        }

        /// <summary>
        /// Gets <see cref="ICommand"/> for moving to the previous page.
        /// </summary>
        public ICommand PreviousCommand
        {
            get
            {
                if (m_previousCommand == null)
                {
                    m_previousCommand = new RelayCommand
                    (
                        () =>
                        {
                            if (m_pages != null)
                            {
                                CurrentPageNumber = (CurrentPageNumber - 1) < 1 ? 1 : CurrentPageNumber - 1;
                                CurrentPage = m_pages[CurrentPageNumber - 1];
                            }
                        },
                        () =>
                        {
                            return (CurrentPageNumber - 1) < 1 ? false : true;
                        }
                    );
                }
                return m_previousCommand;
            }
        }

        /// <summary>
        /// Gets <see cref="ICommand"/> for moving to the next page.
        /// </summary>
        public ICommand NextCommand
        {
            get
            {
                if (m_nextCommand == null)
                {
                    m_nextCommand = new RelayCommand
                    (
                        () =>
                        {
                            if (m_pages != null)
                            {
                                CurrentPageNumber = (CurrentPageNumber + 1) > m_pageCount ? m_pageCount : CurrentPageNumber + 1;
                                CurrentPage = m_pages[CurrentPageNumber - 1];
                            }
                        },
                        () =>
                        {
                            return (CurrentPageNumber + 1) > m_pageCount ? false : true;
                        }
                    );
                }
                return m_nextCommand;
            }
        }

        /// <summary>
        /// Gets <see cref="ICommand"/> for moving to the last page.
        /// </summary>
        public ICommand LastCommand
        {
            get
            {
                if (m_lastCommand == null)
                {
                    m_lastCommand = new RelayCommand
                    (
                        () =>
                        {
                            if (m_pages != null)
                            {
                                CurrentPage = m_pages[m_pageCount - 1];
                                CurrentPageNumber = m_pageCount;
                            }
                        },
                        () =>
                        {
                            return (CurrentPageNumber + 1) > m_pageCount ? false : true;
                        }
                    );
                }
                return m_lastCommand;
            }
        }

        /// <summary>
        /// Gets save <see cref="ICommand"/>.
        /// </summary>
        public ICommand SaveCommand
        {
            get
            {
                if (m_saveCommand == null)
                    m_saveCommand = new RelayCommand(Save, () => CanSave);

                return m_saveCommand;
            }
        }

        /// <summary>
        /// Gets delete <see cref="ICommand"/>.
        /// </summary>
        public ICommand DeleteCommand
        {
            get
            {
                if (m_deleteCommand == null)
                    m_deleteCommand = new RelayCommand(Delete, () => CanDelete);

                return m_deleteCommand;
            }
        }

        /// <summary>
        /// Gets clear <see cref="ICommand"/>.
        /// </summary>
        public ICommand ClearCommand
        {
            get
            {
                if (m_clearCommand == null)
                    m_clearCommand = new RelayCommand(Clear, () => CanClear);

                return m_clearCommand;
            }
        }

        /// <summary>
        /// Gets flag that indicates if <see cref="CurrentItem"/> state is valid and can be saved.
        /// </summary>
        /// <returns><c>true</c> if <see cref="CurrentItem"/> can be saved; otherwise <c>false</c>.</returns>
        public virtual bool CanSave
        {
            get
            {
                if (CurrentItem == null)
                    return false;
                else
                    return CurrentItem.IsValid;
            }
        }

        /// <summary>
        /// Gets flag that indicates if <see cref="CurrentItem"/> can be deleted.
        /// </summary>
        /// <returns><c>true</c> if <see cref="CurrentItem"/> can be deleted; otherwise <c>false</c>.</returns>
        public virtual bool CanDelete
        {
            get
            {
                if (CurrentItem == null)
                    return false;
                else
                    return !IsNewRecord;
            }
        }

        /// <summary>
        /// Gets flag that indicates if <see cref="CurrentItem"/> can be cleared.
        /// </summary>
        /// <returns><c>true</c> if <see cref="CurrentItem"/> can be cleared; otherwise <c>false</c>.</returns>
        public virtual bool CanClear
        {
            get
            {
                return true;
            }
        }

        /// <summary>
        /// Gets name of associated <see cref="IDataModel"/>.
        /// </summary>
        public virtual string DataModelName
        {
            get
            {
                return s_dataModelType.Name;
            }
        }

        /// <summary>
        /// Gets flag that determines if <see cref="CurrentItem"/> is a new record.
        /// </summary>
        public abstract bool IsNewRecord
        {
            get;
        }

        #endregion

        #region [ Methods ]

        /// <summary>
        /// Gets the primary key value of the <see cref="CurrentItem"/>.
        /// </summary>
        /// <returns>The primary key value of the <see cref="CurrentItem"/>.</returns>
        public abstract TPrimaryKey GetCurrentItemKey();

        /// <summary>
        /// Gets the string based named identifier of the <see cref="CurrentItem"/>.
        /// </summary>
        /// <returns>The string based named identifier of the <see cref="CurrentItem"/>.</returns>
        public abstract string GetCurrentItemName();

        /// <summary>
        /// Loads the records for the associated <see cref="IDataModel"/>.
        /// </summary>
        public virtual void Load()
        {
            Mouse.OverrideCursor = Cursors.Wait;
            try
            {
                if (OnBeforeLoadCanceled())
                    throw new OperationCanceledException("Load was canceled.");

                ItemsSource = (ObservableCollection<TDataModel>)s_loadRecords.Invoke(this, new object[] { (AdoDataConnection)null });

                OnLoaded();
            }
            catch (Exception ex)
            {
                if (ex.InnerException != null)
                    Popup(ex.Message + Environment.NewLine + "Inner Exception: " + ex.InnerException.Message, "Load " + DataModelName + " Exception:", MessageBoxImage.Error);
                else
                    Popup(ex.Message, "Load " + DataModelName + " Exception:", MessageBoxImage.Error);
            }
            finally
            {
                Mouse.OverrideCursor = null;
            }
        }

        /// <summary>
        /// Saves the record for the associated <see cref="IDataModel"/>.
        /// </summary>
        public virtual void Save()
        {
            if (CanSave)
            {
                try
                {
                    if (OnBeforeSaveCanceled())
                        throw new OperationCanceledException("Save was canceled.");

                    string result = (string)s_saveRecord.Invoke(this, new object[] { (AdoDataConnection)null, CurrentItem });

                    OnSaved();

                    m_propertyChanged = false;  // after saving information, set this flag to false.

                    if (!m_hideMessages)
                    {
                        Popup(result, "Save " + DataModelName, MessageBoxImage.Information);
                        Load();
                    }
                }
                catch (Exception ex)
                {
                    if (ex.InnerException != null)
                        Popup(ex.Message + Environment.NewLine + "Inner Exception: " + ex.InnerException.Message, "Save " + DataModelName + " Exception:", MessageBoxImage.Error);
                    else
                        Popup(ex.Message, "Save " + DataModelName + " Exception:", MessageBoxImage.Error);
                }
            }
        }

        /// <summary>
        /// Deletes the record for the associated <see cref="IDataModel"/>.
        /// </summary>
        public virtual void Delete()
        {
            if (CanDelete && Confirm("Are you sure you want to delete \'" + GetCurrentItemName() + "\'?", "Delete " + DataModelName))
            {
                try
                {
                    if (OnBeforeDeleteCanceled())
                        throw new OperationCanceledException("Delete was canceled.");

                    string result = (string)s_deleteRecord.Invoke(this, new object[] { (AdoDataConnection)null, GetCurrentItemKey() });

                    OnDeleted();

                    Load();

                    Popup(result, "Delete " + DataModelName, MessageBoxImage.Information);
                }
                catch (Exception ex)
                {
                    if (ex.InnerException != null)
                        Popup(ex.Message + Environment.NewLine + "Inner Exception: " + ex.InnerException.Message, "Delete " + DataModelName + " Exception:", MessageBoxImage.Error);
                    else
                        Popup(ex.Message, "Delete " + DataModelName + " Exception:", MessageBoxImage.Error);
                }
            }
        }

        /// <summary>
        /// Clears the record for the associated <see cref="IDataModel"/>.
        /// </summary>
        public virtual void Clear()
        {
            if (CanClear)
                CurrentItem = new TDataModel();
        }

        /// <summary>
        /// Method to check if property has changed and if so then either save or ask user's confirmation.
        /// </summary>
        public virtual void ProcessPropertyChange()
        {
            if (m_propertyChanged)
            {
                m_propertyChanged = false;

                if (CanSave)
                {
                    if (AutoSave)
                    {
                        m_hideMessages = true;
                        Save();
                        m_hideMessages = false;
                    }
                    else if (Confirm("\'" + GetCurrentItemName() + "\' has changed. Do you want to save changes?", "Save " + DataModelName))
                    {
                        Save();
                    }
                    else
                    {
                        Load();
                    }
                }
                else
                {
                    Load();
                }
            }
        }

        /// <summary>
        /// Raises the <see cref="PropertyChanged"/> event.
        /// </summary>
        /// <param name="propertyName">Property name that has changed.</param>
        protected virtual void OnPropertyChanged(string propertyName)
        {
            if (PropertyChanged != null)
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
        }

        /// <summary>
        /// Raises the <see cref="BeforeLoad"/> event.
        /// </summary>
        protected virtual bool OnBeforeLoadCanceled()
        {
            CancelEventArgs cancelEventArgs = new CancelEventArgs();

            if (BeforeLoad != null)
                BeforeLoad(this, cancelEventArgs);

            return cancelEventArgs.Cancel;
        }

        /// <summary>
        /// Raises the <see cref="Loaded"/> event.
        /// </summary>
        protected virtual void OnLoaded()
        {
            if (Loaded != null)
                Loaded(this, EventArgs.Empty);
        }

        /// <summary>
        /// Raises the <see cref="BeforeSave"/> event.
        /// </summary>
        protected virtual bool OnBeforeSaveCanceled()
        {
            CancelEventArgs cancelEventArgs = new CancelEventArgs();

            if (BeforeSave != null)
                BeforeSave(this, cancelEventArgs);

            return cancelEventArgs.Cancel;
        }

        /// <summary>
        /// Raises the <see cref="Saved"/> event.
        /// </summary>
        protected virtual void OnSaved()
        {
            if (Saved != null)
                Saved(this, EventArgs.Empty);
        }

        /// <summary>
        /// Raises the <see cref="BeforeDelete"/> event.
        /// </summary>
        protected virtual bool OnBeforeDeleteCanceled()
        {
            CancelEventArgs cancelEventArgs = new CancelEventArgs();

            if (BeforeDelete != null)
                BeforeDelete(this, cancelEventArgs);

            return cancelEventArgs.Cancel;
        }

        /// <summary>
        /// Raises the <see cref="Deleted"/> event.
        /// </summary>
        protected virtual void OnDeleted()
        {
            if (Deleted != null)
                Deleted(this, EventArgs.Empty);
        }

        // We monitor for changes to IsValid property on current item so that we can propagate
        // this change notification to CanSave

        /// <summary>
        /// Handles PropertyChanged event on CurrentItem.
        /// </summary>
        /// <param name="sender">Source of the event.</param>
        /// <param name="e">Event arguments.</param>
        protected virtual void m_currentItem_PropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            // Change Save button appearance based on IsValid property value.
            // If value of IsValid is changed then raise OnPropertyChanged for CanSave to enable or disable Save button.
            if (string.Compare(e.PropertyName, "IsValid", true) == 0)
                OnPropertyChanged("CanSave");

            m_propertyChanged = true;
        }

        // We monitor the changes to the collection currently displayed on the screen.
        // If user tried to delete then process it.
        private void m_currentPage_CollectionChanged(object sender, NotifyCollectionChangedEventArgs e)
        {
            if (e.Action == NotifyCollectionChangedAction.Remove)
            {
                foreach (object item in e.OldItems)
                {
                    CurrentItem = (TDataModel)item;
                    s_deleteRecord.Invoke(this, new object[] { (AdoDataConnection)null, GetCurrentItemKey() });
                }
            }
        }

        /// <summary>
        /// Method to create a list of pages based on the <see cref="ItemsSource"/>.
        /// </summary>
        private void GeneratePages()
        {
            if (ItemsSource != null && ItemsSource.Count > 0)
            {
                if (ItemsPerPage > 0)
                {
                    PageCount = (int)Math.Ceiling(ItemsSource.Count / (double)ItemsPerPage);
                    m_pages = new ObservableCollection<ObservableCollection<TDataModel>>();

                    for (int i = 0; i < m_pageCount; i++)
                    {
                        ObservableCollection<TDataModel> page = new ObservableCollection<TDataModel>();
                        for (int j = 0; j < ItemsPerPage; j++)
                        {
                            if (i * ItemsPerPage + j > ItemsSource.Count - 1)
                                break;
                            page.Add(ItemsSource[i * ItemsPerPage + j]);
                        }
                        m_pages.Add(page);
                    }

                    if (CurrentPage == null || CurrentPageNumber == 0)
                    {
                        CurrentPage = m_pages[0];
                        CurrentPageNumber = 1;
                    }
                    else
                    {
                        // Retain current page when user deletes any record from the collection
                        CurrentPageNumber = (CurrentPageNumber + 1) > m_pageCount ? m_pageCount : CurrentPageNumber;
                        CurrentPage = m_pages[CurrentPageNumber - 1];
                    }
                }
            }
            else
            {
                PageCount = 0;
                CurrentPage = new ObservableCollection<TDataModel>();
                CurrentItem = new TDataModel();
                CurrentPageNumber = 0;
            }
        }

        #endregion

        #region [ Static ]

        // Static Fields
        private static Type s_dataModelType = typeof(TDataModel);
        private static MethodInfo s_loadRecords = s_dataModelType.GetMethod("Load");
        private static MethodInfo s_saveRecord = s_dataModelType.GetMethod("Save");
        private static MethodInfo s_deleteRecord = s_dataModelType.GetMethod("Delete");

        #endregion
    }
}
