<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Toolchain/private/Stop-DotnetInstallHolder.ps1
    folder: private
    name: stop-dotnet-install-holder
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Tooling.Toolchain/tests/Stop-DotnetInstallHolder.Tests.ps1
    cites:
      - ADR-PWSH-DRYRUN#1
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
