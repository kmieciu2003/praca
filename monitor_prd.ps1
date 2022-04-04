cls
Set-AzContext -Subscription 'da6b5497-ec65-44a3-a2d5-1457870f7073'
$head = @"
Stan na: "+(getdate).ToString('yyyy-MMdd HH:mm:ss.ms')+"

<style>
    body
  {
      background-color: Gainsboro;
  }

    table, th, td{
      border: 1px solid;
    }
</style>
"@
cls 
$rgName='otd-weu-p-sbn-rg'
$nsName='otd-weu-p-sbn'
[System.Collections.ArrayList]$tabelka=@()
foreach($queue in (Get-AzServiceBusQueue -ResourceGroupName $rgName -NamespaceName $nsName | where {$_.Name -like '*_error'})){
   $row = [pscustomobject]@{'QueueName'=$queue.Name;'ActiveMessageCount'=$queue.CountDetails.ActiveMessageCount; 'DeadLetterMessageCount'=$queue.CountDetails.DeadLetterMessageCount}
   if($queue.CountDetails.ActiveMessageCount+$queue.CountDetails.DeadLetterMessageCount -gt 0){
       $tabelka.Add($row) | Out-Null
   }
   $row=$null
}
$tabelka | ConvertTo-Html  -Title "error monitor" -PreContent $head |Out-File .\index.html
git add .\index.html
git commit -m (get-date)
git push