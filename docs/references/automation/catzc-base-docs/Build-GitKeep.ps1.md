---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/Build-GitKeep.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: fc62cc6dc0b6
    adrs:
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Base.Docs/Build-GitKeep.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$outputRoot = [System.IO.Path]::Combine($repositoryRoot, 'out')`, written with `#`.

```text
Walk the tree for .gitkeep files, skipping git's own store and the vendored modules (not ours to
manage). The output root's own .gitkeep is checked, but its contents — transient artifacts that may
carry fixture copies — are never descended into. [System.IO] over cmdlets on this hot path
([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)); sorted for deterministic
output.
```
