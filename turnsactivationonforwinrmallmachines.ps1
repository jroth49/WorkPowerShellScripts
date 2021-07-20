$myCred = get-Credential

foreach($unit in Get-Content C:\Users\jack\Desktop\unit_winRM.txt) {
  $online = Test-Connection $unit -Quiet -Count 1  
  Write-Host($unit)
  if($online) {
    $login = New-PSSession -ComputerName $unit -Credential $myCred
    Invoke-Command -Session $login -ScriptBlock { 
        $TPM = Get-WMIObject -Class "Win32_Tpm" -Namespace "ROOT\CIMV2\Security\MicrosoftTpm"
        $TPM.SetPhysicalPresenceRequest(6)
    }
  } else {
    Write-Host("Unit is not online")
  }

}