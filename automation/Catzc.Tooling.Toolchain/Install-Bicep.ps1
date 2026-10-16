<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Install-Bicep.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Tooling.Toolchain/tests/Install-Bicep.Tests.ps1
    adrs:
      - ADR-AUTO-PKGMGR
      - ADR-REPO-FORMAT#8
  config:
    synopsis: Installs the Bicep CLI, the formatter engine for the infrastructure templates, at the tools.yml pin.
    description: |-
      The Bicep CLI is the `bicep` engine Format-Code runs over every .bicep file (languages.yml;
      [ADR-REPO-FORMAT#8](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8)). Windows and macOS delegate to
      Install-Tool: winget Microsoft.Bicep as a user-scope portable (no admin), or brew from Microsoft's tap
      ([ADR-AUTO-PKGMGR](/docs/adr/automation/use-proper-package-managers.md)). Linux has no distribution package, so it
      installs the release binary, verified against its published SHA-256, into ~/.local/bin (Install-BicepStandalone).
      Idempotent: a Bicep CLI already at the pinned version is left alone; another version throws unless -Force.
    parameters:
      Version: 'The version prefix to install. Default: the tools.yml pin.'
      Force: Replace an installed Bicep CLI at another version.
    examples:
      - Install-Bicep
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
