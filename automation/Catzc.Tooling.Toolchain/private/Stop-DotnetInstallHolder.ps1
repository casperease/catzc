<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/private/Stop-DotnetInstallHolder.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Tooling.Toolchain/tests/Stop-DotnetInstallHolder.Tests.ps1
    adrs:
      - ADR-PWSH-DRYRUN#1
  config:
    synopsis: Stops exactly the named processes that hold a .NET install open, then asserts the install is free.
    description: |-
      Stops each holder Get-DotnetInstallHolder named — by process id, nothing else — and waits for it to exit,
      so its handles on the install are released. A process that already exited is skipped. Refuses to stop the
      calling session itself. Throws when the install is still held afterwards (a process restarted, or a new
      holder appeared).
    parameters:
      InstallDir: The .NET install directory.
      Holder: The holders to stop, as Get-DotnetInstallHolder returned them.
---
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
