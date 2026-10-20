<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Write-TestRunContext.ps1
    folder: private
    name: write-test-run-context
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Write-TestRunContext.Tests.ps1
    docs: "[Write-TestRunContext.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Write-TestRunContext.ps1.md)"
---
#>

function Write-TestRunContext {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Context
    )

    $location = $Context.location
    if ($Context.locationReason) {
        $location += " ($($Context.locationReason))"
    }
    $tiers = "asked $($Context.tiersRequested) · running $($Context.tiersRunning)"
    if ($Context.tierCap) {
        $tiers += " — $($Context.tierCap)"
    }
    $tools = @($Context.tools.Keys | ForEach-Object {
            $state = if ($Context.tools[$_]) {
                'yes'
            }
            else {
                'no'
            }
            "$_ $state"
        }) -join ' · '

    $lines = [ordered]@{
        'entry point' = "$($Context.entryPoint) · $($Context.run) run · code root $($Context.codeRoot)"
        'location'    = $location
        'tiers'       = $tiers
        'actor'       = $Context.actor
        'tools'       = $tools
        'selection'   = $Context.selection
    }
    foreach ($label in $lines.Keys) {
        Write-Message ('  {0,-12} {1}' -f $label, $lines[$label]) -NoHeader
    }
}
