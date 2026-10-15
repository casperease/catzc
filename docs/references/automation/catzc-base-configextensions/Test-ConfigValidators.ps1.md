---
catzc:
  derived:
    path: docs/references/automation/catzc-base-configextensions/Test-ConfigValidators.ps1.md
    kind: comment-page
    body_sha: "0ea875bdfe1b"
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-DSGN-RUNMODE#2
    links: []
---

# automation/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the
PowerShell validator convention of Invoke-ConfigValidator: a validator is found by name — the
Assert-<TitleCase(name)>Config of the module that ships configs/<name>.yml — so a validator whose name maps to
no shipped config is never called. It lists every such orphan.

It walks the module folders of the loaded code root (Get-CatzcModulesRoot), so it checks the shipped configs of
whichever tree the modules were loaded from — the source tree or a built package
([ADR-DSGN-RUNMODE#2](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode2)) — and reads each loaded module's own
validators from its scope (private functions are scope-isolated, so a module lists only its own).
```
