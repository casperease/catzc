---
catzc:
  immutable:
    with_body_sha: dff933650ecc
    repo_status: locked
    path: docs/references/automation/catzc-tooling-core/Remove-LinuxToolInstall.ps1.md
    folder: docs/references/automation/catzc-tooling-core
    name: remove-linux-tool-install-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Tooling.Core/Remove-LinuxToolInstall.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Evicts an off-config Linux install of a tool so the managed (user-space) build can win — the Linux counterpart to Remove-SystemInstallation
(Windows).

### description

Given a tool's tools.yml config, removes an install that did NOT come from the tool's configured manager — the shadow that would otherwise
take precedence over the managed build — by the mechanism that placed it
([ADR-AUTO-REMOVE#7](../../../adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove7)). In precedence order:

1. an apt-owned binary -> sudo apt-get remove -y `<owning package>` (the one step that needs root)
2. a uv-managed-Python package -> uv pip uninstall --system `<name>` (user-space, uv-scoped)
3. a stray binary on PATH -> delete the file (user-space)

The apt owner is resolved by 'dpkg -S `<path>`' (which package owns the resolved binary), so an apt 'azure-cli' is caught even though
az_cli's configured manager is uv — detection does not rely on the config naming an apt_package. Only the apt path asserts root; the uv-pip
and stray-binary paths are user-space ([ADR-AUTO-REMOVE#6](../../../adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)).

This is invoked from the Linux branch of a `Remove-<Tool>`, which owns the -Force dry-run guard and the managed-install refusal
(Test-ExpectedPackageManager) — so this core is only ever reached for an off-config install, and just evicts it.

### parameter Config

The tool's parsed tools.yml entry (from Get-ToolConfig).

### outputs

`[bool]` — $true when an off-config install was removed, $false when there was nothing to remove.

## comment:1

Above `if (Test-Command dpkg) {`, written with `#`.

```text
1. apt-owned shadow — dpkg -S names the package that owns the resolved binary, robust across the config's
   own manager (an apt 'azure-cli' owns /usr/bin/az even though az_cli is a uv tool). apt needs root.
```
