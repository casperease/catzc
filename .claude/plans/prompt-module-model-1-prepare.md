# out/prompt-module-model-1-prepare.md

`Prompt 1 of 2 for out/plan-module-model.md: close the missing work, read-only, and draft the ADR — paste as the first message of a fresh session`

Written 2026-10-16. Named `prompt-*`; copy it and the two plans into your scratchpad first (another session wiped `out/` once).
Everything below the rule is the prompt.

---

You are preparing the Module-model work in `C:\projects\catzc` (PowerShell 7.4+ module system, "cats"). This session is **read-only on
the code and docs trees**: it writes only under `out/`. Nothing is committed; the user commits.

## 1. Read first

1. `.claude/CLAUDE.md` in full: one-file-at-a-time editing, the time safeguard (every Bash call `timeout: 3000`; longer work
   `run_in_background: true` with a `timeout <s>` prefix around one command, at most 360 s, no `cd … &&`, pipes or `;` there), no mutating
   git, plans in `out/plan-*.md`.
2. `docs/adr/index.md`, then in full: `ADR-DSGN-TRACK` (`design/tracks.md`), `ADR-DSGN-ASPECT` (`design/module-aspects.md`), `ADR-AUTO-DEPM`
   (`automation/controlling-module-dependencies.md`), `ADR-AUTO-ENGINE` (`automation/execution-engines.md`), `ADR-AUTO-BUNDLE`
   (`automation/platform-bundle.md`), `ADR-PWSH-MANIFEST` (`pwsh/dynamic-module-manifests.md`), `ADR-AUTO-TYPES` (`automation/BCL/native-csharp-types.md`),
   `ADR-AUTO-DEFAULT`, `ADR-AUTO-ZERO`, `ADR-AUTO-EXTEND`, `ADR-PRIN-CONFIG`, `ADR-PRIN-ONELIVE`, `ADR-REPO-VOCAB`. Never sweep the corpus.
3. `out/plan-module-model.md` (the plan this prepares) and `out/plan-k8s-kinds.md` (the sibling that consumes `Module`).

## 2. Decisions in force (the user's, 2026-10-16; do not reopen)

- Module is the central concern of the repo: one generic C# definition, backed by one ADR, `ADR-AUTO-MODULE`, in `docs/adr/automation/`.
- **Registration is placement:** a module exists when correctly named language fragments sit in their semantic slots; slots are one layout,
  config with sensible defaults (`ADR-AUTO-DEFAULT#6`). No registry, no descriptor.
- Two axes: language and execution engine. Operations (build, QC, test, bundle) are handlers resolved from config by (track, language).
- Module is a kind inside tracks (no `modules` track); the same definition serves `automation` and `infrastructure`.
- Go, Python and Bash stay test artifacts (`ADR-AUTO-GO/PY/BASH`); model them as languages of the tests aspect.

## 3. Do (in order; each result goes to a file in `out/`, not to chat)

1. **Caller inventory** (`out/module-model-callers.md`): grep every use of `Get-BaseModule`, `Get-AutomationModules`, `Get-PathModule`,
   `Get-ModuleTestOrder`, `Get-ModuleDependencyMap`, `Get-ModuleDependencyClosure`, `Get-ModuleProfile`, `DiskModule`, `BaseModule`,
   `SessionModule`, and the six `Kind` values, with file and line and a one-word role (def, caller, test, doc).
2. **Read the unread code** the plan depends on and record what each does in 3 to 6 lines (`out/module-model-reading.md`): `Build-Modules`
   and the merge, `Get-ModuleGlobSet`, `Get-AutomationModules`, `New-DynamicManifest`, `Test-Automation`'s order use, `AspectPartition`,
   `VariantAspect`, `VariantTrack`, `FileLanguage`, `LanguagesConfig`, `Get-ModuleProfile`.
3. **Slot table** (`out/module-model-slots.md`): every placement rule the repo applies today, from `New-DynamicManifest`, `Get-PathModule`,
   `variants.yml` aspects and `file-kinds.yml`; list where the copies disagree. Include the `.internal/*.psm1` file module and
   `infrastructure/modules/*.bicep` and `templates/`.
4. **Layering proof** (`out/module-model-layering.md`): from `dependencies.yml` groups and modules, state whether `Catzc.Base.ModuleSystem`
   may take `Catzc.Base.Engines`, `Catzc.Base.Languages` and `Catzc.Base.Variants` as dependencies with no cycle, naming the path of any
   cycle. If it would cycle, propose the lowest module that sees all three.
5. **Draft the ADR** (`out/draft-adr-auto-module.md`) following `docs/adr/index.md` authoring conventions (rules registry first, present
   tense, no history, plain language, padded headings, links per `ADR-REPO-LINK`), the seven rules in the plan section 4, plus the
   glossary entry text and the `adrs.yml` entry. Do not place it in `docs/` yet.
6. **Update the plan** `out/plan-module-model.md`: answer each open question Q-A to Q-G with a recommendation grounded in what you read,
   mark each **unverified** item verified or still open, and correct any claim the reading disproved. State corrections in a short list at
   the top.

## 4. Done when

All six files exist; the plan has no unverified item left that step 1 to 4 could settle; a three-line summary lists the open choices that
only the user can make. Do not start implementation. Tell the user the next prompt is `out/prompt-module-model-2-implement.md`.
