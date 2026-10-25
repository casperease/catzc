# Manual test plan — Spelling and language

Spell-checking, the terminology registry and dictionaries, and the glossary. Part of the [manual test plan](../manual-test-plan.md), which
says how to run a check.

## Index

| #   | Tier | Test file                                                                | FullNameFilter                                             | Guards                                                                                                                                                                                 |
| --- | ---- | ------------------------------------------------------------------------ | ---------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | L1   | pwsh/Catzc.Base.QualityGates/tests/Build-EnglishDictionary.Tests.ps1     | Build-EnglishDictionary — committed dictionary drift guard | The committed English word list matches its stamp and the pinned cspell version (`Test-GeneratedFiles -Generator Build-EnglishDictionary` reports 0 issues).                           |
| 2   | L1   | pwsh/Catzc.Base.QualityGates/tests/types/SpellingOracle.Tests.ps1        | SpellingOracle.CoinedFragments (shipped dictionary)        | The spelling oracle recognizes real words and flags coined fragments against the shipped dictionary.                                                                                   |
| 3   | L2   | pwsh/Catzc.Base.Docs/tests/Build-Glossary.Tests.ps1                      | Build-Glossary — generated glossary page                   | The generated docs/drs/glossary.md is current: `Test-GeneratedFiles -Generator Build-Glossary` reports no drift from the modules' configs/glossary.yml sources.                        |
| 4   | L2   | pwsh/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1               | Repository spelling integrity                              | All in-scope repository content passes spell-check.                                                                                                                                    |
| 5   | L2   | pwsh/Catzc.Base.QualityGates/tests/Build-TerminologyDictionary.Tests.ps1 | Build-TerminologyDictionary — real registry                | The generated terminology dictionaries match the registry (`Test-GeneratedFiles -Generator Build-TerminologyDictionary` reports 0 issues) and are lower-cased, unique, ordinal-sorted. |
| 6   | L2   | pwsh/Catzc.Base.QualityGates/tests/Test-Terminology.Tests.ps1            | Terminology registry integrity                             | The shipped terminology registry passes every check: no drift, no orphans, every entry justified.                                                                                      |
| 7   | L2   | pwsh/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1                       | Test-Glossary — real glossary sources                      | At least one glossary source exists, and the real sources pass every glossary check (G1–G5) over the real ADRs, tests, and tracked files.                                              |
| 8   | L1   | pwsh/Catzc.Base.Docs/tests/Build-Glossary.Tests.ps1                      | Build-Glossary — shipped configs/drs.yml and types         | Build-Glossary finds the domain registry and the C# type sources it stamps in the loaded module (ADR-AUTO-ASSETDEP-COVEREDBYREALTEST).                                                 |
| 9   | L1   | pwsh/Catzc.Base.QualityGates/tests/Build-TerminologyDictionary.Tests.ps1 | Build-TerminologyDictionary — shipped configs/terminology/ | Build-TerminologyDictionary finds the registry it stamps in the loaded module (ADR-AUTO-ASSETDEP-COVEREDBYREALTEST).                                                                   |

## Checks

### 4. Repository spelling integrity

**Guards:** all in-scope repository content is spell-clean.

**Checks:**

- Real `cspell` over the default content scope (excludes `out/`, `docs/notes/`, vendored) reports no misspelling.

**Prerequisite:** cspell.

### 5. Build-TerminologyDictionary — real registry

**Guards:** the checked-in terminology dictionaries reflect the authored registry.

**Checks:**

- `Test-GeneratedFiles -Generator Build-TerminologyDictionary` reports 0 issues: the generated `.cspell/<category>.txt` lists (gitignored,
  regenerated on import) match what the registry generates.
- Each generated dictionary is lower-cased, de-duplicated, and ordinal-sorted (deterministic).

### 6. Terminology registry integrity

**Guards:** the shipped terminology registry passes every `Test-Terminology` check.

**Checks:**

- `Test-Terminology` over the shipped `terminology.yml` reports 0 issues: no drift, no orphans, and every entry is justified (a category and
  a meaning, with an expansion for each abbreviation).
