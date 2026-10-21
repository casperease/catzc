<#
---
catzc:
  immutable:
    with_body_sha: "7412e855d131"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-TestRunLocationEntry.Tests.ps1
    docs: "[Get-TestRunLocationEntry.ps1.md](../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-TestRunLocationEntry.ps1.md)"
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
