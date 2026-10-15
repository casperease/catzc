---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Remove-AzCli.ps1.md
    kind: comment-page
    body_sha: "39b1a79205ff"
    adrs:
      - ADR-AUTO-REMOVE#3
      - ADR-AUTO-REMOVE#4
      - ADR-AUTO-REMOVE#5
      - ADR-AUTO-REMOVE#6
---

# automation/Catzc.Tooling.Toolchain/Remove-AzCli.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Removes an Azure CLI installed OUTSIDE the tooling system — the destructive `Remove-` verb of the tool
lifecycle ([ADR-AUTO-REMOVE](/docs/adr/automation/tool-removal-lifecycle.md)). Refuses a managed install and
redirects to Uninstall-AzCli
([ADR-AUTO-REMOVE#3](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove3)). Per platform:

  - Windows: delete the MSI install folder and strip it from the machine PATH (needs Administrator).
  - Linux: evict via the mechanism that placed it — apt package / uv-Python pip / stray binary
    (Remove-LinuxToolInstall); elevation is scoped to the mechanism
    ([ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)).

-Force confirms the destructive action; without it the plan is reported and nothing changes
([ADR-AUTO-REMOVE#4](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove4)).
Usually reached through the escalation `Uninstall-AzCli -Remove -Force`
([ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)).
```

## comment:2

Above `if (Test-ExpectedPackageManager -Config $config) {`.

```text
Gate: managed by our tooling system → refuse, redirect to Uninstall-AzCli
([ADR-AUTO-REMOVE#3](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove3)).
```

## comment:3

Above `if ($IsLinux -or $IsMacOS) {`.

```text
Unix: evict an off-config install by the mechanism that placed it (native package manager / uv-Python pip
/ stray binary); elevation is scoped to the mechanism
([ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)), so no admin assert
here.
```

## comment:4

Above `if (Test-ExpectedPackageManager -Config $config) {`.

```text
Gate: managed by our tooling system → refuse, redirect to Uninstall-AzCli
([ADR-AUTO-REMOVE#3](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove3)).
```

## comment:5

Above `if ($IsLinux -or $IsMacOS) {`.

```text
Unix: evict an off-config install by the mechanism that placed it (native package manager / uv-Python pip
/ stray binary); elevation is scoped to the mechanism
([ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)), so no admin assert
here.
```
