---
catzc:
  immutable:
    with_body_sha: "43ca183e1145"
    path: docs/references/automation/catzc-base-qualitygates/configs/terminology.yml.md
    folder: docs/references/automation/catzc-base-qualitygates/configs
    name: terminology-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-SPELL#{5,8}
---

# automation/Catzc.Base.QualityGates/configs/terminology.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `categories:`, written with `#`.

```text
Terminology registry — the single authored source of approved repository vocabulary.

Generated cspell word lists derive from this file (Build-TerminologyDictionary); never hand-edit
those lists. Two roots: `categories:` defines the vocabulary classes, and `terms:` groups the words under
them — `terms: <category>: [ { term, meaning }, ... ]`. A term's category is the group it sits in (no
per-entry category field); an abbreviation entry also carries `expands_to`. See
[ADR-AUTO-SPELL](/docs/adr/automation/spell-out-names.md)
([ADR-AUTO-SPELL#5](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell5)-[ADR-AUTO-SPELL#8](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell8)).

Loaded via Get-Config -Config terminology; validated by Catzc.Base.QualityGates.TerminologyConfig, which
requires every term's category to be one defined here.
```

## comment:2

Above `categories:`, written with `#`.

```text
categories — the allowed values for a term's `category`, each with what it means. This is the single
source of the category set: the type validates every term against it, and Build-TerminologyDictionary
emits one gitignored cspell dictionary (.cspell/<category>.txt) per category.

Each category is a mapping with a required `description` and an OPTIONAL `scope` — a list of repo-relative
`/`-separated globs DECLARING which language zone a category's terms belong to (the test zone, the live
zone, the design zone — see
[ADR-REPO-LANG](/docs/adr/repository/domain-language-separation.md)). `scope` is a DECLARATION of intent, not a cspell
rule: cspell tokenizes text, not meaning, and example/fixture vocabulary legitimately appears in comments,
doc-example blocks, and demo data across every file type (a config comment illustrating `[acme, globex]`,
a pipeline's `'Contoso Ltd'` demo record, a function's .EXAMPLE help), so a file-glob dictionary scope
cannot separate "fixture-as-illustration" from "fixture-as-leaked-production-data". The zone separation
is therefore enforced by
[ADR-AUTO-TEST](/docs/adr/automation/test-automation.md) + code review (and, prospectively, a TAG-AWARE AST gate over test files —
an extension of Get-TestTagViolations that inspects string literals, not comments), with `scope` as the
machine-readable zone map that gate would consume. All categories are effectively GLOBAL to cspell today.
See [ADR-REPO-LANG](/docs/adr/repository/domain-language-separation.md) and
[ADR-AUTO-SPELL](/docs/adr/automation/spell-out-names.md).
```
