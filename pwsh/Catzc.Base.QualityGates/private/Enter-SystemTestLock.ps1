<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Enter-SystemTestLock.ps1.md"
  warning: "Generated Header"
---
#>

function Enter-SystemTestLock {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $EntryPoint,

        [string] $RunDirectory,

        [string] $RepositoryRoot,

        [string] $Name = ('Global\catzc-system-tests-' + [Convert]::ToHexString(
                [System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes(
                        "$([Environment]::UserDomainName)\$([Environment]::UserName)".ToLowerInvariant())))),

        [string] $LockPath = $(if ($IsWindows) {
                Join-Path $env:LOCALAPPDATA 'catzc\test-runs\system-test-lock.json'
            }
            else {
                Join-Path $HOME '.local/share/catzc/test-runs/system-test-lock.json'
            })
    )

    $mutex = [System.Threading.Mutex]::new($false, $Name)
    $acquired = try {
        $mutex.WaitOne(0)
    }
    catch [System.Threading.AbandonedMutexException] {
        # The previous holder died owning the lock; the wait handle grants us ownership.
        Write-Message 'The previous system-test lock holder died owning it; ownership transferred.' -Verbose:($VerbosePreference -eq 'Continue')
        $true
    }

    if ($acquired) {
        Write-TestRunLockRecord -Path $LockPath -EntryPoint $EntryPoint -RunDirectory $RunDirectory -RepositoryRoot $RepositoryRoot
        return [pscustomobject]@{ Acquired = $true; Mutex = $mutex; LockPath = $LockPath; Holder = $null }
    }

    $mutex.Dispose()
    [pscustomobject]@{ Acquired = $false; Mutex = $null; LockPath = $null; Holder = (Get-TestRunLockHolder -Path $LockPath) }
}
