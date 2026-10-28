# Manual test plan — Spelling and language

Spell-checking, the terminology registry and dictionaries, and the glossary. Part of the [manual test plan](../manual-test-plan.md), which
says how to run a check.

## Index

| #   | Tier | Check                                                            |
| --- | ---- | ---------------------------------------------------------------- |
| 1   | L1   | [Build-EnglishDictionary — committed dictionary drift guard][c1] |
| 2   | L1   | [SpellingOracle.CoinedFragments (shipped dictionary)][c2]        |
| 3   | L2   | [Build-Glossary — generated glossary page][c3]                   |
| 4   | L2   | [Repository spelling integrity][c4]                              |
| 5   | L2   | [Build-TerminologyDictionary — real registry][c5]                |
| 6   | L2   | [Terminology registry integrity][c6]                             |
| 7   | L2   | [Test-Glossary — real glossary sources][c7]                      |
| 8   | L1   | [Build-Glossary — shipped configs/drs.yml and types][c8]         |
| 9   | L1   | [Build-TerminologyDictionary — shipped configs/terminology/][c9] |

[c1]: #1-build-englishdictionary--committed-dictionary-drift-guard
[c2]: #2-spellingoraclecoinedfragments-shipped-dictionary
[c3]: #3-build-glossary--generated-glossary-page
[c4]: #4-repository-spelling-integrity
[c5]: #5-build-terminologydictionary--real-registry
[c6]: #6-terminology-registry-integrity
[c7]: #7-test-glossary--real-glossary-sources
[c8]: #8-build-glossary--shipped-configsdrsyml-and-types
[c9]: #9-build-terminologydictionary--shipped-configsterminology

## Checks

### 1. Build-EnglishDictionary — committed dictionary drift guard

**Test file:** `pwsh/Base.QualityGates/tests/Build-EnglishDictionary.Tests.ps1` (L1), block
`Build-EnglishDictionary — committed dictionary drift guard`.

**Guards:** The committed English word list matches its stamp and the pinned cspell version
(`Test-GeneratedFiles -Generator Build-EnglishDictionary` reports 0 issues).

### 2. SpellingOracle.CoinedFragments (shipped dictionary)

**Test file:** `pwsh/Base.QualityGates/tests/types/SpellingOracle.Tests.ps1` (L1), block
`SpellingOracle.CoinedFragments (shipped dictionary)`.

**Guards:** The spelling oracle recognizes real words and flags coined fragments against the shipped dictionary.

### 3. Build-Glossary — generated glossary page

**Test file:** `pwsh/Base.Docs/tests/Build-Glossary.Tests.ps1` (L2), block `Build-Glossary — generated glossary page`.

**Guards:** The generated docs/drs/glossary.md is current: `Test-GeneratedFiles -Generator Build-Glossary` reports no drift from the
modules' configs/glossary.yml sources.

### 4. Repository spelling integrity

**Test file:** `pwsh/Base.QualityGates/tests/Test-Spelling.Tests.ps1` (L2), block `Repository spelling integrity`.

**Guards:** all in-scope repository content is spell-clean.

**Checks:**

- Real `cspell` over the default content scope (excludes `out/`, `docs/notes/`, vendored) reports no misspelling.

**Prerequisite:** cspell.

### 5. Build-TerminologyDictionary — real registry

**Test file:** `pwsh/Base.QualityGates/tests/Build-TerminologyDictionary.Tests.ps1` (L2), block
`Build-TerminologyDictionary — real registry`.

**Guards:** the checked-in terminology dictionaries reflect the authored registry.

**Checks:**

- `Test-GeneratedFiles -Generator Build-TerminologyDictionary` reports 0 issues: the generated `.cspell/<category>.txt` lists (gitignored,
  regenerated on import) match what the registry generates.
- Each generated dictionary is lower-cased, de-duplicated, and ordinal-sorted (deterministic).

### 6. Terminology registry integrity

**Test file:** `pwsh/Base.QualityGates/tests/Test-Terminology.Tests.ps1` (L2), block `Terminology registry integrity`.

**Guards:** the shipped terminology registry passes every `Test-Terminology` check.

**Checks:**

- `Test-Terminology` over the shipped `terminology.yml` reports 0 issues: no drift, no orphans, and every entry is justified (a category and
  a meaning, with an expansion for each abbreviation).

### 7. Test-Glossary — real glossary sources

**Test file:** `pwsh/Base.Docs/tests/Test-Glossary.Tests.ps1` (L2), block `Test-Glossary — real glossary sources`.

**Guards:** At least one glossary source exists, and the real sources pass every glossary check (G1–G5) over the real decision records,
tests, and tracked files.

### 8. Build-Glossary — shipped configs/drs.yml and types

**Test file:** `pwsh/Base.Docs/tests/Build-Glossary.Tests.ps1` (L1), block `Build-Glossary — shipped configs/drs.yml and types`.

**Guards:** Build-Glossary finds the domain registry and the C# type sources it stamps in the loaded module
(ADR-AUTO-ASSETDEP-COVEREDBYREALTEST).

### 9. Build-TerminologyDictionary — shipped configs/terminology/

**Test file:** `pwsh/Base.QualityGates/tests/Build-TerminologyDictionary.Tests.ps1` (L1), block
`Build-TerminologyDictionary — shipped configs/terminology/`.

**Guards:** Build-TerminologyDictionary finds the registry it stamps in the loaded module (ADR-AUTO-ASSETDEP-COVEREDBYREALTEST).

### 10. Build-EnglishDictionary — shipped assets/english.txt.gz

**Test file:** `pwsh/Base.QualityGates/tests/Build-EnglishDictionary.Tests.ps1` (L1), block
`Build-EnglishDictionary — shipped assets/english.txt.gz`.

**Guards:** `Build-EnglishDictionary` finds the word list and its stamp where it writes them, in the loaded QualityGates module
(ADR-AUTO-ASSETDEP-COVEREDBYREALTEST).
