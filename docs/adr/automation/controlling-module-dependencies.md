# ADR: Controlling module dependencies

## Rules: ADR-AUTO-DEPM

### Rule ADR-AUTO-DEPM-CODEBUILTFROM

A module dependency (`ADR-AUTO-DEPM`) is code the toolset is built from. Its internal edges — module A needing module B among the
repository's own modules — are declared in `pwsh/Catzc.Base.ModuleSystem/configs/dependencies.yml`; the declaration is the allow-list, and
an actual edge with no declaration fails the build.

- [The declared graph](#the-declared-graph)

### Rule ADR-AUTO-DEPM-UNIFIEDGRAPH

The graph is unified across both kinds of module content. A cross-module function call and a cross-module C# type reference are the same
relationship — module A needs module B — so they live in one graph, not two: each kind has its extractor of actual edges, and the
`Test-ModuleDependency` quality gate checks their union against the single `dependencies.yml`.

- [One graph, two kinds of edge](#one-graph-two-kinds-of-edge)

### Rule ADR-AUTO-DEPM-TWOSECTIONS

`dependencies.yml` has two sections. `groups:` declares a named set of on-disk modules with its own internal member→member DAG — a group is
a logical concept, not a disk module. `modules:` declares, per consumer, the names it may depend on: a GROUP (loose — an edge to any member)
or a specific MODULE (tight). A module absent from `modules:` is unconstrained.

- [Groups and modules](#groups-and-modules)

### Rule ADR-AUTO-DEPM-GROUPAWAREINTEGRITY

Integrity is group-aware and fails fast. At load, the `DependenciesConfig` type checks the declaration's shape: every target resolves to a
declared module or group, each group is closed over its own members, and the module graph and each group's internal DAG are acyclic. Against
the real repository, the `Test-ModuleDependency` quality gate checks that every declared module and group member exists on disk, that each
actual edge falls within the resolved allow-set, and that actual intra-group edges are a subset of the declared internal map.

- [Enforcement](#enforcement)

### Rule ADR-AUTO-DEPM-EXTENDBYDECLARING

Extend by declaring, not by importing. A new module dependency is a new declared edge in `dependencies.yml`, landed in the **same** change
as the code that introduces it — never an ad-hoc cross-module call or type reference that merely resolves at runtime or compiles into the
combined assembly.

- [Extend by declaring](#extend-by-declaring)

### Rule ADR-AUTO-DEPM-NOTSYSTEMDEPENDENCY

A module dependency (`ADR-AUTO-DEPM`) is not a system dependency (`ADR-AUTO-DEPS`). A `ADR-AUTO-DEPM` is code the toolset is built _from_ —
pinned, and stitched into the build (whether it is internal code the repository already holds or an external package a feed supplies); a
`ADR-AUTO-DEPS` is an external runtime it runs _against_ (`pwsh`, Python, the Azure CLI), version-locked and asserted by the Tooling layer,
governed by [controlling-systemwide-deps](controlling-systemwide-deps.md). Keep the two names distinct in code, config, and prose.

- [Not a system dependency](#not-a-system-dependency)

### Rule ADR-AUTO-DEPM-EXACTVERSIONPINS

Pin every module dependency to an exact version. An internal dependency is pinned by the commit — its code is in-tree, so a checkout builds
against exactly the code that commit holds. An external dependency is pinned to an exact version in config, never a floating range or
`latest`, so the same sources build the same result on any machine at any time.

- [Pinning: an exact version](#pinning-an-exact-version)

### Rule ADR-AUTO-DEPM-INTERNALVENDORED

Internal module dependencies are vendored and named. The code is in-tree — the toolset's own modules, and third-party modules vendored under
`pwsh/.vendor/` — and every edge is declared by name in `dependencies.yml` (ADR-AUTO-DEPM-CODEBUILTFROM). The repository alone is the internal
dependency set; there is nothing to fetch.

- [Internal: vendored and named](#internal-vendored-and-named)

### Rule ADR-AUTO-DEPM-EXTERNALSTITCHEDATBUILD

External module dependencies are stitched in at build time by the package manager named in config. A capability not worth reimplementing and
not appropriate to vendor is pulled — at build, never at runtime — from its feed: NuGet, an Artifactory repository, an artifact an upstream
pipeline uploaded, or another feed, chosen per dependency under [use-proper-package-managers](use-proper-package-managers.md).

- [External: stitched at build time](#external-stitched-at-build-time)

### Rule ADR-AUTO-DEPM-STITCHISCONFIG

The stitch is config, and the config is ours. Which external dependencies exist, at which pinned versions, from which feeds is declared as
config in the repository — a reviewed change, not an ambient fact of a build machine — so the whole graph, internal and external, is
reproducible from the checkout.

- [The stitch is config](#the-stitch-is-config)

## Context

The repository is a mono-repo of modules that use one another: a function in one module calls a function in another, and a C# type in one
module references a type in another. Left implicit, those uses form an unmanaged graph — and an unmanaged graph drifts into cycles and layer
inversions, where a foundation module quietly comes to depend on a leaf. Neither medium the edges travel through stops this on its own:
PowerShell imports every module into one global function namespace (see [dynamic-module-manifests](../pwsh/dynamic-module-manifests.md)), so
any module can call any other's function; and the C# types compile into a **single combined assembly** (see
[native-csharp-types](BCL/native-csharp-types.md)), so the compiler does not forbid a cross-module type reference that inverts a layer.

So the layering is made explicit and enforced: the allowed edges are declared once, in one file, and the actual edges are extracted from the
code and checked against that declaration. This is the [poka-yoke](../principles/poka-yoke.md) move — an undeclared dependency is caught
mechanically, not by review vigilance — and it keeps a single, legible answer to "what may depend on what."

## Decision

Module dependencies are declared in one place and checked against the code. The declaration lives in
`pwsh/Catzc.Base.ModuleSystem/configs/dependencies.yml`; the actual function-call and C# type edges are extracted and checked against it.

### The declared graph

`The declared graph is the contract`

`dependencies.yml` is the single declaration of which module may depend on which. It is an allow-list, and the direction of truth is
one-way: the code is checked against the declaration, never the reverse. An edge that exists in the code but not in the declaration is a
violation, a target that is not itself declared is rejected at load, and a declared module that does not exist on disk is a gate finding.
There is no second place a dependency can be expressed — no per-module manifest of imports, no implicit "whatever it happens to call."

### One graph, two kinds of edge

A module's content is of two kinds — `pwsh` functions and C# types — but a dependency between modules is one relationship regardless of
which kind carries it. A cross-module function call and a cross-module type reference both mean "module A needs module B," so they are
unified in one graph rather than split across two declarations. `Get-ModuleDependency` extracts the function-call edges and
`Get-CSharpTypeDependency` the type-reference edges (the combined assembly means the C# compiler will not — see
[native-csharp-types](BCL/native-csharp-types.md#rule-adr-auto-types-referencesfollowdependencies)); `Test-ModuleDependency` unions the two sets and checks them against
the one `dependencies.yml`. There is no separate "type dependency" file to keep in sync. How the PowerShell function-call edges are
extracted is [dynamic-module-manifests](../pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest-crossmodulecalls).

### Groups and modules

The declaration has two sections:

- `groups:` — a named set of on-disk modules **with its own internal member→member DAG**. A group is a concept, not a disk module: its name
  is a logical handle that other modules can depend on wholesale, and its internal map is the layering contract among its members (each
  member's actual edges must stay within it). The clusters are `Base` (the small focused base libraries), `AzureExt` (the Azure modules
  below the `Catzc.Azure` root), and `Tooling` (the non-vendored external-tool managers).
- `modules:` — per consumer module, the names it may depend on: a **group** (loose — an edge to any member) and/or a specific **module**
  (tight coupling). A module not listed in `modules:` is unconstrained.

Pinning a group permits an edge to any of its members; pinning a module permits exactly that one edge. The group is what lets a cluster be
depended on as a unit without enumerating every member at every call site.

### Enforcement

The graph is checked at two moments, and both fail fast:

- **At load** — the `DependenciesConfig` type (with `ModuleGroup` for each group) validates `dependencies.yml` itself, without reading the
  disk: every target resolves to a declared module or group; each group is closed over its members; and the module graph and each group's
  internal member→member graph are acyclic.
- **Against the real repository** — the `Test-ModuleDependency` quality gate ([ADR-AUTO-TEST-QUALITYGATE](test-automation.md#rule-adr-auto-test-qualitygate))
  reports every declared module and group member that does not exist on disk (`UnknownModule`), and compares the extracted edges
  (`Get-ModuleDependency` + `Get-CSharpTypeDependency`) to the resolved allow-set: each actual edge must fall within it, and actual
  intra-group edges must be a subset of the group's declared internal map. Its L1 integrity test fails on any finding.

### Extend by declaring

Adding a dependency is adding a declared edge — in the same change as the code that introduces it, so the tree is never in a state where a
call or type reference outruns the declaration. This follows [one-living-version](../principles/one-living-version.md): there is one source
of truth for the graph and no back-compat or drift tolerated between it and the code. The failure mode to avoid is treating the declaration
as documentation to be reconciled later; it is the contract the build enforces.

### Not a system dependency

"Dependency" names two different things in this repo, and they are governed by opposite disciplines. A **module dependency**
(`ADR-AUTO-DEPM`) is code the toolset is built _from_ — pinned to an exact version and stitched into the build, whether it is internal code
the repository holds (vendored and named) or an external package a feed supplies. A **system dependency** (`ADR-AUTO-DEPS`) is an external
runtime or CLI the automation merely runs _against_ — `pwsh`, Python, `dotnet`, the Azure CLI, git — version-locked and asserted, never
built from, by the Tooling layer. That concern has its own ADR, [controlling-systemwide-deps](controlling-systemwide-deps.md). The two codes
carry the split: `ADR-AUTO-DEPM` (MOD = module) and `ADR-AUTO-DEPS` (SYS = system). Keeping the words distinct keeps the two from being
conflated.

### Pinning: an exact version

Reproducibility is the point, so nothing floats. An internal dependency needs no version field — its code is in the checkout, so the commit
is the pin: a given commit builds against exactly the code that commit holds. An external dependency carries an exact version in config — a
single version, not a `2.x` range or `latest` — so its feed resolves the same artifact every time. This is the determinism
[vend](../pwsh/vendor-toolset-dependencies.md) secures for vendored modules, applied to every module dependency however it arrives.

### Internal: vendored and named

An internal module dependency is visible in the repository two ways at once. It is **vendored** — the code is in-tree, whether the toolset's
own modules under `pwsh/` or a third-party module checked in under `pwsh/.vendor/<Name>/<Version>/`
([vend](../pwsh/vendor-toolset-dependencies.md)) — so loading is a path read with no network. And it is **named** — the edge is declared in
`dependencies.yml` and checked (the graph rules above). Vendored gives the code; named gives the layering. Together they make the repository
alone the internal dependency set: nothing is fetched and nothing is resolved.

### External: stitched at build time

Some capability is not worth reimplementing and not appropriate to vendor — too large, too fast-moving, or naturally delivered as a package.
That is an external module dependency, and it is _stitched_ in: the package manager named in config pulls the pinned version from its feed
at build time, into the build, before the toolset runs. Stitching is build-time by definition — an external dependency resolved at runtime
is a system dependency's discipline applied to the wrong thing. The manager and feed are a per-dependency choice, because the right one
depends on the dependency: NuGet from a gallery, an Artifactory repository, an artifact an upstream pipeline uploaded, or another feed,
under [use-proper-package-managers](use-proper-package-managers.md).

### The stitch is config

`The stitch is config, and it is ours`

Which external dependencies exist, at which versions, from which feeds — the stitch — is the toolset's own concern, declared as config in
the repository rather than left to a build machine or a hand-run install. An internal change shows up as a diff in `dependencies.yml` or
`.vendor/`; an external one as a diff in the stitch config. So the dependency set a build assembles is always exactly the one the checkout
describes, and adding or moving a dependency is a reviewed change.

## How this is enforced

- **`dependencies.yml`** (`pwsh/Catzc.Base.ModuleSystem/configs/`) — the single declared allow-list of module edges, with its `groups:` and
  `modules:` sections.
- **`DependenciesConfig`** — the config type that validates the declaration at load: resolvable targets, closed groups, acyclic module and
  group graphs.
- **`Get-ModuleDependency`** + **`Get-CSharpTypeDependency`** — extract the actual function-call and C# type-reference edges from the code.
- **`Test-ModuleDependency`** — the quality gate that checks the declaration against the repository (every declared module and group member
  exists on disk) and the extracted edges against the declaration (allow-set membership and the group's internal-map subset rule), failing
  its L1 integrity test on any finding.
- **Code review** — enforces `ADR-AUTO-DEPM-EXTENDBYDECLARING`: a new edge is declared in the same change as the code, not deferred.
- **`Install-VendorModule`** + **`Import-VendorModules`** ([vend](../pwsh/vendor-toolset-dependencies.md)) — pin a vendored internal
  dependency by its `pwsh/.vendor/<Name>/<Version>/` folder and load only from there (`ADR-AUTO-DEPM-INTERNALVENDORED`).
- **Pinning** — the commit pins every internal dependency; an external dependency carries its exact version in the stitch config, reviewed
  in the diff (`ADR-AUTO-DEPM-EXACTVERSIONPINS`).

## Consequences

- There is one legible answer to "what may depend on what," and it is a checked-in file — not tribal knowledge and not whatever the code
  happens to import.
- Function-call and type-reference edges obey one graph, so a module's dependencies read the same whether they cross via a call or a type.
- Cycles and layer inversions are caught mechanically — at load for the declaration, in L1 for the code — instead of surfacing as a
  confusing load-order or assembly problem later.
- Groups let a cluster be depended on as a unit while still enforcing the layering among its members, so the declaration stays compact
  without losing precision.
- The cost is one declared edge per real dependency, added in the same change: a small, mechanical tax that buys a drift-free, acyclic
  graph.
- A build is reproducible from the checkout: internal code by path (vendored), external code by a pinned feed fetch (stitched), the same on
  any machine — and offline for everything vendored. An internal change shows up as a diff in `dependencies.yml` or `.vendor/`, an external
  one as a diff in the stitch config, so nothing enters the build as an unreviewed ambient fact.
