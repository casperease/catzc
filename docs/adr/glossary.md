# docs/adr/glossary.md

Glossary: the controlled vocabulary

Every defined term of the repository, generated from the glossary sources (each module's `configs/glossary.yml`) by `Build-Glossary` — edit
a source, never this page. A term's meaning is fixed by the one ADR rule that defines it
([controlled-vocabulary](repository/controlled-vocabulary.md)); this page collects them, with how each differs from its neighbours and the
phrasings to avoid. `Test-Glossary` checks the sources.

## thesis

### adjacent store

The one legitimate second store — a repository or service, such as a GitOps repository, with its own history, driven one way from the
trunk's pipelines and never edited beside it.

- **Defined by:** [ADR-THES-ONETRUTH#2](thesis/one-source-of-truth.md#rule-adr-thes-onetruth2)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [source of truth](#source-of-truth): The source of truth is the record everything is driven from; an adjacent store is a one-way
    projection of it, never a second record.

### pin

An explicit version, controlled by the consumer, of a dependency that crosses the repository boundary inward, stitched into an immutable
artifact at build time.

- **Defined by:** [ADR-THES-ONETRUTH#4](thesis/one-source-of-truth.md#rule-adr-thes-onetruth4)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [provided contract](#provided-contract): A provided contract is the promise catzc keeps to a consumer; a pin is the consumer's explicit
    choice of the version that promise holds for.
  - [trunk](#trunk): Inside the trunk everything is at HEAD, with no version; a pin is the one form of synchronisation, at the repository
    boundary.

### product mono-repository

One repository that several teams contribute to for one product, bounded into tracks and deployable-units by path filters; catzc is one.

- **Defined by:** [ADR-THES-ONETRUTH#4](thesis/one-source-of-truth.md#rule-adr-thes-onetruth4)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [trunk](#trunk): The trunk is the one mainline of a product mono-repository, where everything is at HEAD; the product mono-repository is
    the repository as a whole, with its tracks and deployable-units.

### query surface

The tooling's Get-* cmdlets, each of which also emits its answer as data (JSON), through which every question about the system's state is
answered.

- **Defined by:** [ADR-THES-ONETRUTH#3](thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Docs/configs/glossary.yml`

### source of truth

The one store whose content decides what is true about the delivered system — for catzc, the repository, changed through one change process.

- **Defined by:** [ADR-THES-ONETRUTH#1](thesis/one-source-of-truth.md#rule-adr-thes-onetruth1)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [adjacent store](#adjacent-store): An adjacent store is a second store driven one way from the trunk's pipelines, a projection of the
    truth; the source of truth is the record it is driven from.
  - [source](#source): A source, always qualified, names where one thing comes from; the source of truth is the one store that decides what
    is true about the delivered system.

### trunk

The one mainline of a product mono-repository, where everything is at HEAD — no internal versions, and a shared change lands in one commit
with all its consumers.

- **Defined by:** [ADR-THES-ONETRUTH#4](thesis/one-source-of-truth.md#rule-adr-thes-onetruth4)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [pin](#pin): A pin is an explicit version at the repository boundary; inside the trunk nothing is pinned, and everything is at HEAD.
  - [product mono-repository](#product-mono-repository): A product mono-repository is the repository as a whole, with its tracks and
    deployable-units; the trunk is its one mainline.

## design

### cell

One row crossed with one column of the world map — the tracked files of one track in one file language, and their count.

- **Defined by:** [ADR-DSGN-TRACK#10](design/tracks.md#rule-adr-dsgn-track10)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [lit cell](#lit-cell): A lit cell is a cell a highlight selects; a cell is any intersection, lit or not.
  - [stack violation](#stack-violation): A stack violation is a cell holding a live file outside its track's file languages; a cell is any
    intersection, allowed or not.
  - [world map](#world-map): The world map is the whole grid; a cell is one intersection of it, holding the files of one track in one file
    language.

### deployable-unit

What ships — a whole track or a reduced composition — bound one-to-one to its pipeline.

- **Defined by:** [ADR-DSGN-TRACK#5](design/tracks.md#rule-adr-dsgn-track5)
- **Realized by:** config-key `automation/Catzc.Base.Globs/configs/globs.yml`
- **Source:** `automation/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [release candidate](#release-candidate): A release candidate is one commit's tagged, immutable build of a deployable-unit; a
    deployable-unit is the composition that ships, whichever commit is built.
  - [track](#track): A track is a root concern, one root folder; a deployable-unit is what ships, composed from a whole track or a reduced
    part of one.

### file language

The language a tracked file is written in, named by its extension — PowerShell, C#, YAML, Bicep, Markdown, Python; a track's tech-stack is a
set of them.

- **Defined by:** [ADR-DSGN-TRACK#6](design/tracks.md#rule-adr-dsgn-track6)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [language zone](#language-zone): A language zone is one of the design, test, and live registers of identities; a file language is the
    kind of text one file holds.
  - [track](#track): A track is a root folder and the concern it holds; a file language is the kind of text one file holds, wherever it
    lives.
  - [unlisted file](#unlisted-file): An unlisted file is a tracked file no file language names — no extension, or one no entry lists; a file
    language is a registered kind of text, named by its extensions.

### lit cell

A world-map cell a highlight selects — an ADR code or a set of files names the files it concerns, and their cells light.

- **Defined by:** [ADR-DSGN-TRACK#12](design/tracks.md#rule-adr-dsgn-track12)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [cell](#cell): A cell is any intersection of the world map; a lit cell is one a highlight selects.
  - [stack violation](#stack-violation): A stack violation is a finding about a cell's files; a lit cell is a selection, made by a
    highlight, that never judges the cell.

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

### root file

A tracked file no track holds — at the repository root itself, or under out/ — the world map's own row.

- **Defined by:** [ADR-DSGN-TRACK#7](design/tracks.md#rule-adr-dsgn-track7)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [track](#track): A track is a root folder and every file under it; a root file is a tracked file outside every track.
  - [unlisted file](#unlisted-file): An unlisted file is a tracked file outside every file language, whatever its track; a root file is one
    outside every track, whatever its file language.

### stack violation

A world-map cell holding a live file whose file language its track does not declare — the second tech-stack ADR-DSGN-TRACK#3 forbids.

- **Defined by:** [ADR-DSGN-TRACK#11](design/tracks.md#rule-adr-dsgn-track11)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [cell](#cell): A cell is any intersection of the world map; a stack violation is a cell that breaks its track's tech-stack.
  - [lit cell](#lit-cell): A lit cell is selected by a highlight and says nothing about the stack; a stack violation is a finding, marked
    whatever the highlight.
  - [value-chain stack](#value-chain-stack): The value-chain stack orders decisions, not files; a stack violation is a world-map cell
    outside its track's tech-stack.

### track

A named repository root concern — one root folder, named by it, classified core, external port, adapter, or verification.

- **Defined by:** [ADR-DSGN-TRACK#1](design/tracks.md#rule-adr-dsgn-track1)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [deployable-unit](#deployable-unit): A deployable-unit is what ships, composed from a whole track or a reduced part of one; a track is
    the root concern itself, one root folder.
  - [file language](#file-language): A file language is the kind of text a file holds, named by its extension; a track is the root folder
    the file lives in, and its tech-stack is a set of file languages.
  - [root file](#root-file): A root file is a tracked file no track holds, at the repository root or under out/; a track is a root folder
    and every file under it.
  - [value-chain concern](#value-chain-concern): A value-chain concern is where along delivery a decision acts; a track is a root concern,
    the root folder where files live.
  - [verification track](#verification-track): A verification track is one class of track — test-only, shipping nothing; a track is any root
    concern.

### unlisted file

A tracked file no file language names — no extension, or one no entry lists — the world map's own column.

- **Defined by:** [ADR-DSGN-TRACK#8](design/tracks.md#rule-adr-dsgn-track8)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [file language](#file-language): A file language is a registered kind of text, named by its extensions; an unlisted file is a tracked
    file whose extension none of them lists.
  - [root file](#root-file): A root file is a tracked file outside every track; an unlisted file is a tracked file outside every file
    language, whatever its track.

### value-chain concern

Where along delivery an ADR acts — automation, build, quality-control, release, deploy, or access — a default per ADR domain, an override
per ADR.

- **Defined by:** [ADR-DSGN-TRACK#15](design/tracks.md#rule-adr-dsgn-track15)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [track](#track): A track is a root concern, the root folder where files live; a value-chain concern is where along delivery a decision
    acts.
  - [value-chain stack](#value-chain-stack): The value-chain stack is the rows, how general a decision is; a value-chain concern is a
    column, where along delivery it acts.

### value-chain map

The ADRs drawn as the value-chain stack crossed with the value-chain concerns, computed from adrs.yml — where a decision sits in the value
chain.

- **Defined by:** [ADR-DSGN-TRACK#16](design/tracks.md#rule-adr-dsgn-track16)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [world map](#world-map): The world map crosses tracks with file languages and says where a decision's files sit; the value-chain map
    says where along delivery the decision acts.

### value-chain stack

The ordered rows a decision sits on, from the axioms down to the vendor — PRIN, DSGN, AUTO, PIPE, CLOUD; each ADR domain declares one.

- **Defined by:** [ADR-DSGN-TRACK#14](design/tracks.md#rule-adr-dsgn-track14)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [stack violation](#stack-violation): A stack violation is a world-map cell outside its track's tech-stack, a set of file languages; the
    value-chain stack orders decisions, not files.
  - [value-chain concern](#value-chain-concern): A value-chain concern is a column, where along delivery an ADR acts; the value-chain stack
    is the rows, how general the decision is.

### verification track

A test-only track — it verifies the core from outside, ships nothing, and is out of every bundle by construction; go is the first.

- **Defined by:** [ADR-DSGN-TRACK#2](design/tracks.md#rule-adr-dsgn-track2)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Languages/configs/glossary.yml`
- **Kind of:** [track](#track)
- **Contrasts:**
  - [track](#track): A track is any root concern; a verification track is the test-only class that ships nothing.

### world map

The repository drawn as tracks crossed with file languages, plus a row for the root files and a column for the unlisted files — every
tracked file in exactly one cell.

- **Defined by:** [ADR-DSGN-TRACK#9](design/tracks.md#rule-adr-dsgn-track9)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [cell](#cell): A cell is one row crossed with one column; the world map is the whole grid of them, computed from the registries and the
    git index.
  - [value-chain map](#value-chain-map): The value-chain map says where along delivery a decision acts; the world map crosses tracks with
    file languages and says where its files sit.

## flow

### gate

A check whose verdict decides whether work may proceed — automated (a quality gate, the CI gate) or human (RC, RBC).

- **Defined by:** [ADR-FLOW-CD#13](flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd13)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.QualityGates/configs/glossary.yml`
- **Forms:** `quality gate`, `CI gate`, `AT gate`, `RC gate`, `RBC gate`, `BVT gate`, `release gate`, `manual gate`, `PR gate`,
  `merge gate`, `commit gate`, `approval gate`, `production gate`, `push gate`, and the bare `gate`
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
  - [published artifact](#published-artifact): A published artifact is any file handed across a stage boundary; a release candidate is the
    tagged build that gets promoted.
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

### bash test folder

The folder `<root>/tests/<module>/` under the Bash root — one per catzc module, named for it in kebab case, holding its black-box `.bats`
tests, which call catzc through `importer.sh` and `cats`.

- **Defined by:** [ADR-AUTO-BASH#2](automation/bash/bash-test-artifacts.md#rule-adr-auto-bash2)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Languages/configs/glossary.yml`

### build verification test

The BVT — the verification that precedes every promotion and every creation of release artifacts, and that the commit gate runs.

- **Defined by:** [ADR-AUTO-TEST#24](automation/test-automation.md#rule-adr-auto-test24)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [quality gate](#quality-gate): A quality gate is one check inside the BVT; the BVT is the verification that runs them together, before a
    promotion and in the commit gate.

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

### execution engine

System.Collections.Specialized.OrderedDictionary

- **Defined by:** [ADR-AUTO-ENGINE#1](automation/execution-engines.md#rule-adr-auto-engine1)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Engines/configs/glossary.yml`

### go test module

The folder `<root>/tests/<module>/` under the Go root — one Go module per catzc module, named for it in kebab case, holding its black-box Go
tests.

- **Defined by:** [ADR-AUTO-GO#2](automation/go/test-artifacts.md#rule-adr-auto-go2)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Languages/configs/glossary.yml`

### phase

One of a test run's three scheduling stages, in order — parallel shards, greedy, serial — chosen per file by the serial/greedy tags.

- **Defined by:** [ADR-AUTO-TEST#26](automation/test-automation.md#rule-adr-auto-test26)
- **Realized by:** tag `serial|greedy`
- **Source:** `automation/Catzc.Base.QualityGates/configs/glossary.yml`
- **Forms:** `parallel phase`, `serial phase`, `greedy phase`, `worker phase`, `execution phase`, `run phase`, `test phase`, and the bare
  `phase`
- **Contrasts:**
  - [tier](#tier): A tier is what a test may touch; a phase is when its file runs within a run (parallel, greedy, serial).

### published artifact

A file one stage produces and a later stage downloads and consumes — carried by ArtifactRef, anchored on its artifact root.

- **Defined by:** [ADR-AUTO-PATH#10](automation/path-representation.md#rule-adr-auto-path10)
- **Realized by:** type `Catzc.Base.Objects.ArtifactRef`
- **Source:** `automation/Catzc.Base.ModuleSystem/configs/glossary.yml`
- **Contrasts:**
  - [contract asset](#contract-asset): A contract asset is a checked-in file that states what the repository boundary requires, frozen with
    its unit's release; a published artifact is a file one stage produces and a later stage consumes within a run.
  - [release candidate](#release-candidate): A release candidate is the tagged build that gets promoted; a published artifact is any file
    handed across a stage boundary.

### python test folder

The folder `<root>/tests/<module>/` under the Python root — one per catzc module, named for it in kebab case, holding its black-box Python
tests; each is a member of the one generated uv workspace.

- **Defined by:** [ADR-AUTO-PY#2](automation/python/python-test-artifacts.md#rule-adr-auto-py2)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Languages/configs/glossary.yml`

### quality gate

A gate checking one property of the whole repository automatically — one Test-<subject> function that reports through
Write-QualityGateReport and throws once with every issue.

- **Defined by:** [ADR-AUTO-TEST#35](automation/test-automation.md#rule-adr-auto-test35)
- **Realized by:** function `Write-QualityGateReport`
- **Source:** `automation/Catzc.Base.QualityGates/configs/glossary.yml`
- **Kind of:** [gate](#gate)
- **Contrasts:**
  - [build verification test](#build-verification-test): The BVT is the verification that runs every quality gate together; a quality gate
    is one check inside it.
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

One invocation of Test-Automation, Test-CatzcBuild, or Invoke-TestFile over a selection of test files, in one location, with one report.

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

### testing in production

The L4 tier — tests of the released system itself, after final approval, that observe it and create nothing of their own.

- **Defined by:** [ADR-AUTO-TEST#41](automation/test-automation.md#rule-adr-auto-test41)
- **Realized by:** tag `L4`
- **Source:** `automation/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [vertical test](#vertical-test): A vertical test crosses the local-tool or outside-state ring around the code; testing in production
    checks the released system.

### tier

A test's level, L0 to L4 — one mandatory tag that sets what the test may touch and when it runs.

- **Defined by:** [ADR-AUTO-TEST#13](automation/test-automation.md#rule-adr-auto-test13)
- **Realized by:** tag `L0|L1|L2|L3|L4`
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
  - [testing in production](#testing-in-production): Testing in production checks the released system after final approval; a vertical test
    crosses a ring around the code.
  - [tier](#tier): A tier names a test's outermost ring and every test has one; a vertical test is an L2 or L3 test, one that crosses a
    ring.

## azure

### hub

The landing zone of a shared subscription — the network every spoke of its tier peers to, holding the private DNS zones.

- **Defined by:** [ADR-AZ-LZ#2](azure/landing-zones.md#rule-adr-az-lz2)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Azure.Templates/configs/glossary.yml`
- **Contrasts:**
  - [spoke](#spoke): A spoke is a customer subscription's landing zone, peered to its hub; a hub is a shared subscription's, listing its
    spokes.

### landing zone

The network, guardrails, and cost control a workload lands in — the CAF application landing zone, deployed once per subscription at
subscription scope by the discovery template.

- **Defined by:** [ADR-AZ-LZ#1](azure/landing-zones.md#rule-adr-az-lz1)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Azure.Templates/configs/glossary.yml`

### slot

A Bicep configuration slot — one config file of a template (`<env>[-<slot>].yml`), deploying one subscription's resource group.

- **Defined by:** [ADR-AZ-DATAMOD#2](azure/azure-data-model.md#rule-adr-az-datamod2)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Azure.Templates/configs/glossary.yml`
- **Forms:** `Bicep slot`, `base slot`, `configuration slot`, `root slot`, `template slot`, `indexed slot`, `special slot`, `optional slot`,
  `customer slot`, `platform slot`, `env slot`, `core slot`, `subfolder slot`, `target slot`, `region slot`, and the bare `slot`

### spoke

The landing zone of a customer subscription — peered to the hub of its tier, holding the subnet its workloads' private endpoints use.

- **Defined by:** [ADR-AZ-LZ#2](azure/landing-zones.md#rule-adr-az-lz2)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Azure.Templates/configs/glossary.yml`
- **Contrasts:**
  - [hub](#hub): A hub is a shared subscription's landing zone, listing its spokes; a spoke is a customer subscription's, peered to its hub.

## repository

### code link

An ADR citation in a code comment, written as a repository-rooted markdown link whose text is the citation code.

- **Defined by:** [ADR-REPO-LINK#1](repository/markdown-links.md#rule-adr-repo-link1)
- **Realized by:** function `Format-Links`
- **Source:** `automation/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [markdown link](#markdown-link): A markdown link lives in a .md file and is relative to it; a code link lives in a comment of a
    non-markdown file and is repository-rooted.

### contract

A binding interface at the repository boundary, held under contracts/ in either direction — provided or depended-on — and proven by its
owning module's tests.

- **Defined by:** [ADR-REPO-CONTRACT#1](repository/api-contracts.md#rule-adr-repo-contract1)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [contract asset](#contract-asset): A contract asset is one file in an owning module's folder of a unit's contracts/ version folder; a
    contract is the binding interface its assets state together.

### contract asset

One file in an owning module's folder of a unit's contracts/ version folder, whose path names the real file it constrains and whose name
picks its kind — a fragment, a schema, or a sample payload.

- **Defined by:** [ADR-REPO-CONTRACT#6](repository/api-contracts.md#rule-adr-repo-contract6)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [contract](#contract): A contract is the binding interface at the repository boundary; a contract asset is one checked-in file that
    states part of it.
  - [published artifact](#published-artifact): A published artifact is a file one stage produces and a later stage consumes within a run; a
    contract asset is a checked-in file that states what the repository boundary requires, frozen with its unit's release.

### depended-on contract

A contract an outside platform expects of our files and calls, such as GitHub reading a workflow file; it follows the platform, so a
platform change is a new draft.

- **Defined by:** [ADR-REPO-CONTRACT#1](repository/api-contracts.md#rule-adr-repo-contract1)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [provided contract](#provided-contract): A provided contract is a promise to an outside consumer, kept while the consumer pins that
    version of its unit; a depended-on contract records what a platform requires and follows the platform.

### domain

A group of ADRs — one docs/adr/ subfolder — that adrs.yml declares with its role and the domains it depends on.

- **Defined by:** [ADR-REPO-FOLDERS#5](repository/conventional-folders.md#rule-adr-repo-folders5)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Docs/configs/glossary.yml`
- **Forms:** `ADR domain`, `thesis domain`, `principles domain`, `process domain`, `design domain`, `flow domain`, `automation domain`,
  `configuration domain`, `pipelines domain`, `github domain`, `azure domain`, `repository domain`, `research domain`, `axioms domain`,
  `architecture domain`, `implementation domain`, `optimisable domain`, `owning domain`, and the bare `domain`
- **Contrasts:**
  - [language zone](#language-zone): A language zone is one of the design, test, and live registers of identities; an ADR domain groups
    ADRs.

### domain rules

The repository's conventions and decision records — its ADRs and the rules they state.

- **Defined by:** [ADR-REPO-VOCAB#7](repository/controlled-vocabulary.md#rule-adr-repo-vocab7)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Docs/configs/glossary.yml`

| Avoid         | Say instead              |
| ------------- | ------------------------ |
| `house rules` | domain rules / ADR rules |

### facet

One of several parallel views of, or checks on, the same thing, none above another — a build facet (types, load, parity, manifest) or a
module facet (disk, session).

- **Defined by:** [ADR-REPO-VOCAB#8](repository/controlled-vocabulary.md#rule-adr-repo-vocab8)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Docs/configs/glossary.yml`
- **Forms:** `build facet`, `types facet`, `load facet`, `parity facet`, `manifest facet`, `module facet`, `disk facet`, `session facet`,
  `runtime facet`, and the bare `facet`, with its verb forms
- **Contrasts:**
  - [layer](#layer): A layer is one level of a stack, sitting on or containing the next; a facet is a parallel view of the same thing.

### inspiration

A sibling repository declared in inspiration.yml and read for ideas, never as a reference implementation.

- **Defined by:** [ADR-REPO-INSPIRE#5](repository/inspiration.md#rule-adr-repo-inspire5)
- **Realized by:** type `Catzc.Tooling.Inspiration.InspirationEntry`
- **Source:** `automation/Catzc.Tooling.Inspiration/configs/glossary.yml`

| Avoid                | Say instead |
| -------------------- | ----------- |
| `inspiration source` | inspiration |

### language zone

One of the three registers — design, test, live — each with its own terminology and identities; a token belongs to exactly one.

- **Defined by:** [ADR-REPO-LANG#1](repository/domain-language-separation.md#rule-adr-repo-lang1)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Docs/configs/glossary.yml`
- **Forms:** `language zone`, `design zone`, `test zone`, `live zone`, `landing zone`, `dns zone`, `availability zone`, and the bare `zone`
- **Contrasts:**
  - [domain](#domain): An ADR domain groups ADRs in one docs/adr/ subfolder; a language zone is a register of identities.
  - [file language](#file-language): A file language is the kind of text one file holds, named by its extension; a language zone is a
    register of identities.

### layer

One stratum of a structure, always qualified — an implementation layer (language, PowerShell, installer, tooling) or a globset layer
(module, fileset).

- **Defined by:** [ADR-REPO-VOCAB#8](repository/controlled-vocabulary.md#rule-adr-repo-vocab8)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Docs/configs/glossary.yml`
- **Forms:** `implementation layer`, `automation layer`, `language layer`, `PowerShell layer`, `installer layer`, `config layer`,
  `configuration layer`, `Azure layer`, `tooling layer`, `YAML layer`, `module layer`, `template layer`, `templating layer`, `vendor layer`,
  `abstraction layer`, `analyzer layer`, `compatibility layer`, `mapping layer`, `serialization layer`, `base layer`, `design layer`,
  `spelling layer`, `Pester layer`, `pip layer`, `path layer`, `support layer`, `doctrine layer`, `globset layer`, `fileset layer`,
  `cross layer`, `ADR layer`, `shaping layer`, and the bare `layer`, with its verb forms
- **Contrasts:**
  - [facet](#facet): A facet is one of several parallel views of, or checks on, the same thing; a layer is one level of a stack.

### markdown link

A link inside a rendered .md file, written relative to that file so it resolves the same on GitHub and in VS Code.

- **Defined by:** [ADR-REPO-LINK#1](repository/markdown-links.md#rule-adr-repo-link1)
- **Realized by:** function `Test-Links`
- **Source:** `automation/Catzc.Base.QualityGates/configs/glossary.yml`
- **Contrasts:**
  - [code link](#code-link): A code link lives in a comment of a non-markdown file and is repository-rooted; a markdown link lives in a .md
    file and is relative to it.

### provided contract

A contract an outside consumer may rely on — the repository's only public API, kept while a consumer pins that version of its unit.

- **Defined by:** [ADR-REPO-CONTRACT#1](repository/api-contracts.md#rule-adr-repo-contract1)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Docs/configs/glossary.yml`
- **Contrasts:**
  - [depended-on contract](#depended-on-contract): A depended-on contract is what an outside platform expects of our files and calls, and it
    follows that platform; a provided contract is a promise to a consumer, kept while the consumer pins that version of its unit.
  - [pin](#pin): A pin is the consumer's explicit choice of a version that crosses the repository boundary; a provided contract is the
    promise catzc keeps under that pin.

### scope

What something reaches, always qualified — a PowerShell scope (module, script, global), an install scope (user, machine), or a selection
scope (verify, scan, content).

- **Defined by:** [ADR-REPO-VOCAB#8](repository/controlled-vocabulary.md#rule-adr-repo-vocab8)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Docs/configs/glossary.yml`
- **Forms:** `PowerShell scope`, `selection scope`, `module scope`, `user scope`, `machine scope`, `content scope`, `script scope`,
  `verify scope`, `shared scope`, `file scope`, `target scope`, `scan scope`, `test scope`, `persistent scope`, `category scope`,
  `global scope`, `process scope`, `Pester scope`, `default scope`, `install scope`, `markdown scope`, `repo scope`, `lint scope`,
  `child scope`, `environment scope`, `subscription scope`, `report scope`, `tag scope`, `declared scope`, `whole scope`, `top scope`,
  `strict scope`, `isolated scope`, `discovery scope`, `glossary scope`, `deployment scope`, `infra scope`, `radius scope`,
  `production scope`, and the bare `scope`, with its verb forms

### source

Where something comes from, always qualified — a source mode, run, or tree; a glossary source; a type, authored, vendor, or dot source.

- **Defined by:** [ADR-REPO-VOCAB#8](repository/controlled-vocabulary.md#rule-adr-repo-vocab8)
- **Realized by:** prose only — a vocabulary term with nothing in code to enforce
- **Source:** `automation/Catzc.Base.Docs/configs/glossary.yml`
- **Forms:** `glossary source`, `type source`, `authored source`, `dot source`, `function source`, `vendor source`, `catzc source`,
  `combined source`, `committed source`, `shipped source`, `tracked source`, `fixture source`, `comparison source`, `primary source`,
  `raw source`, `install source`, `rule source`, `docs source`, `derived source`, `current source`, `real source`, `configured source`,
  `public source`, `single source`, `token source`, `relative source`, `repo source`, `authoritative source`, `cross source`,
  `vendored source`, `input source`, and the bare `source`, with its verb forms
- **Contrasts:**
  - [source of truth](#source-of-truth): The source of truth is the one store that decides what is true about the delivered system, the
    repository; a source, always qualified, names where one thing comes from.
