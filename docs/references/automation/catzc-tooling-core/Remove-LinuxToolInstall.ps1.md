---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Remove-LinuxToolInstall.ps1.md
    kind: comment-page
    body_sha: e7f56c08c16b
    adrs:
      - ADR-AUTO-REMOVE#6
      - ADR-AUTO-REMOVE#7
---

# automation/Catzc.Tooling.Core/Remove-LinuxToolInstall.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
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
```

## comment:2

Above `if (Test-Command dpkg) {`.

```text
1. apt-owned shadow — dpkg -S names the package that owns the resolved binary, robust across the config's
   own manager (an apt 'azure-cli' owns /usr/bin/az even though az_cli is a uv tool). apt needs root.
```

## comment:3

Above `if (Test-Command dpkg) {`.

```text
1. apt-owned shadow — dpkg -S names the package that owns the resolved binary, robust across the config's
   own manager (an apt 'azure-cli' owns /usr/bin/az even though az_cli is a uv tool). apt needs root.
```
