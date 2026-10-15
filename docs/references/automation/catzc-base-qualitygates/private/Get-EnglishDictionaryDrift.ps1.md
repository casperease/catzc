---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-EnglishDictionaryDrift.ps1.md
    kind: comment-page
    body_sha: "352437cdf174"
    adrs: []
    links: []
---

# automation/Catzc.Base.QualityGates/private/Get-EnglishDictionaryDrift.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Build-EnglishDictionary's -DryRun re-flattens cspell's bundled tries (node, npx, cspell), so the drift check
reads the committed artifact's stamp instead: the gz and its stamp both exist, the stamp's cspell version
matches the pinned cspell version, and the stamp's word count matches the gz's line count. Each failure is
one reason; none means the list is current. Test-GeneratedFiles turns each reason into one issue.
```
