# .unordered/15-10-2026/plan-diagram-wave-9.md

`Plan: diagram wave 9 — slides drawn from the source code, landed beside the module reference articles`

**Status 2026-10-15: landed.** D1–D9 taken as recommended. All 11 slides are in
`docs/.assets/references/automation/<module-kebab>/` with `.drawio.md` and `.drawio.verify.md`, embedded in 10 module reference articles.
#6 and #7 had one change pass each. No ADR links (references point code → ADR). Drift items B34–B39, C8, D12–D13 are in
`plan-adr-code-drift.md`. The backlog below is the next wave.

## Goal

Draw a wave of slides whose boxes and arrows come from the actual source code: modules, public and private functions, `configs/*.yml`, C#
types, and the call sites between them. Every box is a name that exists in `automation/`, and every arrow is backed by a call site
(`file:line`). Each slide lands as `docs/.assets/<subfolder>/<stem>.drawio.png` with its `<stem>.drawio.md` description. The Markdown that
should show it embeds or links it: mainly the module reference articles in `docs/references/automation/`, none of which embeds a diagram
today. Nothing is drawn until the user approves this plan. The first render is one sample slide (P1).

## What exists

- **Modules and articles.** There are 42 modules under `automation/Catzc.*` and 44 reference articles under `docs/references/automation/`
  (author's guide: `docs/references/automation/CLAUDE.md`). Each article has a `## What the module does` section, a natural place for an
  embed. The articles are copied into `automation/<Module>/README.md` by `MarkdownLinkRebaser`, which rebases relative links
  (`docs/adr/repository/generated-readmes.md:46-48`).
- **Slides.**
  - `docs/.assets/explanation/` holds the ADR-centric five-lens slides, each with a `.drawio.md` and three minimaps with sister `.md` files.
    Its articles are under `docs/explanation/`.
  - `docs/.assets/azure/` holds only `azure-name-assembly.drawio.png`, which has no `.drawio.md`.
  - `docs/.assets/commits-quality/` holds 4 slides.
- **Already drawn from ADRs.** These are excluded from this wave: the importer load sequence (`adr-auto-bundle--*`, `adr-dsgn-runmode--*`),
  `globs.yml` → consumers (20 `adr-flow-cd-globs--*` slides) and timeout resolution (`adr-auto-failfast--resolve-one-limit-in-code-order`).
- **Kit.** `.claude/drawio/` holds drawio_png.py, STYLE.md, glyphs.xml, the gallery, contact-sheet, atlas and migration scripts, and the
  minimaps. `out/diagrams/` is empty, because `out/` was wiped.
- **Kit gaps for source slides** (scout, with evidence):
  - The five lenses are fixed: STYLE.md:164-175, and `minimaps/render.py:32` (a new lens throws a KeyError at :501).
  - `code unit` is one glyph for module, function, type and script (glyphs.xml:11, STYLE.md:66). Dashed is reserved for ADR-only
    (STYLE.md:451), so it cannot mean "private".
  - drawio_png.py has these limits:
    - It offsets a child by only one parent level (:175-179).
    - It draws edges straight, centre to centre, and ignores waypoints (:233-244).
    - It has only one arrowhead (:245-246).
  - `minimaps/highlights.ps1:75-81` lights cells by `-Adr` only, although `Get-WorldMapHighlight` already has `-Path`
    (`Catzc.Base.Maps/Get-WorldMapHighlight.ps1:45-54`).
  - gallery_pdf.py pairs `<stem>.md`/`<stem>.visual.md`, not `.drawio.md` (:154-155).
  - atlas.py reads only `out/`.
  - STYLE.md contradicts itself on title length (≤ 60 at :422, ≤ 100 at :152) and on the companion names (:313-320 vs :466-477).
- **ADR-REPO-FOLDERS#5** (`docs/adr/repository/conventional-folders.md:43-45`) lets `docs/` organise its subfolders freely. It allows
  `docs/.assets/` to hold binary diagram assets, "each optionally beside its `<name>.drawio.md` description". The rule does not name minimap
  PNGs, sister `.md` files or `.drawio.verify.md`. Decision A2 of `plan-explanation-assets-source.md` (commit the verify files) is decided
  but not landed.

## Decisions for the user

1. **D1 — Where source slides land.** Recommend `docs/.assets/references/automation/<module-kebab>/<stem>.drawio.png` (+
   `<stem>.drawio.md`). This mirrors the article path `docs/references/automation/<module-kebab>.md` and keeps them apart from the
   ADR-centric `explanation/`. The ADR-REPO-COMMENTS pages live in `docs/references/automation/<module-kebab>/` (docs side), so the asset
   folder does not clash with them. The alternatives are `explanation/` (flat; it mixes two kinds) or the existing `azure/`.
2. **D2 — Slide unit.** Recommend one slide per responsibility, where each slide states one finding. A slide per module would be a box dump:
   QualityGates alone has 43 public and 120 private functions. A module gets 0–2 slides in this wave.
3. **D3 — A new `source` lens and glyph phrases.** Recommend yes, minimal. The changes:
   - Add a `source` lens to STYLE.md with a box cap of 10, and a `SRC` badge in `render.py` LENS_BADGE.
   - Use the subtitle `Module <Name> · source lens`. Supports chips name the ADRs the module's code cites.
   - Add three glyph phrases inside the 4-kind budget, put in glyphs.xml and STYLE.md before makers start:
     - private helper: a code unit with a thinner, lighter rim (not dashed)
     - C# type: a code unit with a type marker
     - other catzc module: a frame or band, distinct from `external tool`
   - `file` stays the glyph for YAML.
4. **D4 — Minimaps on source slides.** Recommend none in this wave. The chain minimap is lit by ADR only, and its layout is being rebuilt by
   plan B. Grid and tree would need a `paths` field in highlights.ps1. Decide again after the sample. Wiring `-Path` is a small P0 add-on if
   the user wants grid/tree.
5. **D5 — Words for each slide.** Recommend the `.drawio.md` asset description (At a glance, Reading path, Glyphs, Edges with one call-site
   `file:line` per edge, Legend, and "Where the code and the ADR differ"). Add a short paragraph and the embed in the module reference
   article under `## What the module does`, and no new `docs/explanation/` article. That keeps the reference article responsibilities-first
   and the slide symbol-only (wave 5 format).
6. **D6 — Build `plan-explanation-assets-source` first?** Recommend no for its steps A.2–A.7 and B: they serve the ADR lens slides. Yes for
   one piece: the ADR-REPO-FOLDERS#5 amendment, so it names every companion (`.drawio.md`, minimap PNG + sister `.md`, `.drawio.verify.md`).
   Then commit this wave's verify files as `<stem>.drawio.verify.md` (A2), which makes the claims rebuildable.
7. **D7 — Renderer nesting fix.** Recommend fixing drawio_png.py:175-179 in P0 so it walks every parent level, which is a small edit. Then
   module ▸ folder ▸ function groups preview correctly. Elbow routing stays out, because port cells (STYLE.md:517-523) cover it.
8. **D8 — Drawing drift.** Recommend that the slide draws the code as it is. Each ADR claim the code contradicts goes into "Where the code
   and the ADR differ" and into `plan-adr-code-drift.md`; it is never fixed silently. The scouts found three (listed below).
9. **D9 — Title length.** Recommend ≤ 60 characters (STYLE.md:422), and fixing STYLE.md:152 to match in P0. Also fix the companion-name
   table at :313-320.

## Candidates

The first make wave takes ranks 1–11, and the backlog follows below. Folders follow D1 (`<A>` = `docs/.assets/references/automation`).
"Embed" is the reference article that shows the slide; "Link" is the ADR or how-to that gets a one-line link.

| #   | Stem                                      | Target asset                                                                  | Finding the title states                                                                                                                                    | Drawn from (file:line)                                                                                                                                                                                                                                                                                                                           | Embed / Link                                                                                                                      | Verify plan                                                                                                           |
| --- | ----------------------------------------- | ----------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| 1   | `test-automation-one-run-pipeline`        | `<A>/catzc-base-qualitygates/test-automation-one-run-pipeline.drawio.png`     | Test-Automation discovers once, splits into three phases, drops protected modules, and a finally always stamps run.json                                     | `Test-Automation.ps1:187`; `private/Invoke-TestRun.ps1:106,117,120,178,186,199,210,233,245,266-271,289,326-332`                                                                                                                                                                                                                                  | Embed `catzc-base-qualitygates.md`; link `docs/adr/automation/test-automation.md`                                                 | Grep each called name in `Invoke-TestRun.ps1`; the phase names come from `Split-TestAutomationFiles`                  |
| 2   | `bicep-deploy-one-immutable-context`      | `<A>/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.png`     | Deploy-Bicep works on one immutable context (plan + artifacts + environment), resolved from the live az session against azure.yml                           | `Deploy-Bicep.ps1:98,169,220,242`; `Get-BicepDeploymentContext.ps1:104,128,129,155,169,187,194`                                                                                                                                                                                                                                                  | Embed `catzc-azure-templates.md`; link `docs/adr/azure/az-session-verification.md`, `azure-data-model.md`                         | Grep the `::new` sites; `class Bicep*` in `types/*.cs`                                                                |
| 3   | `tools-yml-install-dispatch`              | `<A>/catzc-tooling-provisioning/tools-yml-install-dispatch.drawio.png`        | tools.yml is the only list of tools: Install-DevBoxTools walks it in depends_on order and dispatches by name to `Install-<TitleCaseKey>`                    | `Install-DevBoxTools.ps1:28,40,41,63,81-91`; `Get-ToolCommandSuffix.ps1:23-24`; `Get-ToolInstallOrder.ps1:16,23`; `Get-ToolConfig.ps1:15,21`; `Get-ToolsStatus.ps1:125`                                                                                                                                                                          | Embed `catzc-tooling-provisioning.md`; link `catzc-tooling-core.md`, `docs/adr/automation/controlling-systemwide-deps.md`         | Glob `automation/Catzc.Tooling.*/Install-*.ps1` against the tools.yml keys; draw only the dispatch targets that exist |
| 4   | `module-graph-declared-vs-observed`       | `<A>/catzc-base-modulesystem/module-graph-declared-vs-observed.drawio.png`    | Two graphs: the declared dependencies.yml graph orders tests and closes profiles; the AST-observed call graph is checked against it                         | `private/Get-ModuleDependencyConfig.ps1:19`; `private/Get-ModuleDependencyMap.ps1:26-27`; `Get-ModuleTestOrder.ps1:30`; `Get-ModuleProfile.ps1:50`; `Copy-Automation.ps1:87`; `Get-FunctionDependency.ps1:68`; `Test-ModuleCycles.ps1:30`; `private/Get-ModuleDependencyViolations.ps1:34-37`; QualityGates `Get-TestAutomationTestPaths.ps1:71` | Embed `catzc-base-modulesystem.md`; link `docs/adr/automation/controlling-module-dependencies.md`                                 | Grep each map/closure consumer; confirm the ordinal fallback at `Get-TestAutomationTestPaths.ps1:74`                  |
| 5   | `azure-identity-resolves-from-config`     | `<A>/catzc-azure/azure-identity-resolves-from-config.drawio.png`              | Every Azure identity resolves from azure.yml + customer.yml through Get-Config; the az session must match exactly one declared subscription                 | `Get-AzCliSessionSubscription.ps1:24,26,27-33,36`; `Get-AzureSubscription.ps1:31,40,45`; `Get-AzureEnvironment.ps1:36,42`; `Get-AzureCustomer.ps1:27`; `types/AzureConfig.cs:42`                                                                                                                                                                 | Embed `catzc-azure.md`; link `catzc-azure-cli.md`, `docs/adr/azure/azure-data-model.md`, `azure-customer-model.md`                | Confirm the 0-or-more-than-1 throw text at :27-33; check the type names in `Catzc.Azure/types/`                       |
| 6   | `invoke-executable-two-paths-one-bounded` | `<A>/catzc-base-execution/invoke-executable-two-paths-one-bounded.drawio.png` | Invoke-Executable has two paths: only the streamed CliRunner path is time-bounded; -Direct runs Invoke-Expression unbounded                                 | `Invoke-Executable.ps1:108,132-133,137,139`; `private/Invoke-ExecutableStreamed.ps1:74,77,95`; `types/CliRunner.cs:189-196`; `private/Invoke-ExecutableDirect.ps1:55-57`; Timeouts `Get-TimeoutSeconds.ps1:67-70`                                                                                                                                | Embed `catzc-base-execution.md`; link `catzc-base-timeouts.md`, `docs/adr/automation/fail-fast-with-asserts.md`                   | Read `CliRunner.cs:189-196` for Kill(entireProcessTree); this slide draws drift item 1 below                          |
| 7   | `protected-module-skip-by-hash`           | `<A>/catzc-base-globs/protected-module-skip-by-hash.drawio.png`               | A module is skipped only when its folded globset hash equals its last green run's in this session; in a pipeline never                                      | QualityGates `private/Select-ProtectedTestFile.ps1:84,86`; `private/Get-ModuleProtectionIdentity.ps1:46,57,60,74`; Globs `Get-GlobSetHash.ps1:59,66`; `Test-GlobSetProtection.ps1:43,64`; QualityGates `private/Protect-TestedModule.ps1:73`; Globs `Protect-GlobSet.ps1:60`                                                                     | Embed `catzc-base-globs.md` (link from `catzc-base-qualitygates.md`); link `docs/adr/repository/protected-globs.md`               | Grep `$script:protectedGlobSets` writers and readers; confirm `Test-IsRunningInPipeline` → false                      |
| 8   | `az-cli-test-assert-share-one-state`      | `<A>/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.png`           | Each az check is one state primitive shared by its Test- and Assert- pair, so they cannot drift; config-aware wrappers only add the azure.yml lookup        | `Test-AzCliConnected.ps1:33`; `Assert-AzCliConnected.ps1:33`; `Get-AzCliConnectionState.ps1:47,49`; `Get-AzCliSubscriptionAccessState.ps1:44`; `private/Get-AzCliBicepState.ps1:21`; `Assert-AzCliIsConnected.ps1:26,28`; `Assert-AzCliCanAccess.ps1:32-33`                                                                                      | Embed `catzc-azure-cli.md`; link `docs/adr/azure/az-session-verification.md`, `docs/adr/automation/idempotent-state-functions.md` | Three columns × four rows; every row cell must grep to a function; this slide draws drift item 2                      |
| 9   | `get-config-merge-seal-type`              | `<A>/catzc-base-config/get-config-merge-seal-type.drawio.png`                 | Get-Config resolves the name, merges an overlay fragment unless sealed, then builds the registered C# type, cached by a key that carries the fragment stamp | `Get-Config.ps1:55,62-68,77,84,86-87,92,100-101`; `private/Get-ConfigRegistry.ps1:30`; `private/Resolve-ConfigEntry.ps1:39-58`; `configs/configs.yml:14,45,54,59,72`                                                                                                                                                                             | Embed `catzc-base-config.md`; link `catzc-base-overlay.md`, `docs/adr/automation/consumer-overlay.md`                             | Diff against `adr-conf-loading--three-caches-back-one-reader`; draw only the merge, seal and type steps               |
| 10  | `bicep-template-is-a-folder`              | `<A>/catzc-azure-templates/bicep-template-is-a-folder.drawio.png`             | A template is a folder; options.yml may override five derived defaults under a strict schema; Build-Bicep emits one parameters file per slot                | `Get-BicepTemplates.ps1:56,101,143,243`; `Read-BicepTemplateOptions.ps1:52,62,69,80`; `Build-Bicep.ps1:86,106,112,134,160,166`                                                                                                                                                                                                                   | Embed `catzc-azure-templates.md`; link `docs/adr/azure/azure-data-model.md`                                                       | List the five `allowedKeys` verbatim from :52; this slide draws drift item 3                                          |
| 11  | `invoke-tool-asserts-locked-version`      | `<A>/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.png`        | Every Invoke-<Tool> asserts the locked version before it runs; Assert-Tool and Test-Tool share one probe and one version read                               | `Invoke-Terraform.ps1:34,37`; `Invoke-Dotnet.ps1:36,39`; `Assert-Tool.ps1:30,36,55`; `Test-Tool.ps1:42,56,68`; `Get-ToolVersion.ps1:25`                                                                                                                                                                                                          | Embed `catzc-tooling-core.md`; link `catzc-tooling-toolchain.md`, `docs/adr/automation/controlling-systemwide-deps.md`            | Grep `Assert-Tool` across `automation/Catzc.*/Invoke-*.ps1`; draw the count on a count chip, not every caller         |

Each maker's verify file has one row per box (Glob hit) and one row per arrow (call-site `file:line`). Rows read confirmed, contradicted or
ADR-only. An edge without a citation is not drawn. A second reader diffs the box set against `ls` of the module.

Every scout read was on 2026-10-15, so each maker re-greps every cited line before it draws.

### Drift found in passing (D8, goes to `plan-adr-code-drift.md`)

1. `docs/adr/automation/fail-fast-with-asserts.md:59` and `.claude/CLAUDE.md` say Invoke-Executable kills a process tree at its limit. The
   `-Direct` path (`Invoke-Executable.ps1:132-133` → `private/Invoke-ExecutableDirect.ps1:55-57`) has no bound. Its docstring at :58 admits
   this.
2. The comment at `Assert-AzCliConnected.ps1:7-8` says `Assert-AzCliIsConnected` delegates to it, but that calls `Get-AzCliConnectionState`
   directly (`Assert-AzCliIsConnected.ps1:28`). Its Test- twin does delegate (`Test-AzCliIsConnected.ps1:27`).
3. `docs/adr/azure/azure-data-model.md:239` labels TEMPLATE_OPTIONS "short_name override" only. The entity (:256-261) and
   `Read-BicepTemplateOptions.ps1:52` allow five keys.

## Stale existing slides found

The scout decoded all 154 `.drawio.png` labels and their `.md` files, and checked them against `docs/adr/index.md`, every rule heading, and
the names under `automation/`.

| Asset                                                                                                                          | Stale claim                                                          | Current truth                                                                                                                                    | Kind                          | Fix                                                                                                    |
| ------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------- | ------------------------------------------------------------------------------------------------------ |
| `docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.drawio.png` (+ `.drawio.md` :27, :34, :43) | ADR-ONLY glyph `build-catzc.ps1` with chip `D1` (ADR-DSGN-RUNMODE#1) | `docs/adr/design/run-modes.md:9-11,80-85`: build mode is entered by `Import-Catzc.ps1` / `Import-Module Catzc`; no `build-catzc.ps1` anywhere    | missing script / ADR moved on | `write-drawio-files`: relabel or drop the glyph (dropping is a geometry change, so it goes to a maker) |
| same slide                                                                                                                     | ADR-ONLY glyph `Write-CatzcLoadBanner` with chip `D1`                | `run-modes.md:200` says only "printed by the load banner"; the function is planned (`plan-built-bundle.md:259`, `plan-adr-code-drift.md:32` A10) | known open drift              | Leave until A10 lands; then relabel                                                                    |

The checks were clean in three places:

- The CAF rename touches no slide (0 hits).
- The ADR-PWSH split left no stale code: all 38 cited codes resolve, and the slides already carry the ADR-PWSH codes.
- Every other drawn function, module and config file name exists.

These checks were not complete:

- YAML key names inside configs.
- Behaviour that changed while its names stayed the same.

The 12 drift slides of `plan-explanation-drift.md` Phase 3 are still true and go stale only as those items land.

Also a gap, not a stale claim: `docs/.assets/azure/azure-name-assembly.drawio.png` has no `.drawio.md`.

## Phases

- **P0 — lead prep (after the user's D-verdicts, no rendering).** This phase edits `.claude/drawio/` only with the user's approval:
  - The STYLE.md fixes (D3 lens and glyph phrases, D9 title and companion table).
  - glyphs.xml phrases, the render.py `SRC` badge, and the drawio_png.py nesting fix (D7).
  - gallery_pdf.py pairing `.drawio.md`.

  This phase also does two things outside `.claude/`:
  - Draft the ADR-REPO-FOLDERS#5 amendment (D6) for the user. A `catzc-worker` lands it, one file.
  - Write the 11 maker briefs into this plan's companion `out/plan-diagram-waves.md` (stem, finding, sketch, cited lines).

- **P1 — sample, one slide.** Candidate 1 (`test-automation-one-run-pipeline`) is built as ONE file in `out/diagrams/dark-sample/`, with its
  `.drawio.md` and verify file, and no minimaps, gallery or atlas. The lead reads the preview, and the user judges the lens, the glyph
  phrases and the words before any fan-out.
- **P2 — makers (≤ 12, one message).** Ranks 2–11, plus a rework of rank 1 if the sample needs one. Each writes only
  `out/diagrams/wave-9/<module-kebab>/<stem>.{xml,drawio.png,drawio.md,verify.md}`, with at most 3 rebuilds and a reply of 8 lines or fewer.
  The lead folds every lesson into STYLE.md as it arrives. Fan-in is one table (path, finding, claim counts, doubts), and the user gives
  verdicts (approve / change / drop). Review bundles are built only when the user asks.
- **P3 — landing and Markdown, one file at a time.** For each approved slide:
  - Copy it to `docs/.assets/references/automation/<module-kebab>/<stem>.drawio.png` with its `.drawio.md` (and `.drawio.verify.md` if D6
    lands). Never overwrite, and stop if a `.$…bkp`/`.dtmp` sibling exists.
  - Use one Edit to embed it in the reference article under `## What the module does`, with a one-paragraph lead-in.
  - Use one Edit per linked ADR or sibling article, for a one-line link in its See also / references.
  - Add the drift items to `plan-adr-code-drift.md`.

  Each file is checked before the next.

- **P4 — gates, per file.** For each touched `.md`, run markdownlint, spelling, `Test-Links` (the image link resolves from the article), the
  six per-file checks, and `Test-Glossary`. Regenerate one module README and confirm that `MarkdownLinkRebaser` rebased the image link into
  `automation/<Module>/README.md` (generated-readmes.md:46-48). The user runs the full `Test-Automation` and makes the commits.

## Rules carried over

- Symbol-only slides with the words in the `.drawio.md` (the wave 5 format). The title states the finding, not the topic.
- Words come only from the source. Box labels are exact function, type and file names that exist today. No invented numbers, parts or loops.
- Look at the actual preview before replying, and read what it plainly shows.
- Render nothing without asking. A sample is ONE file in `out/diagrams/dark-sample/`.
- Every lit minimap cell is reasoned in its sister `.md`. With D4 there are no minimaps in this wave.
- At most 12 agents in flight, launched in one message. Scouts are read-only, and makers write only their own `wave-9/` folder.
- The time safeguard is in every brief: foreground `timeout: 3000`; background `timeout <s>` around one command, with no `cd … &&`, pipes or
  `;`.
- Never edit `docs/` before an approval, never overwrite an asset, never run a mutating git command. The user commits.
- Edit one file at a time with the Edit tool, then verify it, with no batch scripts. Use "domain rules" / "ADR rules", and "cats" in prose.

## Backlog

| Stem                               | Module                     | Finding (draft)                                                                                             | Source                                                                                                                           |
| ---------------------------------- | -------------------------- | ----------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| `ado-yaml-inventory-classifies`    | Catzc.Azure.DevOps         | Every pipeline YAML is classified once by `Resolve-AdoYamlClassification` into a `YamlClassificationResult` | `Get-AdoYamlInventory.ps1:45,55`; `Get-AdoYamlFiles.ps1:103`; `Resolve-AdoYamlClassification.ps1:28-85`; `Test-Pipelines.ps1:70` |
| `azure-name-assembly` description  | Catzc.Azure                | Write the missing `.drawio.md` for the existing slide                                                       | `docs/.assets/azure/azure-name-assembly.drawio.png`; `Get-AzureResourceName`                                                     |
| Catzc.Base.Asserts slide           | Catzc.Base.Asserts (23)    | Needs a scout pass: no candidate was found with a call flow worth drawing                                   | `automation/Catzc.Base.Asserts/`                                                                                                 |
| Catzc.Base.Docs slide              | Catzc.Base.Docs (18/22/32) | Needs a scout pass: the README generation and agent-registry checks are likely candidates                   | `automation/Catzc.Base.Docs/`, `configs/{readme,agents,adrs}.yml`                                                                |
| Catzc.Base.Maps / Contracts slides | Maps (29 .cs), Contracts   | Type-heavy modules; wait for the D3 C# type phrase                                                          | `automation/Catzc.Base.Maps/types/`, `automation/Catzc.Base.Contracts/`                                                          |
| Grid/tree minimaps by path         | kit                        | Wire `paths` into `minimaps/highlights.ps1` → `Get-WorldMapHighlight -Path` (D4)                            | `highlights.ps1:17,75-81`; `Get-WorldMapHighlight.ps1:45-54`                                                                     |
| Stale slide fix                    | explanation                | `adr-auto-bundle--rule-and-gate-per-load-stage--governance`: drop or relabel `build-catzc.ps1`              | see the stale table                                                                                                              |
