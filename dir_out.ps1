# Script by MSP-Greg

$dflt_dir = (&ruby.exe -rrubygems -e 'puts Gem.default_dir' | Out-String).trim()

$dir_gems      = "$dflt_dir/gems"
$dir_gem_cache = "$dflt_dir/cache"
$dir_spec      = "$dflt_dir/specifications"
$dir_spec_dflt = "$dir_spec/default"

ruby -v 2> $null
Write-Host RubyGems (gem --version)
bundle version 2> $null
Write-Host "$($dash * 55) gem list"
gem list
Write-Host "$($dash * 55) Folder contents"

Write-Host "`n$($dash * 20)  $dir_gems"
Get-ChildItem -Directory -Name -Path $dir_gems

foreach ($list in @($dir_gem_cache, $dir_spec, $dir_spec_dflt)) {
  Write-Host "`n$($dash * 20)  $list"
  Get-ChildItem -File -Name -Path $list
}
