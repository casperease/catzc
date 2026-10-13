# docs/how-to/automation/manual-test-plan/spelling-and-language.md

`Manual test plan — Spelling and language`

Spell-checking, the terminology registry and dictionaries, and the glossary. Part of the [manual test plan](../manual-test-plan.md), which
says how to run a check.

## Index

| #   | Tier | Test file                                                                      | FullNameFilter                                             | Guards                                                                                                                                   |
| --- | ---- | ------------------------------------------------------------------------------ | ---------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | L1   | automation/Catzc.Base.QualityGates/tests/Build-EnglishDictionary.Tests.ps1     | Build-EnglishDictionary — committed dictionary drift guard | The committed English word list matches its stamp and the pinned cspell version (no drift).                                              |
| 2   | L1   | automation/Catzc.Base.QualityGates/tests/types/SpellingOracle.Tests.ps1        | SpellingOracle.CoinedFragments (shipped dictionary)        | The spelling oracle recognizes real words and flags coined fragments against the shipped dictionary.                                     |
| 3   | L1   | automation/Catzc.Base.Docs/tests/Build-Glossary.Tests.ps1                      | Build-Glossary — generated glossary page                   | The generated docs/adr/glossary.md is current: no drift from the modules' configs/glossary.yml sources.                                  |
| 4   | L2   | automation/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1               | Repository spelling integrity                              | All in-scope repository content passes spell-check.                                                                                      |
| 5   | L2   | automation/Catzc.Base.QualityGates/tests/Build-TerminologyDictionary.Tests.ps1 | Build-TerminologyDictionary — real registry                | The checked-in terminology dictionary matches the registry (no drift) and is lower-cased, unique, ordinal-sorted.                        |
| 6   | L2   | automation/Catzc.Base.QualityGates/tests/Test-Terminology.Tests.ps1            | Terminology registry integrity                             | The shipped terminology registry passes every gate: no drift, no orphans, every entry justified.                                         |
| 7   | L2   | automation/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1                       | Test-Glossary — real glossary sources                      | At least one glossary source exists, and the real sources pass every glossary gate (G1–G5) over the real ADRs, tests, and tracked files. |

## Checks

### 4. Repository spelling integrity

**Guards:** all in-scope repository content is spell-clean.

**Checks:**

- Real `cspell` over the default content scope (excludes `out/`, `docs/notes/`, vendored) reports no misspelling.

**Prerequisite:** cspell.

### 5. Build-TerminologyDictionary — real registry

**Guards:** the checked-in terminology dictionaries reflect the authored registry.

**Checks:**

- The generated `.cspell/<category>.txt` lists (gitignored, regenerated on import) match what the registry generates (no drift).
- Each generated dictionary is lower-cased, de-duplicated, and ordinal-sorted (deterministic).

### 6. Terminology registry integrity

**Guards:** the shipped terminology registry passes every terminology gate.

**Checks:**

- `Test-Terminology` over the shipped `terminology.yml` throws nothing: no drift, no orphans, and every entry is justified (a category and a
  meaning, with an expansion for each abbreviation).
