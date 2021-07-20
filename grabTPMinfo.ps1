$myCred = get-Credential



foreach($unit in Get-Content C:\Users\jack\Desktop\unit_winRM.txt) {
  $online = Test-Connection $unit -Quiet -Count 1  
  Write-Host($unit)
  if($online) {

    $login = New-PSSession -ComputerName $unit -Credential $myCred
    
    Invoke-Command -Session $login -ScriptBlock { 
        $unit = hostname
        Get-TPM | Out-File -FilePath \\$unit\c$\$unit.txt
        manage-bde -status | Add-Content \\$unit\c$\$unit.txt
        wmic bios get smbiosbiosversion | Add-Content \\$unit\c$\$unit.txt
        Get-Date | Add-Content \\$unit\c$\$unit.txt
    }

    Move-Item \\$unit\c$\$unit.txt -Destination \\10DP4548\c$\Users\jack\Desktop\TPM_INFO\$unit.txt

  } else {
    Write-Host("Unit is not online")
  }

}