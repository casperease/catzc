function Get-TestTargetSkipReason {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Environment,

        [Parameter(Mandatory)]
        [ValidateSet('ReadOnly', 'Synthetic')]
        [string] $Mode,

        [Parameter(Mandatory)]
        [scriptblock] $Probe
    )

    $segment = ($Environment.ToLowerInvariant() -replace '[^a-z0-9]', '')
    Assert-True ($segment -match '^[a-z0-9]+$') -ErrorText "Get-TestTargetSkipReason: environment '$Environment' has no letter or digit to name it by."

    $policyMode = if ($Mode -eq 'Synthetic') {
        'synthetic'
    }
    else {
        'read-only'
    }
    if (-not (Get-Config -Config test-policy).Allows($Environment, $policyMode)) {
        return "target_${segment}_readonly"
    }

    $reachable = try {
        [bool] (& $Probe)
    }
    catch {
        $false
    }
    if (-not $reachable) {
        return "target_${segment}_unreachable"
    }
}
