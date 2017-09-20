#While($TRUE) {ps | sort -des cpu | select -f 30 | ft -a; sleep 2; cls}
$saveY = [console]::CursorTop
$saveX = [console]::CursorLeft      

cls
while ($true) {
    Get-Process | Sort -Descending -Unique SI,ProcessName| Select -First 30 -Property Username;
    Sleep -Seconds 2;
    [console]::setcursorposition($saveX,$saveY-6)
}