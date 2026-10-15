---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-MarkdownHeadingFinding.ps1.md
    kind: comment-page
    body_sha: ababb772c7ec
---

# automation/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A heading is plain words: a trailing parenthesized group that holds only code spans and separators — a file
name, a path, a citation such as (`ADR-AZ-DATAMOD`) — is moved out of the heading onto its own line directly
below it, the groups joined by ' · ' and a known citation code written as a relative link to its ADR. Code that
is the subject of a heading (`$Matches` — capture immediately) and a group holding prose stay in the heading. Every
heading's GitHub anchor is unique within its document. In a dora-explains.md file each H2 entry's DORA paragraph —
paraphrased research — opens the entry as a > blockquote, which renders as grey text.

Findings are Reference (a group moved out; the heading's anchor changes from From to To), Quote (a DORA paragraph
quoted), and Duplicate (an anchor used twice — the author rewords; no fix). Headings inside fenced code blocks and
YAML front matter are not headings; the H1 is the title and belongs to Get-MarkdownTitleFinding. Fixed is the
corrected file text, keeping the file's own line endings; it equals the input when there is nothing to fix.
```

## comment:2

Section `.PARAMETER Citation` of the comment-based help.

```text
Citation code -> repository-relative ADR path, for the links a moved citation becomes. A code not in it stays a
code span.
```

## comment:3

Above `$head = $Matches['head']`.

```text
Capture before the next -match overwrites $Matches
([ADR-PWSH-AUTOVAR](/docs/adr/pwsh/automatic-variable-pitfalls.md)).
```

## comment:4

Above `$head = $Matches['head']`.

```text
Capture before the next -match overwrites $Matches
([ADR-PWSH-AUTOVAR](/docs/adr/pwsh/automatic-variable-pitfalls.md)).
```
