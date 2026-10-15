---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/tests/Get-AutoControlledGlobs.Tests.ps1.md
    kind: test-asset
    body_sha: efa00fc12aab
    adrs:
      - ADR-REPO-OUTDIR#10
---

# automation/Catzc.Base.Git/tests/Get-AutoControlledGlobs.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Mock Get-Config {`.

```text
A fixture registry: one gitignored managed target (belongs in the whitelist), one committed
managed target (importer.ps1-shaped — must NOT be whitelisted), one not opted in.
```

## comment:2

Above `& $isControlled 'out/plan-widget.md' | Should -BeFalse`.

```text
the authored plan files are working notes, not output
([ADR-REPO-OUTDIR#10](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir10))
```
