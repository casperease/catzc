---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vscode/tests/New-VSCodeSettings.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "81d5682c3de1"
    adrs:
      - ADR-PWSH-PESTER#2
---

# automation/Catzc.Base.VSCode/tests/New-VSCodeSettings.Tests.ps1

<!-- cspell:ignore gopls -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Get-Config -ModuleName Catzc.Base.VSCode {`, written with `#`.

```text
Isolate through the config seam
([ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)): a small
fixture registry with an authored
search.exclude carrying an explicit un-exclude (false) that injection must not override.
```

## comment:2

Above `$text = New-VSCodeSettings -ManagedTarget 'go.work', '*/tests/*/go.mod'`, written with `#`.

```text
The managed Go targets (go.work and the generated go.mod files) are injected like every managed target;
the test code under either Go root must stay visible, searchable, watched, and loaded by gopls.
```
