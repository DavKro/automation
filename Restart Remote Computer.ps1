﻿#Display warning
Write-Host "This script restarts targeted" -ForegroundColor Yellow


$_Creds=Get-Credential

while($true){

    #Requests user input username
    Restart-Computer -ComputerName (Read-Host "ComputerName") -Credential $_Creds -Force


    #Hard Stop for Script to keep window open
    Write-Host ""
}