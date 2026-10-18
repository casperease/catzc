<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1
    name: test-glob-set-affected
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Globs/tests/Test-GlobSetAffected.Tests.ps1
    cites:
      - ADR-AUTO-FAILFAST
      - ADR-FLOW-CD-GLOBS#1
      - ADR-REPO-PROTGLOB#5
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
    if (-not $config.Contains($Name)) {
        throw "Test-GlobSetAffected: '$Name' is not a declared globset (globs.yml)."
    }

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
