<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Git/Push-Dirty.ps1
    name: push-dirty
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Git
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-git/Push-Dirty.ps1.md
    test: automation/Catzc.Base.Git/tests/Push-Dirty.Tests.ps1
    cites:
      - ADR-AUTO-DRYRUN#2
      - ADR-DSGN-LIFE#11
  config:
    synopsis: |-
      Lands the working tree on the server with one fast push: stage everything, commit, push, never force.
    description: |-
      The fast push of [ADR-DSGN-LIFE#11](/docs/adr/design/commit-lifecycle.md#rule-adr-dsgn-life11). Stages every change when
      the tree is dirty, commits it with -Message (the editor's commit field; `...` when none is given), and pushes the current
      branch to origin. A tree with nothing to commit still pushes the commits that are waiting locally.

      It stops, changing nothing, in `main-via-pr` while standing on main/master (the `git_workspace` variant's one stop
      condition), and it never forces: a push the server rejects because main moved is reported and left for you to integrate
      by hand, since rebasing would build the commit on a tip that may be a dirty HEAD.
    parameters:
      Message: 'The commit message. Empty or omitted: `...`.'
      DryRun: 'Report what would be committed and pushed, and change nothing.'
    outputs: |-
      [pscustomobject] With -DryRun: @{ Branch; HasChanges; Message }. Otherwise nothing — the outcome is reported.
    examples:
      - Push-Dirty
      - Push-Dirty -Message 'Fix the loader'
      - Push-Dirty -DryRun
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
