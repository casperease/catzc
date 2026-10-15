---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Invoke-FormatterEngine.ps1.md
    kind: comment-page
    body_sha: "2310494cf066"
    adrs:
      - ADR-PRIN-CONFIG#2
---

# automation/Catzc.Base.QualityGates/private/Invoke-FormatterEngine.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one place an engine name from languages.yml becomes code: each engine LanguagesConfig.FormatterEngines declares
has exactly one adapter here, and every adapter takes the same -File and -DryRun and returns the changed files
([ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2)). A language is never
named here — which language uses which engine is configuration.
```
