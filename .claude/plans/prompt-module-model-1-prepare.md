# Prompt 1 of 2 for plan-module-kinds-tracks: close the missing work, read-only, and draft the ADR; paste as the first message

Rewritten 2026-10-16 on the Track-as-root premise (Q98, F2, S2); the earlier text made Module the central concern. Copy it and the plan into
your scratchpad first (another session wiped `out/` once). Everything below the rule is the prompt.

---

You are preparing the Module-model work in `C:\projects\catzc` (PowerShell 7.4+ module system, "cats"). This session is **read-only on the
code and docs trees**: it writes new files only under `out/`, and edits only the plan file this prompt names. Nothing is committed; the user
commits.

## 1. Read first

1. `.claude/CLAUDE.md` in full: one-file-at-a-time editing, the time safeguard (every Bash call `timeout: 3000`; longer work
   `run_in_background: true` with a `timeout <s>` prefix around one command, at most 360 s, no `cd … &&`, pipes or `;` there), no mutating
   git.
2. `docs/adr/index.md`, then in full: `ADR-DSGN-TRACK` (`design/tracks.md`), `ADR-DSGN-TRACKTYPE` (`design/track-types.md`),
   `ADR-DSGN-MODTYPE` (`design/module-types.md`), `ADR-DSGN-ASPECT` (`design/module-aspects.md`), `ADR-AUTO-DEPM`
   (`automation/controlling-module-dependencies.md`), `ADR-AUTO-ENGINE` (`automation/execution-engines.md`), `ADR-AUTO-BUNDLE`
   (`automation/platform-bundle.md`), `ADR-PWSH-MANIFEST` (`pwsh/dynamic-module-manifests.md`), `ADR-AUTO-TYPES`
   (`automation/BCL/native-csharp-types.md`), `ADR-AUTO-DEFAULT`, `ADR-AUTO-ZERO`, `ADR-AUTO-EXTEND`, `ADR-PRIN-CONFIG`, `ADR-PRIN-ONELIVE`,
   `ADR-REPO-VOCAB`. Never sweep the corpus.
3. `.claude/plans/plan-module-kinds-tracks.md` (the plan this prepares; its carried section "plan-module-model" is the old draft, written
   with Module at the centre, and is corrected by this session) and, in the same file, the carried section "plan-k8s-kinds" (the sibling
   that consumes the kind vocabulary). Read the plan's "Decided, and why" first: it overrides the carried drafts.

## 2. Decisions in force (the user's, 2026-10-16; do not reopen)

- **Track is the root entity; Module is one of its kinds** (Q98, F2, S2). `ADR-AUTO-MODULE` sits under `ADR-DSGN-TRACK`: it cites
  `ADR-DSGN-TRACK`, `ADR-DSGN-TRACKTYPE` and `ADR-DSGN-MODTYPE` as the rules it specialises and never restates them. Its domain is
  `automation` (Q31), because `design` cannot cite `automation` by the domain order. Every deployable track has the Module kind; the
  resolver reads modules through their track.
- Tracks, track types and vendors are landed: `ADR-DSGN-TRACKTYPE` (seven rules), `VariantTrack` with places, type and vendor. Build on
  them; do not redraft them.
- **Registration is placement:** a module exists when correctly named language fragments sit in their semantic slots; the slots are one
  layout, config with sensible defaults (`ADR-AUTO-DEFAULT#6`). No registry, no descriptor.
- Two axes: language and execution engine. Languages are modelled generally and forbidden by the track's declared languages; the GO, PY and
  BASH ADRs stay unchanged and those remain test-artifact languages (Q27). Engines are declared per track with a per-module override (Q28).
  A track has one primary language by default (Q35).
- The resolver is `Get-CatzcModule`, a new name; `Get-BaseModule` and `Get-AutomationModules` go (Q29). `LoadedModule` is one rule of
  `ADR-AUTO-MODULE` (Q30). The layout lives under each language in `languages.yml` (Q32). An unplaced file inside a module folder is a
  finding (Q33). Every vendored file lives in the vendor track (Q34); `node_modules` compares to `.vendor` (C1).
- Sequencing: this plan lands first, while the folder is still `automation`; new code takes the track from the one resolver and never spells
  a track root, so the later rename to `pwsh` stays a data edit (layers Q8). Every config key it adds declares its default once on the type
  (plan-config-defaults); where both plans touch `VariantsConfig.cs` or `VariantTrack.cs`, this plan owns the file.
- Look first at the three `Get-ModuleProtectionIdentity` failures in ModuleSystem (Q37). The `Test-ShippedTypes` flags on `TrackTypeEntry`
  and `VendorEntry` are this work's (Q88). The Kubernetes namespace is planned after kinds land (Q36).
- One living version: no shims, no aliases, no old shape kept beside the new.

## 3. Do (in order; each result goes to a file in `out/`, not to chat)

1. **Caller inventory** (`out/module-model-callers.md`): grep every use of `Get-BaseModule`, `Get-AutomationModules`, `Get-PathModule`,
   `Get-ModuleTestOrder`, `Get-ModuleDependencyMap`, `Get-ModuleDependencyClosure`, `Get-ModuleProfile`, `DiskModule`, `BaseModule`,
   `SessionModule`, and the six `Kind` values, with file and line and a one-word role (def, caller, test, doc).
2. **Read the unread code** the plan depends on and record what each does in 3 to 6 lines (`out/module-model-reading.md`): `Build-Modules`
   and the merge, `Get-ModuleGlobSet`, `Get-AutomationModules`, `New-DynamicManifest`, `Test-Automation`'s order use, `AspectPartition`,
   `VariantAspect`, `VariantTrack`, `Get-Track`, `FileLanguage`, `LanguagesConfig`, `Get-ModuleProfile`, `Get-PathModule`, the module-types
   registry.
3. **Slot table** (`out/module-model-slots.md`): every placement rule the repo applies today, from `New-DynamicManifest`, `Get-PathModule`,
   `variants.yml` aspects and `file-kinds.yml`; list where the copies disagree. Include the `.internal/*.psm1` file module and
   `infrastructure/modules/*.bicep` and `templates/`.
4. **Layering proof** (`out/module-model-layering.md`): from `dependencies.yml` groups and modules, state whether `Catzc.Base.ModuleSystem`
   may take `Catzc.Base.Engines`, `Catzc.Base.Languages` and `Catzc.Base.Variants` as dependencies with no cycle, naming the path of any
   cycle. If it would cycle, propose the lowest module that sees all three.
5. **The three protection-identity failures** (`out/module-model-protection-identity.md`): run the test file in the background, quote the
   failures, say whether they belong to this work.
6. **Draft the ADR** (`out/draft-adr-auto-module.md`) following `docs/adr/index.md` authoring conventions (rules registry first, present
   tense, no history, plain language, padded headings, links per `ADR-REPO-LINK`): the seven rules of the plan's section 4, restated under
   `ADR-DSGN-TRACK` (Module as a kind of a deployable track, resolved through its track), plus the glossary entry text, the
   `dora-explains.md` entry and the `adrs.yml` entry. Do not place it in `docs/` yet.
7. **Update the plan** `.claude/plans/plan-module-kinds-tracks.md`: answer each open question of the carried module-model section with a
   recommendation grounded in what you read, mark each **unverified** item verified or still open, and correct any claim the reading
   disproved. State corrections in a short list at the top of the carried section.

## 4. Done when

All seven files exist; the plan has no unverified item that steps 1 to 5 could settle; neither the ADR draft nor the plan says Module is the
central concern, and the draft says `ADR-AUTO-MODULE` sits under `ADR-DSGN-TRACK`; a three-line summary lists the open choices that only the
user can make. Do not start implementation. Tell the user the next prompt is `.claude/plans/prompt-module-model-2-implement.md`.
