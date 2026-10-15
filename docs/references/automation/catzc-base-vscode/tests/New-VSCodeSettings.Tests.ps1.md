---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vscode/tests/New-VSCodeSettings.Tests.ps1.md
    kind: test-asset
    body_sha: fcc94a0953a0
    adrs:
      - ADR-PWSH-PESTER#2
---

# automation/Catzc.Base.VSCode/tests/New-VSCodeSettings.Tests.ps1

<!-- cspell:ignore gopls -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Mock Get-Config -ModuleName Catzc.Base.VSCode {`.

```text
Isolate through the config seam
([ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)): a small
fixture registry with an authored
search.exclude carrying an explicit un-exclude (false) that injection must not override.
```

## comment:2

Above `$text = New-VSCodeSettings -ManagedTarget 'go.work', '*/tests/*/go.mod'`.

```text
The managed Go targets (go.work and the generated go.mod files) are injected like every managed target;
the test code under either Go root must stay visible, searchable, watched, and loaded by gopls.
```
