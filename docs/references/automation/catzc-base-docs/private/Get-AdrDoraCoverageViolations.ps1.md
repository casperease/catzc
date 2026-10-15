---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-AdrDoraCoverageViolations.ps1.md
    kind: comment-page
    body_sha: c02604046f10
---

# automation/Catzc.Base.Docs/private/Get-AdrDoraCoverageViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Every domain outside the exempt list keeps one DORA file (dora_coverage.file, default dora-explains.md) with one `## ` section per
ADR of the domain, the authoring conventions of the ADR index. A section links an ADR when any markdown link in it resolves to the
ADR's file (Resolve-AdrLinkTarget). This collects a finding when a rule set's ADR is linked from no section, or from more than one,
and when the DORA file itself is missing. A rule set with no file, or several, is a finding of Test-AdrRegistry and is skipped here,
and so is one whose ADR lies in a folder the settings exempt (exempt_folders): a vendor-checklist ADR is grounded in the vendor's
reference, not in DORA.

Private helper for Test-AdrRegistry; not exported.
```
