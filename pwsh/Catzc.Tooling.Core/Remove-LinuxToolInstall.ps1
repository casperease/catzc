<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Core/Remove-LinuxToolInstall.ps1
    name: remove-linux-tool-install
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Tooling.Core/tests/Remove-LinuxToolInstall.Tests.ps1
    docs: "[Remove-LinuxToolInstall.ps1.md](docs/references/pwsh/catzc-tooling-core/Remove-LinuxToolInstall.ps1.md)"
    cites:
      - ADR-AUTO-REMOVE-ELEVATIONFOLLOWSMECHANISM
      - ADR-AUTO-REMOVE-THREEPLATFORMCORES
---
#>

function Remove-LinuxToolInstall {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    if (-not (Test-Command $Config.command)) {
        Write-Message "No '$($Config.command)' on PATH — nothing to remove"
        return $false
    }

    $source = (Get-Command $Config.command).Source

    if (Test-Command dpkg) {
        $owner = Invoke-Executable "dpkg -S $source" -PassThru -NoAssert -Silent
        if ($owner.ExitCode -eq 0 -and $owner.Output) {
            $package = ($owner.Output -split ':', 2)[0].Trim()
            Assert-IsAdministrator -ErrorText "Removing the apt package '$package' (it owns '$source') needs root. Re-run elevated, or run 'sudo apt-get remove -y $package' by hand."
            Invoke-Executable "sudo apt-get remove -y $package"
            return $true
        }
    }

    # 2. uv-Python pip shadow, then 3. a stray binary — the shared user-space tail (also used by macOS).
    Remove-UvPipOrStrayInstall -Config $Config -Source $source
}
