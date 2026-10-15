---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/Get-FileLanguage.ps1.md
    kind: reference
    body_sha: "2d25d860d6d6"
    adrs:
      - ADR-DSGN-TRACK#6
---

# automation/Catzc.Base.Languages/Get-FileLanguage.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The file-language registry (configs/languages.yml, validated by the LanguagesConfig type) names each language a
tracked file is written in by its extensions ([ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)),
with the formatter engine that formats it (or why it has none) and its ADR folder. Each result is a FileLanguage,
in declared order.

-Path answers "which file language is this file?" by its extension, case-insensitively. A file whose extension no
language lists, a file with no extension, and a dotfile such as .gitkeep return nothing; -Path never throws.
```
