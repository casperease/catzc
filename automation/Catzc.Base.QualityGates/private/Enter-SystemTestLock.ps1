<#
.SYNOPSIS
    Tries, without waiting, to take the user's system-test lock — the right to run L3 on this account.
.DESCRIPTION
    L3 holds the vertical system tests, which change state outside the repository: the user's PATH and other...
    [ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33),
    [ADR-AUTO-TEST#32](/docs/adr/automation/test-automation.md#rule-adr-auto-test32)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Enter-SystemTestLock.ps1.md#comment1)
.PARAMETER EntryPoint
    The entry point taking the lock — written to the lock record.
.PARAMETER RunDirectory
    The run's report folder — written to the lock record.
.PARAMETER RepositoryRoot
    The run's working folder — written to the lock record, so the holder's checkout can be named.
.PARAMETER Name
    The mutex name. Defaults to the current user's: Global\catzc-system-tests-<hash of domain\user>.
.PARAMETER LockPath
    The lock record.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Enter-SystemTestLock.ps1.md#comment2)
.OUTPUTS
    [pscustomobject] Acquired ([bool]), Mutex (owned, or $null), LockPath (the record this run wrote, or $null),
    and Holder (Get-TestRunLockHolder's description of who holds it, or $null).
.EXAMPLE
    $lock = Enter-SystemTestLock -EntryPoint 'Test-Automation' -RunDirectory $runDir -RepositoryRoot $root
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
