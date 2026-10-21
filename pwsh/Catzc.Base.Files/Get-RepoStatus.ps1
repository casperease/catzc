<#
---
catzc:
  immutable:
    with_body_sha: b93662c44a03
  edges:
    test: pwsh/Catzc.Base.Files/tests/Get-RepoStatus.Tests.ps1
    docs: "[Get-RepoStatus.ps1.md](docs/references/pwsh/catzc-base-files/Get-RepoStatus.ps1.md)"
    cites:
      - ADR-REPO-FILEMETA-FILEISNODE
---
#>

function Get-RepoStatus {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    $relative = $Path -replace '\\', '/'
    if (-not (@(Get-GitTrackedPath $relative) -contains $relative)) {
        return 'unset'
    }

    $root = Get-RepositoryRoot
    $status = Invoke-Executable "git status --porcelain=v1 -z --no-renames -- `"$relative`"" -WorkingDirectory $root -PassThru -Silent
    $entry = "$($status.Output)" -split "`0" | Where-Object { $_.Length -gt 3 } | Select-Object -First 1
    if ($entry) {
        # 'XY path': X is the index against HEAD, Y the working tree against the index.
        if ($entry[1] -ne ' ') {
            return 'edited'
        }
        return 'staged'
    }

    $branchResult = Invoke-Executable 'git branch --show-current' -WorkingDirectory $root -PassThru -Silent
    $branch = "$($branchResult.Output)".Trim()
    $upstream = ''
    if ($branch) {
        $upstreamResult = Invoke-Executable "git for-each-ref --format=%(upstream:short) refs/heads/$branch" -WorkingDirectory $root -PassThru -Silent
        $upstream = "$($upstreamResult.Output)".Trim()
    }
    if (-not $upstream) {
        return 'ready'
    }
    $logResult = Invoke-Executable "git log -1 --format=%H $upstream..HEAD -- `"$relative`"" -WorkingDirectory $root -PassThru -Silent
    if ("$($logResult.Output)".Trim()) {
        return 'committed'
    }
    'pushed'
}
