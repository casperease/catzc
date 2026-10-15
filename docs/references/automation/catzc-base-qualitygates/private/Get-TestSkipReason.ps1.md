---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestSkipReason.ps1.md
    kind: reference
    body_sha: "3abad0db54c4"
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Get-TestSkipReason.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A test skipped with `Set-ItResult -Skipped -Because '<reason>'` carries an error record whose message
reads "is skipped, because <reason>"; this returns just "<reason>". A skip with no -Because (a bare
`Set-ItResult -Skipped`, or an `It -Skip`, which records no error at all) has no reason, so the function
returns 'no reason given'. Any other recorded message (e.g. Run.SkipRemainingOnFailure's "Skipped due to
previous failure at …") is returned verbatim. Feeds Write-TestAutomationSkipReport.
```

## comment:2

Above `if ($message -match 'because\s+(.+?)\s*$') {`.

```text
Set-ItResult renders "is skipped, because <reason>" — pull out the reason. Capture $Matches
immediately (it is clobbered by the next -match; see automatic-variable-pitfalls).
```
