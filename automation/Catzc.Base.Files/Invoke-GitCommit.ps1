<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Files/Invoke-GitCommit.ps1
    kind: function
    module: Catzc.Base.Files
    visibility: public
    adrs:
      - ADR-AUTO-DRYRUN
      - ADR-AUTO-IDEM
      - ADR-AUTO-PRELOG
---
#>

<#
.SYNOPSIS
    Commits the changes under the given repository paths as one git commit.
.DESCRIPTION
    All policy (branch guards, CI detection, which paths to commit) belongs to the caller, never to this wrapper.
    [ADR-AUTO-IDEM](/docs/adr/automation/idempotent-state-functions.md),
    [ADR-AUTO-PRELOG](/docs/adr/automation/log-before-invoke.md)
    [comment:1](/docs/references/automation/catzc-base-files/Invoke-GitCommit.ps1.md#comment1)
.PARAMETER Path
    The repository-relative, '/'-separated paths (files or folders) whose changes make up the commit.
.PARAMETER Message
    The commit message. Double quotes are rejected — the message is embedded in a quoted command string.
.PARAMETER DryRun
    Skips even the status check, so a dry run lists both commands whether or not anything changed.
    [ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md)
    [comment:2](/docs/references/automation/catzc-base-files/Invoke-GitCommit.ps1.md#comment2)
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
