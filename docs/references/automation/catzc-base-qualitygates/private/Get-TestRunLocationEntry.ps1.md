---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestRunLocationEntry.ps1.md
    kind: comment-page
    body_sha: "02638bb4542f"
    adrs:
      - ADR-AUTO-TEST#30
    links: []
---

# automation/Catzc.Base.QualityGates/private/Get-TestRunLocationEntry.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The run seam ([ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30)) names the script
each worker dot-sources to load the modules: empty for
the source importer, the build's Import-Catzc.ps1 for the build run. A snapshot run (Enter-TestRunLocation)
must load from the snapshot so that every path a worker resolves — out/, .compiled, git — lands inside it
([ADR-AUTO-NOPWD](/docs/adr/automation/never-depend-on-pwd.md)):

- in place: the entry passes through unchanged;
- snapshot, source run: the snapshot's own importer, without janitors;
- snapshot, a run's own entry script: kept (it lives outside the repository), with every repository
  path among its arguments (the build run's RepositoryRoot) mapped into the snapshot.
```
