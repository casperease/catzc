<#
.SYNOPSIS
    Configures a fresh git clone with the local git settings this repository's workflow needs.
.DESCRIPTION
    Hooks up the clone-local git configuration right after a `git clone`, so the trunk-based flow
    works from the first pull and push:

    - pull.rebase true — a plain `git pull` rebases local commits (e.g. the importer janitor's
      generated-file sync commits) onto the remote head instead of failing with "You have divergent
      branches and need to specify how to reconcile them".
    - credential.helper — in a WSL session, points git at the Windows Git Credential Manager under
      /mnt/c, so an HTTPS push reuses the Windows-managed credentials instead of prompting for a
      username in the Linux shell.

    Every setting is written to the clone's local config (--local), never the user's global config,
    so nothing outside the named repository changes. Idempotent: a setting that already holds the
    desired value is left untouched, and re-running is always safe. Also reports when the git
    identity (user.name / user.email) resolves to nothing, with the exact commands to set it —
    commits (including the janitor's automatic ones) fail without an identity.
.PARAMETER Repository
    Path to the cloned repository to configure. Defaults to this repository's root, so the
    zero-argument call configures the clone the session runs from.
.PARAMETER DryRun
    Return the `git config` commands that would run, without executing them.
.OUTPUTS
    [string[]] Under -DryRun, the planned `git config` commands; otherwise nothing.
.EXAMPLE
    Initialize-GitClone
.EXAMPLE
    Initialize-GitClone ~/catzc -DryRun
#>
# Uses -DryRun, not ShouldProcess/-WhatIf — see docs/adr/automation/prefer-dryrun-over-shouldprocess.md#rule-adr-dryrun2.
function Initialize-GitClone {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string] $Repository = (Get-RepositoryRoot),

        [switch] $DryRun
    )

    Assert-Command git
    Assert-PathExist $Repository -PathType Container

    $workTree = Invoke-Executable 'git rev-parse --is-inside-work-tree' -WorkingDirectory $Repository -PassThru -NoAssert -Silent
    Assert-True ($workTree.ExitCode -eq 0) -ErrorText "'$Repository' is not a git repository. Clone first, then run Initialize-GitClone."

    # The desired clone-local settings. pull.rebase keeps a plain `git pull` working when local
    # commits (the janitor's generated-file syncs) diverge from the remote; the WSL credential
    # helper reuses the Windows credential store for HTTPS pushes.
    $settings = [ordered]@{ 'pull.rebase' = 'true' }
    if (Test-IsWslSession) {
        $credentialManager = Find-WindowsGitCredentialManager
        if ($credentialManager) {
            # git runs the helper value through sh, so spaces in the /mnt/c path must be escaped
            # inside the value itself.
            $settings['credential.helper'] = $credentialManager -replace ' ', '\ '
        }
        else {
            Write-Message 'WSL session, but no Windows Git Credential Manager was found under /mnt/c — credential.helper left unchanged'
        }
    }

    $planned = @()
    foreach ($key in $settings.Keys) {
        $value = $settings[$key]
        $current = Invoke-Executable "git config --local --get $key" -WorkingDirectory $Repository -PassThru -NoAssert -Silent
        if ($current.ExitCode -eq 0 -and "$($current.Output)".Trim() -eq $value) {
            Write-Verbose "$key is already '$value' — skipping"
            continue
        }
        $planned += "git config --local $key `"$value`""
    }

    if ($DryRun) {
        return $planned
    }

    foreach ($command in $planned) {
        Invoke-Executable $command -WorkingDirectory $Repository
    }

    # An unset identity is not this function's to invent, but the very next commit (often the
    # janitor's) fails without one — so report the exact remediation instead of staying silent.
    foreach ($identityKey in @('user.name', 'user.email')) {
        $identity = Invoke-Executable "git config --get $identityKey" -WorkingDirectory $Repository -PassThru -NoAssert -Silent
        if ($identity.ExitCode -ne 0 -or -not "$($identity.Output)".Trim()) {
            Write-Message "git $identityKey is not set — commits will fail. Run: git config --global $identityKey `"<your $identityKey>`""
        }
    }

    if ($planned.Count) {
        Write-Message "Configured $($planned.Count) git setting(s) in '$Repository'"
    }
    else {
        Write-Message "Git clone at '$Repository' is already configured — nothing to change"
    }
}
