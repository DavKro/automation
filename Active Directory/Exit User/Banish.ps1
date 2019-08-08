#Import Active Directory Module
Import-Module ActiveDirectory

#Display warning
Write-Host "WARNING: This script disables accounts on the specified domain, use with care" -ForegroundColor Yellow

#Get standard variables
$_Date=Get-Date -Format "MM/dd/yyyy"
$_Server=Read-Host "Enter the domain you want to search"
$_Creds=Get-Credential

while($true){

#Requests user input username
$_Name=Read-Host "Enter account name you wish to disable"

#Lists the users AD groups and removes them
Start-Sleep -s 10
Get-ADUser -Identity $_Name -Properties MemberOf -Credential $_Creds| ForEach-Object {
$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -Credential $_Creds -Confirm:$false
} 
write-host "User has been removed from the listed groups..." -ForegroundColor blue

#Disables the account
Disable-ADAccount -Identity $_Name -Server $_Server -Credential $_Creds
write-host "Disabling $_Name..." -ForegroundColor blue

#Sets the Description to Date the Script was ran and scrubs Office and Department to clear up Dynamic Distribution Lists
Set-ADUser $_Name -Server $_Server -Description "Disabled on $_Date" -Credential $_Creds
write-host "Changing Description to Disabled on $_Date..." -ForegroundColor blue

#Hard Stop for Script to keep window open
Write-Host "User account $_Name has been disabled" -ForegroundColor Green
Write-Host ""
}
