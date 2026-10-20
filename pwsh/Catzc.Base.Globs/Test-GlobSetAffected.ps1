<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Globs/Test-GlobSetAffected.ps1
    name: test-glob-set-affected
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Globs/tests/Test-GlobSetAffected.Tests.ps1
    docs: "[Test-GlobSetAffected.ps1.md](docs/references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md)"
    cites:
      - ADR-AUTO-FAILFAST
      - ADR-FLOW-CD-GLOBS-CHANGECOMPUTEDFROMGIT
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
