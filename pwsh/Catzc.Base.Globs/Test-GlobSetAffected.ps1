<#
---
catzc:
  immutable:
    with_body_sha: "6a0c16d3c2c2"
  edges:
    test: pwsh/Catzc.Base.Globs/tests/Test-GlobSetAffected.Tests.ps1
    docs: "[Test-GlobSetAffected.ps1.md](docs/references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md)"
    cites:
      - ADR-AUTO-FAILFAST
      - FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT
---
#>

function Test-GlobSetAffected {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string] $Name
    )

    $config = Get-Config -Config globs
    Assert-True $config.Contains($Name) -ErrorText "Test-GlobSetAffected: '$Name' is not a declared globset (globs.yml)."

    $range = Get-GlobSetChangeRange
    if ($null -eq $range) {
        return $true
    }

    try {
        $touched = @(Get-ChangedGlobSet -Range $range)
    }
    catch {
        Write-Message "Test-GlobSetAffected: could not resolve change range '$range' ($($_.Exception.Message)); proceeding (fail-open)."
        return $true
    }

    [bool]($touched.Name -contains $Name)
}
