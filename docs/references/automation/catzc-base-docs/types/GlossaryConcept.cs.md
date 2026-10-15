---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/types/GlossaryConcept.cs.md
    kind: comment-page
    body_sha: ef353bfeb8e9
    adrs:
      - ADR-AUTO-TEST#30
      - ADR-AUTO-TYPES#8
      - ADR-AZ-CUSTOMER#3
      - ADR-FLOW-CD#2
      - ADR-REPO-VOCAB#1
      - ADR-REPO-VOCAB#4
      - ADR-REPO-VOCAB#5
      - ADR-REPO-VOCAB#8
    links: []
---

# automation/Catzc.Base.Docs/types/GlossaryConcept.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One defined term of the controlled vocabulary (a configs/glossary.yml `concepts:` entry, keyed by the term). It
carries the term's machine key, its ADR domain, the ONE rule that defines it
([ADR-REPO-VOCAB#1](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab1)), a one-line
definition, how it exists in the repository (GlossaryRealization), and optionally its relations to other terms,
its contrasts with similar terms (each explained,
[ADR-REPO-VOCAB#4](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab4)), and its avoided phrasings (GlossaryAvoid,
[ADR-REPO-VOCAB#5](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab5)), and the words allowed to qualify its
head word (forms, [ADR-REPO-VOCAB#8](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab8)). Mirrors the YAML entry (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Only the entry's own shape is checked here. Whether `defined_by` names a real rule, `domain` a declared ADR
domain, and the relation/contrast targets real concepts are cross-file facts, checked by the glossary checks
(Test-Glossary), not on load — so loading a glossary stays hermetic (the
[ADR-AZ-CUSTOMER#3](/docs/adr/azure/azure-customer-model.md#rule-adr-az-customer3) pattern).
```

## comment:2

Above `public static readonly Regex CitationRe = new...`.

```text
A rule citation in the '#' form: ADR-<code>[-<NAME>…]#<n>
([ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30),
[ADR-FLOW-CD#2](/docs/adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd2)).
```

## comment:3

Above `public IReadOnlyList<string> forms { get; }`.

```text
The words allowed to qualify the term's head word ('quality' in 'quality gate'), in entry order. Empty when the
entry declares no forms; then the qualified-forms check (G6) does not look at the term.
```

## comment:4

Above `public bool verbs { get; }`.

```text
Whether the head word's -ed and -ing forms are ordinary English for this term ('scoped', 'sourced'), so the
qualified-forms check (G6) allows them. False by default: a noun family such as 'gate' takes no verb forms.
```
