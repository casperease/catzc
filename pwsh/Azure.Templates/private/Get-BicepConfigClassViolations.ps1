function Get-BicepConfigClassViolations {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [AllowEmptyCollection()]
        [Parameter(Mandatory)] [string[]] $Environment,
        [Parameter(Mandatory)] $AzureConfig,
        [Parameter(Mandatory)] [string] $Location
    )

    $violations = @()

    $perSubscription = [System.Collections.Generic.List[string]]::new()
    $standard = [System.Collections.Generic.List[string]]::new()
    foreach ($name in @($Environment | Select-Object -Unique)) {
        $environmentEntry = $AzureConfig.environments[$name]
        if ($null -ne $environmentEntry -and $environmentEntry.Contains('per_subscription') -and $environmentEntry['per_subscription']) {
            $perSubscription.Add($name)
        }
        else {
            $standard.Add($name)
        }
    }
    if ($perSubscription.Count -gt 0 -and $standard.Count -gt 0) {
        $violations += "$Location mixes environment classes: per-subscription env(s) $($perSubscription -join ', ') and standard env(s) $($standard -join ', ') — a template's slots share one class (per_subscription in azure.yml), so split them into two templates"
    }

    $violations
}
