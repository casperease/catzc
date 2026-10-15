<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Remove-LinuxToolInstall.ps1
    kind: automation-function
    module: Catzc.Tooling.Core
    visibility: public
    relatives:
      page: docs/references/automation/catzc-tooling-core/Remove-LinuxToolInstall.ps1.md
      test: automation/Catzc.Tooling.Core/tests/Remove-LinuxToolInstall.Tests.ps1
    adrs:
      - ADR-AUTO-REMOVE#{6,7}
  config:
    synopsis: |-
      Evicts an off-config Linux install of a tool so the managed (user-space) build can win — the Linux
      counterpart to Remove-SystemInstallation (Windows).
    description: |-
      Given a tool's tools.yml config, removes an install that did NOT come from the tool's configured manager
      — the shadow that would otherwise take precedence over the managed build — by the mechanism that placed
      it ([ADR-AUTO-REMOVE#7](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove7)). In precedence order:

        1. an apt-owned binary   -> sudo apt-get remove -y <owning package>   (the one step that needs root)
        2. a uv-managed-Python package -> uv pip uninstall --system <name>    (user-space, uv-scoped)
        3. a stray binary on PATH      -> delete the file                     (user-space)

      The apt owner is resolved by 'dpkg -S <path>' (which package owns the resolved binary), so an apt
      'azure-cli' is caught even though az_cli's configured manager is uv — detection does not rely on the
      config naming an apt_package. Only the apt path asserts root; the uv-pip and stray-binary paths are
      user-space ([ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)).

      This is invoked from the Linux branch of a Remove-<Tool>, which owns the -Force dry-run guard and the
      managed-install refusal (Test-ExpectedPackageManager) — so this core is only ever reached for an
      off-config install, and just evicts it.
    parameters:
      Config: The tool's parsed tools.yml entry (from Get-ToolConfig).
    outputs: '[bool] — $true when an off-config install was removed, $false when there was nothing to remove.'
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
