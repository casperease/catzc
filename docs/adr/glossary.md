# docs/adr/glossary.md

Glossary: the controlled vocabulary

Every defined term of the repository, generated from the glossary sources (each module's `configs/glossary.yml`) by `Build-Glossary` — edit
a source, never this page. A term's meaning is fixed by the one ADR rule that defines it
([controlled-vocabulary](repository/controlled-vocabulary.md)); this page collects them, with how each differs from its neighbours and the
phrasings to avoid. `Test-Glossary` checks the sources.

## design

### deployable-unit

What ships — a whole track or a reduced composition — bound one-to-one to its pipeline.

- **Defined by:** [ADR-DSGN-TRACK#5](design/tracks.md#rule-adr-dsgn-track5)
- **Realized by:** config-key `automation/Catzc.Base.Globs/configs/globs.yml`
- **Source:** `automation/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [release candidate](#release-candidate): A release candidate is one commit's tagged, immutable build of a deployable-unit; a
    deployable-unit is the composition that ships, whichever commit is built.

### occupant

The one commit an always-on environment holds, deployed there as its release candidate — named by its environment.

- **Defined by:** [ADR-DSGN-LIFE#5](design/commit-lifecycle.md#rule-adr-dsgn-life5)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [release candidate](#release-candidate): A release candidate is the artifact, the same bytes wherever it is deployed; an occupant is the
    commit one environment holds.

| Avoid               | Say instead                           |
| ------------------- | ------------------------------------- |
| `current occupant`  | occupant (the <environment> occupant) |
| `current occupants` | occupants                             |
| `resident commit`   | occupant                              |

## flow

### gate

A check whose verdict decides whether work may proceed — automated (a quality gate, the CI gate) or human (RC, RBC).

- **Defined by:** [ADR-FLOW-CD#13](flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.QualityGates/configs/glossary.yml`
- **Forms:** `quality gate`, `CI gate`, `RC gate`, `RBC gate`, `release gate`, `manual gate`, `PR gate`, `merge gate`, `commit gate`,
  `approval gate`, `production gate`, `push gate`, and the bare `gate`
- **Contrasts:**
  - [quality gate](#quality-gate): A quality gate is one automated check of the repository; a gate is any decision point, human or
    automated.

### release candidate

The immutable, tagged artifact a CI component builds from one commit — versioned, never rebuilt, promotable toward production.

- **Defined by:** [ADR-FLOW-CD#14](flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd14)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [deployable-unit](#deployable-unit): A deployable-unit is the composition that ships, whichever commit is built; a release candidate is
    one commit's tagged, immutable build of it.
  - [occupant](#occupant): An occupant is the commit an environment holds; a release candidate is the artifact built from it, the same bytes
    wherever it is deployed.
  - [test run](#test-run): A test run executes tests; a release candidate is the artifact a release-candidate test run verifies.
  - [test suite](#test-suite): A test suite is the declared selection of tests that verifies a change; a release candidate is the artifact
    under test.

| Avoid                     | Say instead                |
| ------------------------- | -------------------------- |
| `release-candidate suite` | release-candidate test run |

## automation

### all tests

Every test in the repository — every test file of every module, at every tier and category; what a test run selects at its defaults.

- **Defined by:** [ADR-AUTO-TEST#36](automation/test-automation.md#rule-adr-auto-test36)
- **Realized by:** function `Test-Automation`
- **Source:** `automation/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [test run](#test-run): A test run executes one selection of tests, possibly all; all tests is every test in the repository, at rest.
  - [test suite](#test-suite): A test suite is a named selection, usually a few modules up to a tier; all tests is every test there is.

| Avoid               | Say instead |
| ------------------- | ----------- |
| `the test suite`    | all tests   |
| `pester suite`      | all tests   |
| `pester test suite` | all tests   |
| `full suite`        | all tests   |

### build verification test

The BVT — the gate that certifies a commit by running the quality gates together, before and after the commit reaches master.

- **Defined by:** [ADR-AUTO-TEST#24](automation/test-automation.md#rule-adr-auto-test24)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.QualityGates/configs/glossary.yml`
- **Kind of:** [gate](#gate)
- **Contrasts:**
  - [quality gate](#quality-gate): A quality gate is one check inside the BVT; the BVT certifies a commit by running the quality gates
    together.

### category

A test's kind, logic or integrity — one mandatory tag saying whether it runs on fixtures or reads the shipped assets.

- **Defined by:** [ADR-AUTO-TEST#1](automation/test-automation.md#rule-adr-auto-test1)
- **Realized by:** tag `logic|integrity`
- **Source:** `automation/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [tier](#tier): A tier says what a test may touch and when it runs; a category says what it reads (logic or integrity).

| Avoid             | Say instead         |
| ----------------- | ------------------- |
| `integrity suite` | the integrity tests |

### phase

One of a test run's three scheduling stages, in order — parallel shards, greedy, serial — chosen per file by the serial/greedy tags.

- **Defined by:** [ADR-AUTO-TEST#26](automation/test-automation.md#rule-adr-auto-test26)
- **Realized by:** tag `serial|greedy`
- **Source:** `automation/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [tier](#tier): A tier is what a test may touch; a phase is when its file runs within a run (parallel, greedy, serial).

### quality gate

A gate checking one property of the whole repository automatically — one Test-<subject> function that reports through
Write-QualityGateReport and throws once with every issue.

- **Defined by:** [ADR-AUTO-TEST#35](automation/test-automation.md#rule-adr-auto-test35)
- **Realized by:** function `Write-QualityGateReport`
- **Source:** `automation/Catzc.Base.QualityGates/configs/glossary.yml`
- **Kind of:** [gate](#gate)
- **Contrasts:**
  - [build verification test](#build-verification-test): The BVT certifies a commit by running the quality gates together; a quality gate is
    one check inside it.
  - [gate](#gate): A gate is any decision point, human or automated; a quality gate is one automated check of the repository.

| Avoid            | Say instead                                     |
| ---------------- | ----------------------------------------------- |
| `analyzer suite` | the analyzer quality gate (Test-ScriptAnalyzer) |

### test

One Pester It — the smallest unit that passes or fails, counted by every report row, rule citation, and timing.

- **Defined by:** [ADR-AUTO-PESTER#8](automation/powershell/pester-testing.md#rule-adr-auto-pester8)
- **Realized by:** function `It`
- **Source:** `automation/Catzc.Base.QualityGates/configs/glossary.yml`
- **Part of:** [test block](#test-block)
- **Contrasts:**
  - [test block](#test-block): A test block groups tests and carries their shared tags and setup; a test is one It that passes or fails.

### test block

A Describe or Context in a test file — a named group of tests whose tags and setup apply to everything inside it.

- **Defined by:** [ADR-AUTO-PESTER#8](automation/powershell/pester-testing.md#rule-adr-auto-pester8)
- **Realized by:** function `Describe|Context`
- **Source:** `automation/Catzc.Base.QualityGates/configs/glossary.yml`
- **Part of:** [test file](#test-file)
- **Contrasts:**
  - [test](#test): A test is one It that passes or fails; a test block groups tests and carries their shared tags and setup.
  - [test file](#test-file): A test file is the *.Tests.ps1 file; a test block is a Describe or Context inside it.

### test file

One *.Tests.ps1 file under a module's tests/ — one per function, named Verb-Noun.Tests.ps1 (or for a C# type under tests/types/).

- **Defined by:** [ADR-AUTO-PESTER#5](automation/powershell/pester-testing.md#rule-adr-auto-pester5)
- **Realized by:** file-pattern `automation/*/tests/**/*.Tests.ps1`
- **Source:** `automation/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [test block](#test-block): A test block is a Describe or Context inside a test file; a test file is the file that holds them.

| Avoid                 | Say instead             |
| --------------------- | ----------------------- |
| `cross-cutting suite` | cross-cutting test file |

### test run

One invocation of Test-Automation, Test-CatzcBuild, or Invoke-TestFile over a selection of test files, in one slot, with one report.

- **Defined by:** [ADR-AUTO-TEST#34](automation/test-automation.md#rule-adr-auto-test34)
- **Realized by:** artifact `out/test-*/*/run.json`
- **Source:** `automation/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [all tests](#all-tests): All tests is every test in the repository, at rest; a test run executes one selection of them, possibly all.
  - [release candidate](#release-candidate): A release candidate is the artifact a release-candidate test run verifies; a test run executes
    tests.
  - [test suite](#test-suite): A test suite is a declared selection at rest; a test run executes a selection, a test suite or an ad-hoc one.

| Avoid          | Say instead                                      |
| -------------- | ------------------------------------------------ |
| `source suite` | source run                                       |
| `build suite`  | build run                                        |
| `build suites` | build runs                                       |
| `both suites`  | both runs (the source run and the build run)     |
| `two suites`   | two test runs (the source run and the build run) |

### test suite

A named, declared selection of tests that runs as one unit — a globset's verify scope in globs.yml (modules up to a tier), run with
Test-Automation -Suite.

- **Defined by:** [ADR-AUTO-TEST#37](automation/test-automation.md#rule-adr-auto-test37)
- **Realized by:** config-key `automation/Catzc.Base.Globs/configs/globs.yml`
- **Source:** `automation/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [all tests](#all-tests): All tests is every test there is; a test suite is a named selection, usually a few modules up to a tier.
  - [release candidate](#release-candidate): A release candidate is the artifact under test; a test suite is the declared selection of tests
    that verifies a change.
  - [test run](#test-run): A test run executes a selection, a test suite or an ad-hoc one; a test suite is the declared selection at rest.
  - [tier](#tier): A tier is one level a single test carries; a test suite selects whole modules up to a top tier.

### tier

A test's level, L0 to L3 — one mandatory tag that sets what the test may touch and when it runs.

- **Defined by:** [ADR-AUTO-TEST#13](automation/test-automation.md#rule-adr-auto-test13)
- **Realized by:** tag `L0|L1|L2|L3`
- **Source:** `automation/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [category](#category): A category says what a test reads (logic or integrity); a tier says what it may touch and when it runs.
  - [phase](#phase): A phase is when a test's file runs within a run (parallel, greedy, serial); a tier is what the test may touch.
  - [test suite](#test-suite): A test suite is a declared selection of modules up to a top tier; a tier is one level a single test carries.
  - [vertical test](#vertical-test): A vertical test is an L2 or L3 test that cuts from its ring through to the core; a tier names the ring,
    any test has one.

| Avoid           | Say instead                |
| --------------- | -------------------------- |
| `l2 suite`      | the L2 tests / the L2 tier |
| `l2 test suite` | the L2 tests / the L2 tier |
| `l3 suites`     | the L3 tests / the L3 tier |

### vertical test

An L2 or L3 test that cuts from an outer ring of the test onion (local tools; outside state) through to the core, the code alone.

- **Defined by:** [ADR-AUTO-TEST#38](automation/test-automation.md#rule-adr-auto-test38)
- **Realized by:** tag `L2|L3`
- **Source:** `automation/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [tier](#tier): A tier names a test's outermost ring and every test has one; a vertical test is an L2 or L3 test, one that crosses a
    ring.

## repository

### code link

An ADR citation in a code comment, written as a repository-rooted markdown link whose text is the citation code.

- **Defined by:** [ADR-REPO-LINK#1](repository/markdown-links.md#rule-adr-repo-link1)
- **Realized by:** function `Format-Links`
- **Source:** `automation/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [markdown link](#markdown-link): A markdown link lives in a .md file and is relative to it; a code link lives in a comment of a
    non-markdown file and is repository-rooted.

### domain rules

The repository's conventions and decision records — its ADRs and the rules they state.

- **Defined by:** [ADR-REPO-VOCAB#7](repository/controlled-vocabulary.md#rule-adr-repo-vocab7)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Docs/configs/glossary.yml`

| Avoid         | Say instead              |
| ------------- | ------------------------ |
| `house rules` | domain rules / ADR rules |

### markdown link

A link inside a rendered .md file, written relative to that file so it resolves the same on GitHub and in VS Code.

- **Defined by:** [ADR-REPO-LINK#1](repository/markdown-links.md#rule-adr-repo-link1)
- **Realized by:** function `Test-Links`
- **Source:** `automation/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [code link](#code-link): A code link lives in a comment of a non-markdown file and is repository-rooted; a markdown link lives in a .md
    file and is relative to it.
