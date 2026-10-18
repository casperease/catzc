# pwsh/Catzc.Base.Docs/types/GlossaryConcept.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One defined term of the controlled vocabulary (a configs/glossary.yml `concepts:` entry, keyed by the term). It
carries the term's machine key, its ADR domain, the ONE rule that defines it
([ADR-REPO-VOCAB-DEFINEDTERM](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab-definedterm)), a one-line
definition, how it exists in the repository (GlossaryRealization), and optionally its relations to other terms,
its contrasts with similar terms (each explained,
[ADR-REPO-VOCAB-SIMILARTERMSCONTRASTED](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab-similartermscontrasted)), and its avoided phrasings (GlossaryAvoid,
[ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab-avoidedphrasingreplaced)), and the words allowed to qualify its
head word (forms, [ADR-REPO-VOCAB-FAMILYFORMS](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab-familyforms)). Mirrors the YAML entry (snake_case keys,
[ADR-AUTO-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types-snakecasemirrorsyaml)).

Only the entry's own shape is checked here. Whether `defined_by` names a real rule, `domain` a declared ADR
domain, and the relation/contrast targets real concepts are cross-file facts, checked by the glossary checks
(Test-Glossary), not on load — so loading a glossary stays hermetic (the
[ADR-AZ-CUSTOMER-REFERENCENOTVALIDATEDONLOAD](/docs/adr/azure/azure-customer-model.md#rule-adr-az-customer-referencenotvalidatedonload) pattern).
```

## comment:2

Above `public static readonly Regex CitationRe = new...`, written with `//`.

```text
A rule citation in the '#' form: ADR-<code>[-<NAME>…]#<n>
([ADR-AUTO-TEST-SAMETESTSBOTHRUNS](/docs/adr/automation/test-automation.md#rule-adr-auto-test-sametestsbothruns),
[ADR-FLOW-CD-SHORTINTEGRATIONCYCLE](/docs/adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd-shortintegrationcycle)).
```

## comment:3

Above `public IReadOnlyList<string> forms { get; }`, written with `//`.

```text
The words allowed to qualify the term's head word ('quality' in 'quality gate'), in entry order. Empty when the
entry declares no forms; then the qualified-forms check (G6) does not look at the term.
```

## comment:4

Above `public bool verbs { get; }`, written with `//`.

```text
Whether the head word's -ed and -ing forms are ordinary English for this term ('scoped', 'sourced'), so the
qualified-forms check (G6) allows them. False by default: a noun family such as 'gate' takes no verb forms.
```
