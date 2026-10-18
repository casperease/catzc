<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
    folder: private
    name: resolve-test-suite
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1
    cites:
      - ADR-AUTO-TEST#37
      - ADR-FLOW-CD-GLOBS#7
---
#>

function Resolve-TestSuite {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Name
    )

    $set = Get-GlobSet -Name $Name
    if ($set.VerifyModules.Count -eq 0) {
        throw "Globset '$Name' declares no verify scope, so it is not a test suite — add 'verify: { modules: [...], level: N }' to it in globs.yml to run it with -Suite (ADR-AUTO-TEST#37)."
    }

    [pscustomobject]@{
        Modules = @($set.VerifyModules)
        Level   = $set.VerifyLevel
    }
}
