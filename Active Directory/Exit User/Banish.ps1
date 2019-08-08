    #Import Active Directory Module
Import-Module ActiveDirectory 


#Variables for Script
$_Name=Read-Host "Enter account name you wish to disable"
$_Date=Get-Date -Format "MM/dd/yyyy"
$_Creds=Get-Credential

#Disable the Account by Input in $_Name Variable
Disable-ADAccount -Identity $_Name -Credential $_Creds
write-host "Disabling $_Name" -ForegroundColor Green

#Sets the Description to Date the Script was ran and scrubs Office and Department to clear up Dynamic Distribution Lists
Set-ADUser $_Name -Description "Disabled on $_Date" -Credential $_Creds
write-host "Changing Description to Disabled on $_Date" -ForegroundColor Green

#Removes All Group Membership except for Domain Users from User
$group = get-adgroup "Domain Users"
$groupSid = $group.sid
$groupSid
[int]$GroupID = $groupSid.Value.Substring($groupSid.Value.LastIndexOf("-")+1)
Get-ADUser $_Name | Set-ADObject -Replace @{primaryGroupID="$GroupID"} -Credential $_Creds
Remove-ADPrincipalGroupMembership -Identity $_Name -MemberOf $(Get-ADPrincipalGroupMembership -Identity $_Name -Credential $_Creds| Where-Object {$_.Name -ne "Domain Users"}) -Confirm:$false 
Write-Host "Removing All Group Membership for $_Name" -ForegroundColor Green

#Creates a variable that configures a remote session to our Exchange Servers to allow Exchange commands through powershell 
$s=New-PSSession -ConfigurationName microsoft.exchange -ConnectionUri http://VSEMPPRDARC20/powershell  -Credential $_Creds -AllowRedirection 
Write-Host "Creating New Exchange Session" -ForegroundColor Green

#Imports the configured remote session
Import-PSSession $s -DisableNameChecking
Write-Host "Importing New Exchange Session" -ForegroundColor Green

#Disables mailbox in exchange
Disable-Mailbox -Identity $_Name
Set-CASMailbox -Identity $_Name -ActiveSyncEnabled $false 
write-host "Exchange Mailbox has been Disabled for $_Name" -ForegroundColor Green

#closes the remote session
Remove-PSSession $s  
Write-Host "Closing Exchange Session" -ForegroundColor Green


#Hard Stop for Script to keep window open
Read-Host "User $_Name has been exited"