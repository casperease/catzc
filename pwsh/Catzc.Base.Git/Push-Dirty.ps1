<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Git/Push-Dirty.ps1
    name: push-dirty
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Git
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Git/tests/Push-Dirty.Tests.ps1
    docs: "[Push-Dirty.ps1.md](docs/references/pwsh/catzc-base-git/Push-Dirty.ps1.md)"
    cites:
      - ADR-AUTO-DRYRUN-BRANCHBEFORESIDEEFFECT
      - ADR-FLOW-CD-LIFE-FASTPUSHLANDS
---
#>

function Push-Dirty {
    [CmdletBinding()]
    param(
        [string] $Message,

        [switch] $DryRun
    )

    Assert-Command git

    # The one place the empty-message default lives: an empty editor field or no -Message commits as '...'.
    if ([string]::IsNullOrWhiteSpace($Message)) {
        $Message = '...'
    }

    $branch = (Invoke-Executable 'git rev-parse --abbrev-ref HEAD' -PassThru -Silent).Output.Trim()
    if ($branch -eq 'HEAD') {
        throw 'Push-Dirty needs a named branch; HEAD is detached.'
    }
    if ((Test-GitWorkspace -MainViaPr) -and $branch -in 'main', 'master') {
        throw "Push-Dirty stopped: git_workspace is main-via-pr and '$branch' is checked out. Work on a branch and open a pull request."
    }

    $status = (Invoke-Executable 'git status --porcelain' -PassThru -Silent).Output
    $hasChanges = [bool] $status.Trim()

    if ($DryRun) {
        return [pscustomobject]@{
            Branch     = $branch
            HasChanges = $hasChanges
            Message    = $Message
        }
    }

    if ($hasChanges) {
        Invoke-Executable 'git add -A' | Out-Null
        $quotedMessage = '"' + ($Message -replace '"', '\"') + '"'
        Invoke-Executable "git commit -m $quotedMessage" | Out-Null
    }

    $push = Invoke-Executable "git push origin $branch" -PassThru -NoAssert
    if ($push.ExitCode -ne 0) {
        throw "Push rejected for '$branch' (the server's tip moved). Nothing was forced and the commit is kept locally; run 'git pull --rebase', then Push-Dirty again."
    }
    Write-Message "Pushed '$branch'."
}
