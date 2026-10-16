<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Enter-SystemTestLock.ps1
    folder: private
    name: enter-system-test-lock
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Enter-SystemTestLock.Tests.ps1
    cites:
      - ADR-AUTO-TEST#{32,33}
  config:
    synopsis: Tries, without waiting, to take the user's system-test lock — the right to run L3 on this account.
    description: |-
      L3 holds the vertical system tests, which change state outside the repository: the user's PATH and other
      persistent environment variables, the registry, installed tools
      ([ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33)). That state belongs to the
      user, not to a checkout, so the working folder's lock (one per checkout) cannot guard it: two clones — or a clone
      and an installed build — each own their own working folder and would run L3 against the same user state at
      once. This lock is keyed on the user instead: a named [System.Threading.Mutex], machine-wide through the
      Global\ namespace, tried with a zero timeout. A run never waits for it
      ([ADR-AUTO-TEST#32](/docs/adr/automation/test-automation.md#rule-adr-auto-test32)): taken, the run may
      run L3; held, it skips L3 and names the holder.

      Taken (or abandoned — the previous holder died mid-run), the holder writes its lock record
      (Write-TestRunLockRecord) to a per-user file, so a run from any checkout can say who holds the lock. The
      caller releases the lock through Exit-TestRunLocation.
    parameters:
      EntryPoint: The entry point taking the lock — written to the lock record.
      RunDirectory: The run's report folder — written to the lock record.
      RepositoryRoot: The run's working folder — written to the lock record, so the holder's checkout can be named.
      Name: 'The mutex name. Defaults to the current user''s: Global\catzc-system-tests-<hash of domain\user>.'
      LockPath: |-
        The lock record. Defaults to the per-user catzc folder (%LOCALAPPDATA%\catzc\test-runs on Windows,
        ~/.local/share/catzc/test-runs on Unix).
    outputs: |-
      [pscustomobject] Acquired ([bool]), Mutex (owned, or $null), LockPath (the record this run wrote, or $null),
      and Holder (Get-TestRunLockHolder's description of who holds it, or $null).
    examples:
      - '$lock = Enter-SystemTestLock -EntryPoint ''Test-Automation'' -RunDirectory $runDir -RepositoryRoot $root'
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
