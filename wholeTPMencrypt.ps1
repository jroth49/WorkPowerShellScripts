$unit = Read-Host("Enter Unit#")
$myCred = get-Credential
$online = Test-Connection $unit -Quiet -Count 1
$login = New-PSSession -ComputerName $unit -Credential $myCred

if($online) {

   Write-Host($unit + " is online")
   Write-Host("Copying TPM_ON folder to " + $unit + " C: Drive")

   try { Copy-item "\\{FilePath}" -Destination "\\$unit\c$" -Recurse } 
   catch [DirectoryExist,Microsoft.PowerShell.Commands.CopyItemCommand] { Write-Host("Error copying over TPM folder. Might already have it?") }

   Start-Sleep -Seconds 15


   Invoke-Command -ComputerName $unit -Credential $myCred -ScriptBlock {
       $unit = hostname
       $present = get-tpm | Select-Object "TpmPresent"
        
       if($present.TpmPresent -eq $False) {
           Write-Host("Tpm is not turned on...")
           Write-Host("Running TPM_ON_v3.exe...")
           Start-Process \\$unit\c$\TPM_ON\TPM_ON_v3\TPM_ON_v3.exe
           Start-Sleep -Seconds 30
           Write-Host("Running TPM_ON_v3.exe...")
           Start-Process \\$unit\c$\TPM_ON\TPM_ON_v3\TPM_ON_v3.exe
           Start-Sleep -Seconds 30
           cat "\\$unit\c$\TPM_ON\TPM_ON_v3\TPM_ON_v3.txt"
       } else {
        Write-Host("Tpm was already on...")
       }
    }

    Restart-Computer -ComputerName $unit -Wait -For WinRM -Force

    Invoke-Command -ComputerName $unit -Credential $myCred -ScriptBlock {
       $unit = hostname
       $TPM = Get-WMIObject -Class "Win32_Tpm" -Namespace "ROOT\CIMV2\Security\MicrosoftTpm"
       $present = get-tpm | Select-Object "TpmPresent"
       

       if($present.TpmPresent -eq $False) {
          Write-Host("Tpm didn't turn on check logs...")
          Exit
       } elseif (($TPM.isEnabled_InitialValue -eq $False) -or ($TPM.isActivated_InitialValue -eq $False)) {
          Write-Host("Activating Tpm...")
          $TPM.SetPhysicalPresenceRequest(6)
       } else {
          Write-Host("Try Rebooting and Initializing TPM");
       }

    }

    Restart-Computer -ComputerName $unit -Wait -For WinRM -Force

    Invoke-Command -ComputerName $unit -Credential $myCred -ScriptBlock {
       $unit = hostname
       $TPM = Get-WMIObject -Class "Win32_Tpm" -Namespace "ROOT\CIMV2\Security\MicrosoftTpm"
       $present = get-tpm | Select-Object "TpmPresent"


       if($TPM.isOwned_InitialValue -eq $False) {
           Initialize-Tpm
       }

       if($present.TpmPresent -eq $False) {
          Write-Host("Tpm didn't turn on check logs...")
          Exit
       } elseif (($TPM.isEnabled_InitialValue -eq $False) -or ($TPM.isActivated_InitialValue -eq $False)) {
          Write-Host("Activating Tpm...")
          $TPM.SetPhysicalPresenceRequest(6)
       } else {
          manage-bde -on c: -recoverypassword
       }
    }

    Restart-Computer -ComputerName $unit -Wait -For WinRM -Force

    Invoke-Command -ComputerName $unit -Credential $myCred -ScriptBlock {
       $unit = hostname
       $TPM = Get-WMIObject -Class "Win32_Tpm" -Namespace "ROOT\CIMV2\Security\MicrosoftTpm"
       $present = get-tpm | Select-Object "TpmPresent"
       $status = manage-bde -status | find "Conversion Status"

       if(($status.Contains("Encryption in Progress") -eq $True) -or ($status.Contains("Fully Encrypted"))) {
            Write-Host("Unit is now encrypting...")
            manage-bde -status
            #Stop-Service "winRM"
       }
    }



}
