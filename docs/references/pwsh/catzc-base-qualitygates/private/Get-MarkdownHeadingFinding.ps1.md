# automation/pwsh/Catzc.Base.QualityGates/private/Get-MarkdownHeadingFinding.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Checks one Markdown file's H2–H6 headings against their normal form and returns the fixed text.

### description

A heading is plain words: a trailing parenthesized group that holds only code spans and separators — a file name, a path, a citation such as
(`ADR-AZ-DATAMOD`) — is moved out of the heading onto its own line directly below it, the groups joined by ' · ' and a known citation code
written as a relative link to its ADR. Code that is the subject of a heading (`$Matches` — capture immediately) and a group holding prose
stay in the heading. Every heading's GitHub anchor is unique within its document. In a dora-explains.md file each H2 entry's DORA paragraph
— paraphrased research — opens the entry as a > blockquote, which renders as grey text.

Findings are Reference (a group moved out; the heading's anchor changes from From to To), Quote (a DORA paragraph quoted), and Duplicate (an
anchor used twice — the author rewords; no fix). Headings inside fenced code blocks and YAML front matter are not headings; the H1 is the
title and belongs to Get-MarkdownTitleFinding. Fixed is the corrected file text, keeping the file's own line endings; it equals the input
when there is nothing to fix.

### parameter `RelativePath`

The file's repository-relative, '/'-separated path.

### parameter `Text`

The file's content.

### parameter `Citation`

Citation code -> repository-relative ADR path, for the links a moved citation becomes. A code not in it stays a code span.

### outputs

`[pscustomobject]` @{ Path; Findings; Fixed } — each finding is @{ Line; Kind; Actual; Expected; From; To }.

## comment:1

Above `$head = $Matches['head']`, written with `#`.

```text
Capture before the next -match overwrites $Matches
([ADR-PWSH-AUTOVAR](/docs/adr/automation/pwsh/automatic-variable-pitfalls.md)).
```
