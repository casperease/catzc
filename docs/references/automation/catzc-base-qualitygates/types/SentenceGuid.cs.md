---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/SentenceGuid.cs.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "51dd46d868f0"
    adrs:
      - ADR-PWSH-TYPES#1
---

# automation/Catzc.Base.QualityGates/types/SentenceGuid.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static class SentenceGuid`, written with `///`.

```text
<summary>
Deterministically converts a sentence into a valid GUID whose hex digits best-effort spell the sentence
(leet-style: s→5, o→0, i/l→1, …). One input character yields exactly one hex digit — a character with no
hex look-alike becomes '0' — so the rendering is positionally stable and human-decodable; whitespace
instead advances to the next GUID dash group, so each word lands in its own segment
("sample test data" → 5a001e00-7e57-da7a-…). The mint behind ConvertTo-Guid: run by a human or an LLM to
produce readable placeholder GUIDs for the managed-GUID registry (guids.yml) — never called by
production code. Validity is structural: any 32 hex digits form a parseable GUID, so every input yields
one. BCL-only ([ADR-PWSH-TYPES#1](/docs/adr/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types1)).
</summary>
```

## comment:2

Above `private static readonly Dictionary<char, char> Map = new Dictionary<char, char>`, written with `//`.

```text
Visual best-guess map into the hex alphabet. Identity hex letters map to themselves; digits pass
through in Convert; characters absent here have no honest hex look-alike and render as '0'. The
table is data — extending it changes only GUIDs minted after the change, never registered ones.
```

## comment:3

Above `private static readonly int[] GroupBoundaries = { 0, 8, 12, 16, 20, 32 };`, written with `//`.

```text
The digit positions where the GUID's dash groups begin and end (8-4-4-4-12). Whitespace advances to
the next of these, so words align with segments; 0 makes leading whitespace a no-op.
```

## comment:4

Above `int boundary = NextGroupBoundary(hex.Length);`, written with `//`.

```text
Skip one dash down: fill to the next group boundary so the next word starts its own
segment. At a boundary this is a no-op, so runs of whitespace collapse.
```

## comment:5

Above `hex.Append('0');` (occurrence 2), written with `//`.

```text
No hex look-alike: render '0' rather than skip, so one character is always one digit
and a human can decode the sentence positionally.
```
