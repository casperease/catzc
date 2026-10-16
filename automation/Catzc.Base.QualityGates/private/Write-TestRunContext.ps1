<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/private/Write-TestRunContext.ps1
    folder: private
    name: write-test-run-context
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Write-TestRunContext.Tests.ps1
  config:
    synopsis: 'Prints a test run''s context block under its banner: one line per fact.'
    description: |-
      Renders Get-TestRunContext's record so a reader sees, before any test output, what the run is and where it
      runs — the entry point and code root, the location and why, the tiers asked for and running (and why they
      differ), who is running it, which local tools are present, and what is selected:

          entry point  Test-Automation · source run · code root C:\repo\automation
          location     snapshot (working folder held by Test-Automation, pid 4242)
          tiers        asked L0-L3 · running L0-L2 — L3 skipped: snapshot location
          actor        Person
          tools        git yes · az no · dotnet yes
          selection    suite infrastructure; modules: Catzc.Azure.Templates
    parameters:
      Context: The record Get-TestRunContext returned.
    examples:
      - Write-TestRunContext -Context $context
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
