---
plan:
  status: active
  value: high
  reviewed: 2026-10-16
  next: the module model has landed; its open items are in plan-module-model-closeout; then kind to role
  targets:
    [
      automation/Catzc.Base.ModuleSystem,
      automation/Catzc.Base.Variants,
      automation/Catzc.Base.Globs/configs,
      docs/adr/automation,
      docs/adr/design,
    ]
---

# Module as the one generic model; object kinds owned by tracks; a type for each track

Three drafts: Module as the generalised, ADR-backed meta model (one C# definition every track instantiates); Kubernetes-style kind names
where kinds are tracks' vocabulary and today's kind becomes role; tracks as on-disk clusters of module contents with a track type
(deployable or holder). Nothing is built. Two prepare and two implement prompts for the first two sit beside this file.

## Why its value is high

Seven places answer "what is a module" and none can answer for the others. Kind and role share one word in every head. The track model is
the user's own and changes what every head's track key means. The config defaults and layers plans both wait on this one landing.

## Decided, and why

- Sequencing (2026-10-16, layers Q8): the module model lands first and keeps the name automation in its text. New code takes the track from
  the one resolver, so the later rename to pwsh stays a data edit. It deletes Get-AutomationModules and Get-BaseModule.
- Config defaults (2026-10-16, plan-config-defaults): every key this plan adds to a config type declares its default once on the type;
  `tracks.<t>.engines` joins variants.yml and VariantTrack; aspects shrinks. If both plans touch VariantsConfig.cs or VariantTrack.cs, this
  plan owns the file and the config defaults plan edits after it.
- k8s plan Q1 to Q3, D1, uniqueness per track, namespace deferred: taken as recommended (section 6 of that draft).
- Module-model Q-A to Q-G decided by the user in the questionnaire round of 2026-10-16 (Q27 to Q33): languages modelled generally and
  forbidden by the track's declared languages, the GO, PY and BASH ADRs unchanged; engines per track with a per-module override; the
  resolver is Get-CatzcModule, a new name; LoadedModule is one rule of ADR-AUTO-MODULE; the ADR's domain is automation; layout lives under
  each language in languages.yml; an unplaced file inside a module folder is a finding.
- Tracks (Q34, Q35): every vendored file lives in the vendor track, none beside its user; the .claude kits stay inside the holder track, the
  user not minding modules in vendor folders as long as their front matter is processed and formatted; and a track has one primary language
  by default, a rule for ADR-DSGN-TRACK.
- Q36 namespace is planned after kinds land; Q37 the module-model session looks at the three Get-ModuleProtectionIdentity failures first;
  Q38 layers P1 runs beside the module model, code phases wait.
- Re-rooted (Q98, F2, S2, 2026-10-16): Track is the root entity and Module is one of its kinds. ADR-AUTO-MODULE becomes a rule set under
  ADR-DSGN-TRACK; the resolver reads modules through their track; every deployable track has the Module kind. The carried module-model draft
  and both module-model prompts were written with Module as the centre and are rewritten before they run. The first import into the landing
  zone is the proof of the track model on foreign code (F10).
- Vendor note (C1): node_modules compares to .vendor, tracked or not; both are ignored by everything but their loader. A vendor track rule
  says so, and the enumeration prune sets name both.
- Q88: the Test-ShippedTypes flags on TrackTypeEntry and VendorEntry are this plan's.
- Module-model open choices a, b, c (2026-10-16), taken as recommended, confirmed by the user 2026-10-18 (D01 to D03): (a) the resolver
  lives in a new small module above Languages and returns a type carrying identity only; needs and order stay in ModuleSystem
  (dependencies.yml lives there). (b) the track key is execution_engines (languages.yml engines: means formatter engines); the table is
  called "layout"; the word "kind" stays out of the ADR text until the kind-to-role rename lands. (c) rule 5 says one function sorts the
  graph; rule 6 covers check and test handlers only (the build is code in the closed Builder); LoadedModule is kept only if the draft's
  reasoning holds on re-reading, else dropped with BaseModule.

## Done, and why: tracks, track types and vendors as ADRs and code (session report of 2026-10-16 15:14, verified in the tree)

- ADR-DSGN-TRACKTYPE, docs/adr/design/track-types.md, seven rules; docs/adr/design/module-types.md alongside. VariantTrack carries places
  (plural, so a track is a cluster of places), type (a track-types registry id) and vendor (the vendor that reads the track's files, or
  none); VariantsConfig and Get-Track tests updated. The carried track-type draft below is superseded where the ADR speaks; its Q1 to Q5 are
  answered by the ADR's rules, not by this file.
- Format-Links aligned two bare citations in WorldMapBuilder.cs; WorldMapBuilder.Tests.ps1 passes (21). Test-Links was not rerun there; its
  two findings in that file should be gone.
- Left open by that session: the stale head.schema.json contract (the head gained tracktype and vendor; see
  plan-file-head-immutable-edges-classes, which owns the contract); and two user choices: which vendored files stay with their users, and
  whether the kits under .claude (agents, drawio) become separate tracks.
- Peer-reported, unowned here: 3 Get-ModuleProtectionIdentity test failures (ModuleSystem), not from that session's changes.
- 2026-10-16: the two module-model prompts and the two k8s prompts are rewritten on the Track-as-root premise (Module is a kind of the
  deployable tracks; ADR-AUTO-MODULE sits under ADR-DSGN-TRACK and cites ADR-DSGN-TRACKTYPE and ADR-DSGN-MODTYPE). Test-Links is clean on
  all four; they carry Q27 to Q38 and Q88. No prompt has been run yet.

## Needed docs

- ADR-AUTO-MODULE, new (domain automation, recommended; LoadedModule provenance as one rule of it).
- ADR-DSGN-TRACK extended: a kind is an object kind of a track, unique per track; track types; a track may be a sub-path or a group of
  dot-roots. The k8s step 4 groups file-kinds.yml by track.
- Glossary: kind (object), role (file role), track type, deployable module, holder track. Comment pages of the touched resolvers.

## Needed tests

- Resolver tests for the new module getter (Q-C, recommended Get-CatzcModule) replacing Get-BaseModule and the Get-PathModule overlap.
- file-kinds.yml grouped by track; Test-FileMetaProcessors kind and processor counts; head.schema.json and sample updated.
- Track type L0 tests with neutral fixtures; variants.yml tracks carry the type.
- Note: FileMetaConfig.cs and FileSelector.cs may hold another session's edits; message before touching.

## Open steps

- [x] Run the prepare prompt (check: its read-only report and ADR draft in out/: module-model-callers, -reading, -slots, -layering,
      -protection-identity, draft-adr-auto-module).
- [x] Settle the three open choices listed under "Corrections": taken as recommended, confirmed by the user 2026-10-18 (D01 to D03) (see
      "Decided, and why").
- [x] Run the implement prompt, steps 1 to 9 (2026-10-16): ADR-AUTO-MODULE landed (6 rules; LoadedModule dropped with BaseModule, no caller
      used it), layout in languages.yml, Catzc.Base.Modules with Get-CatzcModule and Get-Aspect, execution_engines on the track,
      Get-ModuleOrder, old getters and types deleted, L1 integrity tests. Left: step 10 (infrastructure), generated READMEs and docs pages,
      Format-FileMeta heads of the new files.
- [x] Step 10, the infrastructure track. Read 2026-10-17 (task-module-model-closeout): the bicep module type places
      `infrastructure/templates` folders and `infrastructure/modules` files below the track's one place `infrastructure`, which the resolver
      treats as internal. Decided and done 2026-10-18 (under the user's "u decide", configure over program): the infrastructure track
      declares its two places, `[infrastructure/templates, infrastructure/modules]`, so no resolver change is needed, and every tracked
      infrastructure file sits under one of them. Check: `Get-CatzcModule -TrackType infrastructure` names 22 modules, the three templates
      and the 19 Bicep modules; a new L1 case in Get-CatzcModule.Tests pins it on the tree; `[Invoke-TestFile] Passed` for
      Get-CatzcModule.Tests, Get-Aspect.Tests, Test-AspectDeclaration.Tests and FileKindReachability.Tests (`out/test-file/20261018-142116`
      to `-142140`); `WORLDMAP issues=0`, `SHIPPED issues=0`, `FILEMETA issues=0`, the analyzer clean on Azure.Templates and Modules.
- [x] Rename kind to role; kind takes the object meaning, partitioned by track (check: Test-FileMeta, Test-FileKinds clean). Done 2026-10-18
      (task-kind-becomes-role steps 2 to 6, on the user's go, D24): every head says `role`, the file-meta kind is `file-role`, rule 11 and
      the glossary say role; `FILEMETA issues=0`, `GENERATED issues=0`. The object's kind stays the track type the head already carries, so
      no second key says it.
- [x] Rerun Test-Links on WorldMapBuilder.cs (check: zero findings there). 2026-10-18: `LINKS issues=0` (`out/test-links/20261018-122129`).
- [x] Look at the 3 Get-ModuleProtectionIdentity failures (check: that test file): run 2026-10-16, 11 passed, 0 failed; the file is in
      QualityGates and isolated from tracks; nothing to fix (out/module-model-protection-identity.md). Run it again after the
      dependencies.yml edges land.
- [x] ADR-DSGN-TRACK gains the rule that a track has one primary language by default (check: Test-AdrRegistry, Test-Links). In the tree as
      ADR-DSGN-TRACK#18, "A track has one primary language by default", so the task's "rule 19" is that rule; `ADRREG issues=0`.
- [x] Namespace follow-up after kinds land (check: a decided section here). Decided 2026-10-18 (D29, delegated by the user): a module's
      namespace is its track's name, so `Catzc.Base.*` stays for the pwsh track, and no step follows.
- [x] Tell plan-config-defaults and plan-layers-vocabulary-rename-contracts when implemented (check: the waits_on line in both heads is
      gone). Done 2026-10-18 by task-module-model-closeout step 10.

## Refs

- carried below: the k8s kinds draft (decisions in its section 6), which the kind-to-role task still reads; the module-model, track-type,
  track-structure and tracks-modules-types drafts are in the tree as ADR-AUTO-MODULE, ADR-DSGN-TRACKTYPE and ADR-DSGN-MODTYPE, so they are
  gone (git keeps them)

## Carried: out/plan-k8s-kinds.md (verbatim, absorbed 2026-10-16; headings below are the draft's own)

## Plan: Kubernetes-style kind names

Goal: the things catzc talks about get the names Kubernetes already gave their counterparts (`Module`, `Service`, `Deployment`, `ConfigMap`,
…), so a reader who knows k8s reads a catzc head or config without a translation table. Kubernetes is the source of the _vocabulary_ only;
catzc's own ADRs decide every meaning (CLAUDE.md "Inspiration" rule: an idea to weigh, never an authority).

**Sequencing with the rename (decided 2026-10-16, [plan-automation-layers-rename.md](plan-layers-vocabulary-rename-contracts.md)):** the
track now called `automation` is renamed to `pwsh` (folder, track key, overlay `.catzc/pwsh/`, outputs `out/pwsh/`) after the module-model
plan lands. This plan keeps the name `automation` in its text; new code and data it adds must take the track key from the registry, not a
literal, so the rename stays a data edit.

## 1. What a k8s `kind` is, and what ours is today

A k8s `kind` answers **what object is this** (`apiVersion` + `kind` = GVK, then `metadata` + `spec`). It is never a file role.

Our head `kind` answers **what role does this file play** (`file-kinds.yml`: `function`, `config`, `template`, `pipeline`, `test`, `adr`,
`reference`, …, matched by glob). Those are two different questions. Only the second exists today, so the new names do not fit in
`file-kinds.yml` as extra rows: `Deployment` is not a file role, it is an object that several files (a `.bicep` template and a
`configuration/<target>.yml`) together describe.

**Kinds are tracks (user, 2026-10-16).** A track is a root concern, one root folder (`ADR-DSGN-TRACK#1`), and every head already carries
`track`. So the object kinds are the vocabulary of the tracks: each track owns the kinds that live in it, and a kind is named for the thing
the track is _about_:

| Track (root folder)    | Object kinds it owns                                                                     |
| ---------------------- | ---------------------------------------------------------------------------------------- |
| `automation`           | **Module** (a folder), **ConfigMap** (its `configs/*.yml`), Type (compiled C#), Function |
| `infrastructure`       | **Deployment** (template × target), Template, BicepModule                                |
| `pipelines`, `.github` | **Pipeline** (and PipelineTemplate)                                                      |
| `contracts`            | Contract (the stable boundary; the nearest k8s idea is Service, see section 2)           |
| `docs`                 | Adr, Reference, HowTo, Explanation, Glossary                                             |
| `go`, `python`, `bash` | Test (verification tracks hold tests only)                                               |
| `.claude`              | Agent, Skill, Hook                                                                       |

**Tracks can themselves be kinds (user, 2026-10-16).** The track list is open (`ADR-DSGN-TRACK#3`: a new tech-stack or concern opens a new
track), so a root folder can be named by a kind: a `services` track holding Services, a `modules` track holding Modules, and so on. Then the
kind is the track name and the pairing is direct (track `pipelines` holds `Pipeline`s, track `services` holds `Service`s). This reopens two
rows below:

- **Service** is no longer blocked on "nothing runs here": it can be a track of its own, opened when the first hosted workload is described,
  and it then keeps the k8s meaning (a stable endpoint in front of a changing workload). Contracts stay `contracts`.
- **Module** as a track conflicts with today's `automation`, which _is_ the track that holds modules (`automation/<Module>/`). Either
  `automation` stays the core track and `Module` is the kind inside it (the table below), or modules move to a `modules` track and
  `automation` keeps only the loader and tooling. The second is a large move (every path, glob, and dependency), so recommend the first
  until a second module-like family needs its own folder. Open question Q3.

This resolves the open design question: the head's `track` says which folder, `kind` says which object of that track's vocabulary, so `kind`
needs no free-standing list of its own, it is partitioned by track. Two consequences: (1) a kind id is unique within its track, not
repo-wide (`Module` exists only in `automation`); (2) the registry (`file-kinds.yml`) groups kinds under their track.

**Decision D1 (recommend: two keys).** Keep the file-role registry as it is and add a second, object-level key. Candidate spelling: the
existing `kind` key becomes the object kind (k8s meaning), the file role is renamed `role`. One living version (`ADR-PRIN-ONELIVE`): that
rename touches every head, so it ships as one change with `Format-FileMeta` rewriting them (never hand-edited). Alternative: leave `kind` =
role and name the new key `object`. Cheaper, but then catzc spells `kind` differently from k8s, which defeats the goal. Recommend the
rename, done once, before the registry is published as a contract (open item 2 of [[file-head-vocabulary]]; `ADR-REPO-CONTRACT#3/#5` say
publish before any release, so now is the cheapest moment).

## 2. Name by name

| k8s kind                     | Catzc counterpart today                                                                                                                                                                                                                             | Verdict                                                                                                                                                                                                                                                                                                                   |
| ---------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Module**                   | Not new. A folder under `automation/` with `.ps1` files is a module (CLAUDE.md "Folder = module"); head key `module`, `Get-PathModule`, module dependencies (`ADR-AUTO-DEPM`).                                                                      | **Adopt as an object kind.** Collision to fix: `file-kinds.yml` already uses `module` for the single-file `.psm1` loader. That row is a _role_ (`role: loader-module`, subkind `internal`), not the object `Module`. k8s has no Module; this is catzc's own kind, named for what we already call it.                      |
| **ConfigMap**                | `automation/**/configs/*.yml`, read by `Get-Config`, validated by a C# type.                                                                                                                                                                        | See section 3.                                                                                                                                                                                                                                                                                                            |
| **Deployment**               | The desired state of one thing in one place: an infrastructure template plus its `configuration/<target>.yml` (for example `foundation` + `apex/nsub`).                                                                                             | **Adopt.** Matches k8s: declared desired state that a controller (the pipeline) converges to. Deployment = template × target.                                                                                                                                                                                             |
| **Service**                  | Nothing runs as a long-lived service in this repo. The nearest k8s idea, a stable name in front of changing pods, is a **contract** (`contracts/`, `ADR-REPO-CONTRACT`): a versioned boundary consumers depend on while the implementation changes. | **Do not adopt yet.** Using `Service` for a contract would break "same meaning as k8s". Adopt it only when a customer workload is described (for example the apps a landing zone hosts). Until then it is a reserved name, listed in the glossary as not-yet-used. Open question Q2.                                      |
| **Pipeline**                 | `pipelines/*.yaml` and `.github/workflows/*.yml`, one per deployable-unit (`ADR-DSGN-TRACK#5`, `ADR-FLOW-CD-TYPE`). Today the file role `pipeline`.                                                                                                 | **Adopt (user-required).** k8s has no Pipeline (Tekton does), so this is catzc's own kind, same as Module. It stays the word ADO and GitHub users see. The type-of-pipeline (CRON, CI, CD, CDe, DEPLOY, INPUT) is a field of the Pipeline, not a kind, which also settles the Job / CronJob row below: do not adopt them. |
| **Secret**                   | Deploy-time injection: the repo holds a template until BVT.                                                                                                                                                                                         | Reserve; a Secret kind lets the template-until-BVT rule have a name.                                                                                                                                                                                                                                                      |
| **Namespace**                | Environment / tenant / customer scoping in `azure.yml` and `customer.yml`.                                                                                                                                                                          | Candidate, decide with the Deployment work.                                                                                                                                                                                                                                                                               |
| **Job / CronJob**            | Pipeline types `CRON`, `CI`, `CD`, `CDe`, `DEPLOY`, `INPUT` (`ADR-FLOW-CD-TYPE`).                                                                                                                                                                   | Not adopted: `Pipeline` is the kind (row above); CRON and the others are its type.                                                                                                                                                                                                                                        |
| **CustomResourceDefinition** | `file-kinds.yml` itself, and every config's C# type.                                                                                                                                                                                                | See section 3.                                                                                                                                                                                                                                                                                                            |
| (none)                       | `deployable-unit` (`globs.yml`, `ADR-DSGN-TRACK#5`): what ships.                                                                                                                                                                                    | k8s has no native kind; Helm calls it a **Chart**. Keep `deployable-unit`; do not invent a k8s name for it.                                                                                                                                                                                                               |

## 3. Do we need our own kind for config?

A k8s `ConfigMap` is untyped key/value data, separate from the code that reads it, consumed by name. Our `configs/*.yml` has the same role
(non-secret, separate from the function that reads it, addressed by name) but is **typed**: a C# class validates it (`FileMetaConfig.cs`,
`FileKindsConfig`). That is what a k8s **custom resource** is: an instance of a kind that a definition (CRD) describes.

Recommend: the object `kind` of a config file is **its C# type name** (`kind: FileKindsConfig`), exactly how a custom resource's kind is its
CRD's `names.kind`. No new `ConfigMap` kind is needed, and `ConfigMap` is kept for any future genuinely untyped key/value file. The C# type
is the CRD; the registry listing which type owns which file is the CRD list. That gives `Get-Config` a rule that already reads like k8s:
look up the kind, validate the document with the type behind it.

Open question Q1: is `kind: <TypeName>` too close to a code detail for a head that prose readers see? Alternative `kind: Config` with the
type under a second key. Recommend the type name: it is the one name that can never drift from the validator.

## 4. Steps (one file at a time, each verified before the next)

1. **Decide D1 and Q1/Q2** with the user. No code before that.
2. **ADR first.** Write the decision as a rule in an ADR in the `repository/` domain (file-meta or a new `object-kinds` ADR), register it in
   `adrs.yml`, rebuild the index with `Build-AdrIndex`. Cite `ADR-REPO-FILEMETA`, `ADR-REPO-CONTRACT`, `ADR-PRIN-ONELIVE`.
3. **Glossary.** One entry per adopted kind in the owning module's `configs/glossary.yml`, with contrasts against the lookalike (`Module` vs
   the `.psm1` loader role; `Deployment` vs `deployable-unit` vs `release candidate`; `ConfigMap` vs `config`). Gate: `Test-Terminology` /
   the controlled-vocabulary check.
4. **Registry.** Extend `Catzc.Base.Globs/configs/file-kinds.yml` (type `FileKindsConfig`) with the role rename and a new object-kind map
   (definition, the files that make it up, the type that validates it). Update `FileKindsConfig.cs` and its tests; new C# edits need a fresh
   `pwsh` process.
5. **Resolver.** `Get-FileKind` returns role and object kind. Declare any new module edge in `ModuleSystem/configs/dependencies.yml` in the
   same change (`ADR-AUTO-DEPM#5`, `Test-ModuleDependency`).
6. **Heads.** Make `Format-FileMeta` write the new key, then regenerate. This also closes open item 1 of [[file-head-vocabulary]] (generated
   heads still say `generated-from-source`): the writers pass the kind from `Get-FileKind` instead.
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

No Kubernetes manifests are generated, no `apiVersion`/`metadata`/`spec` envelope is added to config files, and no k8s tooling is used. We
borrow names, not a runtime. Not a repo-wide version (mono repo, not monolith): the kind registry versions like any other contract.

## 6. Decisions (user, 2026-10-16: "go with your recommendations")

- **Q1:** a config's kind is its C# type name (`kind: FileKindsConfig`); `ConfigMap` is reserved for untyped key/value files.
- **Q2:** `Service` opens a `services` track when the first hosted workload is described; contracts stay `contracts`.
- **Q3:** `Module` is a kind inside the `automation` track; no `modules` track.
- **D1:** today's `kind` is renamed `role`; `kind` takes the k8s meaning (object kind), partitioned by `track`.
- **Uniqueness:** kind ids are unique per track, not repo-wide.
- **Namespace:** follow-up, not in this change.
- Step 4 groups `file-kinds.yml` by track; the track list is `ADR-DSGN-TRACK#1`, so the ADR in step 2 should extend `ADR-DSGN-TRACK` (a kind
  is an object kind of a track) rather than add a competing ADR.

Note (parallel sessions): `FileMetaConfig.cs` and `FileSelector.cs` have uncommitted edits from another session. Message before touching
them.
