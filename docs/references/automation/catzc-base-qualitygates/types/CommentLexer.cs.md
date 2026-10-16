---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/CommentLexer.cs.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "43bd9672b6fc"
    adrs:
      - ADR-REPO-LINK#{1,6}
---

# automation/Catzc.Base.QualityGates/types/CommentLexer.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
Finds the comment spans of a source file — the only places a code link lives
([ADR-REPO-LINK#1](/docs/adr/repository/markdown-links.md#rule-adr-repo-link1)) — per language
family, by file extension:
  PowerShell (.ps1 .psm1 .psd1)   the real PowerShell tokenizer's Comment tokens (line comments and <# #> blocks)
  C family   (.cs .bicep)         // and /* */ (/// included), skipping string, verbatim, raw, and char literals
  Hash       (.yml .yaml)         # at line start or after whitespace, outside quoted scalars and block scalars
  XML        (.csproj .props .targets)  <!-- -->
It also returns the string-literal spans, which hold docs paths and citations as data
([ADR-REPO-LINK#6](/docs/adr/repository/markdown-links.md#rule-adr-repo-link6)): PowerShell's string tokens, C#'s
and Bicep's string literals (regular, verbatim, interpolated, raw), and a YAML line's text outside its comment.
Spans are (Start, Length) offsets into the text, in document order.
```

## comment:2

Above `public static IReadOnlyList<(int Start, int Length)> Strings(string text,...`, written with `//`.

```text
The string-literal spans of any code file, quotes included: PowerShell's string tokens, the C family's
literals, and each YAML line's non-blank text outside its comment (a YAML value is data however it is quoted).
Empty for XML, whose text is not code.
```

## comment:3

Above `static IReadOnlyList<(int, int)> CFamily(string text, string extension, bool...`, written with `//`.

```text
The C family's comment spans (wantComments) or string-literal spans (otherwise), from one scan that skips each
kind while it looks for the other.
```

## comment:4

Above `public static string LineMarker(string comment)`, written with `//`.

```text
The comment family's line marker for a span, used to continue a wrapped line comment: '///', '//', '#',
or null for a block comment (<# #>, /* */, <!-- -->), whose continuation is plain indentation.
```
