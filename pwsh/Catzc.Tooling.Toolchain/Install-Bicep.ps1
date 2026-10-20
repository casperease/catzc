<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Toolchain/Install-Bicep.ps1
    name: install-bicep
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Tooling.Toolchain/tests/Install-Bicep.Tests.ps1
    docs: "[Install-Bicep.ps1.md](docs/references/pwsh/catzc-tooling-toolchain/Install-Bicep.ps1.md)"
    cites:
      - ADR-AUTO-PKGMGR
      - ADR-REPO-FORMAT-CONFIGUREDFORMATTERS
---
#>

function Install-Bicep {
    [CmdletBinding()]
    param(
        [string] $Version = (Get-ToolConfig -Tool 'bicep').version,

        [switch] $Force
    )

    if (-not $IsLinux) {
        # Windows / macOS: Install-Tool (winget / brew).
        Install-Tool -Tool 'bicep' -Version $Version -Force:$Force
        return
    }

    $probe = Test-Tool 'bicep' -PassThru
    if ($probe.Version -and $probe.Version.StartsWith($Version)) {
        Write-Message "Bicep CLI $Version is already installed at '$($probe.Path)'"
        return
    }
    if ($probe.Version -and -not $Force) {
        throw "Bicep CLI version mismatch: expected $Version.x, found $($probe.Version) at '$($probe.Path)'. Run Install-Bicep -Force to replace."
    }
    Install-BicepStandalone -Version $Version
    Add-PermanentPath (Join-Path $env:HOME '.local/bin') -Label 'Install-Bicep'

    $probe = Test-Tool 'bicep' -PassThru
    if (-not ($probe.Version -and $probe.Version.StartsWith($Version))) {
        throw "The Bicep CLI was installed to ~/.local/bin but the check found $($probe.Version ?? 'no version') at '$($probe.Path ?? 'no path')'. Restart your shell, then run Test-Tool bicep -PassThru | Write-ToolProbeReport."
    }
}
