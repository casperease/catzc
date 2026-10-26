# pwsh/Tooling.Core/Remove-LinuxToolInstall.ps1

The Linux platform core of the tool-removal lifecycle: it evicts an install that did not come from a tool's configured manager, so the
managed user-space build can win.

## help

### synopsis

Evicts an off-config Linux install of a tool so the managed (user-space) build can win — the Linux counterpart to Remove-SystemInstallation
(Windows).

### description

Given a tool's tools.yml config, removes an install that did NOT come from the tool's configured manager — the shadow that would otherwise
take precedence over the managed build — by the mechanism that placed it
([ADR-AUTO-REMOVE-THREEPLATFORMCORES](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-threeplatformcores)). In
precedence order:

1. an apt-owned binary -> sudo apt-get remove -y `<owning package>` (the one step that needs root)
2. a uv-managed-Python package -> uv pip uninstall --system `<name>` (user-space, uv-scoped)
3. a stray binary on PATH -> delete the file (user-space)

The apt owner is resolved by 'dpkg -S `<path>`' (which package owns the resolved binary), so an apt 'azure-cli' is caught even though
az_cli's configured manager is uv — detection does not rely on the config naming an apt_package. Only the apt path asserts root; the uv-pip
and stray-binary paths are user-space
([ADR-AUTO-REMOVE-ELEVATIONBYMECHANISM](../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-elevationbymechanism)).

This is invoked from the Linux branch of a `Remove-<Tool>`, which owns the -Force dry-run guard and the managed-install refusal
(Test-ExpectedPackageManager) — so this core is only ever reached for an off-config install, and just evicts it.

### parameter `Config`

The tool's parsed tools.yml entry (from Get-ToolConfig).

### outputs

`[bool]` — $true when an off-config install was removed, $false when there was nothing to remove.

## The apt-owned shadow

`dpkg -S` names the package that owns the resolved binary, which holds across the config's own manager: an apt `azure-cli` owns
`/usr/bin/az` even though az_cli is a uv tool. Removing it is the one step that needs root.
