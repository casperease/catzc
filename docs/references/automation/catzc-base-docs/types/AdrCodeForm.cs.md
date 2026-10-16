---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/types/AdrCodeForm.cs.md
    folder: docs/references/automation/catzc-base-docs/types
    name: adr-code-form-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "4836b39ab8b8"
---

# automation/Catzc.Base.Docs/types/AdrCodeForm.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static class AdrCodeForm`, written with `//`.

```text
The minimal form of a set of ADR citations, and the parser that reads it back.

  ADR-<CODE>#5             one rule
  ADR-<CODE>#{1,3-5,9}     a group: numbers and ranges (a range is a run of three or more)
  ADR-<CODE>               no numbers: the whole ADR, every rule of it (or a domain), never grouped

Minimize takes the registry only to see when a code's rules are all present, and then writes the bare code: the whole ADR. A bare code
never changes meaning when the ADR gains a rule; without a registry no code is ever collapsed.
```

## comment:2

Above `public static IReadOnlyList<string> Minimize(string[] citations,...`, written with `//`.

```text
The fewest tokens that name exactly the citations given. Each input is a bare code or a single rule; duplicates collapse. A code whose
rules the registry declares, all present and none extra, is written as the bare code.
```
