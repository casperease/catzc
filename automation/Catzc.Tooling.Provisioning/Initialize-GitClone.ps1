# catzc:
#   path: automation/Catzc.Tooling.Provisioning/Initialize-GitClone.ps1
#   module: Catzc.Tooling.Provisioning
#   visibility: public

<#
.SYNOPSIS
    Configures a fresh git clone with the local git settings this repository's workflow needs.
.DESCRIPTION
    Writes only to the clone's local config, never the global one, and skips settings that already hold the value.
    [comment:1](/docs/references/automation/catzc-tooling-provisioning/Initialize-GitClone.ps1.md#comment1)
.PARAMETER Repository
    Defaults to this repository's root, so a call with no argument configures the clone the session runs from.
    [comment:2](/docs/references/automation/catzc-tooling-provisioning/Initialize-GitClone.ps1.md#comment2)
.PARAMETER DryRun
    Return the `git config` commands that would run, without executing them.
.OUTPUTS
    [string[]] Under -DryRun, the planned `git config` commands; otherwise nothing.
.EXAMPLE
    Initialize-GitClone
.EXAMPLE
    Initialize-GitClone ~/catzc -DryRun
#>
# The preview is a -DryRun switch that returns the git config commands, not ShouldProcess and -WhatIf.
# [ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2)
# [comment:3](/docs/references/automation/catzc-tooling-provisioning/Initialize-GitClone.ps1.md#comment3)
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

    # pull.rebase keeps git pull working when generated-file sync commits diverge from the remote head.
    # [comment:4](/docs/references/automation/catzc-tooling-provisioning/Initialize-GitClone.ps1.md#comment4)
    $settings = [ordered]@{ 'pull.rebase' = 'true' }
    if (Test-IsWslSession) {
        $credentialManager = Find-WindowsGitCredentialManager
        if ($credentialManager) {
            # git runs the helper value through sh, so a space in the /mnt/c path must be escaped in the value itself.
            # [comment:5](/docs/references/automation/catzc-tooling-provisioning/Initialize-GitClone.ps1.md#comment5)
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

    # An unset identity is reported, not invented, because the next commit, often the janitor's, fails without one.
    # [comment:6](/docs/references/automation/catzc-tooling-provisioning/Initialize-GitClone.ps1.md#comment6)
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
