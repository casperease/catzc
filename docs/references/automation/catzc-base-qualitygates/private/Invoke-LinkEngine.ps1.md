---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Invoke-LinkEngine.ps1.md
    kind: reference
    body_sha: "9f1bc2e6642d"
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Invoke-LinkEngine.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one place Format-Links and Test-Links assemble the engine, so the aligner and the gate can never disagree:
the ADR citation map (Get-AdrCitationMap), the line limits (Get-LinkLineLimit over .editorconfig and links.yml),
the default limit, the wrap mode, this repository's web URL (Get-RepositoryWebUrl), the string-citation check's
exempt globs (links.yml string_citations), and the paths git tracks, so a
markdown link to a file GitHub does not have is reported. Any other root (a test's scratch root) has no tracked
set to compare against, so the tracked check is skipped there. Reads only — the result
carries each changed file's new text for the caller to write.
```
