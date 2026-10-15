---
catzc:
  derived:
    path: docs/adr/design/tracks.md
    kind: adr
    body_sha: ad1e63e6e8fd
    adrs:
      - ADR-DSGN-TRACK#1
      - ADR-DSGN-TRACK#10
      - ADR-DSGN-TRACK#11
      - ADR-DSGN-TRACK#12
      - ADR-DSGN-TRACK#13
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#17
      - ADR-DSGN-TRACK#2
      - ADR-DSGN-TRACK#3
      - ADR-DSGN-TRACK#4
      - ADR-DSGN-TRACK#5
      - ADR-DSGN-TRACK#6
      - ADR-DSGN-TRACK#7
      - ADR-DSGN-TRACK#8
      - ADR-DSGN-TRACK#9
      - ADR-REPO-VOCAB#1
---

# ADR: Tracks — the repository's root concerns

## Rules: ADR-DSGN-TRACK

### Rule ADR-DSGN-TRACK:1

A **track** is a named repository root concern, mapped onto exactly one root folder and named by that folder: `automation`,
`infrastructure`, `pipelines`, `docs`, `contracts`, `go`, `python`, `bash`, `.github`, `.cspell`, `.claude`, and `.unordered`. Every root
folder git tracks a file under names a track, except `out/`, which holds gitignored output; a track never spans two roots, and a root never
carries two tracks. Tracks are what this mono repository is composed of.

- [What a track is](#what-a-track-is)

### Rule ADR-DSGN-TRACK:2

Every track carries one classification from the taxonomy: **core** (defines the internal ports the other tracks rest on — `automation`),
**external port** (the repository's boundary/configuration for one outside concern — `contracts` for its API consumers and the platforms
that read its files, `docs` for its readers, and the dot-roots `.github`, `.cspell`, and `.claude` for the tools that read them), or
**adapter** (adapts the core to a delivery target — `infrastructure`, with its Bicep modules and named templates, and `pipelines`, the
delivery machines the deployable-units bind to), **unordered** (`.unordered`, ADR-DSGN-TRACK#17), or **verification**. A **verification
track** is a test-only track: it verifies the core from outside, ships nothing, and is out of every bundle by construction, because it lies
outside `automation/`, where the builder reads its modules. `go`, the Go black-box tests, is the first; a repository without a `go/` root
keeps the same tests in the dot-prefixed `.go`, which is of the same class. `python`, the Python black-box tests, is the second, by the same
convention: `.python` when the repository has no `python/` root. `bash`, the Bash black-box tests, is the third: `.bash` when the repository
has no `bash/` root. Cross-cutting slices (e.g. the cats configs — every yml/config file across automation) are **scopes over tracks**, not
tracks: they select through the roots rather than owning one.

- [The taxonomy](#the-taxonomy)

### Rule ADR-DSGN-TRACK:3

A track owns one coherent **tech-stack**, and a new tech-stack opens a new track — never a subfolder inside an existing one. `automation`'s
stack is deliberately intricate: two automation layers (PowerShell and C#) packaged as PowerShell modules. `infrastructure`'s stack is
deliberately simple — Bicep plus PowerShell extension points and one configuration yml per subscription target — and rests on `automation`
for context and execution. Future concerns follow the same shape: a `frontend` track for small front-apps, a `services` track for PaaS
services and C# function apps.

- [A track has a tech-stack](#a-track-has-a-tech-stack)

### Rule ADR-DSGN-TRACK:4

Tracks are **subscribable, never path-coupled**: a consumer binds to a track through its module dependencies (depm — dependencies between
modules, never on systems) or through its globset's native trigger projection, never by hand-matching the track's source paths. The globsets
are the source of truth that coordinates "which tracks and deployable-units carry changes in this commit" — computed from git, the mechanism
that keeps a change in one track from rebuilding every customer of every other track.

- [Subscription and coordination](#subscription-and-coordination)

### Rule ADR-DSGN-TRACK:5

A **deployable-unit** is what ships: a whole track (`ci-automation` verifies the entire automation track) or a reduced composition (the
shared infrastructure templates in a defined order, one customer's foundation). Deployable-units determine pipelines **1-1** — one unit, one
pipeline — widening to **1-2** only when a DEPLOY stage is split out of CD. A pipeline never binds to a track except through the
deployable-unit that IS that track.

- [Tracks, units, pipelines](#tracks-units-pipelines)

### Rule ADR-DSGN-TRACK:6

A **file language** is the language a tracked file is written in, named by its extension — PowerShell, C#, YAML, Bicep, Markdown, Python,
and so on — and every extension belongs to exactly one file language. A track's tech-stack (ADR-DSGN-TRACK#3) is the set of file languages
it owns, so a file in a language outside that set is a second tech-stack inside the track.

- [File languages](#file-languages)

### Rule ADR-DSGN-TRACK:7

A **root file** is a tracked file that no track holds: a file at the repository root itself (`LICENSE`, `importer.ps1`, `.gitignore`), or a
file under the one root folder that is not a track (`out/`). Root files belong to the repository as a whole, so the track-by-file-language
map gives them their own row, never a track's.

- [Root files and unlisted files](#root-files-and-unlisted-files)

### Rule ADR-DSGN-TRACK:8

An **unlisted file** is a tracked file that no file language names: it has no extension, or an extension no file language lists. An unlisted
file sits in its own column of the track-by-file-language map, never in a file language's, so every tracked file has exactly one cell.

- [Root files and unlisted files](#root-files-and-unlisted-files)

### Rule ADR-DSGN-TRACK:9

A **world map** is the repository drawn as its tracks crossed with its file languages: one row per track (ADR-DSGN-TRACK#1) and one for the
root files (ADR-DSGN-TRACK#7), one column per file language (ADR-DSGN-TRACK#6) and one for the unlisted files (ADR-DSGN-TRACK#8), and every
tracked file counted in exactly one cell. It is computed from the track and file-language registries and the git index, never drawn by hand,
so it is the same picture on every run of the same commit.

- [The world map](#the-world-map)

### Rule ADR-DSGN-TRACK:10

A **cell** is one row crossed with one column of a map, the world map (ADR-DSGN-TRACK#9) or the value-chain map (ADR-DSGN-TRACK#16). A
world-map cell holds the tracked files whose root folder names its row and whose extension names its column, and its file count is how many
there are; a value-chain map cell holds the ADRs whose ADR domain declares its row and whose value-chain concerns include its column. Every
row meets every column, so an empty cell is still a cell of the map.

- [The world map](#the-world-map)

### Rule ADR-DSGN-TRACK:11

A **stack violation** is a cell that holds a live file whose file language its track does not declare: the second tech-stack
ADR-DSGN-TRACK#3 forbids, made visible. Test files, vendored files, and the files of a verification track are never live, so they never make
one, and the root files' row has no track, so none of its cells is one.

- [The world map](#the-world-map)

### Rule ADR-DSGN-TRACK:12

A **lit cell** is a cell a highlight selects. On the world map, an ADR code, or a set of files, names the files it concerns, and every cell
holding one of them is lit; on the value-chain map, an ADR code, or one of its rules, lights every cell its ADR sits in. A lit cell answers
"where does this decision, or this change, sit"; lighting a cell never changes what the cell holds.

- [The world map](#the-world-map)

### Rule ADR-DSGN-TRACK:13

Every label the world map prints names a defined term in its head, the text before its first colon: each title, each axis header, the header
of each catch-all row or column, and each legend entry; the row and column names are tracks and file languages. A concept the map prints
gets its defining rule and its glossary entry before the map prints it, and a label is never reworded to slip past the check. The
`Test-WorldMap` quality gate checks it.

- [The world map](#the-world-map)

### Rule ADR-DSGN-TRACK:14

The **value-chain stack** is the ordered set of rows a decision sits on, from the axioms down to the vendor: `PRIN` (what catzc is for, its
principles, its process, and the research they rest on), `DSGN` (how the platform and its delivery flow are shaped), `AUTO` (the tooling
that enacts them), `PIPE` (the pipelines that run the tooling), and `CLOUD` (the substrate it deploys onto). Every ADR domain declares
exactly one row (`stack:` in `adrs.yml`), and every ADR it holds sits on that row. The value-chain stack orders decisions; it is not a
track's tech-stack (ADR-DSGN-TRACK#3), which is a set of file languages.

- [The value-chain map](#the-value-chain-map)

### Rule ADR-DSGN-TRACK:15

A **value-chain concern** is one of the six columns that say where along delivery an ADR acts, in value-chain order: `automation` (loading
the modules, reading their configuration, and selecting files through globsets), `build` (turning the tracked files into an artifact),
`quality-control` (verifying a change — tests, checks, and quality gates), `release` (making a build a versioned, promotable release
candidate), `deploy` (putting a release onto its target), and `access` (reaching and operating what runs — identities, credentials, and
monitoring). Every ADR domain declares a default (`concern:` in `adrs.yml`), and an ADR declares its own only when it differs, so every ADR
resolves to one or more value-chain concerns, never to none and never to an unknown one. A value-chain concern is not a track's root concern
(ADR-DSGN-TRACK#1): a track is where files live, and a value-chain concern is where a decision acts.

- [The value-chain map](#the-value-chain-map)

### Rule ADR-DSGN-TRACK:16

The **value-chain map** is the ADRs drawn as the value-chain stack crossed with the value-chain concerns: one row per row of the stack
(ADR-DSGN-TRACK#14) and one column per value-chain concern (ADR-DSGN-TRACK#15), and an ADR lights the places where the row of the ADR domain
that holds it meets each of its value-chain concerns. It is computed from `adrs.yml`, never drawn by hand, and every label it prints names a
defined term in its head, as the world map's labels do (ADR-DSGN-TRACK#13); its row names are the rows of the value-chain stack, and its
column names are the value-chain concerns.

- [The value-chain map](#the-value-chain-map)

### Rule ADR-DSGN-TRACK:17

The **unordered track** (`.unordered`, class `unordered`) holds fragments frozen at the moment they were committed, such as finished plans,
and it is not part of the system. No command, default, glob, gate, generator, or agent reads, writes, or falls back to it unless a person
names it, and nothing depends on a file in it, because the track may be emptied at any time and `git log` keeps its history. It holds no
active work: the running session's scratch lives in `out/`, and an active plan is `out/plan-<topic>.md`.

- [The unordered track](#the-unordered-track)

## Context

A mono repository holds several concerns that differ in everything but their home: language, delivery target, cadence, and blast radius.
Without a named concept for "the root concern", those differences leak everywhere — pipelines path-filter on ad-hoc folder lists, tests
guess their scope, and a change in one corner rebuilds customers who never consumed it. The repository has the ingredients (root folders
with strong conventions, the globset registry with durable-SHA stamps, per-module dependency maps); a track is the word that ties them
together, and the rules below keep them tied.

### What a track is

The unit of "concern" in this repository is the root folder. `automation/` is the automation platform; `infrastructure/` is the IaC tree;
`pipelines/` holds the delivery pipelines; `docs/` is the documentation; `contracts/` is the repository boundary's binding contracts, in
both directions; each `.<foldername>` configures exactly one external system (the repository's boundary for that concern). `out/` is a root
folder but not a concern: it holds the output every run writes, gitignored (`ADR-REPO-OUTDIR`). Naming the concept makes the mapping
normative: the folder is the registration (the root folders and their conventions are `ADR-REPO-FOLDERS`), the folder name is the track
name, and asking "which track does this file belong to?" always has exactly one answer. That single-answer property is what every consumer
below builds on.

### The taxonomy

Tracks are not peers in role, only in shape. The **core** track defines the internal ports — `automation` is the engine, and every other
track assumes it. **External ports** hold the repository's side of an outside contract: `contracts/` for consumers of this repo and the
platforms that read it, `docs/` for its human readers (the ADRs, reference articles, and guides, partly generated by the core), the
dot-roots (`.github/`, `.cspell/`, `.claude/`) for the tools that read them. **Adapters** turn the core's capabilities toward a delivery
target — `infrastructure/` adapts to Azure through Bicep modules and named templates, and `pipelines/` adapts to Azure DevOps: each pipeline
is a deployable-unit's delivery machine, and it runs the core through one runner script. **Verification** tracks test the core from outside
and deliver nothing: `go/` holds black-box tests that start the engine as a process and assert on what it prints, so its files are never
part of a deployable-unit's output, and no bundle can hold them. The three verification tracks have their own ADRs:
[go-test-artifacts](../automation/go/go-test-artifacts.md), [python-test-artifacts](../automation/python/python-test-artifacts.md), and
[bash-test-artifacts](../automation/bash/bash-test-artifacts.md). The taxonomy earns its keep in review: a proposed root that is none of
these is probably a subfolder of an existing track, and a cross-cutting need (all config files, all markdown) is a **scope** — a globset
selecting through tracks — not a new root.

### A track has a tech-stack

The stack is the reason tracks exist as _separate roots_ rather than folders inside one tree: each stack brings its own toolchain, its own
verification, and its own failure modes. Keeping one stack per track keeps every gate honest — the automation tests verify PowerShell/C#,
the infrastructure quality gates verify Bicep against its configuration model, the Go toolchain runs and vets the Go tests — and keeps the
door open for new stacks (`frontend`, `services`) without disturbing the existing ones. The dependency between stacks is explicit and
one-directional: adapters, ports, and verification tracks rest on the core (`infrastructure` consumes `automation` for context and
execution, `go` starts it as a process), never the reverse.

### Subscription and coordination

Two subscription surfaces exist, both derived from the same source of truth:

- **depms** — the module dependencies declare which modules (and by extension which tracks) a consumer rests on; the graph quality gates
  enforce them. A depm is module-to-module only — a dependency on a system is a dep, a different concern with different tooling.
- **globset projections** (`ADR-FLOW-CD-GLOBS`) — each track's globset projects to native vendor path filters that pipelines trigger on, and
  to a git-reflected area-of-control the PR report reads; test tooling derives blast radius from the same globsets. Nothing is committed per
  set.

This is the coordination answer to the monorepo's core tension: everything lives together, but nothing rebuilds together unless the change
actually touches it.

### Tracks, units, pipelines

A track is a concern; a deployable-unit is a shippable composition; a pipeline is a unit's delivery machine. The three relate strictly:
units compose from tracks (whole or reduced), pipelines bind to units 1-1 (1-2 when DEPLOY splits from CD), and nothing binds to a track's
source paths directly. `ci-automation` is the degenerate-but-common case where the unit is the whole core track; the per-customer CD
pipelines are the reduced case — one customer's foundation unit, composed from the infrastructure track's shared modules plus that
customer's configuration surface.

### File languages

"One tech-stack per track" is only checkable when a stack is made of something countable. The countable part is the file language: every
tracked file has exactly one, read off its extension, so the files of a track add up to the set of languages the track actually holds. A
stack is that set as declared — `automation` holds PowerShell and C#, `infrastructure` holds Bicep and its configuration YAML — and a file
whose language falls outside its track's declared set is the second stack the rule forbids, visible without reading the file. A file
language is not a tech-stack: the stack adds the toolchain, verification, and failure modes around its languages, while the language is only
the kind of text a file holds.

### Root files and unlisted files

Crossing the tracks with the file languages places a file only when it has both. Two kinds of file have one but not the other, and naming
them keeps the map whole instead of dropping them. A root file has no track: the license, the importer scripts, the git settings at the top
of the tree, and the placeholder that keeps `out/` in git. An unlisted file has no file language: a `.gitkeep`, a `LICENSE`, or an extension
no entry of the file-language registry lists yet. The root files get one row of their own and the unlisted files one column, and a file that
is both sits where they cross, so the map's file count equals the tracked file count. An unlisted file in a track's live aspect is still a
second tech-stack (ADR-DSGN-TRACK#3) when it has an extension: an extension nobody registered is a language nobody declared.

### The world map

The rules above make the repository countable, and the world map is the count drawn. Its rows are the tracks and its columns the file
languages, so a reader sees at a glance which track holds which kinds of text and how much of each. A cell is where one track meets one file
language, and its shade says how many files sit there. A stack violation is marked on its cell, because the place is the finding: it says
which track holds the second stack and in which language. A highlight lights the cells an ADR governs or a change touches, so the same
picture answers "where does this decision apply" and "where does my change sit". The map prints only defined terms
([ADR-REPO-VOCAB#1](../repository/controlled-vocabulary.md#rule-adr-repo-vocab1)): a label that names an undefined concept would teach its
reader a word the repository never fixed, so every printed concept carries a rule here and a glossary entry, and the quality gate fails a
label that names none.

### The unordered track

A finished plan, an old sketch, or a note nobody owns has no place in the system, and deleting it loses what `git log` would keep. The
unordered track is that place: a root folder that git tracks and the world map counts, so the root-folder rule (ADR-DSGN-TRACK#1) holds,
with one property that sets it apart. It is a shelf, not a source: it has no tech-stack beyond the Markdown it holds, no consumer, and no
default. Anything that quietly read from it would make the system depend on fragments that exist only because nobody deleted them, so the
rule is stated as a prohibition, and every other track keeps its own reason to exist. Active plans never start here: they live in
`out/plan-<topic>.md`, the gitignored output directory, and move to the unordered track only once they are done.

### The value-chain map

The world map says where a decision's files sit; it cannot say where along delivery the decision acts. A rule about formatting and a rule
about release tags can govern the same PowerShell files in the same track, and the world map lights the same cells for both. The value-chain
map answers the other question. Its rows are the value-chain stack, ordered from the axioms every decision specialises down to the vendor
every deployment lands on, so the row says how general a decision is. Its columns are the value-chain concerns, ordered the way a change
travels — the tooling it runs on, its build, its verification, its release, its deployment, and the access to what runs — so the columns
read left to right like the value-chain diagrams ([visual-design](visual-design.md)). The two maps sit side by side because each answers
what the other cannot.

The place is declared, never guessed. Every ADR domain names its row and a default set of value-chain concerns in `adrs.yml`, and an ADR
that acts elsewhere declares its own, so the declaration is made once per ADR domain and repeated only where an ADR differs, the same
resolution every setting follows ([sensible-defaults](../automation/sensible-defaults.md#rule-adr-auto-default6)). Both words are qualified
on purpose: "concern" already names a track, the repository's root concern, and "stack" already names a track's tech-stack, so the
value-chain forms keep each word to one meaning.

## Decision

Name the concept: repository root concerns are **tracks** — folder-named (ADR-DSGN-TRACK#1), classified core/port/adapter/verification, plus
the unordered shelf that nothing defaults to (ADR-DSGN-TRACK#2, ADR-DSGN-TRACK#17), one tech-stack each (ADR-DSGN-TRACK#3), subscribable
only via depms and globset projections (ADR-DSGN-TRACK#4), and shipped through deployable-units that bind pipelines 1-1 (ADR-DSGN-TRACK#5).
A tech-stack is a set of file languages, each named by its extension (ADR-DSGN-TRACK#6). The world map crosses the tracks with the file
languages (ADR-DSGN-TRACK#9), with a row for the root files and a column for the unlisted files (ADR-DSGN-TRACK#7, ADR-DSGN-TRACK#8); its
cells (ADR-DSGN-TRACK#10) mark the stack violations (ADR-DSGN-TRACK#11) and light for a highlight (ADR-DSGN-TRACK#12), and every label it
prints names a defined term (ADR-DSGN-TRACK#13). Beside it, the value-chain map (ADR-DSGN-TRACK#16) crosses the value-chain stack
(ADR-DSGN-TRACK#14) with the value-chain concerns (ADR-DSGN-TRACK#15), both declared per ADR domain in `adrs.yml`, with a per-ADR override
of the concerns.

### How this is enforced

- **`ADR-REPO-FOLDERS`** (conventional folders) keeps the root inventory deliberate — a new root folder is a reviewed decision, and under
  this ADR it is the decision to open a track.
- **The globset registry** (`Catzc.Base.Globs`, `ADR-FLOW-CD-GLOBS`) declares each track's file set; pipelines filter on its native
  projection and the drift quality gate fails a trigger that no longer matches, while the git-reflected report answers what a change
  touches.
- **depms and the dependency-graph quality gates** (`ADR-AUTO-DEPM`) enforce the declared subscription edges, including the one-directional
  core ← adapter/port dependency.
- **The `Test-WorldMap` quality gate** reads the world map and fails on a stack violation (ADR-DSGN-TRACK#11), a root folder with tracked
  files that no track names (ADR-DSGN-TRACK#1), and a printed label that names no defined term (ADR-DSGN-TRACK#13).
- **`Catzc.Base.Docs.AdrsConfig`**, the type of `adrs.yml`, declares the rows of the value-chain stack and the value-chain concerns once, in
  order, and fails the load on an ADR domain without a row or a default, on a row or a value-chain concern outside them, and on an unknown
  key, so every ADR resolves to its row and one or more value-chain concerns (ADR-DSGN-TRACK#14, ADR-DSGN-TRACK#15).
- **Code review** applies the taxonomy: a new root must name its classification and tech-stack; a cross-cutting need becomes a scope
  globset, not a root.

## Consequences

- "Which track does this change touch?" has one answer, computed (git-reflected against the globsets), not argued.
- "Where along delivery does this decision act?" has a declared answer too: the value-chain map reads it from `adrs.yml`, and a new ADR
  inherits its ADR domain's default until it declares otherwise.
- Pipelines, tests, and reviewers all read the same coordination surface, so a change's blast radius is the same fact everywhere.
- Opening a concern is cheap and bounded: one root folder, one classification, one globset entry — and the rest of the repository is
  untouched by construction.
- The cost is discipline at the root: no drive-by root folders, no second stack smuggled into an existing track, and the registry has to
  stay curated as tracks grow.
