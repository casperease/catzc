<#
---
catzc:
  immutable:
    with_body_sha: "27467b195cf5"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1
    docs: "[Resolve-TestSuite.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Resolve-TestSuite.ps1.md)"
    cites:
      - ADR-AUTO-TEST-TESTSUITE
      - FDR-CD-GLOBS-EVERYSETHASLAYER
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
