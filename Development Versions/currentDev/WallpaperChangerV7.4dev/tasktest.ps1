#While($TRUE) {ps | sort -des cpu | select -f 30 | ft -a; sleep 2; cls}
$saveY = [console]::CursorTop
$saveX = [console]::CursorLeft      

cls
while ($true) {
    Get-Process | Sort -Unique SI,ProcessName| Select | Where-Object -FilterScript {$_.SessionId -ne 0} ;
    Sleep -Seconds 1;
    [console]::setcursorposition($saveX,$saveY-6)
}