---
catzc:
  derived:
    path: docs/adr/pwsh/bounded-enumeration.md
    kind: adr
    language: markdown
    track: docs
    body_sha: b0131730897a
    defines:
      - ADR-PWSH-ENUM#{1-6}
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TRACKED#1
      - ADR-PWSH-PARAM#4
      - ADR-PWSH-PESTER#9
    links:
      - docs/adr/automation/tracked-files-from-the-index.md
---

# ADR: Bounded enumeration

## Rules: ADR-PWSH-ENUM

### Rule ADR-PWSH-ENUM:1

List the children of a folder, and anything deeper, with raw .NET only, through `Get-ChildPath` (the `Catzc.Base.Folders` module, backed by
the compiled `FolderWalker` type). `Get-ChildItem`, `gci`, `dir`, and `ls` never enumerate the filesystem. A probe that asks only whether a
folder holds any entry is not a listing: it calls `[System.IO.Directory]::EnumerateFileSystemEntries` and stops at the first entry, so no
name is pruned and nothing is collected.

- [Raw .NET, one way](#raw-net-one-way)
- [Emptiness probes](#emptiness-probes)

### Rule ADR-PWSH-ENUM:2

Enumeration is shallow by default: the depth is 2, declared once on the `folder-walk` config type (ADR-AUTO-DEFAULT#6) and read in the
parameter declaration (ADR-PWSH-PARAM#4). A deeper walk is an explicit `-Depth` at the call site, never a new default.

- [Shallow by default](#shallow-by-default)

### Rule ADR-PWSH-ENUM:3

Nothing is enumerated without a bound. `SearchOption.AllDirectories`, an unlimited depth, and a walk that builds a full list before it
filters are all unbounded. A call site that walks a whole tree on purpose is a named exception: it states its depth, and the comment says
why that depth is needed.

- [Nothing unbounded](#nothing-unbounded)

### Rule ADR-PWSH-ENUM:4

A walk prunes the folders that are never the answer: the config's `exclude` names (`.git`, `node_modules`, `out`) and, while the global
config value `prune_vendor_in_searches` is `true`, the vendor folder. A caller's explicit `-Exclude` or `-PruneVendor` wins over the config.
A walk lists a link and never enters it.

- [Pruned, and never through a link](#pruned-and-never-through-a-link)

### Rule ADR-PWSH-ENUM:5

Enumeration that is hot, repeated, or deep is a compiled C# type (ADR-AUTO-TYPES), measured against the PowerShell form. `FolderWalker` is
that type for folders. Code that needs a different walk extends the one type; it never carries a second copy of the stack walk
(ADR-PRIN-ONELIVE).

- [A compiled type for the hot path](#a-compiled-type-for-the-hot-path)

### Rule ADR-PWSH-ENUM:6

Code that loads before `Catzc.Base.Folders` exists (the internal bootstrap, vendor, and types modules, and the modules `Folders` itself
depends on) lists one level with an inline, non-recursive `[System.IO.Directory]::Enumerate*` call. It never recurses inline.

- [Callers below the walker](#callers-below-the-walker)

## Context

A recursive listing is the easiest way to find a file and the easiest way to make a command slow and its result wrong. An unbounded walk
enters `.git`, `node_modules`, and vendored modules, loads the whole tree into memory, and returns files the caller never meant to touch.
The cost grows with the repository, so a command that is fast today slows down as the tree grows, and nothing in the code says why.

The walker answers "what is on disk below this folder", which includes an untracked file and leaves out a deleted one. "Which files does git
track" is a different question with its own seam, `Get-GitTrackedPath`
([tracked-files-from-the-index](../automation/tracked-files-from-the-index.md), `ADR-AUTO-TRACKED#1`). Code that scopes itself by what is
committed asks that seam and never walks the folder; code that needs what is actually present, such as a build input, a fixture tree, a
report folder, or a freshly written file, walks.

### Raw .NET, one way

On Windows the PowerShell file cmdlets carry per-call provider and AV/AMSI overhead that `System.IO` avoids (ADR-PWSH-PESTER#9 names the
same effect for tests). `Get-ChildItem` also wraps every entry in a `PSObject`, so a large listing pays for properties the caller discards.
Raw .NET returns plain strings.

Raw calls alone are not enough: each author then writes the loop, the pruning, and the depth handling again, and each copy differs. One
function, `Get-ChildPath`, is the single way, so the depth, the pruning, and the link rule are decided once.

### Emptiness probes

"Is this folder empty?" has a different answer from "what is in it?". A listing prunes `.git` and `node_modules` and builds a collection, so
a target that holds only `.git` would read as empty and a large folder would be read in full for a yes or no. The probe takes the first
entry of any kind and stops, which is bounded by construction.

### Shallow by default

Most searches target a known place: a module's own files, a folder's direct children, a config tree a few levels down. A default of 2 covers
those and costs almost nothing. A default of "all levels" makes the rare deep walk free to write and the common walk expensive to run.

The default is a setting, so it lives where every setting default lives: on the config type, once. A function parameter, a literal at a call
site, and a constant in the walker would each be a second declaration. A caller that needs more says so with `-Depth`, which makes the cost
visible in review.

### Nothing unbounded

A depth is a promise about cost. `AllDirectories` makes no promise, and a full list built before filtering holds the entire tree in memory
even when the caller wants three files. A bounded, lazy walk visits only what its depth allows.

Some work does cover a whole tree: copying a package tree, snapshotting a build. These are legitimate, so the rule does not forbid them. It
asks the call site to state a depth that fits the tree and to say why, so a whole-tree walk is a decision someone made rather than a default
nobody noticed.

### Pruned, and never through a link

A search for `*.yml` below `automation/` should not return the vendored modules' files, and a search below the repository root should not
enter `.git`. Pruning by folder name, before descending, is far cheaper than filtering a full listing afterwards.

Vendor pruning is a global config value rather than a list entry or a parameter default, because the same repository question, "do searches
include third-party code?", has one answer for every command. A caller that needs vendored files passes `-PruneVendor $false`.

A link can point back into its own ancestry, so a walk that follows links can run forever or leave the tree. The walker lists the link as an
entry and does not descend into it.

### A compiled type for the hot path

Measured on twelve seeded random folders at depths 1 to 4, the type listed them in 4.3 ms, `Get-ChildItem` took 16.7 ms, and a
PowerShell-only walk with the same pruning took 13.2 ms; on the largest sampled folder the PowerShell loop was slower than the cmdlet. The
per-item PowerShell cost is the cost, and a compiled type removes it. This is the case ADR-AUTO-TYPES makes for a native type, and
ADR-PWSH-TYPES describes how the type is hosted.

### Callers below the walker

The internal modules load before the combined types assembly is built, so they cannot call `FolderWalker`. `Config`, `Repository`, and
`Objects` sit below `Folders` in the dependency order for the same reason. Their listings are one level deep, so a single inline
`Directory.Enumerate*` call is complete, bounded, and needs no stack walk. Anything that needs recursion belongs in a module above
`Folders`.

## Decision

Enumerate the filesystem with `Get-ChildPath`, to a bounded depth that defaults to 2, with the config's exclude names and the vendor folder
pruned and links never entered. Back it with a compiled type. Code that loads before the walker lists one level inline.

### How this is enforced

- **`Get-ChildPath` and `FolderWalker`** — the one walk; its tests cover the default depth, an explicit depth, pruning, ordering, a missing
  root, a tree deeper than the depth that is never entered, and a link that is listed and not followed.
- **`folder-walk` config** — `Test-ShippedConfigs` validates the shipped values against the config type that declares the defaults.
- **Custom PSScriptAnalyzer rule `Measure-NoUnboundedEnumeration`** (`automation/.scriptanalyzer/NoUnboundedEnumeration.psm1`, severity:
  Error) — flags `Get-ChildItem` and its aliases on a filesystem path (ADR-PWSH-ENUM#1) and `[System.IO.SearchOption]::AllDirectories`
  (ADR-PWSH-ENUM#3). A literal provider path (`env:`, `function:`, `HKLM:`) is left alone, a provider listing through a variable carries a
  justified suppression. Test files are covered like any other code.
- **Code review** — a whole-tree walk whose depth or comment is not justified is checked against this ADR.

## Consequences

- A search costs what its depth allows, not what the repository has grown to.
- Vendored, generated, and `.git` content stays out of results unless a caller asks for it.
- A deep or whole-tree walk is visible at its call site as a stated depth with a reason.
- One walker carries the depth, pruning, and link behaviour, so a fix or a speed-up reaches every caller.
- Modules below `Folders` carry a small inline one-level listing, which is the price of loading before the walker.
