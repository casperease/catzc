# pwsh/Base.QualityGates/types/SpellingOracle.cs

The word oracle behind the spell-out-names analyzer rule (`Measure-SpellOutIdentifiers`), backing
[ADR-AUTO-SPELL](../../../../drs/automation/spell-out-names.md). It answers one question fast: given an identifier, which of its word
fragments are neither a real English word nor approved repository vocabulary, that is, invented local abbreviations that must be spelled
out.

The rule decides which identifiers to feed and applies the AST-level exemptions (automatic variables, variables of a drive). This type is
deliberately dumb and fast: it only tokenizes and looks up.

## Dictionary

The dictionary is a single `HashSet` loaded once per process from the committed `english.txt.gz`, flattened from cspell's own dictionaries
by `Build-EnglishDictionary`, plus every generated `.cspell/*.txt` term list (the product vocabulary and the conventional-abbreviation
allow-list, from `terminology.yml`).

Both the load and the per-fragment lookup are in C# rather than PowerShell on purpose. A PowerShell method call costs about 10 microseconds,
so tokenizing and looking up thousands of fragments per file in PowerShell would dominate the analyzer's runtime, while the same work in C#
is microseconds
([ADR-BCL-TYPES-NATIVETYPEDMODEL](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-nativetypedmodel): a concept the
platform's own logic operates on becomes a native type).

## Initialize

`Initialize` loads the oracle once from the gzip-compressed English list and every plain-text term list. It is idempotent, so a second call
is a no-op and each analyzer shard pays the load once. Term-list lines starting with `#` (the generated-file header) and blank lines are
skipped; every other token is added lower-cased.

Fixture terms are kept separate
([ADR-AUTO-SPELL-CATEGORYANDMEANING](../../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-categoryandmeaning)). They are
accepted only when `CoinedFragments` is called with `includeFixtures`, which the caller passes only for a test file, so a fixture token
cannot bless a real identifier in production code.

## Lookup

`CoinedFragments` splits an identifier into word fragments and returns those, of length at least `MinFragmentLength`, that are not in the
dictionary: the invented abbreviations to spell out. It returns an empty array for a fully spelled-out identifier. The overload without
`includeFixtures` is the production scope, where fixture terms are not accepted.

Fragments shorter than `MinFragmentLength` (2) are never flagged: single letters are loop indices or type variables, which the record
exempts ([ADR-AUTO-SPELL-ALLOWEDABBREVIATIONS](../../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-allowedabbreviations)).

`Tokenize` splits on non-letters (snake_case underscores, digits) and case boundaries: a camelCase hump (`rule|Collection`) and an
acronym-to-word seam (`HTTP|Server`, `IO|Stream`). Each fragment is lower-cased. Non-letter runs are separators and are dropped, so numeric
suffixes never form fragments.

## Assets folder

`AssetsFolder` gives the folder the English word list ships in, the QualityGates module's assets. The caller passes that module's root,
since its folder drops the namespace its name carries
([DDR-TRACK-MODULENAMESPACE](../../../../drs/design/tracks.md#rule-ddr-track-modulenamespace)).
