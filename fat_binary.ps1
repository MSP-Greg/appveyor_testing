$base_path = 'C:\Program Files\7-Zip;C:\Program Files\AppVeyor\BuildAgent;C:\Program Files\Git\cmd;C:\Windows\system32;C:\Program Files;C:\Windows'

$dashes = "$([char]0x2015)" * 65

Write-Host `n$dashes Install 32 bit -ForegroundColor yellow
$env:path = "C:\Ruby23\bin;C:\Users\appveyor\.gem\ruby\2.3.0\bin;$base_path"
ruby -v
Write-Host "gem install eventmachine --user-install -N"  -ForegroundColor yellow
gem install eventmachine --user-install -N

Write-Host `n$dashes Install 64 bit -ForegroundColor yellow
$env:path = "C:\Ruby23-x64\bin;C:\Users\appveyor\.gem\ruby\2.3.0\bin;$base_path"
ruby -v
Write-Host "gem install eventmachine --user-install -N"  -ForegroundColor yellow
gem install eventmachine --user-install -N

Write-Host `n$dashes Testing 64 bit -ForegroundColor yellow
Write-Host 'ruby -v -reventmachine -e "puts $LOAD_PATH"' -ForegroundColor yellow
ruby -v -reventmachine -e "puts `$LOAD_PATH"

Write-Host `n$dashes Testing 32 bit -ForegroundColor yellow
$env:path = "C:\Ruby23\bin;C:\Users\appveyor\.gem\ruby\2.3.0\bin;$base_path"
Write-Host 'ruby -v -reventmachine -e "puts $LOAD_PATH"' -ForegroundColor yellow
ruby -v -reventmachine -e "puts `$LOAD_PATH"
