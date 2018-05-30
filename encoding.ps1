#[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host OutputEncoding
$OutputEncoding

Write-Host [Console]::OutputEncoding
[Console]::OutputEncoding

$enc = [Console]::OutputEncoding.HeaderName

ruby.exe $PSScriptRoot\encoding.rb $enc
