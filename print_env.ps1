$dash = "$([char]0x2015)"
Write-Host "`n$($dash * 60) ENV" -ForegroundColor Yellow
$env = gci env:
foreach ($e in $env) {
  Write-Host $e.name.PadRight(35) $e.value
}

Write-Host "`n$($dash * 60) dir C:\" -ForegroundColor Yellow
Push-Location C:\
Get-ChildItem * | format-table Name, LastWriteTime -AutoSize
Pop-Location

Write-Host "`n$($dash * 60) dir C:\Windows\System32 ssl" -ForegroundColor Yellow
Push-Location C:\Windows\System32
Get-ChildItem * -Include *crypto*.dll, *ssl*.dll | format-table Name, LastWriteTime -AutoSize
Pop-Location
