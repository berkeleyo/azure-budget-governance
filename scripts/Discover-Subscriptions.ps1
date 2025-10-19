param(
    [string]$ManagementGroupId,
    [string]$OutputCsv = "./output/subscriptions.csv"
)
<# 
.SYNOPSIS
    Enumerate subscriptions for budget rollout.
#>
Import-Module Az.Accounts -ErrorAction Stop
Import-Module Az.Resources -ErrorAction Stop

$subs = @()

if ($ManagementGroupId) {
    $mgSubs = Get-AzSubscription -WarningAction SilentlyContinue | Where-Object { $_.State -eq 'Enabled' }
    $subs += $mgSubs
} else {
    $subs += Get-AzSubscription | Where-Object { $_.State -eq 'Enabled' }
}

$dir = Split-Path -Parent $OutputCsv
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }

$subs | Select-Object Id, Name, State |
    Export-Csv -NoTypeInformation -Path $OutputCsv

Write-Host "Wrote $($subs.Count) subscriptions to $OutputCsv"
