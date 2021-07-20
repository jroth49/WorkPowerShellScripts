foreach($unit in Get-Content C:\Users\jack\Desktop\runTool.txt) {
  $online = Test-Connection $unit -Quiet -Count 1  
  if($online) {
    Write-Host($unit)
  } else {
    Write-Host("$unit is not online")
  }

}