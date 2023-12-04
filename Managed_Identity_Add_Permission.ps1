﻿ 
#NOTES
#Onjuective:      Script to used to Add Permission in Managed Identity application
#Version:         1.0
#Author:          Chander Mani Pandey
#Creation Date:   3 Dec 2023
#Find Author on 
#Youtube:-        https://www.youtube.com/@chandermanipandey8763
#Twitter:-        https://twitter.com/Mani_CMPandey
#LinkedIn:-       https://www.linkedin.com/in/chandermanipandey


#==============User Input Section=======================
$ManagedIDEntAppName = "IntuneReportingAutomation"
#=======================================================
cls
Set-ExecutionPolicy -ExecutionPolicy Bypass

# Check if the Microsoft.Graph module is installed
if (-not (Get-Module -Name Microsoft.Graph -ListAvailable)) {
    Write-Host "Microsoft.Graph module not found. Installing..."
    
    # Module is not installed, so install it
    Install-Module Microsoft.Graph -Scope CurrentUser -Force
    
    Write-Host "Microsoft.Graph module installed successfully."
}
else {
    Write-Host "Microsoft.Graph module is already installed."
}

Write-Host "Importing Microsoft.Graph module..."
# Import the Microsoft.Graph module
Import-Module Microsoft.Graph.Authentication

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "Application.Read.All","AppRoleAssignment.ReadWrite.All,RoleManagement.ReadWrite.Directory"
Write-Host "Connected to Microsoft Graph."

$ManagedIdentityId = (Get-MgServicePrincipal -Filter "displayName eq '$ManagedIDEntAppName'").id

# Adding Microsoft Graph permissions
$GraphAppServicePrincipal = Get-MgServicePrincipal -Filter "AppId eq '00000003-0000-0000-c000-000000000000'"

# Add the required Graph scopes
$Scopes = @(
  "DeviceManagementManagedDevices.Read.All", "AuditLog.Read.All", "User.Read.All","DeviceManagementApps.Read.All","DeviceManagementServiceConfig.Read.All","Device.Read.All","DeviceLocalCredential.Read.All"
)
ForEach($Scope in $Scopes){
  $Role = $GraphAppServicePrincipal.AppRoles | Where-Object {$_.Value -eq $Scope}

  if ($null -eq $Role) { Write-Warning "not able to find Role for scope $Scope"; continue; }

  # Check if permissions aren't already assigned
  $AARole = Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $ManagedIdentityId | Where-Object { $_.AppRoleId -eq $Role.Id -and $_.ResourceDisplayName -eq "Microsoft Graph" }

  if ($null -eq $AARole) {
    New-MgServicePrincipalAppRoleAssignment -PrincipalId $ManagedIdentityId -ServicePrincipalId $ManagedIdentityId -ResourceId $GraphAppServicePrincipal.Id -AppRoleId $Role.Id
  } else {
    Write-Host " $Scope Scope is already assigned"
  }
}
