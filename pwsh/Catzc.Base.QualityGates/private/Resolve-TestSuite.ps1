<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
    folder: private
    name: resolve-test-suite
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
    test: pwsh/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1
    docs: "[Resolve-TestSuite.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Resolve-TestSuite.ps1.md)"
    cites:
      - ADR-AUTO-TEST-TESTSUITE
      - ADR-FLOW-CD-GLOBS-EVERYSETHASLAYER
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
        throw "Globset '$Name' declares no verify scope, so it is not a test suite — add 'verify: { modules: [...], level: N }' to it in globs.yml to run it with -Suite (ADR-AUTO-TEST-TESTSUITE)."
    }

    [pscustomobject]@{
        Modules = @($set.VerifyModules)
        Level   = $set.VerifyLevel
    }
}
