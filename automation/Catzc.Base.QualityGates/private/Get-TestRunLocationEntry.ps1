<#
.SYNOPSIS
    Resolves the entry script a test run's workers load, for the location the run executes in.
.DESCRIPTION
    The run seam names the script each worker dot-sources to load the modules: empty for the source importer, the...
    [ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30),
    [ADR-AUTO-NOPWD](/docs/adr/automation/never-depend-on-pwd.md)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-TestRunLocationEntry.ps1.md#comment1)
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
