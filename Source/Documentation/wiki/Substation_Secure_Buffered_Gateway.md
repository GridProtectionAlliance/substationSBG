<html lang="en">
<head>
</head>
<body>
<!--HtmlToGmd.Body-->
<h1>
<a href="https://github.com/GridProtectionAlliance/substationSBG"><img src="https://github.com/GridProtectionAlliance/substationSBG/blob/master/Source/Documentation/wiki/substationSBG_Logo.png" alt="The Open Source Phasor Data Concentrator" /></a></h1>
<div id="NavigationMenu">
<table style="width: 100%; border-collapse: collapse; border: 0px solid gray;">
<tr>
<td style="width: 25%; text-align:center;"><b><a href="http://www.gridprotectionalliance.org">Grid Protection Alliance</a></b></td>
<td style="width: 25%; text-align:center;"><b><a href="https://github.com/GridProtectionAlliance/substationSBG">substationSBG Project on GitHub</a></b></td>
<td style="width: 25%; text-align:center;"><b><a href="https://github.com/GridProtectionAlliance/substationSBG/blob/master/Source/Documentation/wiki/Substation_Secure_Buffered_Gateway.md">openPDC Wiki Home</a></b></td>
<td style="width: 25%; text-align:center;"><b><a href="https://github.com/GridProtectionAlliance/substationDBG/tree/master/Source/Documentation/wiki/openPDC_Documentation_Home.md">Documentation</a></b></td>
</tr>
</table>
</div>
<hr />
<!--/HtmlToGmd.Body-->
<div class="WikiContent">
<div class="wikidoc">
<p><strong>Project Description</strong><br>
The&nbsp;substationSBG administered by the <a title="GPA" href="http://www.gridprotectionalliance.org">
Grid Protection Alliance </a>(GPA) couples the high-performance phasor data&nbsp;processing features of the openPDC and the security features of SIEGate into a purpose-built<br>
system that is both a substation PDC and a gateway for the secure, reliable communication of synchrophasor data from a substation to the control center. It acts as a synchrophasor data gateway in that it can securely and efficiently gather and redistribute
 high-resolution (e.g., 60 sample-per-second) time-series data from multiple devices and move real-time&nbsp;data in a consolidated stream to a central location, e.g., as upstream openPDC, and also keep a&nbsp;central data repository&nbsp;complete by providing
 automated data recovery capabilities using its short-term rolling local archive.</p>
<p>Be sure to check out our new video on <a title="Data Gap Recovery" href="http://youtu.be/wcUWMv2iCyk" target="_blank">
Data Gap Recovery</a>.</p>
<p><img src="https://github.com/GridProtectionAlliance/substationSBG/blob/master/Source/Documentation/wiki/files/SSBGOverview.png" alt="substationSBG Overview" width="639" height="210"></p>
<p><img src="https://github.com/GridProtectionAlliance/substationSBG/blob/master/Source/Documentation/wiki/files/AutomatedDataRecovery.png" alt="Overview" width="637" height="514"></p>
<p><img src="https://github.com/GridProtectionAlliance/substationSBG/blob/master/Source/Documentation/wiki/files/brochure-R3.png" alt="substationSBG Brochure" width="647" height="871"></p>
<p><strong>The Gateway Exchange Protocol</strong><br>
The&nbsp;substationSBG uses the highly efficient Gateway Exchange Protocol (GEP) to move data among interested parties (all standard synchrophasor protocols are also supported as needed). This protocol has been optimized to minimize bandwidth as the gateway
 flexibly implements publish-subscribe with individual phasor measurement point granularity. See:
<a href="http://www.gridprotectionalliance.org/docs/products/gsf/gep-overview.pdf">GEP Protocol Overview</a><br />
<a href="http://www.gridprotectionalliance.org/docs/products/gsf/gep-use-tutorial.pdf">GEP Protocol Use Tutorial</a><br />
<a href="http://www.gridprotectionalliance.org/docs/products/gsf/GEP-bandwidth-estimator.zip">GEP Bandwidth Estimator Spreadsheet</a><br />
<a href="https://github.com/GridProtectionAlliance/openPDC/blob/master/Source/Documentation/wiki/GEP_Subscription_Tester.md">GEP Subscription Tester</a></p>
</div>
</div>
<hr />
<div class="footer">
Last edited <span class="smartDate" title="3/10/2015 6:43:25 PM" LocalTimeTicks="1426038205">Mar 10, 2015 at 6:43 PM</span> by <a id="wikiEditByLink" href="https://github.com/ritchiecarroll">ritchiecarroll</a>, version 48<br />
<!--HtmlToGmd.Migration-->Migrated from <a href="http://substationsbg.codeplex.com/">CodePlex</a> Nov 6, 2015 by <a href="https://github.com/ajstadlin">ajstadlin</a><!--/HtmlToGmd.Migration-->
</div>
</body>
</html>