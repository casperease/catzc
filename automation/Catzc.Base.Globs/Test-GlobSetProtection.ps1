<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Globs/Test-GlobSetProtection.ps1
    name: test-glob-set-protection
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
    page: docs/references/automation/catzc-base-globs/Test-GlobSetProtection.ps1.md
    test: automation/Catzc.Base.Globs/tests/Test-GlobSetProtection.Tests.ps1
    cites:
      - ADR-PWSH-CACHE#4
      - ADR-REPO-PROTGLOB
---
#>

function Test-GlobSetProtection {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Test,

        [Parameter(Mandatory, Position = 1)]
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string] $Name,

        [string] $Hash
    )

    if (Test-IsRunningInPipeline) {
        return $false
    }

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:protectedGlobSets')) {
        $script:protectedGlobSets = @{}
        $script:pendingGlobProtections = @{}
    }

    $key = "$Test|$Name"
    $identity = if ($Hash) {
        $Hash
    }
    else {
        Get-GlobSetHash -Name $Name
    }

    if ($script:protectedGlobSets[$key] -ceq $identity) {
        Write-Message "'$Test' skipped for '$Name': identity $($identity.Substring(0, 8)) unchanged since its last green run this session."
        return $true
    }

    $script:pendingGlobProtections[$key] = $identity
    return $false
}
