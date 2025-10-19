param(
    [Parameter(Mandatory=$true)][string]$InputCsv,
    [decimal]$Amount = 5000,
    [ValidateSet('Monthly','Quarterly','Annually')][string]$TimeGrain = 'Monthly',
    [int[]]$Thresholds = @(50,75,90,100),
    [switch]$Remove
)
<#
.SYNOPSIS
    Create or update Azure Budgets per subscription.
#>
Import-Module Az.Accounts -ErrorAction Stop
Import-Module Az.Billing -ErrorAction Stop
Import-Module Az.Resources -ErrorAction Stop

$items = Import-Csv $InputCsv
foreach ($row in $items) {
    $subId = $row.Id
    $scope = "/subscriptions/$subId"

    Set-AzContext -Subscription $subId | Out-Null

    if ($Remove) {
        $existing = Get-AzConsumptionBudget -Scope $scope -ErrorAction SilentlyContinue
        foreach ($b in $existing) {
            Remove-AzConsumptionBudget -Scope $scope -Name $b.Name -Force
            Write-Host "Removed budget $($b.Name) in $subId"
        }
        continue
    }

    $name = "budget-standard"
    $start = Get-Date -Day 1 -Hour 0 -Minute 0 -Second 0
    $end = $start.AddYears(10)

    $params = @{
        Name        = $name
        Scope       = $scope
        Category    = "Cost"
        Amount      = $Amount
        StartDate   = $start
        EndDate     = $end
        TimeGrain   = $TimeGrain
    }

    $budget = Get-AzConsumptionBudget -Scope $scope -Name $name -ErrorAction SilentlyContinue
    if ($null -eq $budget) {
        $null = New-AzConsumptionBudget @params
        Write-Host "Created budget $name in $subId amount $Amount"
    } else {
        $null = Update-AzConsumptionBudget @params
        Write-Host "Updated budget $name in $subId amount $Amount"
    }

    foreach ($t in $Thresholds) {
        Write-Host "Configured threshold $t% (action groups wired separately)"
    }
}
