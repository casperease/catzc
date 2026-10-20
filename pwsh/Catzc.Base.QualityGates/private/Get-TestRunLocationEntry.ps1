<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-TestRunLocationEntry.ps1
    folder: private
    name: get-test-run-location-entry
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
    test: pwsh/Catzc.Base.QualityGates/tests/Get-TestRunLocationEntry.Tests.ps1
    docs: "[Get-TestRunLocationEntry.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-TestRunLocationEntry.ps1.md)"
    cites:
      - ADR-AUTO-NOPWD
      - ADR-AUTO-TEST-SAMETESTSBOTHRUNS
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
