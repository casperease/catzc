# pwsh/Base.Docs/types/GlossaryConcept.cs

One defined term of the controlled vocabulary (a glossary source's `concepts:` entry, keyed by the term). It mirrors the YAML entry,
snake_case keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Properties

- **`term`** and **`key`** — the canonical term, and its snake_case machine key.
- **`domain`** and **`defined_by`** — the ADR domain, and the one rule that defines the term
  ([ADR-REPO-VOCAB-DEFINEDTERM](../../../../drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-definedterm)). A `defined_by` is a
  rule code of any kind, as `DrsCodeForm.AnyKind` gives it: a two-to-four-letter kind prefix and at least two more `-<NAME>` segments
  ([ADR-AUTO-TEST-SAMETESTSBOTHRUNS](../../../../drs/automation/test-automation.md#rule-adr-auto-test-sametestsbothruns),
  [FDR-CD-SHORTINTEGRATIONCYCLE](../../../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-shortintegrationcycle)).
- **`short`** — a one-line definition.
- **`realized_by`** — how the concept exists in the repository (`GlossaryRealization`).
- **relations** and **contrasts** — related terms, and similar terms each with one sentence on how they differ
  ([ADR-REPO-VOCAB-SIMILARTERMSCONTRASTED](../../../../drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-similartermscontrasted)).
- **`avoid`** — the avoided phrasings (`GlossaryAvoid`,
  [ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED](../../../../drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-avoidedphrasingreplaced)).
- **`forms`** — the words allowed to qualify the term's head word ('quality' in 'quality gate'), in entry order
  ([ADR-REPO-VOCAB-FAMILYFORMS](../../../../drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-familyforms)). Empty when the entry
  declares no forms; then the qualified-forms check (G6) does not look at the term.
- **`verbs`** — whether the head word's -ed and -ing forms are ordinary English for this term ('scoped', 'sourced'), so G6 allows them.
  False by default: a noun family such as 'gate' takes no verb forms.

## Validation

Only the entry's own shape is checked on load. Whether `defined_by` names a real rule, `domain` a declared ADR domain, and the relation and
contrast targets real concepts are cross-file facts, checked by the glossary checks (`Test-Glossary`), so loading a glossary stays hermetic
(the [ADR-AZ-CUSTOMER-REFERENCEUNVALIDATED](../../../../drs/azure/azure-customer-model.md#rule-adr-az-customer-referenceunvalidated)
pattern).
