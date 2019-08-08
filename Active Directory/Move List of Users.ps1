# Import AD Module
import-module ActiveDirectory

# Import CSV 
# Import the data from CSV file and assign it to variable 
$_Creds=Get-Credential
$Imported = Import-Csv -Path "C:\temp\name.csv" 
$Imported | ForEach-Object {
# Retrieve DN of User.
$UserDN = (Get-ADUser -Identity $_.Username).distinguishedName
$TargetOU = $_.TargetOU
Write-Host " Moving Accounts ..... "
# Move user to target OU.
Move-ADObject -Identity $UserDN -TargetPath $TargetOU -Credential $_Creds

}
Write-Host " Completed move " 
$total = ($Imported).count
Write-Host $total "User Moved Successfully"