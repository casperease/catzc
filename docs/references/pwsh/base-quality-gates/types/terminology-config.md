# pwsh/Base.QualityGates/types/TerminologyConfig.cs

The typed record for the terminology registry, `configs/terminology.yml`, and its validity rules
([ADR-AUTO-SPELL](../../../../drs/automation/spell-out-names.md),
[ADR-AUTO-SPELL-ONEVOCABULARYSOURCE](../../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-onevocabularysource) to
[ADR-AUTO-SPELL-LIVEVOCABULARYONLY](../../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-livevocabularyonly)). Constructing an
instance validates the registry, throwing on the first malformed shape, and exposes the parsed categories, their scopes and the flattened
terms, each carrying its group's category, to the generator (`Build-TerminologyDictionary`) and the gate (`Test-Terminology`).

## Shape

- **`categories`** — a non-empty map, and the single source of the category set. Each category is a mapping with a required `description`
  and an optional `scope`, a list of repository-relative globs bounding where that category's terms are legitimate. No other key is allowed.
- **`terms`** — a non-empty map that groups entries under the category keys: `terms: <category>: [ {term, meaning, [expands_to]}, ... ]`.
  The group key is the category, so entries carry no category field. Every group key must be a defined category, every entry a valid
  `TerminologyTerm`, and no term may be duplicated across groups.

## Scope

A category with no `scope` is global: its terms are legitimate everywhere. A category with a scope is zone-bound: its terms belong only
under the scope globs, and cspell enforces that, so a fixture token in shipped config, or a live identity in a logic test, becomes a
spelling failure. `categoryScopes` holds each category's scope globs (repository-relative, `/`-separated), keyed by category name. An empty
list means the category is global.

## Defining files

`DefiningFiles` lists the files that define the terms, which the orphan search leaves out: the registry, and one generated dictionary per
category. The caller passes the QualityGates module's root, since its folder drops the namespace its name carries
([DDR-TRACK-MODULENAMESPACE](../../../../drs/design/tracks.md#rule-ddr-track-modulenamespace)).
