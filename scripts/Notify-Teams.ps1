param(
    [Parameter(Mandatory=$true)][string]$WebhookUrl,
    [string]$Title = "Azure Budget Governance",
    [string]$Message = "Operation completed successfully.",
    [ValidateSet("info","warning","error")][string]$Severity = "info"
)
<#
.SYNOPSIS
    Post a simple message card to a Teams channel via webhook.
#>
$payload = @{
    "@type" = "MessageCard"
    "@context" = "http://schema.org/extensions"
    "summary" = $Title
    "themeColor" = switch ($Severity) { "info" {"0078D4"} "warning" {"FFA000"} "error" {"D13438"} }
    "title" = $Title
    "text" = $Message
}

Invoke-RestMethod -Method Post -Uri $WebhookUrl -Body (ConvertTo-Json $payload -Depth 5) -ContentType "application/json"
