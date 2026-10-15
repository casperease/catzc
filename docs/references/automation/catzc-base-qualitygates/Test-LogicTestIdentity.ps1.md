---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-LogicTestIdentity.ps1.md
    kind: comment-page
    body_sha: "7651be86e801"
---

# automation/Catzc.Base.QualityGates/Test-LogicTestIdentity.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$exactTokens = @($live.Values | Where-Object { $_.MatchMode -eq 'exact' } |...`.

```text
Parse only files that COULD carry a finding — a provable SUPERSET, so no leak is ever skipped. A finding
needs either an exact-match token as a string-literal value (which therefore appears word-bounded in the
source — `'apex'`, `-Customer apex`) or an ambiguous env/shortcode bound to an identity parameter (so the
parameter name is in the source). Every other file cannot match and is skipped parse-free — the AST parse
is the whole cost, and ~95% of the tree contains no live token at all, so this is a cheap text scan for
them. Word boundaries keep 2-char shortcodes (ap/nv/de/…) from matching inside ordinary words.
```
