# pwsh/Base.QualityGates/configs/terminology.yml

The terminology registry: the single authored source of approved repository vocabulary. It is a folder of per-category files,
`configs/terminology/<category>.yml`, loaded together as one config.

## Roots

Each part holds two roots. `categories:` defines the vocabulary classes, and `terms:` groups the words under them as
`terms: <category>: [ { term, meaning }, ... ]`. A term's category is the group it sits in, with no per-entry category field, and an
abbreviation entry also carries `expands_to`. Load it with `Get-Config -Config terminology`. The TerminologyConfig type validates it and
requires every term's category to be one defined in the registry. The generated cspell word lists derive from it
(Build-TerminologyDictionary), so never hand-edit those lists. See [ADR-AUTO-SPELL](../../../../drs/automation/spell-out-names.md)
([ADR-AUTO-SPELL-ONEVOCABULARYSOURCE](../../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-onevocabularysource) to
[ADR-AUTO-SPELL-LIVEVOCABULARYONLY](../../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-livevocabularyonly)).

## Categories

`categories` holds the allowed values of a term's `category`, each with what it means. It is the single source of the category set: the type
validates every term against it, and Build-TerminologyDictionary emits one gitignored cspell dictionary, `.cspell/<category>.txt`, per
category. Each category is a mapping with a required `description` and an optional `scope`.

## Scope

`scope` is a list of repository-relative, `/`-separated globs that declare which language zone a category's terms belong to: the test zone,
the live zone, the design zone ([ADR-REPO-LANG](../../../../drs/repository/domain-language-separation.md)). It is a declaration of intent,
not a cspell rule. cspell tokenizes text, not meaning, and example and fixture vocabulary legitimately appears in comments, doc-example
blocks and demo data across every file type, so the file globs a dictionary is scoped by cannot tell fixture-as-illustration from
fixture-as-leaked-production-data. All categories are effectively global to cspell, and the zone separation is enforced by
[ADR-AUTO-TEST](../../../../drs/automation/test-automation.md) and code review. A scope list with no entries makes the category global.

The one scope matched today is the `reserved` category's, by Test-Terminology. It matches case-insensitively: the glob and the tracked path
are both lowercased before the match, as the term itself is matched ignoring case.
