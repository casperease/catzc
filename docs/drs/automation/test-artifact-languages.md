# Automation: Test-artifact languages — modules by layout, one root, black-box tests of the engine, one bridge

## Rules: ADR-AUTO-TESTLANG

### Rule ADR-AUTO-TESTLANG-MODULESBYLAYOUT

Code in a test-artifact language is either a module of that language's track, a folder under the language's root that exists by the layout
(ADR-AUTO-MODULE-EXISTSBYLAYOUT, ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE), or a black-box test under the track's test holder,
`<root>/tests/<module>/`. Such a module ships only what `files.yml` packages, and a test file never ships: the builder's input is the
engine's track, so no bundle holds a file of a test-artifact language by construction. No function of the engine is written in a
test-artifact language; a module of one is a tool of the repository that the engine runs as a process.

- [Outside the engine](#outside-the-engine)

### Rule ADR-AUTO-TESTLANG-ONEROOT

Each test-artifact language keeps its code and its tests under one root, a repository-relative folder declared by the language's config
`root` with one sensible default for every language, declared once on the config type and resolved there for every caller: the language's
track folder when the repository has it, else the same name dot-prefixed. The config names a `root` only to place the root elsewhere. Under
the root, the track's test holder `tests/<module>/` holds one test folder per catzc module, holding that module's black-box tests and named
by rendering the module's repository normal form in the language's own folder case (ADR-AUTO-IDIOM-TESTFOLDERBYIDIOM), so the folder maps
back to its module with no mapping file; a module of the language's own track keeps its tests in its own `tests/` folder.

- [One root](#one-root)

### Rule ADR-AUTO-TESTLANG-BLACKBOX

A test of the engine in a test-artifact language is a black-box test: it reaches the engine only through the start contract its runner sets
(ADR-AUTO-ENGINE-STARTENVIRONMENT), runs commands, and asserts on their output and exit codes, never on the engine's internals. The contract
is either the engine's executable with start arguments that load the run's entry and end in the test's command, or the language's own entry,
which the test loads the way a user of that language does; the test never builds a command line of its own. The entry is the repository's in
a source run and the build's in a build run, and the contract names the repository root. The runner sets the contract for its own processes
only and restores the session's values afterwards, so the same test proves both run modes unchanged (ADR-AUTO-TEST-SAMETESTSBOTHRUNS). A
test that starts the engine runs once per execution engine; a test that loads its language's own entry runs under that language's engine
only.

- [A black box](#a-black-box)

### Rule ADR-AUTO-TESTLANG-BRIDGE

The test run reaches every test-artifact language through one bridge: discovery reads the tests from the source, without the language's
tool, and maps each test folder to its catzc module, so ordering, protection, module and suite selection, the tiers, and both runs apply as
to the module's own tests. The bridge runs the language's runner once per mapped module and turns every top-level test into one test of the
run (ADR-AUTO-TEST-TEST), its subtests or parametrised cases folded into it. Every such test is tagged `L2`, a test through a real tool
(ADR-AUTO-TEST-NOCLOUDBELOWLTHREE), plus a category from its name, decided in one place, the language's test result type: a test the
language's integrity marker names is `integrity`, every other test `logic`. The run's source session locates the language's tool once, at
its locked version, and hands its path to the bridge beside the engine entry, and a worker never locates a tool itself; without the tool,
the bridge skips with a `tool_<name>_missing` reason, and without an execution engine, that engine's run skips the same way
(ADR-AUTO-TEST-TAGBYOUTERMOSTRING).

- [One bridge](#one-bridge)

## Context

The engine's own tests load its modules in-process and call functions directly. That suits the engine's logic and misses the question a user
asks: does the engine, started as a process the way a user or a pipeline starts it, do what it says? A test in a second language cannot
reach into the engine's session, so it can only ask that question. Go, Python and Bash each answer it from a different side, and JavaScript
tests the editor extensions, the modules of its own track, under the same root and through the same bridge. The twins
[go test artifacts](go/go-test-artifacts.md), [python test artifacts](python/python-test-artifacts.md),
[bash test artifacts](bash/bash-test-artifacts.md) and [javascript track](javascript/javascript-track.md) hold each language's spellings,
and this record holds the decision they share.

### Outside the engine

The risk of a second language is a second tech stack spreading through the repository: helpers beside the engine's functions, a second build
in the bundle, a second set of committed module files to keep in step. A test-artifact language is a language track like any other
([module-model](module-model.md#rule-adr-auto-module-everylanguagetrackalike)), and the engine stays one stack
([tracks](../design/tracks.md#rule-ddr-track-onetechstack)); a test verifies the engine from outside, and nothing in the engine calls it.
The builder reads the engine's track, so the layout is the guarantee that no test reaches a bundle ([platform-bundle](platform-bundle.md)).

### One root

One convention for every language's root ([sensible-defaults](sensible-defaults.md)) means a reader who knows one language's layout knows
them all. The track's folder is the natural root ([tracks](../design/tracks.md#rule-ddr-track-onetracktype)), and the dot-prefixed fallback,
as the tooling folders are named, keeps a repository without that folder from growing one for tests alone.

### A black box

A test knows two things about the engine, both from the environment its runner sets: how to start it and the repository it works on. The
start comes from the execution engine model ([execution-engines](execution-engines.md)), so a test that never builds a command line holds no
engine's quoting rule and runs unchanged under every engine. A language whose users load an entry of their own tests that path, the way its
user takes it. The variables are an external contract between the run and the processes it starts
([environment-variables](environment-variables.md#rule-adr-auto-envvar-setonlyfortools)).

The entry is the only difference between the two runs ([run-modes](../design/run-modes.md)), and the tests are the same files in both, so
"works in both modes" holds for the engine as a process too.

### One bridge

One bridge for every language means one test run ([test-automation](test-automation.md)): a test in any language is selected, ordered,
protected and reported exactly as the engine's own tests are, so a language adds its discovery and its runner, never a second test run.
Discovery reads the source, so it is fast, offline, and works where the tool is missing. A test of a second language runs a real tool, so
the bridge tags it `L2` with no per-test choice to make, and both tag axes stay mandatory and checked as for every test
(ADR-AUTO-TEST-TWOMANDATORYTAGS).

The tool belongs to the harness, not to the engine under test. A build run's workers load the build, which holds only the selected modules
and so not the tools config the tool's location reads; the source session therefore locates the tool once and hands the path down, and the
bundle under test stays exactly what ships.

## Decision

A test-artifact language holds modules by layout and black-box tests of the engine under one root, reached by the test run through one
bridge. Each language's twin record spells its root, its start contract, its tool and its checks.

## Consequences

- Adding a test-artifact language is a twin record, a config with a root, and a discovery for the bridge; the shared decision is not
  restated.
- No bundle holds a test of any language, by construction.
- A test in any language proves the engine as a process, in both run modes.
- Without its tool, a language's tests skip and the run says so.
