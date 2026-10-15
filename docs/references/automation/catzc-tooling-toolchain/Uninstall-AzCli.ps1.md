---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Uninstall-AzCli.ps1.md
    kind: comment-page
    body_sha: "57b5cc51d797"
    adrs:
      - ADR-AUTO-ONEJOB#5
      - ADR-AUTO-REMOVE#4
      - ADR-AUTO-REMOVE#5
    links: []
---

# automation/Catzc.Tooling.Toolchain/Uninstall-AzCli.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Removes az's dedicated uv venv via Uninstall-UvVenvTool — the managed uninstall (idempotent, skips if not
installed). For an Azure CLI installed OUTSIDE the tooling system (a lingering machine-scope MSI, an apt
'azure-cli', a pip install), escalate with -Remove -Force: the managed uninstall runs best-effort and then
falls through to Remove-AzCli, which destructively evicts whatever the configured manager did not own
([ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)).
```

## comment:2

Section `.PARAMETER Remove` of the comment-based help.

```text
After the managed uninstall, escalate to Remove-AzCli to evict an off-config install the managed path
cannot touch. Pair with -Force to actually remove; -Remove alone reports the plan
([ADR-AUTO-REMOVE#4](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove4)).
```

## comment:3

Above `try {`.

```text
Managed uninstall best-effort. With -Remove a failure (a foreign install the manager cannot touch — the
exact case -Remove exists for) is logged and the escalation proceeds to Remove-AzCli; without -Remove it
propagates as a normal uninstall failure. Catching only under -Remove is the escalation's single stated
purpose, not general catch-and-continue
([ADR-AUTO-ONEJOB#5](/docs/adr/automation/single-responsibility-functions.md#rule-adr-auto-onejob5),
[ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)).
```
