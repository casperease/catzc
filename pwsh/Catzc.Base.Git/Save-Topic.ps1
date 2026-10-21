<#
---
catzc:
  immutable:
    with_body_sha: "60eb1ea03912"
  edges:
    test: pwsh/Catzc.Base.Git/tests/Save-Topic.Tests.ps1
    docs: "[Save-Topic.ps1.md](docs/references/pwsh/catzc-base-git/Save-Topic.ps1.md)"
    cites:
      - ADR-FLOW-GIT-USERRUNSGIT
---
#>

function Save-Topic {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $Message,

        [Catzc.Base.Git.GitFlowConfig] $Config = (Get-Config -Config git),

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    Assert-Command git

    if ([string]::IsNullOrWhiteSpace($Message)) {
        $Message = '...'
    }

    $branch = "$((Invoke-Executable 'git rev-parse --abbrev-ref HEAD' -WorkingDirectory $RepositoryRoot -PassThru -Silent).Output)".Trim()
    Assert-True ($branch -cne 'HEAD') -ErrorText 'Save-Topic needs a named branch; HEAD is detached.'
    Assert-False ((Test-GitWorkspace -MainViaPr) -and $Config.IsMain($branch)) -ErrorText "Save-Topic stopped: git_workspace is main-via-pr and '$branch' is checked out. Work on a topic branch and open a pull request."

    $status = "$((Invoke-Executable 'git status --porcelain' -WorkingDirectory $RepositoryRoot -PassThru -Silent).Output)".Trim()
    if (-not $status) {
        Write-Message "Save-Topic: nothing to save on '$branch'."
        return [pscustomobject]@{ Branch = $branch; Saved = $false; Message = $Message }
    }

    Invoke-Executable 'git add -A' -WorkingDirectory $RepositoryRoot -Silent | Out-Null
    $quoted = '"' + ($Message -replace '"', '\"') + '"'
    Invoke-Executable "git commit -m $quoted" -WorkingDirectory $RepositoryRoot -Silent | Out-Null
    Write-Message "Save-Topic: committed the changes on '$branch'."
    [pscustomobject]@{ Branch = $branch; Saved = $true; Message = $Message }
}
