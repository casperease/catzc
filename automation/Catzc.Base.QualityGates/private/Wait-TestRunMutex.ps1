<#
.SYNOPSIS
    Acquires the machine-wide test-run mutex for this repository and returns it, owned.
.DESCRIPTION
    One checkout, one test run: concurrent runs (a second Test-Automation, or an Invoke-TestFile launched
    mid-suite) share the real out/template build folders, the .compiled assembly, and .triggers/ — they
    wipe and lock files under each other, and every such collision reads as a flaky test. This is the one
    acquisition path both entry points use: a named [System.Threading.Mutex] keyed on the repository root
    (machine-wide via the Global\ namespace), awaited through Wait-Mutex — a short glitch leaves only a
    verbose breadcrumb, while a genuine wait announces itself and writes liveness dots (ADR-CONSOLE:10),
    and an abandoned mutex (the previous holder's process died mid-run) transfers ownership and is not an
    error. The caller MUST release and dispose the returned mutex in a finally.
.PARAMETER Reason
    Short label for the announcement when waiting (e.g. 'Test-Automation run', 'test file run').
.OUTPUTS
    [System.Threading.Mutex] the acquired (owned) mutex — or $null inside a worker whose parent run
    already holds the lock (CATZC_TEST_RUN_LOCK_HELD; acquiring would deadlock on our own parent).
    Callers release and dispose only a non-null return.
#>
function Wait-TestRunMutex {
    [CmdletBinding()]
    [OutputType([System.Threading.Mutex])]
    param(
        [string] $Reason = 'test run'
    )

    # A worker process of a run that holds the lock (the harness tests drive Invoke-TestFile for real from
    # inside a suite): the parent's ownership covers us — waiting here would deadlock on our own parent.
    if ($env:CATZC_TEST_RUN_LOCK_HELD -eq '1') {
        return $null
    }

    $mutexKey = [Convert]::ToHexString(
        [System.Security.Cryptography.SHA256]::HashData(
            [System.Text.Encoding]::UTF8.GetBytes((Get-RepositoryRoot).ToLowerInvariant())))
    $runMutex = [System.Threading.Mutex]::new($false, "Global\catzc-test-automation-$mutexKey")
    Wait-Mutex $runMutex -Name 'test-run mutex' -AnnounceText "Another test run is active on this repository — the $Reason waits for it to finish"

    $runMutex
}
