<#
---
catzc:
  immutable:
    with_body_sha: af916832e28c
  edges:
    test: pwsh/Catzc.Base.Files/tests/Get-FileLockingProcess.Tests.ps1
    docs: "[Get-FileLockingProcess.ps1.md](docs/references/pwsh/catzc-base-files/Get-FileLockingProcess.ps1.md)"
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
