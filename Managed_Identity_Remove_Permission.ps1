﻿ 
#NOTES
#Onjuective:      Script to used to Remove Permissio in Managed Identity application
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

$ManagedID = (Get-MgServicePrincipal -Filter "displayName eq '$ManagedIDEntAppName'").id

# Removing all Graph scopes
$ManagedID_permissions = Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $ManagedID
ForEach($ManagedIDAssignment in $ManagedID_permissions){
  Remove-MgServicePrincipalAppRoleAssignment -AppRoleAssignmentId $ManagedIDAssignment.Id -ServicePrincipalId $ManagedID
}