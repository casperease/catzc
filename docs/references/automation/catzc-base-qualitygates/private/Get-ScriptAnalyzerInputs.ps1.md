---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-ScriptAnalyzerInputs.ps1.md
    kind: comment-page
    body_sha: "6ed252390d0f"
    adrs:
      - ADR-AUTO-CACHE#10
---

# automation/Catzc.Base.QualityGates/private/Get-ScriptAnalyzerInputs.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The analyzer's result cache keys each file on its SHA-256 and a stamp of these inputs
([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)), so this list must hold everything the
analysis loads: the settings file; every file of the custom rules (automation/.scriptanalyzer, the settings'
CustomRulePath); the vendored analyzer's module manifests, which name its version; and what the spelling rule's
oracle reads — the English word list, the generated terminology dictionaries (.cspell/*.txt) and the oracle's own
source. A rule that starts reading another file adds it here in the same change.
```
