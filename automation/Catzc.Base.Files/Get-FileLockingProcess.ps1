<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Files/Get-FileLockingProcess.ps1
    name: get-file-locking-process
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Files/tests/Get-FileLockingProcess.Tests.ps1
  config:
    synopsis: Lists the processes that hold a file open (lock it).
    description: |-
      Asks the Windows Restart Manager which processes hold the file — the same API behind Explorer's "file in
      use by …" dialog. It needs no admin rights and sees both an open handle and a loaded (mapped) DLL, so it
      names the session holding a stale assembly. Each holder is enriched with its executable name, command
      line and parent process (one CIM query for all holders); a process that exits between the two lookups
      keeps only the Restart Manager's facts (id, app name, start time).

      File locking is mandatory on Windows but advisory on Linux/macOS, where an open file blocks neither a
      delete nor a rename — so there is no holder to report and this returns nothing there (matching
      Test-FileIsLocked, which reports $false).
    parameters:
      Path: Path to the file whose holders to list.
    outputs: '[Catzc.Base.Files.FileLockingProcess] per holding process; nothing when the file is not held.'
    examples:
      - Get-FileLockingProcess $dllPath
      - 'Get-FileLockingProcess $dllPath | ForEach-Object { "$_" }   # "pwsh.exe (PID 10276, started 2026-10-13 14:10)"'
---
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

    $holders = [Catzc.Base.Files.RestartManager]::GetHolders([System.IO.Path]::GetFullPath($Path))
    if ($holders.Count -eq 0) {
        return
    }

    # One CIM query for every holder — a per-process query (or a per-process GetOwner call) costs ~100 ms each.
    $filter = ($holders | ForEach-Object { "ProcessId=$($_.ProcessId)" }) -join ' OR '
    $processes = @{}
    foreach ($process in (Get-CimInstance -ClassName Win32_Process -Filter $filter -Property ProcessId, Name, CommandLine, ParentProcessId)) {
        $processes[[int] $process.ProcessId] = $process
    }

    foreach ($holder in $holders) {
        $process = $processes[$holder.ProcessId]
        if (-not $process) {
            $holder   # exited between the lookups — the Restart Manager's facts are all there is
            continue
        }
        [Catzc.Base.Files.FileLockingProcess]::new(
            $holder.ProcessId, $process.Name, $holder.AppName, $holder.Started,
            $process.CommandLine, [int] $process.ParentProcessId)
    }
}
