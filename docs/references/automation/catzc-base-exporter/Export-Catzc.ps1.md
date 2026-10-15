---
catzc:
  derived:
    path: docs/references/automation/catzc-base-exporter/Export-Catzc.ps1.md
    kind: comment-page
    body_sha: "2dcad4b211ec"
    adrs:
      - ADR-AUTO-BUNDLE#6
    links: []
---

# automation/Catzc.Base.Exporter/Export-Catzc.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The top-level export ([ADR-AUTO-BUNDLE#6](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle6)). It builds
with Build-Modules (exporter.yml defaults; the build
parameters pass through) and delivers the build:
  - disk (default): the two-part install to -Root (Install-Catzc) — the build under <Root>/.vendor/Catzc/<version>/
    and a root importer.ps1 that enters it with <Root> as the working root;
  - nuget: the build folder packed with Compress-PSResource into <Get-OutputRoot>/automation/packages/, for a
    client to register as a local PSResource repository and Install-PSResource Catzc. Publishing beyond the
    local disk is the release workflow's act, never this function's.
```
