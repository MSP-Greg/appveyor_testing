#$OutputEncoding = [System.Text.Encoding]::GetEncoding(65001)
#[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(65001)

#$OutputEncoding = [System.Text.Encoding]::UTF8
#[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host OutputEncoding
$OutputEncoding

Write-Host `n[Console]::OutputEncoding
[Console]::OutputEncoding

Write-Host `n`n`n

ruby.exe -Eutf-8:utf-8 $PSScriptRoot\encoding.rb
