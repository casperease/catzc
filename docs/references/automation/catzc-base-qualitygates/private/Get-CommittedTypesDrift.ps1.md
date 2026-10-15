---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-CommittedTypesDrift.ps1.md
    kind: comment-page
    body_sha: "6ae863aefb0b"
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Get-CommittedTypesDrift.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The build ships the committed automation/.compiled/Catzc.Types.<hash>.dll by copy, so that file must be the
assembly of the current type sources: exactly one Catzc.Types.*.dll, named for the combined hash of the
sources (Get-CombinedTypeHash, the one implementation the loader and the janitor share), and no pending git
change under automation/.compiled — the importer rebuilds the DLL when a types/*.cs changes, and a rebuild
that was not committed shows there. Each failure is one reason; none means the committed assembly is current.
```
