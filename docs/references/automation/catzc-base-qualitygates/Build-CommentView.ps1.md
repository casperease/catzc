---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Build-CommentView.ps1.md
    kind: reference
    body_sha: "806e1e4b5fae"
    adrs:
      - ADR-PRIN-ONELIVE#1
      - ADR-REPO-OUTDIR#1
---

# automation/Catzc.Base.QualityGates/Build-CommentView.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The inverse of Export-Comments. A file keeps one residue per long comment and the prose lives once, in the file's
comment page ([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)); the view
is the generated, gitignored copy a reader or an agent opens to see a file with its comments inline. It is written
under comments.yml's `view` folder in out/
([ADR-REPO-OUTDIR#1](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir1)), at the file's own
repository path, so `out/annotated/<path>` is the annotated `<path>`. Only files with residues get a view; a
residue whose section the page lacks stays as written (Test-Comments reports it).

Idempotent: a view whose content is current is not rewritten (Write-FileIfChanged), so a second run is a fast
no-op. A source-tree tool: it throws in build mode (Assert-SourceTree).
```
