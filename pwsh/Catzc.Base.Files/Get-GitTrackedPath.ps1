<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Files/Get-GitTrackedPath.ps1
    name: get-git-tracked-path
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Files/tests/Get-GitTrackedPath.Tests.ps1
    docs: "[Get-GitTrackedPath.ps1.md](docs/references/pwsh/catzc-base-files/Get-GitTrackedPath.ps1.md)"
    cites:
      - ADR-AUTO-CACHE-SESSIONCHANGEDGITSTATE
      - ADR-AUTO-TRACKED
      - ADR-PWSH-CACHE-STRICTSAFEPROBE
---
#>

function Get-GitTrackedPath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Path,

        [switch] $ExecutableOnly
    )

    $indexPath = Get-GitIndexPath
    if (-not [System.IO.File]::Exists($indexPath)) {
        # A fresh `git init` with nothing added has no index yet: nothing is tracked.
        return
    }

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:gitIndexCache')) {
        $script:gitIndexCache = @{}
    }

    $content = [System.IO.File]::ReadAllBytes($indexPath)
    $index = $script:gitIndexCache[$indexPath]
    if ($null -eq $index -or $index.ContentHash -ne [Catzc.Base.Git.GitIndex]::HashContent($content)) {
        $index = [Catzc.Base.Git.GitIndex]::Parse($content)
        $script:gitIndexCache[$indexPath] = $index
    }
    if ($ExecutableOnly) {
        return $index.ExecutableUnder($Path)
    }
    $index.Under($Path)
}
