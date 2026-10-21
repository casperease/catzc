# pwsh/Catzc.Base.QualityGates/types/SpellingOracle.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static class SpellingOracle`, written with `///`.

```text
<summary>
The word oracle behind the spell-out-names analyzer rule (Measure-SpellOutIdentifiers), backing
[ADR-AUTO-SPELL](/docs/adr/automation/spell-out-names.md). It answers one question fast: given an identifier, which of its
word fragments are neither a real English word nor approved repository vocabulary — i.e. invented local
abbreviations that must be spelled out.

The dictionary is a single HashSet loaded once per process from the committed english.txt.gz (flattened
from cspell's own dictionaries by Build-EnglishDictionary) plus every generated .cspell/*.txt term list
(the product vocabulary and the conventional-abbreviation allow-list, from terminology.yml). Both the load
and the per-fragment lookup are here in C# rather than PowerShell on purpose: a PowerShell method call
costs ~10 microseconds, so tokenizing and looking up thousands of fragments per file in PowerShell would
dominate the analyzer's runtime, whereas the same work in C# is microseconds
([ADR-BCL-TYPES-NATIVETYPEDMODEL](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-nativetypedmodel) — a concept the
platform's own logic operates on becomes a native type).

The rule decides WHICH identifiers to feed and applies AST-level exemptions (automatic variables, drive
scopes); this type is deliberately dumb and fast — it only tokenizes and looks up.
</summary>
```

## comment:2

Above `public const int MinFragmentLength = 2;`, written with `//`.

```text
Fragments shorter than this are never flagged: single letters are loop indices / type variables
([ADR-AUTO-SPELL-ALLOWEDABBREVIATIONS](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell-allowedabbreviations)), which the ADR exempts.
```

## comment:3

Above `public static void Initialize(string englishGzPath, IEnumerable<string>...`, written with `///`.

```text
<summary>
Load the oracle once: the gzip-compressed English list plus every plain-text term list. Idempotent — a
second call is a no-op, so each analyzer shard pays the load once. Fixture terms are kept SEPARATE
([ADR-AUTO-SPELL-CATEGORYANDMEANING](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell-categoryandmeaning)): they are accepted only when
CoinedFragments is called with includeFixtures — i.e. for a test
file — so a fixture token cannot bless a real identifier in production code. Term-list lines starting
with '#' (the generated-file header) and blank lines are skipped; every other token is added lower-cased.
</summary>
```

## comment:4

Above `public static string[] CoinedFragments(string identifier, bool includeFixtures)`, written with `///`.

```text
<summary>
Split an identifier into word fragments and return those (length >= MinFragmentLength) that are not in
the dictionary — the invented abbreviations to spell out. Returns an empty array for a fully
spelled-out identifier. Fixture terms count as known only when <paramref name="includeFixtures"/> is set
(the caller passes true only for a test file), so a fixture token never blesses a production identifier
([ADR-AUTO-SPELL-CATEGORYANDMEANING](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell-categoryandmeaning)).
</summary>
```

## comment:5

Above `public static string[] CoinedFragments(string identifier)`, written with `///`.

```text
<summary>Production-scope overload: fixture terms are not accepted
([ADR-AUTO-SPELL-CATEGORYANDMEANING](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell-categoryandmeaning)).</summary>
```

## comment:6

Above `public static IEnumerable<string> Tokenize(string identifier)`, written with `///`.

```text
<summary>
Split on non-letters (snake_case underscores, digits) and case boundaries: a camelCase hump
(rule|Collection) and an acronym-to-word seam (HTTP|Server, IO|Stream). Each fragment is returned
lower-cased; non-letter runs are separators and are dropped, so numeric suffixes never form fragments.
</summary>
```
