---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-GlossaryFormViolations.ps1.md
    kind: comment-page
    body_sha: b805c29bc5a1
    adrs:
      - ADR-REPO-VOCAB#8
    links: []
---

# automation/Catzc.Base.Docs/private/Get-GlossaryFormViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A term that names a family declares the words allowed to qualify its head word (`forms:`), and any other qualified
use is a defect ([ADR-REPO-VOCAB#8](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab8)): for
`gate`, "quality gate" and "CI gate" are forms, "spelling gate" is not. For every concept with forms whose source
takes part in the `forms` check, this reads the same tracked files and text surfaces as the avoided-phrasing check
(G4, Get-GlossaryPhrasingViolations) and reports:
  - a qualified use: "<word> <head>" or "<word>-<head>" (singular or plural), where <word> is neither one of the
    concept's forms nor a function word (an article, determiner, quantifier, possessive, preposition, conjunction,
    or number — "the gate", "each gate", "two gates", "and gates" are always allowed), nor a keyword after a dot
    (`.PARAMETER Slot`); the comparison ignores case;
  - a verb use: the head word's -ed and -ing forms ("gated", "gating"), which a noun family never takes — unless the
    concept sets `verbs: true` because they are ordinary English for it ("scoped", "sourced").
The bare head word is always allowed. A mention — the phrase in backticks or quotes — is exempt, as in G4, so the
vocabulary can talk about itself.

Private helper for the glossary checks; not exported.
```

## comment:2

Section `.PARAMETER SurfaceCache` of the comment-based help.

```text
The text surfaces already read, keyed by tracked file, each value the file's Catzc.Base.Docs.GlossarySegment array
(Catzc.Base.Docs.GlossaryProse): a file read once is not read again. Test-Glossary hands the
same table to this check and to the avoided-phrasing check (G4, Get-GlossaryPhrasingViolations), which read the same
surfaces of the same files under the same root, so one run reads each file's prose once. Defaults to an empty
table.
```

## comment:3

Above `[string[]]...`.

```text
The scan runs compiled (Catzc.Base.Docs.GlossaryScan): it reads each file's prose through GlossaryProse into the
surface cache once, and matches every concept with forms over the files each glossary source's scope selects.
```
