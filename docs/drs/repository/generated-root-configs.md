# Repository: Generated root configs — every managed root file from one in-repo source of truth

## Rules: ADR-REPO-ROOTCFG

### Rule ADR-REPO-ROOTCFG-FULLYMANAGED

An opted-in repository-root config file is **fully managed by the source-of-truth automation**: it is materialised from exactly one in-repo
source of truth — a `source` file (an authored template copied out under the generated-file head, ADR-REPO-ROOTCFG-HEADEDCOPY) or a
`generator` function (e.g. `New-Importer`). Corrections go to the source: a managed root file is a rendering and is never hand-edited.

- [Decision](#decision)

### Rule ADR-REPO-ROOTCFG-REGISTRY

The registry is `pwsh/Base.RootConfig/configs/rootconfig.yml` — validated by the `RootConfigFiles` type, materialised by `Build-RootConfig`,
the single writer. **Opt-out is the default**: an entry (or a root file) not opted in stays hand-authored and committed; `optIn: true` is
the explicit takeover switch. The target-to-source pairing is not restated anywhere else. A generator lives in a Base module, since
`Invoke-RootConfigGenerator` (`Catzc.Base.RootConfig`) calls each by name and a Tooling generator would be a Base→Tooling edge.

- [Decision](#decision)

### Rule ADR-REPO-ROOTCFG-COMMITTEDFLAG

Per entry, the `committed` boolean (default false) decides git membership and nothing else. `committed: false` → the target is a derived,
gitignored artifact, materialised on import like the generated module manifests. `committed: true` → the target stays tracked because git or
the bootstrap reads it **before the importer runs** (`importer.ps1`), while the automation owns its content — a source change surfaces as a
reviewable diff. The difference between the two is one boolean, not two systems.

- [One system, one boolean](#one-system-one-boolean)

### Rule ADR-REPO-ROOTCFG-COMPOSEDROOTFILE

Every managed root file — a `source` copy or a `generator`'s output — carries the unified generated-file head
([ADR-REPO-FILEMETA-COMPOSEDFILES](file-meta.md#rule-adr-repo-filemeta-composedfiles)): the one warning that the file is generated, and
while git tracks the file its regenerate and remove commands, its sources (the template or the generator's inputs) and `with_body_sha`,
projected from its writer row and never read back
([ADR-REPO-FILEMETA-PROVENANCEINHEAD](file-meta.md#rule-adr-repo-filemeta-provenanceinhead)). `Build-RootConfig` writes the head, in the
carrier its `carrier` key names (default: the carrier of the target's file language), so a generator renders its content bare and no entry
and no template hand-words a banner or a managed-file marker. The head is strictly a leading block: config formats have no portable in-body
anchor.

- [Decision](#decision)

### Rule ADR-REPO-ROOTCFG-THREEWAYAGREEMENT

The registry, `.gitignore`, and git's tracked set must agree, and an integrity test asserts it: every opted-in `committed: false` target is
matched by an ignore rule and untracked; every `committed: true` target is tracked and not ignored; a generator target matches its
generator's output (the drift check). The same test covers the copies: every `source` target equals its template under the generated head,
byte for byte once the line endings are LF, and no managed target is a link.

- [The integrity test](#the-integrity-test)

### Rule ADR-REPO-ROOTCFG-HEADEDCOPY

A `source` entry is materialised as a **headed copy**: the root file is its template, `pwsh/Base.RootConfig/assets/root/<name>` (or the
module asset the entry names), under the generated-file head ([ADR-REPO-ROOTCFG-COMPOSEDROOTFILE](#rule-adr-repo-rootcfg-composedrootfile)).
The template stays the pure authored file, with no head and no marker, and the root file is never a link to it, hard or symbolic, since a
head written into a link would land in the template. A tool that rejects comments in its format keeps the head in the carrier the carrier
registry gives it, such as the ignored property of a JSON file.

- [A headed copy](#a-headed-copy)

### Rule ADR-REPO-ROOTCFG-WILDCARDGENERATOR

A `generator` entry may name a wildcard target (`*/tests/*/go.mod`) and render one file per record: its generator returns one
`{ Target; Content }` record per file, each target a repository-relative path the entry's pattern matches. `Build-RootConfig` writes and
reports each file on its own, and the drift check compares each on its own. A wildcard entry may render no file; a literal target renders
exactly one. A wildcard is for a generator only, since a `source` entry has one file to copy.

- [One entry, many files](#one-entry-many-files)

### Rule ADR-REPO-ROOTCFG-ONECLASSPERWRITER

Every writer of a generated file, `Build-RootConfig` among them, is one row of the writer registry, its own module's
`configs/generated.yml`: its name, its inputs, its outputs with the inputs each output reads, its class and its check. `rootconfig.yml`,
`readme.yml` and `comment-pages.yml` stay the configs that expand a writer's instances, and its row points at them. A writer has exactly one
class: `rollable`, whose files a roll-off may take out of the working copy and its writer render back; `import-critical`, the importer, the
root configs, the track-sets and the module manifests, never rolled off, since the session that restores them must first import; `snapshot`,
a writer that reads outside the tree (`Update-AzurePriceTable`, `Update-AdoFlowOccupants`), never rolled off, since the tree alone cannot
render it back; and `untracked`, a writer whose output git never tracks (`out/`, `bin/` and `obj/`, `.venv`).

- [Writers and their classes](#writers-and-their-classes)

### Rule ADR-REPO-ROOTCFG-DERIVEDRENDERORDER

The order writers render in is derived from the writer registry's input and output graph, a topological order in which a writer runs after
every writer whose output it reads, and is never listed by hand; a cycle in the graph is a registry error. The same graph answers which
writer and which inputs a generated file comes from and whether it is stale against its inputs, a picture as much as a text file.

- [One graph, one order](#one-graph-one-order)

### Rule ADR-REPO-ROOTCFG-ROLLOFFROUNDTRIP

Roll-off and roll-on are one operation over the `generated` filter view
([DDR-FILTER-VIEWOVERMODEL](../design/repository-filters.md#rule-ddr-filter-viewovermodel)), resolved from the writer registry and never
from a head: `Remove-Generated` deletes the view's `rollable` files from the working copy, so git shows them deleted, and
`Restore-Generated` runs their writers in the derived order. The proof that every rollable file is reproducible from the tree is the round
trip: `Remove-Generated`, then `Restore-Generated`, then a `git status` that shows no change.

- [The round trip](#the-round-trip)

## Context

The repository root carries configuration files for git, editors, and quality-gate tools. Kept by hand, each is a source of truth of its
own, with its own drift risk, and the tool-specific quirks (a `.psd1` that must be a literal hashtable, a JSON manifest with no comment
syntax) get re-solved ad hoc. "Root" names the ownership — one source of truth under `pwsh/`, one writer — not a path constraint: the
managed set covers the repository root and, below it, the `.vscode/` editor files (settings, extension recommendations, launch profiles, the
Azure Pipelines schema, and the preview CSS) and `.cspell/.gitignore` — all of those `committed: false`, so the editor greys them and a
fresh clone materialises them on its first import — the same contract as the generated cspell dictionaries
([dedicated-output-directory](dedicated-output-directory.md#rule-adr-repo-outdir-dictionariesgenerated)). The module manifests and the
READMEs ([generated-readmes](generated-readmes.md)) are generated, gitignored artifacts, and a root config file is the same pattern, given
one registry and one writer.

## Decision

Every opted-in root config file is materialised by `Build-RootConfig` (module `Catzc.Base.RootConfig`) from the single source of truth its
`rootconfig.yml` entry names: a `source` file copied out under a generated-file head, or a `generator` function whose rendered output is the
whole file. The registry entry carries two booleans — `optIn` (is the file managed at all; opt-out is the default) and `committed` (is the
managed target tracked in git) — and the importer tail keeps every opted-in target current on every load.

### One system, one boolean

Some root files are read before the importer can possibly have produced them: `importer.ps1` is the load entry point itself, and git reads
`.gitignore`/`.gitattributes` at checkout. Those files cannot be gitignored copy-ins — but they can be fully managed, because "managed"
means "reproduced from one in-repo source of truth", not "absent from git". `committed: true` expresses exactly that: same registry, same
writer, same drift guarantee; the only difference is that the target stays tracked and a regeneration shows up as a normal diff to review
and commit.

### A headed copy

`The template is authored, the root file is its generated copy`

A root file that a reader opens must say that it is generated, and the template it comes from must stay the file an author edits. One file
cannot be both: a link makes the root path and the template one file, so a head written into the root file lands in the template, and a
template with no head leaves the root file looking authored. A copy keeps them apart: the template under `assets/root` holds the content
alone, and the root file is that content under the generated-file head, which carries the one warning; the template to edit is the one
`rootconfig.yml` names. The copy is rewritten on every import, so it never drifts for longer than a session, and the integrity test compares
it with its template byte for byte, so an edit made in the copy is a finding that names the template to edit instead.

A tool reads its root file whatever comes before its content, as long as the head is in the format's own comment syntax, so the carrier
registry decides the form: a `#` comment head for a dotfile, a YAML file or a solution file after its preamble, and the ignored property of
a JSON file whose parser rejects comments. A target that is a link is stale whatever its bytes: `Build-RootConfig` deletes it before it
writes the copy, so a write never tunnels through a link into a template
([ADR-REPO-README-READMEIDEMPOTENT](generated-readmes.md#rule-adr-repo-readme-readmeidempotent)), and the integrity test fails a managed
target that is a link (ADR-REPO-ROOTCFG-THREEWAYAGREEMENT).

### One entry, many files

`One entry, many files`

Some generated files come in a set whose size the repository decides: the Go workspace has one `go.mod` per Go test module
([go-test-artifacts](../automation/go/go-test-artifacts.md#rule-adr-auto-go-goworkspace)), and a new test folder adds one. A registry entry
per file would be a second list of those folders, kept by hand. A wildcard target states the set once — `*/tests/*/go.mod` — and the
generator, which discovers the folders, renders one record per file (`Get-RootConfigRenderedFile` normalises the two shapes). Every file
then takes the same path as a single-file target: one `Write-FileIfChanged` write, one result row under its own path, one drift issue when
stale, and `Build-RootConfig <path>` selects either the whole entry by its pattern or one file the pattern matches. A record outside the
entry's pattern, or a literal target rendering anything but one file, throws with the entry and the generator named.

### Writers and their classes

`One row per writer, one class per row`

A root config is one kind of generated file among many: pages, contracts, dictionaries and pictures come from writers too. The question "is
this file generated, and by what" has one answer only when every writer is declared in one place, its own module's row, so the registry is
read the same way for a root file and for a slide picture ([one-living-version](../principles/one-living-version.md)). The class says what a
writer's files may go through. Most can leave the working copy and come back from the tree alone. A file the importer needs cannot, because
nothing renders it before the session that would render it has imported; a file read from outside the tree cannot, because the tree does not
hold what it reads; and a file git never tracks has nothing to roll. One class per writer keeps the answer a lookup, never a judgement per
file.

### One graph, one order

`The inputs and outputs decide the order`

A picture is rendered from a declaration, a slide picture from that picture, a slide from its picture: a chain whose order is a fact of the
inputs and outputs. A hand-kept list of that order is a second statement of the graph and drifts the first time a writer gains an input, so
the order is sorted from the graph each time it is needed. The graph that orders the writers also answers where a file comes from and
whether it is stale, so the source of a file, its staleness and its render order never disagree.

### The round trip

`Take it off, render it back, see nothing change`

A generated file that cannot be rendered back from the tree is an authored file under another name. Taking every rollable file off and
rendering it back is the direct test: when `git status` is clean afterwards, every one of them is reproducible, and a writer that misses a
file, reads an undeclared input or renders differently shows as a change. The set comes from the registry and the filter view, never from
the heads, so a hand-made file with a stray head is never deleted, and a generated file whose head is stale is rolled like any other.

### Always current

`Always current, at no steady-state cost`

Because the targets are cheap to reproduce and must never go stale, the importer regenerates them on every load, as it does the READMEs
([generated-readmes](generated-readmes.md)). That is safe because generation is idempotent
([ADR-REPO-README-READMEIDEMPOTENT](generated-readmes.md#rule-adr-repo-readme-readmeidempotent)): `Write-FileIfChanged` canonicalises,
compares ignoring line endings, and writes only on a real change, delete-then-write, so a changed write yields a fresh, independent file.
The same primitive is the write tail of every generated-artifact builder, one living copy of that logic
([one-living-version](../principles/one-living-version.md)) instead of one per builder.

### The integrity test

Three parties must stay consistent: the registry (what is managed and how), `.gitignore` (what git ignores), and the index (what git
tracks). Any pairwise drift is a defect — a managed copy that is tracked, a committed bootstrap file that an ignore rule swallows, an
opted-in target with no ignore rule. The integrity test (`Test-RootConfigIntegrity.Tests.ps1`) asserts all of it from the registry outward,
so adding an entry without its `.gitignore` line, or opting in a file without `git rm --cached`, fails the test with the exact remediation.
The copies are asserted too: every `source` target equals its template under the generated head (the failure names the template to edit),
and no managed target is a link (the case a content compare cannot see, since a link reads the same bytes as the file it points at).

## Consequences

- A root config is authored once — in its source under `pwsh/` (or rendered by its generator) — and cannot drift from a second hand-kept
  root copy.
- Taking over a root file is one registry entry plus its source; opting out is the default, so an unregistered file is simply not touched.
- The root analyzer settings are an ordinary `source` entry with no bespoke builder, and `importer.ps1` is a `generator` entry whose
  `New-Importer` drift guard also backs `ADR-REPO-ROOTCFG-THREEWAYAGREEMENT`.
- A reader never mistakes a managed root file for a source of truth: every one carries the generated-file head with the one warning, and
  `rootconfig.yml` names the template to edit; committed targets are named in the registry and drift-tested.
- A template under `assets/root` is the pure authored file, so a consumer can take it as it is, and an edit in the root copy is a finding,
  never a change that reaches the template unseen.
