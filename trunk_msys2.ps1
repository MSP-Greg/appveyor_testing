$dash  = "$([char]0x2015)"
$msys2 = 'C:\msys64'

$env:path = "$msys2\usr\bin;C:\ruby25-x64\bin;C:\Program Files\7-Zip;C:\Program Files\AppVeyor\BuildAgent;C:\Program Files\Git\cmd;C:\Windows\system32;C:\Program Files;C:\Windows"

#—————————————————————————————————————————————————————————————————————————————— Update MSYS2
Write-Host "$($dash * 63) Updating MSYS2 / MinGW" -ForegroundColor Yellow

Write-Host "pacman.exe -Syu --noconfirm --noprogressbar" -ForegroundColor Yellow
pacman.exe -Syu --noconfirm --noprogressbar

Write-Host "`npacman.exe -Su --noconfirm --noprogressbar" -ForegroundColor Yellow
pacman.exe -Su --noconfirm --noprogressbar

Write-Host "`nThe following two commands may not be needed, but I had issues" -ForegroundColor Yellow
Write-Host "retrieving a new key without them..." -ForegroundColor Yellow

$t1 = "pacman-key --init"
Write-Host "`nbash.exe -lc $t1" -ForegroundColor Yellow
bash.exe -lc $t1

$t1 = "pacman-key -l"
Write-Host "bash.exe -lc $t1" -ForegroundColor Yellow
bash.exe -lc $t1

Write-Host "Clean cache & database" -ForegroundColor Yellow
Write-Host "pacman.exe -Sc  --noconfirm" -ForegroundColor Yellow
pacman.exe -Sc  --noconfirm

#——————————————————————————————————————————————————————————————————————————————
#                ALL BELOW CODE IS JUST INFORMATIONAL & TESTING

#——————————————————————————————————————————————————————————————————————————————  MSYS2 Info
Write-Host "`n$($dash * 80)`nCached Packages" -ForegroundColor Yellow
Write-Host "dir C:\msys64\var\cache\pacman\pkg (cached packages)" -ForegroundColor Yellow
dir C:\msys64\var\cache\pacman\pkg | Format-Table -Property Name

Write-Host "`n$($dash * 80)`nInstalled Packages" -ForegroundColor Yellow

ruby.exe pacman_query.rb

Write-Host "`n$($dash * 80)`n" -ForegroundColor Yellow

#—————————————————————————————————————————————————————————————————————————————— Add GPG key
$key = '77D8FA18'
$ks1 = 'hkp://na.pool.sks-keyservers.net'
$ks2 = 'hkp://pgp.mit.edu/'

$gdbm    = 'mingw-w64-x86_64-gdbm-1.10-2-any.pkg.tar.xz'
$openssl = 'mingw-w64-x86_64-openssl-1.1.0.h-1-any.pkg.tar.xz'
$dl_uri  = 'https://dl.bintray.com/msp-greg/ruby_trunk'

$wc  = $(New-Object System.Net.WebClient)
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

$pkgs = "C:\pkgs"
$pkgs_u = $pkgs.replace('\', '/')

Write-Host "$($dash * 63) Adding GPG key" -ForegroundColor Yellow
Write-Host "try retrieving & signing key" -ForegroundColor Yellow

$t1 = "pacman-key -r $key --keyserver $ks1 && pacman-key -f $key && pacman-key --lsign-key $key"
bash.exe -lc $t1 2> $null
$exit_code = $LastExitCode
# below is for occasional key retrieve failure on Appveyor
if ($exit_code) {
  Write-Host GPG Key Lookup failed from $ks1 -ForegroundColor Yellow
  # try another keyserver
  $t1 = "pacman-key -r $key --keyserver $ks2 && pacman-key -f $key && pacman-key --lsign-key $key"
  bash.exe -lc $t1 1> $null
  $exit_code = $LastExitCode
  if ($exit_code) {
    Write-Host GPG Key Lookup failed from $ks2 -ForegroundColor Yellow
    exit $exit_code
  }
}

if ( !(Test-Path -Path $pkgs -PathType Container) ) {
  New-Item -Path $pkgs -ItemType Directory 1> $null
}

#—————————————————————————————————————————————————————————————————————————————— Add gdbm & openssl
Write-Host "$($dash * 63) Try installing gdbm & openssl" -ForegroundColor Yellow
Write-Host "Installing $gdbm"
$wc.DownloadFile("$dl_uri/$gdbm", "$pkgs\$gdbm")
$wc.DownloadFile("$dl_uri/$gdbm" + ".sig", "$pkgs\$gdbm" + ".sig")

#pacman.exe -Rdd --noconfirm mingw-w64-x86_64-gdbm  1> $null
pacman.exe -Udd --noconfirm $pkgs_u/$gdbm            1> $null
if ($LastExitCode) {
  Write-Host "Error installing gdbm" -ForegroundColor Yellow
  exit 1
} else { Write-Host "Finished" }

Write-Host "Installing $openssl"
$wc.DownloadFile("$dl_uri/$openssl", "$pkgs\$openssl")
$wc.DownloadFile("$dl_uri/$openssl" + ".sig", "$pkgs\$openssl" + ".sig")

pacman.exe -Rdd --noconfirm mingw-w64-x86_64-openssl 1> $null
pacman.exe -Udd --noconfirm $pkgs_u/$openssl         1> $null
if ($LastExitCode) {
  Write-Host "Error installing openssl" -ForegroundColor Yellow
  exit 1
} else { Write-Host "Finished" }

Write-Host "$($dash * 63) MinGW Package Check" -ForegroundColor Yellow
bash -lc "pacman -Qs x86_64\.\+\(gcc\|gdbm\|openssl\) | sed -n '/^local/p' | sed 's/^local\///' | sed 's/ (.\+$//'"

Write-Host "`n$($dash * 80)`n" -ForegroundColor Yellow
