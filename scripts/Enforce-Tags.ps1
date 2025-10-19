param(
    [Parameter(Mandatory=$true)][string]$InputCsv,
    [string[]]$RequiredTags = @('CostCenter','Owner','Environment'),
    [switch]$Fix
)
<#
.SYNOPSIS
    Report (and optionally fix) tag compliance.
#>
Import-Module Az.Accounts -ErrorAction Stop
Import-Module Az.Resources -ErrorAction Stop

$items = Import-Csv $InputCsv
$report = @()

foreach ($row in $items) {
    $subId = $row.Id
    Set-AzContext -Subscription $subId | Out-Null
    $rgs = Get-AzResourceGroup
    foreach ($rg in $rgs) {
        foreach ($tag in $RequiredTags) {
            if (-not $rg.Tags.ContainsKey($tag)) {
                $obj = [pscustomobject]@{ Subscription=$subId; ResourceGroup=$rg.ResourceGroupName; MissingTag=$tag }
                $report += $obj
                if ($Fix) {
                    $new = $rg.Tags
                    if ($null -eq $new) { $new = @{} }
                    $new[$tag] = "TBD"
                    Set-AzResourceGroup -Name $rg.ResourceGroupName -Tag $new | Out-Null
                }
            }
        }
    }
}

$dir = "./output"
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
$report | Export-Csv -NoTypeInformation -Path "$dir/tag-compliance.csv"
Write-Host "Compliance report written to $dir/tag-compliance.csv"
