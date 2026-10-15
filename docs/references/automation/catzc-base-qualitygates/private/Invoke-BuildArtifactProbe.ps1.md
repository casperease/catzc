---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Invoke-BuildArtifactProbe.ps1.md
    kind: comment-page
    body_sha: "8df1d2b7d77e"
    adrs:
      - ADR-AUTO-TEST#30
---

# automation/Catzc.Base.QualityGates/private/Invoke-BuildArtifactProbe.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Loaded assemblies and $env: are process-global, so a build is observed in its own child pwsh
([ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30)): the child dot-sources
<BuildRoot>/Import-Catzc.ps1 -RepositoryRoot <RepositoryRoot>, observes the session once, and writes the
observation to a JSON file — never stdout, so the importer's console lines cannot mix into it. The
observation names the two roots and the run mode; per loaded Catzc module its base folder, exported and
defined function names, and instance count; the internal modules' bases; the types assembly and an
accelerator; every shipped config read through Get-Config; a few calls into the modules; and whether Pester's
InModuleScope enters a built module. Test-BuildArtifact judges it.
```
