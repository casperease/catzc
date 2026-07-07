<#
.SYNOPSIS
    Commits the changes under the given repository paths as one git commit.
.DESCRIPTION
    A thin, policy-free git wrapper: stages everything under -Path (modified, new, and deleted files —
    `git add -A`) and commits exactly those paths with the given message. All policy — branch guards,
    CI detection, which paths deserve auto-committing — belongs to the caller.

    Idempotent (see docs/adr/automation/idempotent-state-functions.md): `git commit` itself is not, so
    the wrapper checks first — when `git status --porcelain` reports nothing under -Path, it returns
    nothing and runs no side effect. Re-running after a successful commit is a quiet no-op.

    Both git invocations run through Invoke-Executable, so the exact commands are logged before they run
    (docs/adr/automation/log-before-invoke.md) and a non-zero exit throws.
.PARAMETER Path
    The repository-relative, '/'-separated paths (files or folders) whose changes make up the commit.
.PARAMETER Message
    The commit message. Double quotes are rejected — the message is embedded in a quoted command string.
.PARAMETER DryRun
    Return the planned command strings without touching git at all (not even the status check) — see
    docs/adr/automation/powershell/prefer-dryrun-over-shouldprocess.md.
.OUTPUTS
    [string] The new commit's full SHA; the planned commands with -DryRun; nothing when there was
    nothing to commit.
.EXAMPLE
    Invoke-GitCommit -Path 'automation/.compiled' -Message 'chore(repo): sync compiled types'
.EXAMPLE
    Invoke-GitCommit -Path 'automation/.compiled', 'out' -Message 'sync' -DryRun
#>
function Invoke-GitCommit {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Path,

        [Parameter(Mandatory)]
        [string] $Message,

        [switch] $DryRun
    )

    Assert-NotNullOrWhitespace $Message -ErrorText 'Invoke-GitCommit: the commit message must not be empty or whitespace.'
    Assert-False $Message.Contains('"') -ErrorText "Invoke-GitCommit: the commit message must not contain a double quote (got: $Message)."

    $quotedPaths = foreach ($item in $Path) {
        "`"$item`""
    }
    $pathSpec = $quotedPaths -join ' '
    $addCommand = "git add -A -- $pathSpec"
    $commitCommand = "git commit -m `"$Message`" -- $pathSpec"

    if ($DryRun) {
        return @($addCommand, $commitCommand)
    }

    # Nothing changed under the given paths -> nothing to do (the idempotent no-op).
    if (-not (Test-GitPathChanged $Path)) {
        return
    }

    Invoke-Executable $addCommand -PassThru | Out-Null
    Invoke-Executable $commitCommand -PassThru | Out-Null
    Get-GitCurrentCommit
}
