
#NOTES
#Onjuective:    Script to used to generate Intune Device Information Report
#Version:         1.0
#Author:          Chander Mani Pandey
#Creation Date:   3 Dec 2023
#Find Author on 
#Youtube:-      https://www.youtube.com/@chandermanipandey8763
#Twitter:-        https://twitter.com/Mani_CMPandey
#LinkedIn:-     https://www.linkedin.com/in/chandermanipandey


#==============User Input Section==========================
$ObjectID = "IntuneReportingAutomation"
#=======================================================

# Connect to Microsoft Graph within Azure Automation 
Connect-AzAccount -Identity  ##Az.Accounts
$token = Get-AzAccessToken -ResourceUrl "https://graph.microsoft.com"
#Connect-MgGraph #Microsoft.Graph.Authentication

#Object ID OF the User Managed Identity

Connect-MgGraph -Identity -ClientId $ObjectID
$graphUri = "https://graph.microsoft.com/beta/deviceManagement/managedDevices"
$Method = "GET"
# Send the request and retrieve the devices
$response = Invoke-MgGraphRequest -Method $Method -uri $graphUri 
# Create a report variable
$report = @()
# Build the report
foreach ($device in $response.value) {
    $deviceName = $device.deviceName
    $serialNumber = $device.serialNumber
    $operatingSystem = $device.operatingSystem
    $osVersion = $device.osVersion 
    $deviceInfo = [PSCustomObject]@{
        DeviceName = $deviceName
        serialNumber= $serialNumber
        operatingSystem = $operatingSystem 
        osVersion = $osVersion 
        
       
    }
    $report += $deviceInfo
}
#Report Outut
$report | Format-Table