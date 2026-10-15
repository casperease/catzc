<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/private/Stop-DotnetInstallHolder.ps1
    kind: function
    module: Catzc.Tooling.Toolchain
    visibility: private
    adrs:
      - ADR-PWSH-DRYRUN#1
---
#>

<#
.SYNOPSIS
    Stops exactly the named processes that hold a .NET install open, then asserts the install is free.
.DESCRIPTION
    The calling session is never stopped, and it throws when the install is still held afterwards.
    [comment:1](/docs/references/automation/catzc-tooling-toolchain/private/Stop-DotnetInstallHolder.ps1.md#comment1)
.PARAMETER InstallDir
    The .NET install directory.
.PARAMETER Holder
    The holders to stop, as Get-DotnetInstallHolder returned them.
#>
function Stop-DotnetInstallHolder {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Private step of Uninstall-Dotnet, whose -Force is the confirmation — see ADR-PWSH-DRYRUN#1')]
    param(
        [Parameter(Mandatory)]
        [string] $InstallDir,

        [Parameter(Mandatory)]
        [Catzc.Base.Files.FileLockingProcess[]] $Holder
    )

    foreach ($process in $Holder) {
        Assert-False ($process.ProcessId -eq $PID) -ErrorText "Stop-DotnetInstallHolder: this session (PID $PID) holds '$InstallDir' open; uninstall .NET from another shell."
    }

    foreach ($process in $Holder) {
        Write-Message "Stopping $process — it holds '$InstallDir' open"
        $running = Get-Process -Id $process.ProcessId -ErrorAction Ignore
        if ($null -eq $running) {
            continue
        }
        Stop-Process -Id $process.ProcessId -Force
        $running.WaitForExit(10000) | Out-Null
    }

    $remaining = @(Get-DotnetInstallHolder -InstallDir $InstallDir)
    if ($remaining.Count -gt 0) {
        throw "Stop-DotnetInstallHolder: '$InstallDir' is still held open after stopping the named processes, by: $(($remaining | ForEach-Object { "$_" }) -join '; ')"
    }
}
