<#
.SYNOPSIS
    Stops the processes holding a file open, so the file can be deleted — the type-cache kill switch.
.DESCRIPTION
    Asks Get-FileLockingProcess who holds the file and stops each holder, waiting briefly for it to exit so its...
    [comment:1](/docs/references/automation/catzc-base-typessystem/private/Stop-FileLockingProcess.ps1.md#comment1)
.PARAMETER Path
    The file whose holders to stop.
.OUTPUTS
    None.
#>
function Stop-FileLockingProcess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    $holders = @(Get-FileLockingProcess $Path)
    if ($holders.Count -eq 0) {
        return
    }

    # This session and its ancestors are never stopped; a cycle guard keeps a reused parent PID from looping.
    $protected = [System.Collections.Generic.HashSet[int]]::new()
    $process = Get-Process -Id $PID
    while ($process -and $protected.Add($process.Id)) {
        $process = $process.Parent
    }

    $name = [System.IO.Path]::GetFileName($Path)
    foreach ($holder in $holders) {
        if ($protected.Contains($holder.ProcessId)) {
            Write-Message "Not stopping $holder — it is this session or one of its parents, and holds $name. Close it yourself." -ForegroundColor Yellow
            continue
        }
        Write-Message "Stopping $holder — it holds $name." -ForegroundColor Yellow
        try {
            Stop-Process -Id $holder.ProcessId -Force -ErrorAction Stop
            Wait-Process -Id $holder.ProcessId -Timeout 10 -ErrorAction SilentlyContinue
        }
        catch [Microsoft.PowerShell.Commands.ProcessCommandException] {
            # It exited between the lookup and the stop: the handle is released either way.
            continue
        }
        catch {
            Write-Message "Could not stop $holder — $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }
}
