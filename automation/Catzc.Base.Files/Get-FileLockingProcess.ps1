<#
.SYNOPSIS
    Lists the processes that hold a file open (lock it).
.DESCRIPTION
    Asks the Windows Restart Manager which processes hold the file — the same API behind Explorer's "file in
    use by …" dialog. It needs no admin rights and sees both an open handle and a loaded (mapped) DLL, so it
    names the session holding a stale assembly. Each holder is enriched with its executable name, command
    line, parent process and owner; a process that exits between the two lookups keeps only the Restart
    Manager's facts (id, app name, start time).

    File locking is mandatory on Windows but advisory on Linux/macOS, where an open file blocks neither a
    delete nor a rename — so there is no holder to report and this returns nothing there (matching
    Test-FileIsLocked, which reports $false).
.PARAMETER Path
    Path to the file whose holders to list.
.OUTPUTS
    [Catzc.Base.Files.FileLockingProcess] per holding process; nothing when the file is not held.
.EXAMPLE
    Get-FileLockingProcess $dllPath
.EXAMPLE
    Get-FileLockingProcess $dllPath | ForEach-Object { "$_" }   # "pwsh.exe (PID 10276, started 2026-10-13 14:10)"
#>
function Get-FileLockingProcess {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Files.FileLockingProcess])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    Assert-PathExist $Path -PathType Leaf

    if (-not $IsWindows) {
        return
    }

    $fullPath = [System.IO.Path]::GetFullPath($Path)
    foreach ($holder in [Catzc.Base.Files.RestartManager]::GetHolders($fullPath)) {
        $process = Get-CimInstance -ClassName Win32_Process -Filter "ProcessId=$($holder.ProcessId)"
        if (-not $process) {
            $holder   # exited between the lookups — the Restart Manager's facts are all there is
            continue
        }
        $owner = Invoke-CimMethod -InputObject $process -MethodName GetOwner
        $user = if ($owner.ReturnValue -eq 0) {
            "$($owner.Domain)\$($owner.User)"
        }
        else {
            $null
        }
        [Catzc.Base.Files.FileLockingProcess]::new(
            $holder.ProcessId, $process.Name, $holder.AppName, $holder.Started,
            $process.CommandLine, [int] $process.ParentProcessId, $user)
    }
}
