<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-toolchain/Install-Bicep.ps1.md"
  warning: "Generated Header"
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
