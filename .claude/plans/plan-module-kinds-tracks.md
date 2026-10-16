---
plan:
  status: active
  value: high
  reviewed: 2026-10-16
  next: run out/prompt-module-model-1-prepare.md in a fresh, read-only session
  targets: [automation/Catzc.Base.ModuleSystem, automation/Catzc.Base.Variants, automation/Catzc.Base.Globs/configs, docs/adr/automation, docs/adr/design]
---

# Module as the one generic model; object kinds owned by tracks; a type for each track

Three drafts: Module as the generalised, ADR-backed meta model (one C# definition every track instantiates); Kubernetes-style kind
names where kinds are tracks' vocabulary and today's kind becomes role; tracks as on-disk clusters of module contents with a track
type (deployable or holder). Nothing is built. Two prepare and two implement prompts for the first two sit in out/.

## Why its value is high

Seven places answer "what is a module" and none can answer for the others. Kind and role share one word in every head. The track
model is the user's own and changes what every head's track key means. The config defaults and layers plans both wait on this
one landing.

## Decided, and why

- Sequencing (2026-10-16, layers Q8): the module model lands first and keeps the name automation in its text. New code takes the
  track from the one resolver, so the later rename to pwsh stays a data edit. It deletes Get-AutomationModules and Get-BaseModule.
- Config defaults (2026-10-16, plan-config-defaults): every key this plan adds to a config type declares its default once on the type;
  tracks.<t>.engines joins variants.yml and VariantTrack; aspects shrinks. If both plans touch VariantsConfig.cs or VariantTrack.cs,
  this plan owns the file and the config defaults plan edits after it.
- k8s plan Q1 to Q3, D1, uniqueness per track, namespace deferred: taken as recommended (section 6 of that draft).
- Module-model Q-A to Q-G: recommendations stand as working decisions; the prepare prompt closes them read-only and drafts the ADR.

## Needed docs

- ADR-AUTO-MODULE, new (domain automation, recommended; LoadedModule provenance as one rule of it).
- ADR-DSGN-TRACK extended: a kind is an object kind of a track, unique per track; track types; a track may be a sub-path or a group
  of dot-roots. The k8s step 4 groups file-kinds.yml by track.
- Glossary: kind (object), role (file role), track type, deployable module, holder track. Comment pages of the touched resolvers.

## Needed tests

- Resolver tests for the new module getter (Q-C, recommended Get-CatzcModule) replacing Get-BaseModule and the Get-PathModule overlap.
- file-kinds.yml grouped by track; Test-FileMetaProcessors kind and processor counts; head.schema.json and sample updated.
- Track type L0 tests with neutral fixtures; variants.yml tracks carry the type.
- Note: FileMetaConfig.cs and FileSelector.cs may hold another session's edits; message before touching.

## Open steps

- [ ] Copy the two plans and two prompts to the scratchpad, then run the prepare prompt (check: its read-only report and ADR draft in out/).
- [ ] Run the implement prompt (check: ModuleSystem and Variants tests; the two old getters gone).
- [ ] Rename kind to role; kind takes the object meaning, partitioned by track (check: Test-FileMeta, Test-FileKinds clean).
- [ ] Track type in variants.yml and the head; answer track-type Q1 to Q5 first (check: Format-GeneratedFileHead and Variants tests).
- [ ] Tell plan-config-defaults and plan-layers-vocabulary-rename-contracts when implemented (their waits_on clears).

## Refs

- carried below in order: the module model (sequencing note at the top, questions in section 7), the k8s kinds (decisions in
  section 6), the track type (Q1 to Q5 open), the track-structure analysis, the tracks-modules-types ADR draft (all formerly out/)
- prompt-module-model-1-prepare.md, prompt-module-model-2-implement.md (beside this file)
- prompt-k8s-kinds-1-prepare.md, prompt-k8s-kinds-2-implement.md (beside this file)

## Carried: out/plan-module-model.md (verbatim, absorbed 2026-10-16; headings below are the draft's own)

# Plan: Module as the generalized, ADR-backed meta model

Part of [plan-k8s-kinds.md](plan-k8s-kinds.md) (kinds are tracks; `Module` is a kind). That plan said "Module is a kind inside the
`automation` track". This plan refines it: `Module` is the repository's central concern, so it gets one generic C# definition that every
track instantiates, and one ADR that backs it. The decisions of the k8s plan (no `modules` track, kind unique per track) still hold.

Nothing here is built yet. Facts below were read from the tree on 2026-10-16; items I did not read are marked **unverified**.

**Sequencing with the rename (decided 2026-10-16, [plan-automation-layers-rename.md](plan-automation-layers-rename.md) Q8):** this plan lands **first**, while
the track and folder are still called `automation`; the text below keeps that name on purpose. The rename plan then renames the track and folder to `pwsh` in
its phase P4, so everything this plan builds must resolve the track root through the one resolver (no `'automation'` literal in new code) and name the
track by its key, never by a path string.

**Config defaults (decided 2026-10-16, [plan-config-defaults.md](plan-config-defaults.md)):** every key this plan adds to a config type
(`tracks.<t>.engines`, the `layout:` slots, `languages.yml` `build:`/`test:`) declares its default **once on the C# type**, with a declared posture
(defaulted, empty-is-valid, or required), and is published as a generated `defaults` contract. `variants.yml` is deleted by that plan's Phase 2 and its
data moves to this repo's `.catzc/` fragment; that phase starts only after this plan is implemented, so this plan still edits `variants.yml` in place.

## 1. What exists today: one concept, seven partial views

"A module" is described by seven separate places, none of which can answer for the others:

| Question | Where it is answered today | What it knows |
| --- | --- | --- |
| Which modules exist on disk? | `Get-BaseModule` (`ModuleSystem`) -> `DiskModule`; also `Get-AutomationModules` (`TypesSystem`) | name, `automation/<name>`, hidden or named, `files.yml` packages |
| Which module owns this path? | `Get-PathModule` (`Variants`) | a regex over `automation/<m>/` plus the `.internal/*.psm1` special case |
| May module A depend on B? | `dependencies.yml` -> `DependenciesConfig`, `ModuleGroup`, `DependencyGraph` (`ADR-AUTO-DEPM`) | allow-list, groups, acyclic |
| In what order? | `Get-ModuleTestOrder` (a Kahn sort in PowerShell), `Get-ModuleDependencyMap/Closure` | topological order, used by `Test-Automation` only |
| Which modules does a bundle carry? | `profiles.yml` + `exporter.yml` bundles + `Get-ModuleProfile` | profile = module roots; closure follows the graph |
| What are its parts? | `variants.yml` `aspects` + `AspectPartition` + `Get-ModuleGlobSet` (`ADR-DSGN-ASPECT`) | live / tests partition, each its own identity |
| Which languages and engines? | `languages.yml` (file languages, formatter, checks), `ExecutionEngines` (`ADR-AUTO-ENGINE`) | per file language, not per module |

Consequences of the split: ordering is spelled "test order" though build, bundle and load need the same order; the module's languages
are never stated (they are guessed from extensions wherever needed); engines attach to black-box _tests_, never to the module; and the
one thing that is not a PowerShell module but is plainly one (a reusable Bicep module under `infrastructure/modules/*.bicep`, a
`template` under `infrastructure/templates/`) has no path into any of the above. The `.internal` single-file modules, a hidden-folder
special case, and `BaseModule`'s `Kind` (named, hidden, imported, vendored, builtin, residue, which mixes on-disk shape with session
provenance) show the model is already straining.

## 2. The model

One C# definition, authored under `ADR-AUTO-TYPES#9` (a first-class concept the platform branches on is a type). Working name `Module`
(replacing `BaseModule`/`DiskModule`/`SessionModule`: one living version, `ADR-PRIN-ONELIVE`; the "Base" in `BaseModule` also collides with
the `Catzc.Base.*` family name).

**A Module is a named unit of one track, with a root, a set of members, declared neighbours, and two axes.**

```text
Module
  Name          Catzc.Base.Globs | Catzc.Internal.Types | foundation (a template) | ...
  Track         automation | infrastructure | ...         (ADR-DSGN-TRACK; the k8s-style kind partition)
  Shape         folder | file                              (a .internal/*.psm1 is a file module)
  Root          repository-relative folder or file
  Members       the tracked files, partitioned into Aspects (live | tests)      <- ADR-DSGN-ASPECT, unchanged
  Languages     the file languages its live members are written in            <- AXIS 1  (languages.yml)
  Engines       the execution engines it must run under                         <- AXIS 2  (ExecutionEngines)
  Needs         declared edges to other modules (and groups)                    <- dependencies.yml, unchanged
  Order         topological rank within the whole graph                         <- derived, one function
  Packages      named extra file groups it owns                                 <- files.yml, unchanged
```

Two lifecycle facts are split off, not left in `Kind`: **Shape/role** (what is on disk) belongs to `Module`; **provenance** (imported,
vendored, builtin, residue: how a loaded module came into the session) stays a separate session view, `LoadedModule`, because a module
that is not ours (builtin, residue) is not a `Module` of any track.

### 2.0 Registration is placement (user, 2026-10-16)

A module is **registered by placing correctly named language fragments in their semantic locations**. There is no registry to add a
module to, and no descriptor file: the module exists when its fragments exist. Three terms carry this, and all three are config with
sensible defaults (one resolution order, `ADR-AUTO-DEFAULT#6`):

- **Fragment:** one file of one language in one semantic role, such as a public function, a private function, a C# type, a config, an
  asset, a test. Its name follows the language's naming rule (`Verb-Noun.ps1` containing exactly `function Verb-Noun`, `ADR-PWSH-ONEFUNC`;
  `types/<Type>.cs` in the module's namespace, `ADR-AUTO-TYPES#1`; `configs/<name>.yml` validated by its type).
- **Slot:** the semantic location a fragment goes in, per language and role: for powershell, public = `<module>/*.ps1`, private =
  `<module>/private/*.ps1`; for csharp, `<module>/types/*.cs`; for yaml, `<module>/configs/*.yml`; assets in `assets/**`; tests in `tests/**`.
- **Layout:** the table of slots, declared once as config (a `layout:` map under each language in `languages.yml`, with the sensible
  default shipped on its C# type, so a consumer overlays only a difference, `ADR-AUTO-OVERLAY`).

These slots are already spread over three configs that say the same thing three times: the `live` patterns in `variants.yml` `aspects`
(`*.ps1`, `private/**`, `types/**`, `configs/**`, `assets/**`), the globs in `file-kinds.yml` (`automation/Catzc.*/*.ps1`,
`automation/Catzc.*/private/*.ps1`, `automation/**/types/*.cs`, `automation/**/configs/*.yml`), and the regexes inside `Get-PathModule`
and `New-DynamicManifest`. **One living version** (`ADR-PRIN-ONELIVE`): the layout becomes the single source, and the aspect partition,
the file-kind globs, the path-to-module lookup and the manifest generator all read it. The `live`/`tests` split is then a property of the
slot (a `tests` slot is non-live), which is what `ADR-DSGN-ASPECT#2` already says ("auto-derived from folder conventions").

Registration semantics:

- **Appears:** a folder under the track root holding a fragment in any live slot is a module of that track, named by the folder. A
  `.internal/<Name>.psm1` is a one-fragment module of `file` shape, named by the file (today's special case becomes a layout row).
- **Valid:** a fragment in the wrong slot or with a wrong name is a finding, not a silent non-module. A file the layout does not place is
  an unplaced file (the leftovers catch-all, `ADR-DSGN-ASPECT#5`), and the aspect default-deny still keeps it from shipping.
- **Disappears:** removing the last live fragment removes the module (`New-DynamicManifest` already deletes a manifest when no `.ps1`
  remains, `ADR-PWSH-MANIFEST#3`).
- **Declared only for what placement cannot say:** needs (`dependencies.yml`), packages (`files.yml`), engine override. Never the
  module's existence.

### 2.1 Derived, not declared

`ADR-AUTO-ZERO` and `ADR-PRIN-CONFIG` decide this, so the default is **no per-module manifest**. Everything below is read from what
exists, and config states only what cannot be read:

| Property | Source | Declared where |
| --- | --- | --- |
| name, track, root, shape | placement: which folder holds live fragments (2.0), `Get-Track` | the layout (section 2.0) |
| members, aspects | `AspectPartition` over `git ls-files`, its live patterns generated from the layout's slots | the layout; `variants.yml` `aspects` keeps only each track's remainder rule |
| languages | the languages of the fragments present, through `languages.yml` | nowhere (derived) |
| engines | see 2.2 | a default per track, one override map |
| needs | `Get-ModuleDependency` + `Get-CSharpTypeDependency` against the allow-list | `dependencies.yml` (exists, `ADR-AUTO-DEPM#1`) |
| order | topological sort of `needs` | nowhere (derived) |
| packages | | `files.yml` (exists) |

`ADR-AUTO-DEPM#1` ("there is no second place a dependency can be expressed, no per-module manifest of imports") is why `needs` stays in
`dependencies.yml` and does not move into a descriptor.

### 2.2 The two axes

**Language axis** (what the module is written in). A module's `Languages` are the file languages of its live aspect, resolved through
`languages.yml`. Today `automation` modules are `powershell` + `csharp` + `yaml`, a Bicep module is `bicep`, and a template is `bicep` +
`yaml`. The axis decides the toolchain: how it is built, checked, tested and bundled (section 3). Go, Python and Bash are verification
languages: `ADR-AUTO-GO`/`ADR-AUTO-PY`/`ADR-AUTO-BASH` make them test artifacts only. The model therefore carries them as languages of the
_tests_ aspect, never of `live`. Widening that (a Bash module that ships) is a decision for those ADRs, not for this one: open question Q-A.

**Engine axis** (what runs it). The engine set is closed at three (`ADR-AUTO-ENGINE#1`). A module's `Engines` is the subset it must run
and be tested under:

- a PowerShell function module runs in **pwsh**; bash and zsh reach it only through the `cats` dispatcher (`ADR-AUTO-ENGINE#6`), so
  pwsh is its one engine and the other two are reach, not run;
- a module that ships POSIX scripts (an `importer.sh` style root config) has **bash** and **zsh**;
- an infrastructure module has no engine of its own: it deploys through the Azure CLI, which the automation tools run under any engine,
  so its engine set is `auto` (`ADR-AUTO-ENGINE#7`).

Default per track in `variants.yml` `tracks` (a new `engines:` key, resolved once by `ADR-AUTO-DEFAULT#6`); a per-module override only
when a module differs from its track. The black-box rule (`ADR-AUTO-ENGINE#4`, every Go/Python test runs once per engine) is then read
from the module: its tests run once per engine in `Module.Engines`, instead of per test file.

### 2.3 Kind meaning (ties back to the k8s plan)

`Module` is the kind; tracks instantiate it: `automation` -> PowerShell/C# modules, `infrastructure` -> Bicep modules. Per-track
uniqueness holds (`Module` exists in both tracks, one definition). A template is a Bicep `Module` composed with a per-target config to
form a `Deployment` (k8s plan, section 2); a Deployment needs a Module, never the reverse.

## 3. Lifecycle: define, build, QC, test, bundle

Each operation is a **handler resolved by (track, language)** from config, never an `if language` in code (`ADR-PRIN-CONFIG`: one mechanism
per kind). The registry is an extension of `languages.yml`, which already holds `formatter` and `checks` per language:

| Operation | Today | Becomes |
| --- | --- | --- |
| **define** | folder + `.ps1` files; `configs/*.yml` validated by a C# type | `Module` derived (2.1); the config types are `ConfigMap`-kind objects of it |
| **order** | `Get-ModuleTestOrder` | `Get-ModuleOrder`: the one function every operation below uses (rename, same change, all callers) |
| **build** | `Build-Modules` merges PowerShell into one psm1 + manifest; C# types compile into one assembly (`ADR-PWSH-MANIFEST#5/6`, `ADR-AUTO-TYPES#3`); Bicep compiles per template (**unverified**) | `build:` handler id per language in `languages.yml`: `powershell` -> merge, `csharp` -> compile into the combined assembly, `bicep` -> `bicep build`. Build walks `Get-ModuleOrder`. |
| **QC** | `languages.yml` `checks:` per language, run by gates | unchanged mechanism; the module supplies the scope (its live and tests members) and the gate set is the union of its languages' `checks`. A new "does every module have a handler for each of its languages" integrity test. |
| **test** | Pester per module in `Get-ModuleTestOrder`; Go/Python/Bash black-box per engine | `test:` handler id per language; run per `Module.Engines`; ordered by `Get-ModuleOrder` |
| **bundle** | `profiles.yml` closure -> `exporter.yml` bundle -> one `Catzc` module (`ADR-AUTO-BUNDLE`) | profile resolves to Modules, closure over `Needs`, the bundle is the ordered list of their `live` aspect built by the build handlers |

`Module.Order` makes load order, test order, build order and bundle order the same fact. Today `Get-ModuleTestOrder` states the property in
its description ("a module is ordered after every module it may depend on"), but only `Test-Automation` uses it.

## 4. The ADR

New ADR `ADR-AUTO-MODULE`, file `docs/adr/automation/module-model.md`. It belongs in `automation/` because that domain is stated for any
engine and already owns `DEPM`, `ENGINE` and `BUNDLE`, which it ties together; `design/` cannot cite `automation/` by the domain order
(`adrs.yml` roles and `depends on`). The pwsh-specific halves stay where they are (`ADR-PWSH-MANIFEST`). It extends, never restates:

1. **Rule 1: the module is one model.** A module is a named unit of one track with a root, members, declared needs and two axes; it is one
   C# type, and no code re-derives a module's name, root, languages or order from paths or folder listings (cites `ADR-AUTO-TYPES#9`,
   `ADR-DSGN-TRACK#1/#3`).
2. **Rule 2: registration is placement.** A module is registered by placing correctly named language fragments in their semantic slots;
   the slots are one layout, config with sensible defaults. Name, track, root, shape, members, languages and order are derived from
   placement; needs, packages and per-module engine overrides are the only declared facts, and a module's existence is never declared
   (cites `ADR-AUTO-ZERO`, `ADR-PRIN-CONFIG`, `ADR-AUTO-DEFAULT#6`, `ADR-AUTO-DEPM#1`).
3. **Rule 3: the language axis.** A module's languages are those of its live members; the toolchain for each language (formatter, build,
   checks, test) is declared once per language in `languages.yml` (cites `ADR-DSGN-ASPECT#1`).
4. **Rule 4: the engine axis.** A module's engines are a subset of the closed engine set, defaulting per track; a module's tests run once
   per engine it names (cites `ADR-AUTO-ENGINE#1/#4/#7`).
5. **Rule 5: one order.** The topological order of the declared graph is the order of load, build, test and bundle; there is one function
   for it (cites `ADR-AUTO-DEPM#2/#4`).
6. **Rule 6: operations are handlers by language.** Build, check, test and bundle are resolved from config by (track, language); adding a
   language adds a registry entry and handlers, not a branch in a function (cites `ADR-AUTO-EXTEND`, `ADR-PRIN-CONFIG`).
7. **Rule 7: a module you do not own is not a Module.** Loaded builtin and residue modules are session facts, kept as a separate
   `LoadedModule` view (cites `ADR-AUTO-DEPS` versus `ADR-AUTO-DEPM#6`).

It also gets: a glossary entry for **module** (contrast: file-module/psm1 role, `deployable-unit`, `track`, `bundle`, `profile`) in the
owning module's `glossary.yml`; a `dora-explains.md` entry for the automation domain; and registration in `adrs.yml` with `Build-AdrIndex`
rebuilding the index and the front-matter `defines`. The ADR is written present-tense, with no history (index authoring conventions).

## 5. Steps, one file at a time, each verified before the next

Ordering matters: the model must exist before the ADR's enforcement can name it, and nothing is renamed until the replacement works.

1. **Settle open questions** (section 7) with the user. No code before.
2. **Inventory the callers (read-only).** Grep every use of `Get-BaseModule`, `Get-AutomationModules`, `Get-PathModule`,
   `Get-ModuleTestOrder`, `Get-ModuleDependencyMap/Closure`, `Get-ModuleProfile`, `DiskModule`, `BaseModule`, `SessionModule`, and the
   `Kind` values. Write the list to `out/`. This is the one-living-version worklist; it is also where the **unverified** items
   (`Build-Modules`, `Get-ModuleGlobSet`, `Get-AutomationModules`, `Test-Automation`'s use of the order) get read.
3. **Write the ADR** and its glossary entry (section 4). Run the ADR gates only after the file lands.
4. **Type.** Add `Module` and `LoadedModule` in `Catzc.Base.ModuleSystem/types/` (it already holds the module types and `DependencyGraph`);
   it needs `Catzc.Base.Engines` and `Catzc.Base.Languages` for the axes, so declare those edges in `dependencies.yml` in the same change
   (`ADR-AUTO-DEPM#5`). **Layering check before this step:** `Catzc.Base.Globs` depends on `Languages` and `Variants`; confirm `ModuleSystem`
   may depend on `Languages` and `Variants` without a cycle (**unverified**; if it would cycle, the type goes in the lowest module that sees
   all three, or the axes are passed in as plain names and resolved by the caller).
5. **Resolver.** One public `Get-Module`-style function that builds `Module[]` (name it so it does not collide with PowerShell's `Get-Module`,
   `ADR-PWSH-MANIFEST#4`; `Get-CatzcModule` is the working name) from the folder walk (bounded, `ADR-PWSH-ENUM`), `Get-Track`, `AspectPartition`,
   `languages.yml` and the graph. `Get-PathModule` becomes a thin lookup into it, not a second regex.
6. **Order.** Rename `Get-ModuleTestOrder` to `Get-ModuleOrder`; point `Test-Automation` and the other callers at it in the same change.
6a. **Layout.** Add the `layout:` slots per language to `languages.yml` with the default on its C# type (`FileLanguage`/`LanguagesConfig`), then
   repoint, one file at a time, the three duplicates onto it: the `aspects` live patterns (`VariantAspect`, `AspectPartition` input), the
   `file-kinds.yml` module globs, and `Get-PathModule`/`New-DynamicManifest`. Each repoint is verified by its own tests before the next.
   Read `New-DynamicManifest` first (**unverified**: it is the loader's own copy of the slot rules).
7. **Axes in config.** `variants.yml` `tracks.<t>.engines`; `languages.yml` `build:` and `test:` handler ids; the C# config types
   (`VariantsConfig`/`VariantTrack`, `LanguagesConfig`/`FileLanguage`) validate them at load. Edit `FileLanguage.cs`/`VariantTrack.cs` one
   at a time; C# edits need a fresh `pwsh` process.
8. **Move callers one file at a time** onto `Module`: build (`Build-Modules`), bundle (`Get-ModuleProfile`, `Export-Catzc`), test
   (`Test-Automation`), QC scoping, the glob sets. Delete `BaseModule`, `DiskModule`, `SessionModule`, `Get-BaseModule` and the old call
   shapes as each caller moves; nothing is kept alongside (`ADR-PRIN-ONELIVE`).
9. **Gate.** An L1 integrity test: every on-disk module resolves to a `Module`, every language of every module has the handlers its
   operations need, and the order is a valid topological order of the graph.
10. **Extend to `infrastructure`** last: a Bicep module and a template resolve as `Module`s of their track with `languages: [bicep, yaml]`.
    Only after the automation track is stable, because it is the larger blast radius for the least gain.

Verification for every step: run the affected file's tests and the relevant gate in the background with `timeout`, and report what
actually ran. Per-file checks only; the user runs the full suite (memory: user handles commits and tests).

## 5a. Missing work (closed by prompt 1, `out/prompt-module-model-1-prepare.md`)

1. **Caller inventory** of `Get-BaseModule`, `Get-AutomationModules`, `Get-PathModule`, `Get-ModuleTestOrder`, `Get-ModuleProfile`,
   `DiskModule`/`BaseModule`/`SessionModule` and the `Kind` values (step 2).
2. **Unread code the plan depends on:** `Build-Modules` and the merge, `Get-ModuleGlobSet`, `Get-AutomationModules`, `New-DynamicManifest`,
   `Test-Automation`'s use of the order, `AspectPartition`, `VariantAspect`/`VariantTrack`, `FileLanguage`/`LanguagesConfig`.
3. **Layering proof** that `ModuleSystem` may depend on `Languages`, `Engines` and `Variants` without a cycle (step 4).
4. **Slot table** (section 2.0): every placement the repo uses today, read out of `New-DynamicManifest`, `Get-PathModule`, `variants.yml` and
   `file-kinds.yml`, with the conflicts between the three copies listed.
5. **Infrastructure fit:** how `infrastructure/modules/*.bicep` and `templates/` map to slots and to `Module`.
6. **Draft of the ADR** `ADR-AUTO-MODULE` and its glossary entry, ready to land.
7. **Resolver name** and the test plan (L0 for the type and layout, L1 for the integrity test).

## 6. Risks

- **Layering.** The model sits above Engines, Languages and Variants but is needed by modules that those depend on indirectly. Step 4's
  check decides this before any code. A cycle would show as a `DependenciesConfig` load failure, which is the safe failure.
- **Blast radius of the rename.** `Get-BaseModule` and `DiskModule` are used by `Copy-Automation` and the module completers. Step 2's list
  sizes it before it is committed to.
- **Parallel sessions.** `FileMetaConfig.cs` and `FileSelector.cs` (QualityGates) carry another session's uncommitted edits; this plan does
  not need them, but the k8s plan's step 4 does. Also ask before editing `Get-ModuleTestOrder`/`Test-Automation` if they show as dirty.
- **Scope creep into build internals.** `Build-Modules` and the merge are unread. If the build handler split is larger than a registry
  entry per language, it becomes its own plan, and this plan stops after step 6 with the axes declared but only `powershell` handled.
- **Name collision.** `Get-Module` is a PowerShell built-in; the resolver needs a different name (step 5).

## 7. Open questions

- **Q-F.** Where does the layout live: under each language in `languages.yml` (recommended: a slot is a property of the language) or in its
  own `layout.yml`? Recommend `languages.yml`, one file the formatter, checks and slots share.
- **Q-G.** An unplaced file inside a module folder: a finding by default (recommended, matches "valid" above), or tolerated and kept
  non-live by the aspect default-deny alone?

- **Q-A.** Is a shipping (non-test) Bash or Go or Python module in scope someday? The model allows the axis; `ADR-AUTO-GO/PY/BASH` forbid
  it today. Recommend: model it generally, forbid by the track's declared languages (as `variants.yml` already does), and leave the
  ADRs alone until a real case exists.
- **Q-B.** Should `Engines` be declared per module or only per track? Recommend per track with a per-module override, since only the
  POSIX-script modules differ.
- **Q-C.** Resolver name: `Get-CatzcModule` (recommended; `Get-Module` is taken) or reuse `Get-BaseModule`'s name for the new function.
  Recommend a new name, because the old one changes shape.
- **Q-D.** Is `LoadedModule` (session provenance) part of this ADR or its own? Recommend part of it (rule 7), one page.
- **Q-E.** ADR domain: `automation/` (recommended) or `design/`. `design/` cannot cite `automation/` by the domain order.

## Carried: out/plan-k8s-kinds.md (verbatim, absorbed 2026-10-16; headings below are the draft's own)

# Plan: Kubernetes-style kind names

Goal: the things catzc talks about get the names Kubernetes already gave their counterparts (`Module`, `Service`, `Deployment`,
`ConfigMap`, …), so a reader who knows k8s reads a catzc head or config without a translation table. Kubernetes is the source of the
_vocabulary_ only; catzc's own ADRs decide every meaning (CLAUDE.md "Inspiration" rule: an idea to weigh, never an authority).

**Sequencing with the rename (decided 2026-10-16, [plan-automation-layers-rename.md](plan-automation-layers-rename.md)):** the track now called
`automation` is renamed to `pwsh` (folder, track key, overlay `.catzc/pwsh/`, outputs `out/pwsh/`) after the module-model plan lands. This plan keeps the
name `automation` in its text; new code and data it adds must take the track key from the registry, not a literal, so the rename stays a data edit.

## 1. What a k8s `kind` is, and what ours is today

A k8s `kind` answers **what object is this** (`apiVersion` + `kind` = GVK, then `metadata` + `spec`). It is never a file role.

Our head `kind` answers **what role does this file play** (`file-kinds.yml`: `function`, `config`, `template`, `pipeline`, `test`, `adr`,
`reference`, …, matched by glob). Those are two different questions. Only the second exists today, so the new names do not fit in
`file-kinds.yml` as extra rows: `Deployment` is not a file role, it is an object that several files (a `.bicep` template and a
`configuration/<target>.yml`) together describe.

**Kinds are tracks (user, 2026-10-16).** A track is a root concern, one root folder (`ADR-DSGN-TRACK#1`), and every head already carries
`track`. So the object kinds are the vocabulary of the tracks: each track owns the kinds that live in it, and a kind is named for the thing
the track is _about_:

| Track (root folder) | Object kinds it owns |
| --- | --- |
| `automation` | **Module** (a folder), **ConfigMap** (its `configs/*.yml`), Type (compiled C#), Function |
| `infrastructure` | **Deployment** (template × target), Template, BicepModule |
| `pipelines`, `.github` | **Pipeline** (and PipelineTemplate) |
| `contracts` | Contract (the stable boundary; the nearest k8s idea is Service, see section 2) |
| `docs` | Adr, Reference, HowTo, Explanation, Glossary |
| `go`, `python`, `bash` | Test (verification tracks hold tests only) |
| `.claude` | Agent, Skill, Hook |

**Tracks can themselves be kinds (user, 2026-10-16).** The track list is open (`ADR-DSGN-TRACK#3`: a new tech-stack or concern opens a new
track), so a root folder can be named by a kind: a `services` track holding Services, a `modules` track holding Modules, and so on. Then
the kind is the track name and the pairing is direct (track `pipelines` holds `Pipeline`s, track `services` holds `Service`s). This
reopens two rows below:

- **Service** is no longer blocked on "nothing runs here": it can be a track of its own, opened when the first hosted workload is
  described, and it then keeps the k8s meaning (a stable endpoint in front of a changing workload). Contracts stay `contracts`.
- **Module** as a track conflicts with today's `automation`, which _is_ the track that holds modules (`automation/<Module>/`). Either
  `automation` stays the core track and `Module` is the kind inside it (the table below), or modules move to a `modules` track and
  `automation` keeps only the loader and tooling. The second is a large move (every path, glob, and dependency), so recommend the first
  until a second module-like family needs its own folder. Open question Q3.

This resolves the open design question: the head's `track` says which folder, `kind` says which object of that track's vocabulary, so
`kind` needs no free-standing list of its own, it is partitioned by track. Two consequences: (1) a kind id is unique within its track,
not repo-wide (`Module` exists only in `automation`); (2) the registry (`file-kinds.yml`) groups kinds under their track.

**Decision D1 (recommend: two keys).** Keep the file-role registry as it is and add a second, object-level key. Candidate spelling:
the existing `kind` key becomes the object kind (k8s meaning), the file role is renamed `role`. One living version
(`ADR-PRIN-ONELIVE`): that rename touches every head, so it ships as one change with `Format-FileMeta` rewriting them (never hand-edited).
Alternative: leave `kind` = role and name the new key `object`. Cheaper, but then catzc spells `kind` differently from k8s, which
defeats the goal. Recommend the rename, done once, before the registry is published as a contract (open item 2 of
[[file-head-vocabulary]]; `ADR-REPO-CONTRACT#3/#5` say publish before any release, so now is the cheapest moment).

## 2. Name by name

| k8s kind | Catzc counterpart today | Verdict |
| --- | --- | --- |
| **Module** | Not new. A folder under `automation/` with `.ps1` files is a module (CLAUDE.md "Folder = module"); head key `module`, `Get-PathModule`, module dependencies (`ADR-AUTO-DEPM`). | **Adopt as an object kind.** Collision to fix: `file-kinds.yml` already uses `module` for the single-file `.psm1` loader. That row is a _role_ (`role: loader-module`, subkind `internal`), not the object `Module`. k8s has no Module; this is catzc's own kind, named for what we already call it. |
| **ConfigMap** | `automation/**/configs/*.yml`, read by `Get-Config`, validated by a C# type. | See section 3. |
| **Deployment** | The desired state of one thing in one place: an infrastructure template plus its `configuration/<target>.yml` (for example `foundation` + `apex/nsub`). | **Adopt.** Matches k8s: declared desired state that a controller (the pipeline) converges to. Deployment = template × target. |
| **Service** | Nothing runs as a long-lived service in this repo. The nearest k8s idea, a stable name in front of changing pods, is a **contract** (`contracts/`, `ADR-REPO-CONTRACT`): a versioned boundary consumers depend on while the implementation changes. | **Do not adopt yet.** Using `Service` for a contract would break "same meaning as k8s". Adopt it only when a customer workload is described (for example the apps a landing zone hosts). Until then it is a reserved name, listed in the glossary as not-yet-used. Open question Q2. |
| **Pipeline** | `pipelines/*.yaml` and `.github/workflows/*.yml`, one per deployable-unit (`ADR-DSGN-TRACK#5`, `ADR-FLOW-CD-TYPE`). Today the file role `pipeline`. | **Adopt (user-required).** k8s has no Pipeline (Tekton does), so this is catzc's own kind, same as Module. It stays the word ADO and GitHub users see. The type-of-pipeline (CRON, CI, CD, CDe, DEPLOY, INPUT) is a field of the Pipeline, not a kind, which also settles the Job / CronJob row below: do not adopt them. |
| **Secret** | Deploy-time injection: the repo holds a template until BVT. | Reserve; a Secret kind lets the template-until-BVT rule have a name. |
| **Namespace** | Environment / tenant / customer scoping in `azure.yml` and `customer.yml`. | Candidate, decide with the Deployment work. |
| **Job / CronJob** | Pipeline types `CRON`, `CI`, `CD`, `CDe`, `DEPLOY`, `INPUT` (`ADR-FLOW-CD-TYPE`). | Not adopted: `Pipeline` is the kind (row above); CRON and the others are its type. |
| **CustomResourceDefinition** | `file-kinds.yml` itself, and every config's C# type. | See section 3. |
| (none) | `deployable-unit` (`globs.yml`, `ADR-DSGN-TRACK#5`): what ships. | k8s has no native kind; Helm calls it a **Chart**. Keep `deployable-unit`; do not invent a k8s name for it. |

## 3. Do we need our own kind for config?

A k8s `ConfigMap` is untyped key/value data, separate from the code that reads it, consumed by name. Our `configs/*.yml` has the same
role (non-secret, separate from the function that reads it, addressed by name) but is **typed**: a C# class validates it
(`FileMetaConfig.cs`, `FileKindsConfig`). That is what a k8s **custom resource** is: an instance of a kind that a definition (CRD)
describes.

Recommend: the object `kind` of a config file is **its C# type name** (`kind: FileKindsConfig`), exactly how a custom resource's kind is its
CRD's `names.kind`. No new `ConfigMap` kind is needed, and `ConfigMap` is kept for any future genuinely untyped key/value file. The C# type
is the CRD; the registry listing which type owns which file is the CRD list. That gives `Get-Config` a rule that already reads like k8s:
look up the kind, validate the document with the type behind it.

Open question Q1: is `kind: <TypeName>` too close to a code detail for a head that prose readers see? Alternative `kind: Config` with the
type under a second key. Recommend the type name: it is the one name that can never drift from the validator.

## 4. Steps (one file at a time, each verified before the next)

1. **Decide D1 and Q1/Q2** with the user. No code before that.
2. **ADR first.** Write the decision as a rule in an ADR in the `repository/` domain (file-meta or a new `object-kinds` ADR),
   register it in `adrs.yml`, rebuild the index with `Build-AdrIndex`. Cite `ADR-REPO-FILEMETA`, `ADR-REPO-CONTRACT`,
   `ADR-PRIN-ONELIVE`.
3. **Glossary.** One entry per adopted kind in the owning module's `configs/glossary.yml`, with contrasts against the lookalike
   (`Module` vs the `.psm1` loader role; `Deployment` vs `deployable-unit` vs `release candidate`; `ConfigMap` vs `config`).
   Gate: `Test-Terminology` / the controlled-vocabulary check.
4. **Registry.** Extend `Catzc.Base.Globs/configs/file-kinds.yml` (type `FileKindsConfig`) with the role rename and a new object-kind map
   (definition, the files that make it up, the type that validates it). Update `FileKindsConfig.cs` and its tests; new C# edits need a fresh
   `pwsh` process.
5. **Resolver.** `Get-FileKind` returns role and object kind. Declare any new module edge in `ModuleSystem/configs/dependencies.yml` in the
   same change (`ADR-AUTO-DEPM#5`, `Test-ModuleDependency`).
6. **Heads.** Make `Format-FileMeta` write the new key, then regenerate. This also closes open item 1 of [[file-head-vocabulary]]
   (generated heads still say `generated-from-source`): the writers pass the kind from `Get-FileKind` instead.
7. **Contract.** Publish the registry and head schemas under `contracts/catzc/0.0.0/` (`ADR-REPO-CONTRACT#3/#5`).
8. **Verify** with the repo gates in the background (`out/run-gates.ps1`, `out/run-generator-tests.ps1`), only reporting results seen.

## 4a. Missing work (not yet read or decided; closed by prompt 1, `out/prompt-k8s-kinds-1-prepare.md`)

1. **Consumer inventory of the `kind` key.** Every reader and writer of `kind` in heads: `Format-FileMeta`, `FileMetaConfig`/`FileMetaKind`,
   `file-meta.yml` selectors, `Get-FileKind`, `Get-PathFileKind`, the generated-head writers (`kind: tracked-generated-from-source`),
   `file-carriers.yml`, and tests. Size of the `kind` to `role` rename is unknown until counted.
2. **Per-track kind vocabulary.** The table in section 1 is a draft for `docs`, `.claude`, `contracts` and the verification tracks; no kind
   list was derived from `file-kinds.yml` row by row (for example where `hook`, `asset`, `script`, `drawio-kit`, `readme`, `index` land).
3. **Config kind = C# type name: is it derivable?** How `Get-Config` maps a config name to its type was not read; the kind is only free if
   that mapping already exists.
4. **Head schema and contract.** The head keys (`kind`, `role`, `track`, `module`, `generator`, …) and the registry have no written schema
   yet; `ADR-REPO-CONTRACT#3/#5` need one before release.
5. **Overlap with the module model.** `Module` is defined by `out/plan-module-model.md`; this plan consumes it and must not define it twice.
6. **The ADR text** extending `ADR-DSGN-TRACK`, and the glossary entries (Module, Deployment, Pipeline, ConfigMap, Service reserved, role).
7. **Namespace** (follow-up) and **Service** track (opened only with a hosted workload).

## 5. Out of scope

No Kubernetes manifests are generated, no `apiVersion`/`metadata`/`spec` envelope is added to config files, and no k8s tooling is
used. We borrow names, not a runtime. Not a repo-wide version (mono repo, not monolith): the kind registry versions like any other
contract.

## 6. Decisions (user, 2026-10-16: "go with your recommendations")

- **Q1:** a config's kind is its C# type name (`kind: FileKindsConfig`); `ConfigMap` is reserved for untyped key/value files.
- **Q2:** `Service` opens a `services` track when the first hosted workload is described; contracts stay `contracts`.
- **Q3:** `Module` is a kind inside the `automation` track; no `modules` track.
- **D1:** today's `kind` is renamed `role`; `kind` takes the k8s meaning (object kind), partitioned by `track`.
- **Uniqueness:** kind ids are unique per track, not repo-wide.
- **Namespace:** follow-up, not in this change.
- Step 4 groups `file-kinds.yml` by track; the track list is `ADR-DSGN-TRACK#1`, so the ADR in step 2 should extend `ADR-DSGN-TRACK`
  (a kind is an object kind of a track) rather than add a competing ADR.

Note (parallel sessions): `FileMetaConfig.cs` and `FileSelector.cs` have uncommitted edits from another session. Message before touching them.

## Carried: out/plan-track-type.md (verbatim, absorbed 2026-10-16; headings below are the draft's own)

# Plan: tracks as clusters of module contents, and a type for each track

Status: plan only, nothing built. Supersedes the first draft of this file (options A/B): the model below is the user's, 2026-10-16.

## The model (user's words, made precise)

- A **track** is an **on-disk cluster of module contents**. It is no longer "exactly one root folder": it may be a root, a sub-path
  (`.github/workflows`), or a group of dot-roots (all vendor settings).
- A **deployable track** *owns* **deployable modules**: collections of in-repo modules we deliver through CI/CD.
- A **holder track** is *itself* a module more than it owns modules: either the grouped vendor configuration of the dot-folders, or a
  vendor-specific holder with one purpose (ADO `pipelines/`, GitHub `.github/workflows`).
- A **track type** says which of these a track is, and what sort of thing it holds.

## What exists today (scanned 2026-10-16)

| Head fact    | Source                                                          | Today                                                          |
| ------------ | --------------------------------------------------------------- | -------------------------------------------------------------- |
| `track`      | `tracks:` in `Catzc.Base.Variants/configs/variants.yml`         | 12 tracks, each = one root (`automation`, `.claude`, ...)      |
| track class  | `tracks.<name>.class` (`VariantTrack.Classes`, ADR-DSGN-TRACK#2) | core, adapter, external-port, verification, unordered; **not in the head** |
| `moduletype` | `Catzc.Base.Variants/configs/module-types.yml` (`places:`)      | pwsh-folder, pwsh-psm1, python, go, bash, bicep, pipeline, settings |
| deployable unit | ADR-DSGN-TRACK#5, pipelines 1-1                              | "what ships": a whole track or a reduced composition           |

Gaps against the model: ADR-DSGN-TRACK#1 forbids a track spanning two roots or living in a sub-path; `.vscode` is on disk but not
tracked, so no track names it; `moduletype: pipeline` merges ADO and GH; "deployable module" is not a defined term (closest:
deployable-unit); the class axis (core/adapter/...) and your type axis are different cuts of the same tracks.

## Proposed tracks and types (every tracked place found in the scan)

| Track (name)        | On disk                                                              | Type               | Notes |
| ------------------- | -------------------------------------------------------------------- | ------------------ | ----- |
| automation          | `automation/Catzc.*`, `.internal`, `.scriptanalyzer`                 | Modules (deployable) | ~1.8k files; owns the bundle(s) via `Catzc.Base.Exporter` |
| infrastructure      | `infrastructure/templates`, `infrastructure/modules`                 | Infrastructure (deployable) | owns per-customer foundation/expedition units |
| services, frontend  | future roots (ADR-DSGN-TRACK#3)                                      | Services (deployable) | not on disk yet |
| pipelines           | `pipelines/` + `extends jobs stages steps variables`                 | Pipelines ADO (holder) | one holder of this repo's ADO pipelines |
| github-workflows    | `.github/workflows`                                                  | Pipelines GH (holder)  | 2 files; sub-path of `.github` |
| vendor-settings     | `.claude`, `.cspell`, `.vscode`, `.github` (minus workflows)         | Vendor Settings (holder) | one track over several dot-roots; `.claude` also carries an agent/drawio kit |
| vendor              | `automation/.vendor`, `bash/.vendor`                                 | Vendor code (holder?)  | open: own track or part of its owner |
| contracts           | `contracts/catzc`                                                    | Configuration (holder?) | open: your "Configuration" type; also per-subscription config under `infrastructure` |
| docs                | `docs/*`                                                             | Docs (holder)      | partly generated |
| go, python, bash    | `go/`, `python/`, `bash/`                                            | Verification       | test-only, ships nothing |
| unordered           | `.unordered`                                                         | Unordered          | frozen shelf, ADR-DSGN-TRACK#17 |
| (root files)        | `LICENSE`, `importer.ps1`, `.gitignore`, ...                         | none               | ADR-DSGN-TRACK#7 |

Known interaction: memory says the module-model and k8s-kinds plans decided "no `modules` track" and "kinds are tracks"; here
"Modules" is a track **type**, and the track stays `automation` (or `pwsh` if the rename plan lands). Check `out/plan-module-model.md`
and `out/plan-k8s-kinds.md` before building, and `out/plan-automation-layers-rename.md` for the track key.

## Steps (one file at a time, verify each)

1. **Vocabulary first.** Decide the closed set of track types and define each term in the glossary (ADR-REPO-VOCAB#1): the type
   names, "holder", "deployable module" versus deployable-unit, and how `tracktype` differs from `class` and `moduletype`.
2. **ADR.** Reword ADR-DSGN-TRACK#1 (track = cluster of module contents, may be a sub-path or a group of roots, still exactly one
   answer per file) and add a rule for the type beside #2; decide whether class survives or is replaced by type
   (ADR-PRIN-ONELIVE: one version, no parallel axis kept "for compatibility").
3. **Registry.** `variants.yml` `tracks:` entries get `places:` (like `module-types.yml`) instead of `root:`, plus `type:`.
   `VariantTrack.cs` gets the closed set and fails the load on an unknown value. Update `Get-Track` and every caller in the same change.
4. **Placement.** Settle the longest-match rule for a file under two places (`.github/workflows/x.yml` is in `github-workflows`, not
   `vendor-settings`). `Test-WorldMap` rows become the new tracks; add the `.vscode` decision.
5. **Moduletype.** Split `pipeline` into ADO and GH if the track split needs it; otherwise derive `tracktype` from the module types a
   track holds rather than keeping a second list.
6. **Contract and head.** `head.schema.json` + `head.sample.yml` (ADR-REPO-CONTRACT#6): add `tracktype`; `Get-TrackFileMetaFact.ps1`
   and the generated-head writer emit it next to `track`.
7. **Re-imprint** with `Format-FileMeta`, then `Test-FileMeta` (about 3.5k heads change in one generator run), L0 tests with
   neutral fixtures (widget/gadget). Globsets and pipeline triggers that name a track follow in the same change.

## Open questions (answers change the build)

1. Type names and count: is the set Modules, Infrastructure, Services, Pipelines ADO, Pipelines GH, Vendor Settings, Configuration,
   plus Docs, Verification, Unordered? What is "Configuration" here (contracts, per-subscription config, or something else)?
2. Is one `vendor-settings` track spanning several dot-roots intended, with `.claude`'s agent/drawio kit staying inside it?
3. Is a "deployable module" the same thing as today's deployable-unit (ADR-DSGN-TRACK#5), or a new level between module and unit?
4. Does `tracktype` replace `class` (core/adapter/external-port/verification/unordered) or sit beside it?
5. Is `.vendor` its own track, or part of the track that uses it?

## Carried: out/analysis-track-structure.md (verbatim, absorbed 2026-10-16; headings below are the draft's own)

# Analysis: the repository's real folder structure against tracks, modules and vendors

Scanned 2026-10-16 from `git ls-files` (4,600 tracked files), the gitignore, and the working tree. Counts are tracked files.

## 1. Every root and what is in it

| Root            | Files | Languages (by extension)                         | What it really is                                                                                           |
| --------------- | ----- | ------------------------------------------------ | ----------------------------------------------------------------------------------------------------------- |
| `automation/`   | ~1.8k | ps1 1527, cs 268, yml 106, psm1 33, json, psd1, dll 12, bicep 9 | 45 module folders in three families, plus four non-module folders (below) |
| `docs/`         | ~2.4k | md 1983, png 430                                 | `adr` 198, `explanation` 160, `how-to` 30, `references` 1160 (generated mirror), `.assets` 864 (diagrams) |
| `infrastructure/` | 43  | bicep 22, yml 21                                 | `modules/` 19 reusable Bicep files; `templates/` 3 folders (discovery, expedition, foundation), 8 files each |
| `pipelines/`    | 13    | yaml 9, gitkeep 3, ps1 1                         | 8 top-level files (cd-apex/flux/nova/shared, ci-automation, ci-infrastructure, expected-failures, the ADO runner script) and 5 subfolders (`extends jobs stages steps variables`) that hold only `.gitkeep` |
| `contracts/`    | 15    | yaml 7, yml 5, json, md                          | `catzc/0.0.0/` holds `contract.yml` and one folder per contracted module (4 modules today) |
| `.claude/`      | 26    | py 10, md 9, xml 2, ps1, json, html, csproj, cs  | `CLAUDE.md`, `settings.json`, `agents/` (7), `drawio/` (a Python diagram kit, 11 + 4 minimap files), `hooks/Assert-BashTimeout/` (a C# program) |
| `.github/`      | 3     | yml 2, md 1                                      | `workflows/` (2 workflows) and a README; nothing else |
| `.cspell/`      | 1     | gitkeep                                          | the dictionaries are generated and gitignored; only the placeholder is tracked |
| `.vscode/`      | 0     | (on disk)                                        | all five files gitignored (generated root configs); no tracked file, so no track |
| `go/ python/ bash/` | 1 / 1 / 22 | go, py, bash/bats                       | one `tests/catzc-base-*` project each; `bash/.vendor/bats-core` is 21 vendored files |
| `.unordered/`   | 20    | md                                               | `15-10-2026/`, the frozen shelf |
| repo root       | 5     | -                                                | `.gitattributes .gitignore LICENSE importer.ps1 importer.sh`; every other root config (`.editorconfig`, `cspell.yml`, `.markdownlint.yml`, ...) is generated and gitignored |
| `out/`          | 0     | -                                                | gitignored output |

## 2. Inside `automation/`: not one kind of thing

| Part                     | Files | Role                                                          |
| ------------------------ | ----- | ------------------------------------------------------------- |
| `Catzc.Base.*`           | 30 folders | the base modules                                         |
| `Catzc.Tooling.*`        | 9 folders  | tool modules (Core, Environment, **Github**, Inspiration, KeyHandler, Node, Provisioning, Python, Toolchain) |
| `Catzc.Azure*`           | 6 folders  | Azure modules (`Azure`, `Cli`, `DevOps`, `DevOps.BuildValidation`, `Firewall`, `Templates`) |
| `.internal/`             | 37    | seven `Catzc.Internal.*.psm1` modules (`pwsh-psm1`), `assets/`, `tests/` |
| `.scriptanalyzer/`       | 38    | analyzer rule modules                                         |
| `.vendor/`               | 65    | checked-in third-party PowerShell modules                     |
| `.compiled/`             | 2     | tracked compiled types output (both currently deleted in the working tree) |

Two facts matter for the ADRs. The module families already carry a **vendor** in their names: `Catzc.Azure.*` is the Azure vendor,
`Catzc.Azure.DevOps` is ADO, `Catzc.Tooling.Github` is GitHub. And `.scriptanalyzer`, `.vendor`, `.compiled` are not
modules (the module-types registry places modules only at `automation/<folder>` and `automation/.internal`), which is what the
`module-leftovers` catch-all (ADR-DSGN-ASPECT#5) already expects to be empty or explained.

## 3. Findings

1. **Only two roots deliver.** `automation` and `infrastructure` own things CI/CD ships (the bundles; the templates per customer). Every
   other root is read by a platform or a tool: they are holders. The deployable/holder split fits the disk exactly.
2. **The dot-roots are one vendor each, not one cluster.** `.claude` (Claude Code), `.github` (GitHub), `.cspell` (cspell) and `.vscode`
   (VS Code) are read by four different vendors. A `vendor` fact says that directly, and it makes a single multi-root "settings" track
   unnecessary: one `vendor-settings` track per vendor, each with one place, keeps "a track is a place" simple.
3. **Pipelines are the same type for two vendors.** `pipelines/` (ADO) and `.github/workflows` (GitHub) both hold pipeline
   definitions: one type `pipelines`, vendor `ado` or `github`. That removes the `pipelines-ado` / `pipelines-gh` pair and the need to
   split `moduletype: pipeline`.
4. **Infrastructure is Azure.** Bicep is read by Azure: type `infrastructure`, vendor `azure`. `contracts` and `docs` have no vendor.
5. **`.github` straddles two types:** `.github/workflows` is pipelines, the rest (the README) is settings. Longest place wins.
6. **`.claude` holds three purposes:** Claude settings and agents, a Python diagram kit, and a C# hook program built by the importer.
   One track fits the vendor rule; the kit and the program are modules inside it (`python`, a C# project) and the question is whether
   the holder track then admits those module types. Open question 4.
7. **Placeholders and generated files.** Three of the five `pipelines/` subfolders and `.cspell` are tracked only by `.gitkeep`; the
   dictionaries and `.vscode` are generated and ignored. A track with no real tracked file besides a placeholder is still a track
   (`.cspell`), one with no tracked file at all (`.vscode`) is not, until git tracks something in it.
8. **`contracts/` is its own thing.** It holds the repository's boundary contracts, in both directions, versioned per contracted module
   (`contracts/catzc/0.0.0/<module>/`), so it is a track type of its own (`contracts`). **Configuration is not a track type:** it is a
   file role (the `config` kind), static source files that sit inside a module (`configs/*.yml`) or inside a vendor-settings boundary
   (`.claude/settings.json`), and it follows its owner's track.
9. **Verification tracks are one project each.** `go/`, `python/`, `bash/` each hold `tests/catzc-base-*` (`catzc-base-engines` only in
   bash).
9a. **Vendored code is mostly its own thing.** `automation/.vendor` (65 files, third-party PowerShell modules) and `bash/.vendor`
   (21 files, bats-core) are third-party source the repository does not author, with their own upstream, version and update path. They
   are tracks of type `vendored-code`, nested under another track's root, and the longest-place rule gives them their files. The word
   *vendor* now has two meanings (the platform that reads a file; the third party that wrote it), so the type is named `vendored-code`,
   never `vendor`, and the `vendor` fact stays the platform.
10. **Docs are mostly generated.** `docs/references` (1160) mirrors modules and is built by the Docs module; `docs/.assets` is 864
    diagram files (430 png plus their sidecars).
11. **Unlisted files** are `.gitkeep` only (about 10 in the tracked set).

## 4. Resulting tracks, with types and vendors

| Track              | Place(s)                                    | Type              | Vendor  |
| ------------------ | ------------------------------------------- | ----------------- | ------- |
| `automation`       | `automation`                                | `modules`         | -       |
| `infrastructure`   | `infrastructure`                            | `infrastructure`  | `azure` |
| `pipelines`        | `pipelines`                                 | `pipelines`       | `ado`   |
| `github-workflows` | `.github/workflows`                         | `pipelines`       | `github` |
| `claude`           | `.claude`                                   | `vendor-settings` | `claude` |
| `github`           | `.github` (minus workflows)                 | `vendor-settings` | `github` |
| `cspell`           | `.cspell`                                   | `vendor-settings` | `cspell` |
| `contracts`        | `contracts`                                 | `contracts`       | -       |
| `docs`             | `docs`                                      | `documentation`   | -       |
| `go` `python` `bash` | `go` `python` `bash`                      | `verification`    | -       |
| `automation-vendor` | `automation/.vendor`                       | `vendored-code`   | -       |
| `bash-vendor`      | `bash/.vendor`                              | `vendored-code`   | -       |
| `unordered`        | `.unordered`                                | `unordered`       | -       |
| (`vscode`)         | `.vscode`, only once git tracks a file      | `vendor-settings` | `vscode` |

`vendor` is a closed set declared once with a one-line definition each: `azure`, `ado`, `github`, `claude`, `cspell`, `vscode`
(extendable by entry, as `file-kinds.yml` is).

## Carried: out/adr-draft-tracks-modules-types.md (verbatim, absorbed 2026-10-16; headings below are the draft's own)

# Draft ADR set: tracks, modules, and their types

Status: draft for review, written 2026-10-16 to `out/` (not yet in `docs/adr/`). Landing it is the checklist at the end. Where the user
has not decided yet, the draft takes the recommended answer and marks it **[confirm]**.

The set is one amendment and two new ADRs, all in the `design/` domain (`stack: DSGN`, `concern: [automation]`):

| Part | File                                | Code                  | What it holds                                                          |
| ---- | ----------------------------------- | --------------------- | ---------------------------------------------------------------------- |
| 1    | `docs/adr/design/tracks.md`         | `ADR-DSGN-TRACK`      | amended: #1 (what a track is), #2 (types replace classes), #5 wording  |
| 2    | `docs/adr/design/track-types.md`    | `ADR-DSGN-TRACKTYPE`  | new: the closed set of track types, deployable vs holder, declaration  |
| 3    | `docs/adr/design/module-types.md`   | `ADR-DSGN-MODTYPE`    | new: what a module is placed as, its type, and which track type admits it |

`ADR-REPO-FILEMETA#12` shrinks to the head fact and points at part 3 (one home for module types). The generic module model
(`ADR-AUTO-MODULE`, `out/plan-module-model.md`) is a different ADR in `automation/`; this set defines only placement and types and
leaves the module's internals (members, languages, engines, order) to it.

---

## Part 1: amendments to `design/tracks.md`

### Rule ADR-DSGN-TRACK:1 (replacement)

A **track** is a named, on-disk cluster of module contents: the tracked files of one concern, selected by the **places** the track
declares (ADR-DSGN-TRACKTYPE#4). A place is a root folder (`automation`), a path inside one (`.github/workflows`), or a group of root
folders (`.claude`, `.cspell`, `.vscode`, the vendor settings of the tools that read them). Every tracked file lies in exactly one
track, or is a root file (ADR-DSGN-TRACK#7); `out/` holds gitignored output and is in none. Tracks are what this mono repository is
composed of.

### Rule ADR-DSGN-TRACK:2 (replacement)

Every track has exactly one **track type** (ADR-DSGN-TRACKTYPE#1). The taxonomy of core, external port, adapter, verification and
unordered is the track type, stated once; a track carries no second classification beside it. Cross-cutting slices (for example the cats
configs: every yml file across automation) are **scopes over tracks**, not tracks: they select through the places rather than owning one.

### Narrative changes

- `What a track is`: "the unit of concern is the root folder" becomes "the unit of concern is the cluster of module contents". The folder
  is still the usual registration, but a place may be narrower (a sub-path) or wider (a group of dot-roots).
- `The taxonomy` section moves to part 2, where the types are defined; here it keeps one paragraph that points there.
- `Rule 5` (deployable-unit): the sentence "a pipeline never binds to a track except through the deployable-unit that IS that track"
  stands. The deployable-unit is what a **deployable track** owns (ADR-DSGN-TRACKTYPE#2).
- `Decision` and `How this is enforced`: "folder-named, classified core/port/adapter/verification" becomes "place-declared, typed".

---

## Part 2: new ADR `track-types.md` — ADR-DSGN-TRACKTYPE

# ADR: Track types — what a track owns, and where tracks are declared

## Rules: ADR-DSGN-TRACKTYPE

### Rule ADR-DSGN-TRACKTYPE:1

A **track type** is the sort of cluster a track is, and it is one of a closed set, each with a one-sentence definition: `modules`,
`infrastructure`, `pipelines`, `vendor-settings`, `vendored-code`, `contracts`, `documentation`, `verification` and `unordered`.
Configuration is no track type: it is a file role (the `config` kind), static source files inside a module or inside a vendor-settings
track, and it follows its owner. A track has exactly one type. A new tech-stack that ships (a `services` or `frontend` track, ADR-DSGN-TRACK#3) adds its type to the set in
the same change that opens the track, never before it.

- [Track types](#track-types)

### Rule ADR-DSGN-TRACKTYPE:2

A track type has one **role**. A **deployable track** (`modules`, `infrastructure`, and the future `services` and `frontend`) *owns*
deployable-units: collections of the track's modules that the repository delivers through CI/CD (ADR-DSGN-TRACK#5). A **holder track**
(every other type) *is* a module more than it owns modules: it holds one vendor's or one tool's files for this repository, and it
ships nothing of its own. The role is declared on the track type, never on the track.

- [Deployable and holder tracks](#deployable-and-holder-tracks)

### Rule ADR-DSGN-TRACKTYPE:3

A track may name the **vendor** that reads its files: the platform or tool, from a closed set declared once with a definition each
(`azure`, `ado`, `github`, `claude`, `cspell`, `vscode`; a new vendor is an entry). A vendor is never mixed into another vendor's track, and one vendor may have several tracks (`github` has a `pipelines` track and a
`vendor-settings` track; `claude` may split its settings from its tooling kit).
The ADO pipelines (`pipelines/`, vendor `ado`) and the GitHub workflows (`.github/workflows`, vendor `github`) are two tracks of one
type, `pipelines`, because each is read by a different platform and bound to a different pipeline model (`pipelines/`, `github/`). The
settings of each tool the repository configures are one `vendor-settings` track per vendor (`.claude`, `.cspell`, the `.github` files
that are not workflows, and `.vscode` once git tracks a file in it). The `infrastructure` track has vendor `azure`. `vendor` is the
platform that reads a file and never the third party that wrote it.

- [Deployable and holder tracks](#deployable-and-holder-tracks)

### Rule ADR-DSGN-TRACKTYPE:4

A track is **declared once**, in the `tracks` map of `variants.yml` (`Catzc.Base.Variants`, ADR-REPO-VARIANT), as its name, its type,
its **places** (the paths it covers), its vendor when it has one (ADR-DSGN-TRACKTYPE#3) and its file languages (ADR-DSGN-TRACK#6). The track types are declared once, in `track-types.yml`
of the same module, each with its definition, its role (ADR-DSGN-TRACKTYPE#2) and the module types it admits (ADR-DSGN-MODTYPE#3). No
other file lists a track, a track type or a place: a command, a gate and a globset read them through `Get-Track`.

- [Where the declarations live](#where-the-declarations-live)

### Rule ADR-DSGN-TRACKTYPE:5

A file belongs to the track with the **longest place** that contains it, so a narrower place wins over a wider one: a file under
`.github/workflows` is in the `pipelines-gh` track, and the rest of `.github` is in `vendor-settings`. Two places of different tracks
that are equally long and both contain a file, a place that no file resolves to, and a tracked file in no track and no root file are load
failures. The answer to "which track holds this file" is therefore one value, computed.

- [Where the declarations live](#where-the-declarations-live)

### Rule ADR-DSGN-TRACKTYPE:6

A file's head carries `track`, `tracktype` and, when the track has one, `vendor`, all read from the declaration and never guessed from
a folder name, and each left out for a root file. `tracktype` and `vendor` are the new head keys; `head.schema.json` and its sample list it (ADR-REPO-CONTRACT#6). A file head never
carries the track's role, places or languages: a reader looks those up by the track's name.

- [Where the declarations live](#where-the-declarations-live)

## Context

The repository holds more than code to deploy. Its `automation` and `infrastructure` trees are collections of modules that CI/CD
delivers; its `pipelines/` and `.github/workflows` trees are the repository's own pipeline definitions for two different platforms; its
dot-folders configure the tools that read them. Calling all of these "root folders" hides the difference that matters: which tracks
produce a deliverable, and which only hold a vendor's configuration. A name for the type of track, declared once, makes that difference
a fact a gate can check.

### Track types

`modules` holds PowerShell and C# modules; `infrastructure` holds Bicep templates and reusable Bicep modules; `pipelines` holds pipeline
definitions, Azure DevOps or GitHub Actions by vendor; `vendor-settings` holds the settings of one tool the repository configures;
`vendored-code` holds third-party source the repository does not author (`automation/.vendor`, `bash/.vendor`), nested under another
track's root and resolved by the longest place; `contracts` holds the repository's boundary contracts, in both directions;
`documentation` holds the ADRs, references and guides; `verification` holds the black-box test projects (Go, Python, Bash);
`unordered` is the frozen shelf (ADR-DSGN-TRACK#17). Configuration is a file role, not a type: `configs/*.yml` belongs to its module's
track and `settings.json` to its vendor-settings track. **[confirm]** the exact set.

### Deployable and holder tracks

The line between deployable and holder follows the delivery model, not the folder. A deployable track has modules that are built,
verified and promoted as units, so it carries aspects (ADR-DSGN-ASPECT), globsets and a pipeline per deployable-unit. A holder track
carries none of that: its files are read by a platform or a tool, and its only checks are that they are well-formed and in the right
place. A holder is therefore small, and a vendor change touches only its holder.

### Where the declarations live

A track and a track type are data, not code (ADR-PRIN-CONFIG): a new track is an entry, a new type is an entry plus the handler its role
needs, and neither is a branch in a command. The declaration sits with the variants because a track is a repository-wide variant
(ADR-REPO-VARIANT), and the types sit beside it so the closed set and the tracks are validated together at load by the config types
(`VariantsConfig`, `VariantTrack`, `TrackTypesConfig`).

## Decision

Name the type of a track and declare it once. A track is a cluster of module contents (ADR-DSGN-TRACK#1) with one of a closed set of
types (ADR-DSGN-TRACKTYPE#1). A deployable track owns deployable-units and a holder track is a module of one vendor or one tool
(ADR-DSGN-TRACKTYPE#2, #3). The `tracks` map and `track-types.yml` are the only declarations (ADR-DSGN-TRACKTYPE#4); the longest place
resolves each file (ADR-DSGN-TRACKTYPE#5); the head says `track` and `tracktype` (ADR-DSGN-TRACKTYPE#6).

### How this is enforced

- **`VariantTrack` / `TrackTypesConfig`** fail the load on a track without a type, an unknown type, an overlapping equal-length place,
  an unknown key, and a type that admits an unknown module type.
- **`Test-WorldMap`** fails a tracked file in no track and a stack violation (ADR-DSGN-TRACK#11); its rows are the tracks.
- **`Test-FileMeta`** compares `track` and `tracktype` in each head with the declaration.

## Consequences

- "Is this track a deliverable or a holder?" is a declared fact, so a gate treats a holder's file without aspects, globsets or a
  deployable-unit and does not guess.
- A vendor change (the GitHub workflows) is a change to one holder track and never re-keys the ADO pipelines.
- The cost is one more declaration per track, and a longest-match rule that a reviewer has to read when a place is narrowed.

---

## Part 3: new ADR `module-types.md` — ADR-DSGN-MODTYPE

# ADR: Module types — what a module is placed as

## Rules: ADR-DSGN-MODTYPE

### Rule ADR-DSGN-MODTYPE:1

A **module** is a named unit placed in a track: a PowerShell module is a folder under `automation` or one `psm1` file, a Bicep module is
a template folder or one reusable `bicep` file, and a holder track's module is the holder itself (the vendor settings, the ADO
pipelines, the GitHub workflows). A file in no module, such as a documentation page, has neither `module` nor `moduletype`.

- [Modules](#modules)

### Rule ADR-DSGN-MODTYPE:2

A **module type** is the sort of module, named without the word module (`pwsh-folder`, `pwsh-psm1`, `bicep`, `pipeline`,
`settings`, `python`, `go`, `bash`), and the module-types registry (`module-types.yml`, `Catzc.Base.Variants`) declares
it once: its definition and its **places**, the paths where modules of the type are found and how a path there names its module (a
folder, one file by extension, or the place's root). `module` and `moduletype` are read from the registry and never guessed from a
folder name.

- [Module types](#module-types)

### Rule ADR-DSGN-MODTYPE:3

Each track type **admits** a set of module types, declared on the track type (ADR-DSGN-TRACKTYPE#4), and a module's type must be
admitted by the type of the track that holds it: `modules` admits `pwsh-folder` and `pwsh-psm1`, `infrastructure` admits `bicep`,
`pipelines` admits `pipeline` (its vendor says which platform), `vendor-settings` admits `settings`, `vendored-code` admits the module
types of the track it is nested in, and `verification` admits `python`, `go` and `bash`. A module of a type its track does not admit is a load failure, so a second stack inside a track shows
as a violation without reading the file (ADR-DSGN-TRACK#3).

- [Types and tracks](#types-and-tracks)

### Rule ADR-DSGN-MODTYPE:4

A deployable track's module is a unit of delivery; a holder track's module is the holder itself, one module per track, so its `module`
is the track's name. A module's bundle (`catzc_bundle`) is read from the exporter registry for a module of a deployable track and is
left out for a holder's, so a head never lists a bundle for a file that is not bundled.

- [Types and tracks](#types-and-tracks)

## Context

### Modules

The word module is used for a PowerShell folder, a Bicep template, a tool's dot-folder and a Python project. They share one fact: each is
a unit with a name and a place. The module-types registry states that fact once per sort.

### Module types

Separating the sort (module type) from the track (track type) matters because a track can hold several sorts of module (`automation`
holds folder and `psm1` modules) and a sort can sit in more than one place (`settings` in several dot-roots). Each of the two is one
declaration; the relation between them is the `admits` list, which is the only place the two meet.

### Types and tracks

Admission is the check that keeps a track one stack: the track type says what its tracks may contain, and the module type says what a
module is. A holder's single module keeps the head honest: the `settings` module of `vendor-settings` is the whole track, so a reader
never looks for a module folder where none exists.

## Decision

A module is a unit placed in a track; its type comes from the registry (ADR-DSGN-MODTYPE#1, #2); its track type must admit it
(ADR-DSGN-MODTYPE#3); a holder's module is the holder (ADR-DSGN-MODTYPE#4).

### How this is enforced

- **The config types** fail the load on an unadmitted module type, an unknown key and a place two types claim.
- **`Test-FileMeta`** compares `module`, `moduletype` and `catzc_bundle` in each head with the registry.

## Consequences

- One registry says what a module is; the file-meta ADR only says the head carries it.
- `pipeline` stays one module type: the platform is the track's vendor, so ADO and GitHub pipelines differ by a declared fact, not by a
  second type.
- The cost is one more head key (`vendor`) and one more declaration (the vendor set), done by regeneration.

---

## Decisions the draft took (confirm or change)

1. **Types replace classes.** The class axis (core, adapter, external-port, verification, unordered) is deleted; the type is finer and
   a class is derivable from it. Keeping both would be two versions of one classification (ADR-PRIN-ONELIVE). Consumers of `class`
   (`Get-Track`, `VariantTrack.Classes`, `Test-WorldMap`, glossary entries) change in the same landing.
2. **"Deployable module" is the deployable-unit.** No new level: a deployable track owns deployable-units (ADR-DSGN-TRACK#5). If you
   want a level between module and unit, that is a new rule here.
3. **Type set and names** as in ADR-DSGN-TRACKTYPE#1, with `services` added only when its track opens. `contracts/` is its own type;
   configuration is a file role, not a type (user, 2026-10-16).
4. **`.vendor` folders are tracks of type `vendored-code`** (`automation-vendor`, `bash-vendor`), nested under their neighbour's root
   (user: "mostly their own thing"). "Mostly" is open: if some vendored file should stay with its user, say which.
5. **One `vendor-settings` track per vendor** (`claude`, `github`, `cspell`, later `vscode`), each with one place, and a `vendor` fact
   on the track: `azure`, `ado`, `github`, `claude`, `cspell`, `vscode`. `pipelines/` and `.github/workflows` are two `pipelines`
   tracks distinguished by vendor. Full structure analysis: `out/analysis-track-structure.md`.
6. **The modules-track key** is `automation` today and follows `out/plan-automation-layers-rename.md` if the folder is renamed; the
   type name `modules` does not change either way.

## Landing checklist (one file at a time; verify each)

1. Read `out/plan-module-model.md`, `out/plan-k8s-kinds.md` and `out/plan-automation-layers-rename.md` first: the module model and the
   kinds-are-tracks decision touch `VariantTrack`, `FileMetaConfig` and the same ADR text. Another session had uncommitted edits in
   `FileMetaConfig.cs` and `FileSelector.cs`: message before touching them.
2. Write `docs/adr/design/track-types.md` and `module-types.md` (no head: `Format-FileMeta` imprints it); amend `tracks.md`.
3. `automation/Catzc.Base.Docs/configs/adrs.yml`: add `track-types` and `module-types` to the `design` rulesets
   (`ADR-DSGN-TRACKTYPE`, `ADR-DSGN-MODTYPE`, `concern: [automation]`); regenerate `docs/adr/index.md` with `Build-AdrIndex`.
4. `docs/adr/design/dora-explains.md`: one entry each (version control, loosely coupled teams, platform engineering).
5. Glossary (`Catzc.Base.ModuleSystem/configs/glossary.yml`): edit `track` (no longer "one root folder", no "classified"), add
   **track type**, **deployable track**, **holder track**, **place**, **vendor** (the platform that reads a file, never the third
   party that wrote it), **vendored code**, **module type**; contrast with class (removed), deployable-unit,
   file language. Run the vocabulary gate.
6. `ADR-REPO-FILEMETA#12`: shorten to the head fact and link `module-types.md`; add `tracktype` to #7's key list.
7. Code, in the order the module-model plan sets: `VariantTrack.cs` (`places`, `type`; drop `class`), `TrackTypesConfig`,
   `variants.yml`, `track-types.yml`, `module-types.yml` (`pipeline` split), `Get-Track`, `Get-TrackFileMetaFact.ps1`,
   `head.schema.json` + `head.sample.yml`, `Test-WorldMap`. Then `Format-FileMeta` over the tree and `Test-FileMeta`.
8. Run per-file tests as each file lands; do not claim a gate passed until it ran (project rule).
