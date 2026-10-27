# ADR: Test-artifact languages — modules by layout, one root, black-box tests of the engine, one bridge

## Rules: ADR-AUTO-TESTLANG

### Rule ADR-AUTO-TESTLANG-MODULESBYLAYOUT

Code in a test-artifact language is either a module of that language's track, a folder under the language's root that exists by the layout
(ADR-AUTO-MODULE-EXISTSBYLAYOUT, ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE), or a black-box test under the track's test holder,
`<root>/tests/<module>/`. Such a module ships only what `files.yml` packages, and a test file never ships: the builder's input is the
engine's track, so no bundle holds a file of a test-artifact language by construction. No function of the engine is written in a
test-artifact language; a module of one is a tool of the repository that the engine runs as a process.

- [Outside the engine](#outside-the-engine)

### Rule ADR-AUTO-TESTLANG-ONEROOT

Each test-artifact language keeps its tests under one root, a repository-relative folder declared by the language's config `root` with one
sensible default for every language: the track folder named for the language when the repository has it, else the same name dot-prefixed.
Under the root, one test folder per catzc module holds that module's tests, named for the module in the language's own folder case
(ADR-AUTO-IDIOM-TESTFOLDERBYIDIOM).

- [One root](#one-root)

### Rule ADR-AUTO-TESTLANG-BLACKBOX

A test in a test-artifact language is a black-box test: it starts the engine from the start contract its runner sets
(ADR-AUTO-ENGINE-STARTENVIRONMENT), runs commands, and asserts on their output and exit codes, never on the engine's internals. The runner
sets that contract for its own processes only and restores the session's values afterwards, so the same test proves both run modes unchanged
(ADR-AUTO-TEST-SAMETESTSBOTHRUNS).

- [Outside the engine](#outside-the-engine)

### Rule ADR-AUTO-TESTLANG-BRIDGE

The test run reaches every test-artifact language through one bridge: discovery maps each test folder to its catzc module, so ordering,
protection, module and suite selection, the tiers, and both runs apply as to the module's own tests, and every top-level test becomes one
test of the run (ADR-AUTO-TEST-TEST), tagged `L2` (ADR-AUTO-TEST-NOCLOUDBELOWLTHREE) plus a category from its name. The run's source session
locates the language's tool once and hands its path to the bridge; without the tool, the bridge skips with a `tool_<name>_missing` reason
(ADR-AUTO-TEST-TAGBYOUTERMOSTRING).

- [One bridge](#one-bridge)

## Context

The engine's own tests load its modules in-process and call functions directly. That suits the engine's logic and misses the question a
user asks: does the engine, started as a process the way a user or a pipeline starts it, do what it says? A test in a second language
cannot reach into the engine's session, so it can only ask that question. Go, Python and Bash each answer it from a different side; the
twins [go test artifacts](go/go-test-artifacts.md), [python test artifacts](python/python-test-artifacts.md) and
[bash test artifacts](bash/bash-test-artifacts.md) hold each language's spellings, and this record holds the decision they share.

### Outside the engine

The risk of a second language is a second tech stack spreading through the repository: helpers beside the engine's functions, a second
build in the bundle, a second set of committed module files to keep in step. A test-artifact language is a language track like any other
([module-model](module-model.md#rule-adr-auto-module-everylanguagetrackalike)), and the engine stays one stack
([tracks](../design/tracks.md#rule-ddr-track-onetechstack)); a test verifies the engine from outside, and nothing in the engine calls it. The
builder reads the engine's track, so the layout is the guarantee that no test reaches a bundle ([platform-bundle](platform-bundle.md)).

### One root

Every language's root follows the same convention, declared once on its config type ([sensible-defaults](sensible-defaults.md)), so a
reader who knows one language's layout knows them all, and the same folder-case rendering lets the harness map a test folder to its catzc
module with no mapping file.

### One bridge

One bridge for every language means one test run: a test in any language is selected, ordered, protected and reported exactly as the
engine's own tests are, so a language adds its discovery and its tool, never a second runner.

## Decision

A test-artifact language holds modules by layout and black-box tests of the engine under one root, reached by the test run through one
bridge. Each language's twin record spells its root, its start contract, its tool and its checks.

## Consequences

- Adding a test-artifact language is a twin record, a config with a root, and a discovery for the bridge; the shared decision is not
  restated.
- No bundle holds a test of any language, by construction.
- A test in any language proves the engine as a process, in both run modes.
