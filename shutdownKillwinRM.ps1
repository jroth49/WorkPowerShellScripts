$myCred = get-Credential
#$online = Test-Connection $unit -Quiet -Count 1


foreach($unit in Get-Content C:\Users\jack\Desktop\list_test.txt) {
  $login = New-PSSession -ComputerName $unit -Credential $myCred
  Write-Host($unit)

  Invoke-Command -Session $login -ScriptBlock { 
    $unit = hostname
    Write-Host("Shutting down $unit in 10 hours...")
    #shutdown /r /t 36000 /c "Computer is restarting in 10 Hours"
    Write-Host("Stopping Windows Remote Management...")
    Stop-Service "winRM"
  }

}