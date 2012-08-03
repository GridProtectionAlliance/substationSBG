﻿using System.Reflection;
using System.Runtime.InteropServices;

// Informational attributes.
[assembly: AssemblyCompany("Grid Protection Alliance")]
[assembly: AssemblyCopyright("Copyright © 2012.  All Rights Reserved.")]
[assembly: AssemblyProduct("openPG")]

// Assembly manifest attributes.
#if DEBUG
[assembly: AssemblyConfiguration("Debug Build")]
#else
[assembly: AssemblyConfiguration("Release Build")]
#endif
[assembly: AssemblyDescription("Windows service that hosts input, action and output adapters.")]
[assembly: AssemblyTitle("openPG Iaon Host")]

// Other configuration attributes.
[assembly: ComVisible(false)]
[assembly: Guid("c8a353e9-9383-46c5-8c19-8da53d307cde")]

// Assembly identity attributes.
[assembly: AssemblyVersion("1.0.37.0")]
[assembly: AssemblyFileVersion("1.0.37.0")]