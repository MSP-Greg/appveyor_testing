# Script by MSP-Greg

New-Variable -Name dash -Value "$([char]0x2015)" -Scope Script -Option AllScope, ReadOnly
New-Variable -Name dir_spec_cache -Value ""      -Scope Script -Option AllScope

[string[]]$suffixes = '', '-x64'
[string[]]$rubies = '200', '21', '22', '23', '24', '25'

$gem_vers = '2.7.7'

$base_path = 'C:/Program Files/7-Zip;C:/Program Files/AppVeyor/BuildAgent;C:/Program Files/Git/cmd;C:/Program Files (x86)/GNU/GnuPG/pub;C:/Windows/system32;C:/Windows;'

# ———————————————————————————————————————————————————————— Clean Spec Cache
$dir_spec_cache = (&ruby.exe -rrubygems -e 'puts Gem.default_spec_cache_dir' | Out-String).trim()
$dir_spec_cache += '/api.rubygems.org%443/quick'
[string[]]$scd = Get-ChildItem -Path $dir_spec_cache | select -expand fullname
$dir_spec_cache = $scd[0]
Remove-Item -Path $dir_spec_cache/bundler-*.gemspec         | Out-Null
Remove-Item -Path $dir_spec_cache/rubygems-update-*.gemspec | Out-Null

# ———————————————————————————————————————————————————————— Download rubygems-update
Push-Location C:\
gem fetch  rubygems-update -v $gem_vers
gem unpack rubygems-update-$gem_vers.gem
Pop-Location

# ———————————————————————————————————————————————————————— Loop thru Ruby Versions
foreach ($suf in $suffixes) {
  foreach ($vers in $rubies) {
    $env:path = "C:/Ruby$vers$suf/bin;$base_path"

    Write-Host "`n$($dash * 65) Ruby$vers$suf Updating"
    Push-Location C:\rubygems-update-$gem_vers
    Remove-Item Env:\GEM_HOME 2> $null
    ruby -v setup.rb 2>&1>$null
    Remove-Item Env:\GEM_HOME 2> $null
    Pop-Location
    gem uninstall rubygems-update -x
    Write-Host "Done with Rubygems Update"
    #————————————————————————————————————————————————————— minitest & rake
    gem install   minitest rake -N -f
    gem cleanup
  }
}

foreach ($suf in $suffixes) {
  foreach ($vers in $rubies) {
    $env:path = "C:/Ruby$vers$suf/bin;$base_path"
    Write-Host "`n$($dash * 70) Ruby$vers$suf"
    ./dir_out.ps1
  }
}

# ———————————————————————————————————————————————————————— Log file Info for cache
Write-Host "`n$($dash * 30)  $dir_spec_cache"
Get-ChildItem -File -Name -Path $dir_spec_cache

# ———————————————————————————————————————————————————————— Delete rubygems-update folder & file
Remove-Item -Path C:\rubygems-update-$gem_vers.gem
Remove-Item -Path C:\rubygems-update-$gem_vers -Recurse -Force | Out-Null
