$_Creds=Get-Credential

while($true){
    $_Endpoint=Read-Host "Enter TA number: "

    Foreach ($_Endpoint in $_Endpoint)
    {
        $_Disks = Get-WmiObject Win32_LogicalDisk -ComputerName $_Endpoint -Credential $_Creds -Filter DriveType=3 | 
            Select-Object DeviceID, 
                @{'Name'='Size'; 'Expression'={[math]::truncate($_.size / 1GB)}}, 
                @{'Name'='Freespace'; 'Expression'={[math]::truncate($_.freespace / 1GB)}}

        foreach ($_Disks in $_Disks)
        {
            $_Disks.DeviceID + $_Disks.FreeSpace.ToString("N0") + "GB / " + $_Disks.Size.ToString("N0") + "GB"

         }
     }
}