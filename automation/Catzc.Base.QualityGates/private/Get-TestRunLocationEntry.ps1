<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestRunLocationEntry.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-TestRunLocationEntry.Tests.ps1
    adrs:
      - ADR-AUTO-NOPWD
      - ADR-AUTO-TEST#30
  config:
    synopsis: Resolves the entry script a test run's workers load, for the location the run executes in.
    description: |-
      The run seam ([ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30)) names the script
      each worker dot-sources to load the modules: empty for
      the source importer, the build's Import-Catzc.ps1 for the build run. A snapshot run (Enter-TestRunLocation)
      must load from the snapshot so that every path a worker resolves — out/, .compiled, git — lands inside it
      ([ADR-AUTO-NOPWD](/docs/adr/automation/never-depend-on-pwd.md)):

      - in place: the entry passes through unchanged;
      - snapshot, source run: the snapshot's own importer, without janitors;
      - snapshot, a run's own entry script: kept (it lives outside the repository), with every repository
        path among its arguments (the build run's RepositoryRoot) mapped into the snapshot.
    parameters:
      Location: The location Enter-TestRunLocation returned.
      EntryScript: The test run's entry script; empty for the source importer.
      EntryParameter: Named arguments for -EntryScript.
    outputs: '[hashtable] @{ EntryScript; EntryParameter }, ready to splat into New-TestAutomationShardScript.'
---
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
