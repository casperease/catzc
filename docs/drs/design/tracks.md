# Design: Tracks — the repository's root concerns

## Rules: DDR-TRACK

### Rule DDR-TRACK-ISPLACEDCLUSTER

A **track** is a named, on-disk cluster of one concern's files, declared once as a set of **members**
([DDR-TRACKTYPE-TYPESDECLAREDONCE][r1]). A member is a folder, a file or a glob, and it carries two facts: **generated**, whether a writer
renders it rather than a person authoring it, and **committed**, whether git tracks it or it is gitignored. `generated` is a member fact,
never a track: a member a catzc generator writes takes it from that generator's declaration, a member only a vendor tool writes declares it
on the member, and both at once is a load failure. `committed` is declared on the member and agrees with the git index. A **place** is the
path of one member: a track's places are computed from its members and never declared beside them. Every file on disk lies in exactly one
track, found by the longest member that contains it ([DDR-TRACKTYPE-LONGESTPLACEWINS](track-types.md#rule-ddr-tracktype-longestplacewins)),
or is a root file (DDR-TRACK-ROOTFILE). `out/` is a track too, the `output` track, its one member generated and not committed. A track's
name is its one definitive name, computed from its members
([DDR-TRACKTYPE-NAMEFROMMEMBERS](track-types.md#rule-ddr-tracktype-namefrommembers)). Tracks are what this mono repository is composed of.

- [What a track is](#what-a-track-is)

### Rule DDR-TRACK-ONETRACKTYPE

Every track has exactly one **track type**, one of the closed set
([DDR-TRACKTYPE-CLOSEDSETOFTYPES](track-types.md#rule-ddr-tracktype-closedsetoftypes)), stated once and carrying no second classification
beside it. The `modules` type holds `pwsh`, the core the other tracks rest on, and the other language tracks, `python`, `go`, `bash` and
`js`, which hold their modules the same way; `.unordered` is the `unordered` track (DDR-TRACK-UNORDEREDTRACK). The type's role is deployable
or holder ([DDR-TRACKTYPE-ONEROLE](track-types.md#rule-ddr-tracktype-onerole)). Each language track keeps a test holder, `<root>/tests/`, of
black-box tests that verify the core from outside; a test file is never live and never ships, and a module of the track ships only what
`files.yml` packages. A repository without a language track's root keeps that track in a dot-prefixed folder of the same name and the same
class, declared once in the languages config. Cross-cutting slices (e.g. the cats configs — every yml/config file across the modules track)
are **scopes over tracks**, not tracks: they select through the roots rather than owning one.

- [The taxonomy](#the-taxonomy)

### Rule DDR-TRACK-MODULENAMESPACE

Each modules track may declare a **module namespace**, once, in its track declaration: a module's full name is that namespace joined to its
folder name in the track's language form, so the track's module folders are named without it. The full name is what leaves the repository
and what code, configs and docs name (a manifest, a loaded module, a C# namespace, a package); the folder name is what the path, which
already states the track, adds. One resolver maps a folder name to a full name and back, and no other code joins the namespace by hand: a
reader that needs a module's location names the module or the track and resolves it, never spells a path with the namespace in it. No folder
or file under a track's members starts with the track's namespace on disk, apart from a global name the track declares exempt, such as a
file that names a product-wide identity. A built bundle is no track place: its module folders carry the full names, because an engine's
module path finds a module only in a folder named for it, so it resolves with no namespace. A track that declares none names its modules by
their folders, and only a track whose type admits modules may declare one.

- [Module namespaces](#module-namespaces)

### Rule DDR-TRACK-ONETECHSTACK

A track owns one coherent **tech-stack**, and a new tech-stack opens a new track — never a subfolder inside an existing one. `pwsh`'s stack
is deliberately intricate: PowerShell, with the C# types it hosts, packaged as PowerShell modules. `infrastructure`'s stack is deliberately
simple — Bicep plus PowerShell extension points and one configuration yml per subscription target — and rests on `pwsh` for context and
execution. Future concerns follow the same shape: a `frontend` track for small front-apps, a `services` track for PaaS services and C#
function apps.

- [A track has a tech-stack](#a-track-has-a-tech-stack)

### Rule DDR-TRACK-SUBSCRIBABLENOTPATH

Tracks are **subscribable, never path-coupled**: a consumer binds to a track through its module dependencies (depm — dependencies between
modules, never on systems) or through its globset's native trigger projection, never by hand-matching the track's source paths. The globsets
are the source of truth that coordinates "which tracks and deployable-units carry changes in this commit" — computed from git, the mechanism
that keeps a change in one track from rebuilding every customer of every other track.

- [Subscription and coordination](#subscription-and-coordination)

### Rule DDR-TRACK-DEPLOYABLEUNIT

A **deployable-unit** is what ships: a reduced composition of tracks (the shared infrastructure templates in a defined order, one customer's
foundation). Deployable-units determine CD pipelines **1-1** — one unit, one pipeline — widening to **1-2** only when a DEPLOY stage is
split out of CD. A CI pipeline that verifies a whole track binds that track's own globset; no other pipeline binds a track's source paths
directly.

- [Tracks, units, pipelines](#tracks-units-pipelines)

### Rule DDR-TRACK-FILELANGUAGE

A **file language** is the language a tracked file is written in, named by its extension — PowerShell, C#, YAML, Bicep, Markdown, Python,
and so on — and every extension belongs to exactly one file language. A track's tech-stack (DDR-TRACK-ONETECHSTACK) is the set of file
languages it owns, so a file in a language outside that set is a second tech-stack inside the track.

- [File languages](#file-languages)

### Rule DDR-TRACK-ROOTFILE

A **root file** is a file on disk that no track's member names. Every file a track's concern owns joins that track as a member, the files at
the repository root included, so a root file is the exception the track declaration has not yet placed, never a home by design. Root files
belong to the repository as a whole, so the track-by-file-language map gives them their own row, never a track's.

- [Root files and unlisted files](#root-files-and-unlisted-files)

### Rule DDR-TRACK-UNLISTEDFILE

An **unlisted file** is a tracked file that no file language names: it has no extension, or an extension no file language lists. An unlisted
file sits in its own column of the track-by-file-language map, never in a file language's, so every tracked file has exactly one cell.

- [Root files and unlisted files](#root-files-and-unlisted-files)

### Rule DDR-TRACK-WORLDMAP

A **world map** is the repository drawn as its tracks crossed with its file languages: one row per track (DDR-TRACK-ISPLACEDCLUSTER) and one
for the root files (DDR-TRACK-ROOTFILE), one column per file language (DDR-TRACK-FILELANGUAGE) and one for the unlisted files
(DDR-TRACK-UNLISTEDFILE), and every tracked file counted in exactly one cell. It is computed from the track and file-language registries and
the git index, never drawn by hand, so it is the same picture on every run of the same commit.

- [The world map](#the-world-map)

### Rule DDR-TRACK-CELL

A **cell** is one row crossed with one column of a map, such as the world map (DDR-TRACK-WORLDMAP). A world-map cell holds the tracked files
whose track names its row and whose extension names its column, and its file count is how many there are. Every row meets every column, so
an empty cell is still a cell of the map.

- [The world map](#the-world-map)

### Rule DDR-TRACK-STACKVIOLATION

A **stack violation** is a cell that holds a live file whose file language its track does not declare: the second tech-stack
DDR-TRACK-ONETECHSTACK forbids, made visible. Test files and vendored files are never live, so they never make one, and the root files' row
has no track, so none of its cells is one.

- [The world map](#the-world-map)

### Rule DDR-TRACK-LITCELL

A **lit cell** is a cell a highlight selects. On the world map, a rule code, or a set of files, names the files it concerns, and every cell
holding one of them is lit. A lit cell answers "where does this decision, or this change, sit"; lighting a cell never changes what the cell
holds.

- [The world map](#the-world-map)

### Rule DDR-TRACK-LABELSNAMEDEFINEDTERMS

Every label the world map prints names a defined term in its head, the text before its first colon: each title, each axis header, the header
of each catch-all row or column, and each legend entry; the row and column names are tracks and file languages. A concept the map prints
gets its defining rule and its glossary entry before the map prints it, and a label is never reworded to slip past the check. The
`Test-WorldMap` quality gate checks it.

- [The world map](#the-world-map)

### Rule DDR-TRACK-UNORDEREDTRACK

The **unordered track** (`.unordered`, class `unordered`) is where imports land, and the unordered part of the repository is whatever is
still under `.unordered/`. An **import** brings an outside repository into this one with its full history; it lands at a **landing
address**, `.unordered/<name>`, where the name is a short kebab word unique among the addresses. **Sorting** moves a file from its landing
address to its module or track with `git mv`, so its history follows. The track is not part of the system: no command, default, glob, gate,
generator, or agent reads, writes, or falls back to it unless a person names it, and nothing depends on a file in it.

- [The unordered track](#the-unordered-track)

### Rule DDR-TRACK-MIGRATEONEFILEPERCOMMIT

A file leaves the unordered track one file per commit: the commit that sorts it to its module or track also brings it into the eac normal
form, so it leaves its landing address only when it is in the form, and a file not yet in the form stays where it landed. A person names
each file to move; migration adds no reader of the track.

- [Leaving the unordered track](#leaving-the-unordered-track)

### Rule DDR-TRACK-PRIMARYLANGUAGE

A track has one **primary language** by default: the first file language its tech-stack (DDR-TRACK-ONETECHSTACK) declares, the one a track
with a single language is written in (DDR-TRACK-FILELANGUAGE). A second file language enters a track by being declared there, never by being
tolerated, so a track's declared languages read as one primary language and the few others it admits on purpose.

- [What a track is](#what-a-track-is)

## Context

A mono repository holds several concerns that differ in everything but their home: language, delivery target, cadence, and blast radius.
Without a named concept for "the root concern", those differences leak everywhere — pipelines path-filter on ad-hoc folder lists, tests
guess their scope, and a change in one corner rebuilds customers who never consumed it. The repository has the ingredients (root folders
with strong conventions, the globset registry with durable-SHA stamps, per-module dependency maps); a track is the word that ties them
together, and the rules below keep them tied.

### What a track is

The unit of "concern" in this repository is the cluster of module contents, and the root folder is its usual home. `pwsh/` is the automation
platform; `infrastructure/` is the IaC tree; `.ado/pipelines` holds the azure devops pipelines and `.github/workflows` the GitHub ones;
`docs/` is the documentation; `contracts/` is the repository boundary's binding contracts, in both directions; each `.<foldername>`
configures exactly one external system (the repository's boundary for that concern); a `.vendor` folder holds third-party code. A member may
be narrower than a root (`.github/workflows`), or a single file (`importer.ps1` joins `pwsh`), so that two tracks share a root without
sharing a file. Naming the concept makes the mapping normative, and the two member facts let a filter, a gate and a pipeline trigger ask one
model instead of keeping their own lists of shapes. That single-answer property is what every consumer below builds on.

### The taxonomy

Tracks are not peers in role, only in shape, and the track type says which shape ([track-types](track-types.md)). The `modules` track
defines the internal ports — `pwsh` is the core track, and every other track rests on it. The holders hold the repository's side of an
outside contract: `contracts/` for consumers of this repo and the platforms that read it, `docs/` for its human readers (the decision
records, reference articles, and guides, partly generated by the core), and a `vendor-settings` track per tool (`.github/`, `.cspell/`,
`.claude/`) for the tools that read them. `infrastructure/` adapts the core to Azure through Bicep modules and named templates, and the
`pipelines` tracks adapt it to Azure DevOps and GitHub: each pipeline is a deployable-unit's delivery machine, and it runs the core through
one runner script. The other **language** tracks hold their own modules and a test holder that tests the core from outside and delivers
nothing: `go/tests/` holds black-box tests that start the engine as a process and assert on what it prints, so its files are never part of a
deployable-unit's output, and no bundle can hold them. The three language tracks, Go, Python and Bash, each have their own decision record
in the automation domain. The taxonomy earns its keep in review: a proposed root that is none of these is probably a subfolder of an
existing track, and a cross-cutting need (all config files, all markdown) is a **scope** — a globset selecting through tracks — not a new
root.

### Module namespaces

A name is short where its container states the rest, and full wherever it travels. Inside the repository a module's path already names its
track, so repeating the product name in every folder adds nothing the path does not say; outside it, in a bundle, a gallery package or a
consumer's session, no track or folder is around to supply that context, so the full name must stand on its own. Declaring the namespace
once on the track keeps one resolution of the long form from the short one, never a second spelling kept in step by hand. The `pwsh` track
declares `Catzc`; a future track declares its own, and its folders stay short in the same way.

### A track has a tech-stack

The stack is the reason tracks exist as _separate roots_ rather than folders inside one tree: each stack brings its own toolchain, its own
verification, and its own failure modes. Keeping one stack per track keeps every gate honest — the automation tests verify PowerShell/C#,
the infrastructure quality gates verify Bicep against its configuration model, the Go toolchain runs and vets the Go tests — and keeps the
door open for new stacks (`frontend`, `services`) without disturbing the existing ones. The dependency between stacks is explicit and
one-directional: adapters, ports, and the other language tracks rest on the core (`infrastructure` consumes `pwsh` for context and
execution, `go` starts it as a process), never the reverse.

### Subscription and coordination

Two subscription surfaces exist, both derived from the same source of truth:

- **depms** — the module dependencies declare which modules (and by extension which tracks) a consumer rests on; the graph quality gates
  enforce them. A depm is module-to-module only — a dependency on a system is a dep, a different concern with different tooling.
- **globset projections** — each track's globset projects to native vendor path filters that pipelines trigger on, and to a git-reflected
  area-of-control the PR report reads; test tooling derives blast radius from the same globsets. Nothing is committed per set.

This is the coordination answer to the monorepo's core tension: everything lives together, but nothing rebuilds together unless the change
actually touches it.

### Tracks, units, pipelines

A track is a concern; a deployable-unit is a shippable composition; a pipeline is a unit's delivery machine. The three relate strictly:
units compose from tracks, CD pipelines bind to units 1-1 (1-2 when DEPLOY splits from CD), and a CI pipeline that verifies a whole track
binds that track's set itself. `ci-pwsh` and `ci-infrastructure` are those CI pipelines: they bind the `pwsh` and `infrastructure` track
sets, which `globs.yml` declares as loose-filesets, so no unit stands between them and their track. The per-customer CD pipelines are the
reduced case — one customer's foundation unit, composed from the infrastructure track's shared modules plus that customer's configuration
surface.

### File languages

"One tech-stack per track" is only checkable when a stack is made of something countable. The countable part is the file language: every
tracked file has exactly one, read off its extension, so the files of a track add up to the set of languages the track actually holds. A
stack is that set as declared — `pwsh` holds PowerShell and C#, `infrastructure` holds Bicep and its configuration YAML — and a file whose
language falls outside its track's declared set is the second stack the rule forbids, visible without reading the file. A file language is
not a tech-stack: the stack adds the toolchain, verification, and failure modes around its languages, while the language is only the kind of
text a file holds.

### Root files and unlisted files

Crossing the tracks with the file languages places a file only when it has both. Two kinds of file have one but not the other, and naming
them keeps the map whole instead of dropping them. A root file has no track: once each root file joins the track whose concern owns it (the
importer scripts their language tracks, the git settings a vendor's track, the license the contracts track), the row stays as the place a
file not yet declared shows up, never as a home. An unlisted file has no file language: a `.gitkeep`, a `LICENSE`, or an extension no entry
of the file-language registry lists yet. The root files get one row of their own and the unlisted files one column, and a file that is both
sits where they cross, so the map's file count equals the tracked file count. An unlisted file in a track's live aspect is still a second
tech-stack (DDR-TRACK-ONETECHSTACK) when it has an extension: an extension nobody registered is a language nobody declared.

### The world map

The rules above make the repository countable, and the world map is the count drawn. Its rows are the tracks and its columns the file
languages, so a reader sees at a glance which track holds which kinds of text and how much of each. A cell is where one track meets one file
language, and its shade says how many files sit there. A stack violation is marked on its cell, because the place is the finding: it says
which track holds the second stack and in which language. A highlight lights the cells a decision record governs or a change touches, so the
same picture answers "where does this decision apply" and "where does my change sit". A label that names an undefined concept would teach
its reader a word the repository never fixed.

### The unordered track

An outside repository brought into this one arrives with a history worth keeping and a layout that matches none of this repository's
modules. Importing it straight into a module would mix its files with code the gates hold to the domain rules before anyone has judged them;
leaving the history behind would lose the record of why each file is the way it is. The unordered track is the place between: a root folder
that git tracks and the world map counts, so the place rule (DDR-TRACK-ISPLACEDCLUSTER) holds, and each import lands whole at its own
landing address. Sorting then moves the files one at a time into the modules and tracks where they belong, with `git mv` so
`git log --follow` keeps every file's history, and the gates hold each file once it arrives. A landing name never carries a suffix: a name
that is taken fails the import, so a second import of the same source is a decision, never an accident.

The track is where imports land, not a source: it has no tech-stack beyond what an import brings, no consumer, and no default. Anything that
quietly read from it would make the system depend on files nobody has sorted yet, so the rule is stated as a prohibition, and every other
track keeps its own reason to exist. What stays under `.unordered/` is exactly the work still to sort.

### Leaving the unordered track

Landing, sorting and leaving are one lifecycle. One file per commit keeps each move reviewable and its history whole, and a file that is not
yet in the form never sits in a module where the gates would hold it to rules it does not meet, so the unordered part shrinks only by files
that are finished.

## Decision

Name the concept: repository concerns are **tracks**, each of one type and one tech-stack, subscribable only through depms and globset
projections and shipped through deployable-units, with the unordered track as the landing place nothing defaults to. Make the repository
countable as the world map.

### How this is enforced

- **The conventional root folders** keep the root inventory deliberate — a new root folder is a reviewed decision, and under this DDR it is
  the decision to open a track.
- **[track-types](track-types.md)** declares each track's type, places and vendor once, and the config types fail the load on a track that
  breaks them.
- **The globset registry** (`Catzc.Base.Globs`) declares each track's file set; pipelines filter on its native projection and the drift
  quality gate fails a trigger that no longer matches, while the git-reflected report answers what a change touches.
- **depms and the dependency-graph quality gates** enforce the declared subscription edges, including the one-directional core ←
  adapter/port dependency.
- **The `Test-WorldMap` quality gate** reads the world map and fails on a stack violation (DDR-TRACK-STACKVIOLATION), a root folder with
  tracked files that no track names (DDR-TRACK-ISPLACEDCLUSTER), and a printed label that names no defined term
  (DDR-TRACK-LABELSNAMEDEFINEDTERMS).
- **Code review** applies the taxonomy: a new track must name its type, its places and its tech-stack; a cross-cutting need becomes a scope
  globset, not a root.

## Consequences

- "Which track does this change touch?" has one answer, computed (git-reflected against the globsets), not argued.
- Pipelines, tests, and reviewers all read the same coordination surface, so a change's blast radius is the same fact everywhere.
- Opening a concern is cheap and bounded: one track entry with its type and places, one globset entry — and the rest of the repository is
  untouched by construction.
- The cost is discipline at the root: no drive-by root folders, no second stack smuggled into an existing track, and the registry has to
  stay curated as tracks grow.

[r1]: track-types.md#rule-ddr-tracktype-typesdeclaredonce
