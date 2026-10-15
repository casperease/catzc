<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestRunLocationEntry.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-NOPWD
      - ADR-AUTO-TEST#30
---
#>

<#
.SYNOPSIS
    Resolves the entry script a test run's workers load, for the location the run executes in.
.DESCRIPTION
    A snapshot run must load from the snapshot, so every path a worker resolves lands inside the snapshot.
.PARAMETER Location
    The location Enter-TestRunLocation returned.
.PARAMETER EntryScript
    The test run's entry script; empty for the source importer.
.PARAMETER EntryParameter
    Named arguments for -EntryScript.
.OUTPUTS
    [hashtable] @{ EntryScript; EntryParameter }, ready to splat into New-TestAutomationShardScript.
#>
function Get-TestRunLocationEntry {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $Location,

        [string] $EntryScript,

        [hashtable] $EntryParameter = @{}
    )

    if ($Location.Mode -ne 'snapshot') {
        return @{ EntryScript = $EntryScript; EntryParameter = $EntryParameter }
    }
    if (-not $EntryScript) {
        return @{ EntryScript = Join-Path $Location.Root 'importer.ps1'; EntryParameter = @{ SkipJanitors = $true } }
    }

    $mappedParameter = @{}
    foreach ($name in $EntryParameter.Keys) {
        $value = $EntryParameter[$name]
        $mappedParameter[$name] = if ($value -is [string]) {
            Convert-TestRunLocationPath -Location $Location -Path $value
        }
        else {
            $value
        }
    }
    @{ EntryScript = $EntryScript; EntryParameter = $mappedParameter }
}
