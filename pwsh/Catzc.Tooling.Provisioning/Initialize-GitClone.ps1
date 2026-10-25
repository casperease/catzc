<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-provisioning/Initialize-GitClone.ps1.md"
  warning: "Generated Header"
---
#>

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

    $settings = [ordered]@{ 'pull.rebase' = 'true' }
    if (Test-IsWslSession) {
        $credentialManager = Find-WindowsGitCredentialManager
        if ($credentialManager) {
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
