---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/ConvertTo-Guid.ps1.md
    kind: comment-page
    body_sha: dd4f20ba1d37
---

# automation/Catzc.Base.QualityGates/ConvertTo-Guid.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The mint for readable placeholder GUIDs: each character maps to its closest hex look-alike (s→5, o→0,
i/l→1, z→2, g→6, t→7, q→9; a–f and digits pass through; anything else renders as 0, so one character is
always one digit and a human can decode the sentence positionally). Whitespace instead skips to the
GUID's next dash group, so each word lands in its own segment. The result is padded with zeros to 32
hex digits, truncated past 32, and formatted as a canonical lowercase GUID. The conversion is
deterministic and total — every non-empty input yields a valid [guid], down to the all-zeros GUID for
an input with no mappable characters.

Run by a human or an LLM to mint entries for the managed-GUID registry
(Catzc.Base.QualityGates/configs/guids.yml) — never called by production code. The engine is the native
type Catzc.Base.QualityGates.SentenceGuid.
```
