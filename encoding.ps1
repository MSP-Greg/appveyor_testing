$OutputEncoding = [System.Text.Encoding]::GetEncoding(65001)
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding(65001)

Write-Host OutputEncoding
$OutputEncoding

Write-Host `n[Console]::OutputEncoding
[Console]::OutputEncoding
