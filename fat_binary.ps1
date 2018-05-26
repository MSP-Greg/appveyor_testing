$base_path = 'C:\Program Files\7-Zip;C:\Program Files\AppVeyor\BuildAgent;C:\Program Files\Git\cmd;C:\Windows\system32;C:\Program Files;C:\Windows'

$dashes = "$([char]0x2015)" * 70
$fc = 'Yellow'

function Ruby-Info($title) {
  $pr = if ($env:APPVEYOR) { 14 } else { 18 }
  $p = $(ruby -e "STDOUT.write RbConfig::TOPDIR").PadRight($pr)
  $bit = if ( $(ruby -e "STDOUT.write RbConfig::CONFIG['target_cpu']") -eq 'x64' )
     { "-64" } else { "-32" }
  $v = $(ruby -e "STDOUT.write RUBY_VERSION")
  Write-Host "`n$dashes $title" -ForegroundColor $fc
  Write-Host "$p $v$bit".PadLeft(70) -ForegroundColor $fc
}

$env:path = "C:\Ruby23\bin;C:\Users\appveyor\.gem\ruby\2.3.0\bin;$base_path"
Ruby-Info "Install 32 bit"
Write-Host "gem install eventmachine --user-install -N"  -ForegroundColor $fc
gem install eventmachine --user-install -N

$env:path = "C:\Ruby23-x64\bin;C:\Users\appveyor\.gem\ruby\2.3.0\bin;$base_path"
Ruby-Info "Install 64 bit"
Write-Host "gem install eventmachine --user-install -N"  -ForegroundColor $fc
gem install eventmachine --user-install -N

Ruby-Info "Testing 64 bit - pre PR"
Write-Host 'gem list' -ForegroundColor $fc
gem list
Write-Host 'ruby -reventmachine -e "puts $LOAD_PATH"' -ForegroundColor $fc
ruby -reventmachine -e "puts `$LOAD_PATH"

$env:path = "C:\Ruby23\bin;C:\Users\appveyor\.gem\ruby\2.3.0\bin;$base_path"
Ruby-Info "Testing 32 bit - pre PR"
Write-Host 'gem list' -ForegroundColor $fc
gem list
Write-Host 'ruby -reventmachine -e "puts $LOAD_PATH"' -ForegroundColor $fc
ruby -reventmachine -e "puts `$LOAD_PATH"

$env:path = "C:\Ruby23\bin;C:\Users\appveyor\.gem\ruby\2.3.0\bin;$base_path"
Ruby-Info "Add PR 2312 32 bit"
Push-Location C:\Ruby23\lib\ruby\site_ruby\2.3.0
Write-Host "C:\Ruby23\lib\ruby\site_ruby\2.3.0>C:\msys64\usr\bin\patch.exe  -p1 -N -i C:\projects\testing-appveyor\rubygems_pr_2312.patch"  -ForegroundColor $fc
C:\msys64\usr\bin\patch.exe -p1 -N -i C:\projects\testing-appveyor\rubygems_pr_2312.patch
Pop-Location

$env:path = "C:\Ruby23-x64\bin;C:\Users\appveyor\.gem\ruby\2.3.0\bin;$base_path"
Ruby-Info "Add PR 2312 64 bit"
Push-Location C:\Ruby23-x64\lib\ruby\site_ruby\2.3.0
Write-Host "C:\Ruby23-x64\lib\ruby\site_ruby\2.3.0>C:\msys64\usr\bin\patch.exe  -p1 -N -i C:\projects\testing-appveyor\rubygems_pr_2312.patch" -ForegroundColor $fc
C:\msys64\usr\bin\patch.exe -p1 -N -i C:\projects\testing-appveyor\rubygems_pr_2312.patch
Pop-Location

Ruby-Info "Testing 64 bit - post PR"
Write-Host 'gem list' -ForegroundColor $fc
gem list
Write-Host 'ruby -reventmachine -e "puts $LOAD_PATH"' -ForegroundColor $fc
ruby -reventmachine -e "puts `$LOAD_PATH"

$env:path = "C:\Ruby23\bin;C:\Users\appveyor\.gem\ruby\2.3.0\bin;$base_path"
Ruby-Info "Testing 32 bit - post PR"
Write-Host 'gem list' -ForegroundColor $fc
gem list
Write-Host 'ruby -reventmachine -e "puts $LOAD_PATH"' -ForegroundColor $fc
ruby -reventmachine -e "puts `$LOAD_PATH"

