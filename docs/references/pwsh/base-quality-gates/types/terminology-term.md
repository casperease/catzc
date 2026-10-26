# pwsh/Base.QualityGates/types/TerminologyTerm.cs

One approved-vocabulary entry from `configs/terminology.yml`: a term and its meaning
([ADR-AUTO-SPELL](../../../../drs/automation/spell-out-names.md),
[ADR-AUTO-SPELL-ONEVOCABULARYSOURCE](../../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-onevocabularysource) to
[ADR-AUTO-SPELL-LIVEVOCABULARYONLY](../../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-livevocabularyonly)). Its properties
mirror a `terminology.yml` entry, snake_case. An abbreviation carries its full-word expansion; the other categories do not.

## Category

The category is the group the entry is listed under in the registry (`terms: <category>: [...]`). `TerminologyConfig` passes it in, so the
entry itself carries no category key.

## Base type

It derives from `Catzc.Base.Objects.DictionaryRecord`, so an instance also presents as a read-only dictionary over its own properties, and
its constructor uses the base's `Req` and `OptStr` extraction helpers.
