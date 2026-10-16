<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Files/Get-RepoStatus.ps1
    name: get-repo-status
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Files/tests/Get-RepoStatus.Tests.ps1
    cites:
      - ADR-REPO-FILEMETA#13
  config:
    synopsis: 'Returns where a file stands in git: unset, edited, staged, ready, committed or pushed.'
    description: |-
      The states of the repository status that only git knows, computed on demand and never written into the file, since the write would
      change them ([ADR-REPO-FILEMETA#13](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta13)). `unset`: git does not track the
      file. `edited`: the working tree differs from the index. `staged`: the index differs from HEAD and the working tree matches the
      index. `committed`: tracked, unchanged, and a commit that touched it is not on the upstream branch. `pushed`: tracked, unchanged and
      every commit that touched it is on the upstream. `ready`: tracked and unchanged on a branch with no upstream, so nothing says
      whether the server has it.

      Read-only: one `git status`, and for an unchanged tracked file one `git branch --show-current`, one `git for-each-ref` and one
      `git log`, each from the repository root.
    parameters:
      Path: The repository-relative, '/'-separated path of the file.
    outputs: '[string] unset, edited, staged, ready, committed or pushed.'
    examples:
      - Get-RepoStatus 'docs/adr/repository/file-meta.md'
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
