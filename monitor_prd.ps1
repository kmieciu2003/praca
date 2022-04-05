#while ($true){
cls
Set-AzContext -Subscription 'da6b5497-ec65-44a3-a2d5-1457870f7073'
$start = @"
<style>
/* Split the screen in half */
.split {
  height: 100%;
  width: 50%;
  position: fixed;
  z-index: 1;
  top: 0;
  overflow-x: hidden;
  padding-top: 20px;
}

/* Control the left side */
.left {
  left: 0;
  background-color: gray;
}

/* Control the right side */
.right {
  right: 0;
  background-color: white;
}

/* If you want the content centered horizontally and vertically */
.centered {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  text-align: center;
}
    body
  {
      background-color: white;
  }

  th {
    background-color: #04AA6D;
    color: white;
  }
  tr:nth-child(even) {background-color: #f2f2f2;}
</style>
<h2>Produkcyjne kolejki *_ERROR</h2>

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
$tabelka | ConvertTo-Html  -Title (get-date).addhours(2).ToString('yyyy-MM-dd HH:mm:ss.ms') -PreContent $start | Out-File .\index.html
git add .\index.html
git commit -m (get-date)
git push
start-sleep -Seconds 300
#}