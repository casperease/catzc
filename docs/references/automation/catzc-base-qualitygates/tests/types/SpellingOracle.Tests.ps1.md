---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/types/SpellingOracle.Tests.ps1.md
    kind: test-asset
    body_sha: "70ffdae8faf6"
    adrs:
      - ADR-AUTO-TEST#1
---

# automation/Catzc.Base.QualityGates/tests/types/SpellingOracle.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'SpellingOracle.CoinedFragments (shipped dictionary)' -Tag 'L1',...`.

```text
source-only: it loads the repository's committed dictionary and .cspell/ lists — the inputs only the source-tree
analyzer rule (Measure-SpellOutIdentifiers) reads — which give the same answer in both run modes.
```

## comment:2

Above `$englishPath = Join-Path (Get-RepositoryRoot)...`.

```text
Binds to the shipped English list + the generated term lists — an integrity test by construction
([ADR-AUTO-TEST#1](/docs/adr/automation/test-automation.md#rule-adr-auto-test1)): it verifies the real oracle,
not a fixture. The static load is idempotent, so this is safe
to run alongside any other consumer in the same process.
```

## comment:3

Above `[Catzc.Base.QualityGates.SpellingOracle]::CoinedFragments('capi', $false) |...`.

```text
'capi' is a fixture-category term — test-only vocabulary. It is coined in production scope and
known only when fixtures are included (a test file).
```

## comment:4

Above `[Catzc.Base.QualityGates.SpellingOracle]::IsKnown('zzq') | Should -BeFalse`.

```text
A 3-char nonsense token: not in the oracle (IsKnown false), and below cspell's minWordLength so the
Test-Spelling does not flag the literal here.
```
