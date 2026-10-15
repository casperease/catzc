<#
.SYNOPSIS
    Configures a fresh git clone with the local git settings this repository's workflow needs.
.DESCRIPTION
    Hooks up the clone-local git configuration right after a `git clone`, so the trunk-based flow works from the...
    [comment:1](/docs/references/automation/catzc-tooling-provisioning/Initialize-GitClone.ps1.md#comment1)
.PARAMETER Repository
    Path to the cloned repository to configure.
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
# Uses -DryRun, not ShouldProcess/-WhatIf — see.
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

    # The desired clone-local settings.
    # [comment:4](/docs/references/automation/catzc-tooling-provisioning/Initialize-GitClone.ps1.md#comment4)
    $settings = [ordered]@{ 'pull.rebase' = 'true' }
    if (Test-IsWslSession) {
        $credentialManager = Find-WindowsGitCredentialManager
        if ($credentialManager) {
            # git runs the helper value through sh, so spaces in the /mnt/c path must be escaped inside the value...
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

    # An unset identity is not this function's to invent, but the very next commit (often the janitor's) fails...
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
