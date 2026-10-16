---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/tests/Get-AutoControlledGlobs.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "6f452770e0e3"
    adrs:
      - ADR-REPO-OUTDIR#10
---

# automation/Catzc.Base.Git/tests/Get-AutoControlledGlobs.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Get-Config {`, written with `#`.

```text
A fixture registry: one gitignored managed target (belongs in the whitelist), one committed
managed target (importer.ps1-shaped — must NOT be whitelisted), one not opted in.
```

## comment:2

Above `& $isControlled 'out/plan-widget.md' | Should -BeFalse`, written with `#`.

```text
the authored plan files are working notes, not output
([ADR-REPO-OUTDIR#10](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir10))
```
