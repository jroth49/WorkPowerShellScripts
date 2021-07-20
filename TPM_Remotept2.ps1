$unit = Read-Host("Enter Unit#")
$myCred = get-Credential
$online = Test-Connection $unit -Quiet -Count 1
$login = New-PSSession -ComputerName $unit -Credential $myCred

if($online) {
   Write-Host($unit + " is online")
   Write-Host("Copying TPM_ON folder to " + $unit + " C: Drive")
   try {
       Copy-item "\\tech1\MisTech\SoftwareReplicated\TechApps\Tools\TPM_ON" -Destination "\\$unit\c$" -Recurse
   } catch {
        Write-Host("Error copying over TPM folder. Might already have it?")
   }
   Start-Sleep -Seconds 15
   Invoke-Command -Session $login -ScriptBlock {
        $unit = hostname
        Write-Host("Running TPM_ON_v3.exe...")
        Start-Process \\$unit\c$\TPM_ON\TPM_ON_v3\TPM_ON_v3.exe
        Start-Sleep -Seconds 30
        Write-Host("Running TPM_ON_v3.exe...")
        Start-Process \\$unit\c$\TPM_ON\TPM_ON_v3\TPM_ON_v3.exe
        Start-Sleep -Seconds 30
        cat "\\$unit\c$\TPM_ON\TPM_ON_v3\TPM_ON_v3.txt"
   } 

} else {
   Write-Host($unit + " is not online")
}