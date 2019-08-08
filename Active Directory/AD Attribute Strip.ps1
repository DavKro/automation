#Import Active Directory Module
Import-Module ActiveDirectory

#Display warning
Write-Host "Welcome to the Mass User List Editor" -ForegroundColor Yellow
Write-Host "Please ensure the list of users you wish to edit is labeled 'users.csv' and place it in this directory" -ForegroundColor Yellow

#Get standard variables
$_Server=Read-Host "Enter the domain"
$_Creds=Get-Credential

while($true){

    #Lists the users AD groups and removes them
    Import-CSV "C:\Users\flanaganp\Downloads\Ticket Email\RemoveMailboxs-REQ1183791.csv" | % {
        $_User = $_.samAccountName

        Set-ADUser $_User -Server $_Server -Clear "mail" -Credential $_Creds
    }

    #Hard Stop for Script to keep window open
    Write-Host "Users attriutes have been edited" -ForegroundColor Green
    Write-Host ""
}