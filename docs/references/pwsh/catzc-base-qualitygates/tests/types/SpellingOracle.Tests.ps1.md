# pwsh/Catzc.Base.QualityGates/tests/types/SpellingOracle.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'SpellingOracle.CoinedFragments (shipped dictionary)' -Tag 'L1',...`, written with `#`.

```text
source-only: it loads the repository's committed dictionary and .cspell/ lists — the inputs only the source-tree
analyzer rule (Measure-SpellOutIdentifiers) reads — which give the same answer in both run modes.
```

## comment:2

Above `$englishPath = Get-CatzcModuleRoot 'assets/english.txt.gz' -Module...`, written with `#`.

```text
Binds to the shipped English list + the generated term lists — an integrity test by construction
([ADR-AUTO-TEST#1](/docs/adr/automation/test-automation.md#rule-adr-auto-test1)): it verifies the real oracle,
not a fixture. The static load is idempotent, so this is safe
to run alongside any other consumer in the same process.
```

## comment:3

Above `[Catzc.Base.QualityGates.SpellingOracle]::CoinedFragments('capi', $false) |...`, written with `#`.

```text
'capi' is a fixture-category term — test-only vocabulary. It is coined in production scope and
known only when fixtures are included (a test file).
```

## comment:4

Above `[Catzc.Base.QualityGates.SpellingOracle]::IsKnown('zzq') | Should -BeFalse`, written with `#`.

```text
A 3-char nonsense token: not in the oracle (IsKnown false), and below cspell's minWordLength so the
Test-Spelling does not flag the literal here.
```
