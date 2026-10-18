# automation/Catzc.Base.Docs/private/Get-GlossaryFormViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the uses of a term outside its declared forms within each glossary source's scope (check G6) — one message per use.

### description

A term that names a family declares the words allowed to qualify its head word (`forms:`), and any other qualified use is a defect
([ADR-REPO-VOCAB#8](../../../../adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab8)): for `gate`, "quality gate" and "CI gate" are
forms, "spelling gate" is not. For every concept with forms whose source takes part in the `forms` check, this reads the same tracked files
and text surfaces as the avoided-phrasing check (G4, Get-GlossaryPhrasingViolations) and reports:

- a qualified use: "`<word>` `<head>`" or "`<word>-<head>`" (singular or plural), where `<word>` is neither one of the concept's forms nor a
  function word (an article, determiner, quantifier, possessive, preposition, conjunction, or number — "the gate", "each gate", "two gates",
  "and gates" are always allowed), nor a keyword after a dot (`.PARAMETER Slot`); the comparison ignores case;
- a verb use: the head word's -ed and -ing forms ("gated", "gating"), which a noun family never takes — unless the concept sets
  `verbs: true` because they are ordinary English for it ("scoped", "sourced").

The bare head word is always allowed. A mention — the phrase in backticks or quotes — is exempt, as in G4, so the vocabulary can talk about
itself.

Private helper for the glossary checks; not exported.

### parameter `Entry`

The merged glossary, as Get-Glossary returns it. Defaults to the repository's glossary.

### parameter `TrackedFile`

The repo-relative, '/'-separated tracked files to consider. Defaults to every file git tracks.

### parameter `Root`

The directory the tracked files are relative to. Defaults to the repository root.

### parameter `SurfaceCache`

The text surfaces already read, keyed by tracked file, each value the file's Catzc.Base.Docs.GlossarySegment array
(Catzc.Base.Docs.GlossaryProse): a file read once is not read again. Test-Glossary hands the same table to this check and to the
avoided-phrasing check (G4, Get-GlossaryPhrasingViolations), which read the same surfaces of the same files under the same root, so one run
reads each file's prose once. Defaults to an empty table.

### outputs

`[string[]]` One message per use — `<file>:<line> says "<use>" — "<term>" takes only: <forms> (<defined_by>)` — in file then line order;
empty when every use is a declared form.

### example 1

```powershell
Get-GlossaryFormViolations
```

## comment:1

Above `[string[]]...`, written with `#`.

```text
The scan runs compiled (Catzc.Base.Docs.GlossaryScan): it reads each file's prose through GlossaryProse into the
surface cache once, and matches every concept with forms over the files each glossary source's scope selects.
```
