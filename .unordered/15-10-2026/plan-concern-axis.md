# out/plan-concern-axis.md

`Plan — the stack × concern grid`

## Goal

Each slide's minimap shows two grids:

- **Where the files are:** tracks × file languages. This is the world map, `Get-WorldMapHighlight`, done in P7.
- **Where the ADR sits in the value chain:** stack × concern. It replaces the old heuristic grid, whose columns were LOAD · CONFIG · GLOBS ·
  BUILD · DEPLOY · ACCESS.

## User decisions (2026-10-14)

| #   | Decision                                                                                                                                                        |
| --- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| U1  | **The columns** stay six. LOAD, CONFIG and GLOBS all belong in **automation**; **quality control** and **release** are added.                                   |
| U2  | **Both grids** go on every slide: tracks × file languages (the files) and stack × concern (the value chain).                                                    |
| U3  | **Each ADR declares its concern.** A ruleset's concern(s) are declared in `adrs.yml`, so there is no guessing; a gate fails when an ADR resolves to no concern. |

## Proposal (coordinator; the user reviews)

- **The columns, in value-chain order:** `automation` · `build` · `quality-control` · `release` · `deploy` · `access`.
- **The rows (stack):** the old five, PRIN · DSGN · AUTO · PIPE · CLOUD. Each ADR domain declares its row once in `adrs.yml`:
  - thesis, principles, process and research → PRIN;
  - design and flow → DSGN;
  - automation, configuration and repository → AUTO;
  - pipelines and github → PIPE;
  - azure → CLOUD.
- **Declared once, with a default** (ADR-AUTO-DEFAULT#6): a domain declares a default `concern`, and a ruleset overrides it only when it
  differs. That keeps the 147 rulesets from each needing a hand entry.
- **Terms first** (D6 and ADR-DSGN-TRACK#13): `concern`, plus each column name the grid prints, and `stack` if it is not already a term.
  Each gets a defining ADR rule and a glossary entry before the grid prints them. Check the glossary for collisions; "concern" may already
  be taken.
- **Query surface:** `Get-AdrConcern` (or an extension of `Get-WorldMapHighlight`) returns each ADR's stack row and concern cells, with
  `-AsJson`. `Test-WorldMap` (or a sibling gate) fails on an ADR with no concern, or on an unknown concern or row.
- **Render:** `_flowB/highlights.ps1` exports the concern cells too, and `render.py` draws the stack × concern grid beside the tracks ×
  file-languages grid, with the same palette and lit-cell styling and the #E6ECF2 background.

## Phases

| Phase  | Owns                                                                                                                                                                                                                                                                                               | Done when                                                                                                    |
| ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **K1** | Terms and rules: the defining rules for concern, the columns and stack, the glossary entries, and the `adrs.yml` schema (domain `stack` plus `concern`, ruleset `concern` override) in its type. It also proposes each domain's default and the ruleset overrides, as a review table for the user. | Test-Glossary, Test-AdrRegistry, Test-GeneratedFiles, the type tests; the review table is in this plan       |
| **K2** | The query function and the gate                                                                                                                                                                                                                                                                    | L0 + L1 tests; the gate reports 0 on the real registry                                                       |
| **K3** | The minimap render of both grids, the re-render and re-join                                                                                                                                                                                                                                        | 176 minimaps checked by eye; background check; each minimap's sister `.md` gains its stack × concern section |

## K1 review table

**Terms (ADR-DSGN-TRACK#14–#16, glossary source `Catzc.Base.ModuleSystem`).** Bare "concern" and "stack" are taken inside the very ADR that
holds the world map: ADR-DSGN-TRACK#1 defines a track as a "repository root concern", and ADR-DSGN-TRACK#3 bolds a track's **tech-stack**
(and "stack violation" is a term). So the defined terms are qualified: **value-chain stack** (the rows), **value-chain concern** (a column),
and **value-chain map** (the grid). The YAML keys stay `stack:` and `concern:`. The six column names (and the five row names) are not
separate glossary terms. They are the members of the closed set the defining rule enumerates, the same way ADR-DSGN-TRACK#13 treats the
world map's track and file-language names. Separate terms named `automation`, `build`, `release`, or `deploy` would collide with the
automation track, the automation ADR domain, the build run mode, the DEPLOY pipeline type, and the release gate.

**Schema.** `concern:` is always a list, `[build]`, on both the domain and the ruleset, so it has one shape. `AdrsConfig.Stacks` and
`AdrsConfig.Concerns` declare the allowed values once, in order. Domain and ruleset keys are closed, so a misspelled `concerns:` fails
instead of silently falling back to the default.

**Domain defaults (in `adrs.yml`).**

| Domain        | stack | default concern                         |
| ------------- | ----- | --------------------------------------- |
| thesis        | PRIN  | all six                                 |
| principles    | PRIN  | all six                                 |
| process       | PRIN  | all six                                 |
| research      | PRIN  | all six                                 |
| design        | DSGN  | automation                              |
| flow          | DSGN  | build, quality-control, release, deploy |
| automation    | AUTO  | automation                              |
| configuration | AUTO  | automation                              |
| repository    | AUTO  | automation                              |
| pipelines     | PIPE  | build, quality-control, release, deploy |
| github        | PIPE  | build, release                          |
| azure         | CLOUD | deploy                                  |

**Ruleset overrides (applied in `adrs.yml`; review each).**

| ADR                   | concern                                 | Reason (title / lede)                                                      |
| --------------------- | --------------------------------------- | -------------------------------------------------------------------------- |
| `ADR-PRIN-CONFIG`     | automation                              | One mechanism per kind and one config entry per instance: configuration.   |
| `ADR-PRIN-POKAYOKE`   | quality-control                         | Make mistakes impossible: error-proofing is quality control.               |
| `ADR-PRIN-ONELIVE`    | release                                 | No back-compat, history in git: one version, and versions only at release. |
| `ADR-PROC-ANDON`      | quality-control                         | A failing quality gate stops the flow until it is green.                   |
| `ADR-PROC-BUILTIN`    | quality-control                         | Build quality in; you cannot inspect it in at the end.                     |
| `ADR-DSGN-THINPLAT`   | automation, deploy                      | A CLI over the vendor; Bicep deploys through az.                           |
| `ADR-DSGN-SELFSERV`   | deploy, access                          | Consumers provision and change managed infrastructure themselves.          |
| `ADR-DSGN-VISUAL`     | quality-control, release, deploy        | The promotion diagrams: commit colours run from BVT to production.         |
| `ADR-DSGN-LIFE`       | quality-control, release, deploy        | The promotion ladder: verified rungs, the RC and RBC gates, production.    |
| `ADR-DSGN-REMOTE`     | build, quality-control                  | Verified integration and PR ingress on the audited remote.                 |
| `ADR-DSGN-RUNMODE`    | automation, build                       | Source mode (loading) and build mode (the merged package).                 |
| `ADR-DSGN-ASPECT`     | automation, build                       | The live/tests partition is what the builder reads to ship.                |
| `ADR-FLOW-CD-RUNNER`  | automation                              | How pipelines invoke automation: the runner.                               |
| `ADR-FLOW-CD-DETECT`  | automation                              | How functions detect their execution context.                              |
| `ADR-FLOW-CD-GLOBS`   | automation                              | Globsets (U1: GLOBS belongs in automation).                                |
| `ADR-AUTO-TEST`       | quality-control                         | Logic tests vs integrity tests.                                            |
| `ADR-AUTO-PESTER`     | quality-control                         | The Pester language rules over test automation.                            |
| `ADR-AUTO-GO`         | quality-control                         | Go black-box tests, never shipped.                                         |
| `ADR-AUTO-PY`         | quality-control                         | Python black-box tests, never shipped.                                     |
| `ADR-AUTO-BASH`       | quality-control                         | Bash black-box tests.                                                      |
| `ADR-AUTO-PSFORMAT`   | quality-control                         | The PowerShell rules over uniform formatting, enforced by Format-Code.     |
| `ADR-AUTO-BUNDLE`     | build, release                          | The merged, versioned, installable build.                                  |
| `ADR-AUTO-TYPES`      | automation, build                       | One combined, compiled assembly loaded by the importer.                    |
| `ADR-AUTO-ASSETDEP`   | automation, build                       | Assets located through one helper and tested in both run modes.            |
| `ADR-AZ-SESSION`      | access                                  | Az CLI session verification: verify is not connect.                        |
| `ADR-AUTO-AZCLI`      | deploy, access                          | The az CLI is the vendor call path for deployments and sessions.           |
| `ADR-PIPE-AUTH`       | access                                  | Pipeline system token vs local Az token.                                   |
| `ADR-AZ-DATAMOD`      | deploy, access                          | The identity data model: tenants, environments, subscriptions.             |
| `ADR-REPO-FORMAT`     | quality-control                         | One mechanical formatting standard, checked.                               |
| `ADR-REPO-CONTRACT`   | release                                 | Contracts at the boundary, versioned with their unit.                      |
| `ADR-REPO-VOCAB`      | quality-control                         | Controlled vocabulary, checked by Test-Glossary.                           |
| `ADR-DORA-AIDATA`     | access                                  | AI-accessible internal data.                                               |
| `ADR-DORA-PLATFORM`   | automation                              | Platform engineering.                                                      |
| `ADR-DORA-VCS`        | automation                              | Version control: the repository the tooling reads.                         |
| `ADR-DORA-MAINTAIN`   | automation, build                       | Code maintainability: finding, reusing, and changing code.                 |
| `ADR-DORA-CD`         | build, quality-control, release, deploy | Continuous delivery covers the whole delivery flow.                        |
| `ADR-DORA-CI`         | build, quality-control                  | Continuous integration: integrate, build, and verify.                      |
| `ADR-DORA-DBCHANGE`   | deploy                                  | Database change management ships with the deployment.                      |
| `ADR-DORA-DEPLOY`     | deploy                                  | Deployment automation.                                                     |
| `ADR-DORA-FLEXINFRA`  | deploy                                  | Flexible (cloud) infrastructure.                                           |
| `ADR-DORA-OBSERV`     | access                                  | Monitoring and observability of what runs.                                 |
| `ADR-DORA-APPROVAL`   | release                                 | Streamlining change approval.                                              |
| `ADR-DORA-TESTAUTO`   | quality-control                         | Test automation.                                                           |
| `ADR-DORA-TESTDATA`   | quality-control                         | Test data management.                                                      |
| `ADR-DORA-TRUNK`      | build                                   | Trunk-based development: integrate into the trunk.                         |
| `ADR-DORA-FEEDBACK`   | access                                  | Customer feedback from what runs.                                          |
| `ADR-DORA-MONITOR`    | access                                  | Monitoring systems.                                                        |
| `ADR-DORA-FAILALERT`  | access                                  | Proactive failure notification.                                            |
| `ADR-DORA-TOOLCHOICE` | automation                              | Teams empowered to choose their tools.                                     |

**Judgement calls for the user.** Should the PRIN-row domains (thesis, principles, process, research) light the whole row by default, or
should they get a narrower default? The DORA culture capabilities (culture, well-being, leadership, and similar) keep the whole row.
`ADR-DORA-DOCS` and `ADR-DORA-SECURITY` keep all six, because both are pervasive. `ADR-AUTO-SPELL`, `ADR-REPO-LINK`, and the generated-file
ADRs (`ADR-REPO-README`, `ADR-REPO-ROOTCFG`) keep `automation`, though quality-control or build are arguable.

## Open

- Do the wave-7 and `docs/.assets/explanation` slides re-render after K3? (catzc-8d's area)

## Hold (2026-10-14)

catzc-27 owns `adrs.yml` for the ADR-PWSH split (P3–P5, likely a few hours). It adds a `pwsh` domain (`stack: AUTO, concern: [automation]`),
moves rulesets with their overrides, and moves AZCLI and AZ-SESSION to azure. Every change to the concern values, including the user's
answers to the judgement calls, waits until catzc-27 says adrs.yml is quiet.

## User answers to the K1 judgement calls (2026-10-15)

- **The PRIN row:** "thesis can be in with principles really". Thesis stays on the PRIN row with principles, as it already is, and the PRIN
  domains keep all six concerns.
- **ADR-DORA-DOCS and ADR-DORA-SECURITY:** keep all six concerns.
- **ADR-AUTO-SPELL (its code after the split) and ADR-REPO-LINK** move to `concern: [quality-control]`. ADR-REPO-README and ADR-REPO-ROOTCFG
  stay `automation`. The adrs.yml edit is **queued** until catzc-27 releases the file after P5 (catzc-27 has been told).
- **Glossary:** the 7 issues from the split were handed to catzc-27. The 2 "lowest layer" wordings were already fixed by another session.
- **Update:** catzc-27 applied the move in adrs.yml (`spell-out-names` and `markdown-links` → `[quality-control]`), so it is no longer
  queued. ADR-PWSH-NAMES, the identifier-naming half of the split, stays `automation`. It is an authoring convention, not a check.

## K2 and K3 done (2026-10-15)

- **K2:** `Get-ValueChainMap` and `Get-ValueChainHighlight` (both with `-AsJson`) and the `Test-ValueChainMap` gate are built. On the real
  repo the gate reports 0 issues (152 ADRs, 23 non-empty cells), and the 183 Maps tests pass. ADR-DSGN-TRACK#10/#12 are widened, so "cell"
  and "lit cell" cover both maps; the glossary entries match, and manual-test-plan rows 20–22 are added. The Maps reference article gains
  responsibility:4, the value-chain map.
- **K3:** each slide's sidebar shows three minimaps, the grid, the tree and the chain (the value-chain map), each with a sister `.md`: 264
  PNGs, all 88 slides re-joined, and every PNG keeps the #E6ECF2 background. Link, markdownlint and spelling checks report 0 on samples. I
  checked one slide by eye: the chain lights DSGN × automation and deploy, AUTO × automation, and CLOUD × deploy and access.
- **Open:**
  - the wave-7 slides' map key overlaps the chain minimap (catzc-8d);
  - the lens XMLs under `out/diagrams/lenses/` still print pre-split codes such as ADR-AUTO-AZCLI in their slide text;
  - on the grid minimap, the upright "Unlisted files" column name sits tight against "yaml".

## K4: the wave against the committed slides (user, 2026-10-15)

The user asked to run the wave against the real artifacts we will commit: the 88 slides in `docs/.assets/explanation/` (`*.drawio.png`, each
with catzc-8d's `.drawio.md`), not only the out/ copies.

- **Tooling moves out of `out/`:** `highlights.ps1`, `render.py`, `describe.py` and the join step go to checked-in tooling under
  `.claude/drawio/` (next to `drawio_png.py`). Their output target is `docs/.assets/explanation/`.
- **Per slide:** the three minimap PNGs (grid, tree, chain) and their sister `.md` files sit beside the slide. The slide's sidebar is
  re-joined with the three minimaps, and the map key moves below them.
- **Gates for the committed files:** Test-Links (tracked targets only), Test-Glossary (allowed phrasings), Test-Spelling, Test-Markdownlint,
  Format-Code on the `.md` files, and the folder conventions (binaries only in `docs/.assets`).
- **Waiting on catzc-8d (owner):** whether docs/.assets/explanation and docs/explanation are free, and agreement to move the wave-7 map key.
- **User requirement, relayed by catzc-8d (2026-10-15):** "make sure all placement on minimap are correctly reasoned for in the sister
  markdown document that is also checked in". Every lit cell or group carries its reason: what lit it, the placement steps with their rules
  (ADR-DSGN-TRACK#1/#6/#7/#8, or #12/#14/#15 plus default vs override), and how the file or ADR was selected (the cited code, the basis,
  file:line). The mapping is one-to-one between lit cells and reasons, a run fails on a mismatch, and touched-only cells are marked. If the
  highlight can't explain a placement, the highlight is extended rather than the placement drawn.

## K4 done (2026-10-15)

- **Tooling:** in `.claude/drawio/minimaps/` (`highlights.ps1`, `render.py`, `describe.py`, `join.py`); the target folder is a parameter,
  defaulting to `docs/.assets/explanation`. STYLE.md is rewritten to match.
- **Slides:** all 88 committed slides are re-joined. Each has `<stem>.{grid,tree,chain}.png` plus a sister `.md` giving every lit cell or
  group its reason. A run fails on a lit cell without a reason or a reason without a lit cell. 31 cells are touched-only (passing mentions).
- **Reasons come from Catzc.Base.Maps:** `CitationSite`, `HighlightReason` and `ValueChainReason`; `HighlightedCell.Reasons` and `.Touched`.
  `Get-WorldMapHighlight` now uses `Get-GitChangedPath` (the ONELIVE dedupe with catzc-e3); the old helper and manual-test-plan row 16 are
  gone.
- **Shared lines:** `variants.yml` adds `powershell` to the `.claude` track (for `highlights.ps1`), and `minimaps` is added to
  terminology.yml (another session added `minimap`).
- **Gates:** on all 264 sister `.md` files, Format-Code, Test-Links, Test-Markdownlint, Test-MarkdownTitle and Test-Spelling all report 0,
  as do Test-CheckedInBinaries, Test-WorldMap, Test-ShippedConfigs and Test-GeneratedFiles. The background check passes 353/353.
- **Handed to catzc-8d:** `out/diagrams/k4-sidebar-facts.json`, for rewriting the `.drawio.md` Sidebar sections, the three-maps update to
  `docs/explanation/index.md`, and the gallery rebuild.

## K5: minimap redesign (user-approved, relayed by catzc-8d, 2026-10-15)

"Drop the density shading from the slide minimaps altogether…" The changes:

- every cell is an idle grey outlined box, zeros included;
- one lit encoding across the grid, chain and tree, with touched-only as a lighter variant of it;
- short horizontal labels in one casing;
- the axis titles move to the key and the sister `.md`;
- the sister `.md` explains idle cells once.

The lit colour comes from STYLE's palette, and the MapsPalette default follows it, so the PDFs and minimaps match. Density stays only on the
full value-chain map. When done, the refreshed `k4-sidebar-facts.json` goes to catzc-8d, who is holding the Sidebar rewrite, the index
update and the gallery until then.

## K5 and K6 done (2026-10-15)

- **K5 (the user-approved redesign):** no density shading on any minimap; idle grey boxes everywhere; one lit encoding, ink #37474F, with
  40% for passing mentions and a white rim on a lit ADR file. `MapsPalette.DefaultHighlight` follows it, so the PDFs match. Labels are short
  and horizontal; the value-chain column codes LOCAL, BUILD, QC, RELEASE, DEPLOY and ACCESS, with LOCAL and RELEASE registered as
  abbreviations. Axis titles live in the map key and in each sister `.md`'s "Key" section. Every check reports 0; I checked the user's
  example slide by eye.
- **K6:** `MapsHighlight.citation_exclude`, default `[docs/.assets/**]`, keeps the generated slide descriptions from lighting minimaps, so a
  minimap no longer describes its own description. docs × markdown lit files went from 7,099 to 2,801, and no cell went dark. 21/21 Maps
  test files pass.
- The refreshed facts file was sent to catzc-8d (Sidebar rewrite, index, gallery).
- **Later:** a full value-chain map view that shows density (the slide minimaps no longer do).

## K7 and the adr-file fix (2026-10-15)

- **K7, the user's option B:** the minimaps light repo-wide citations. `citation_exclude` defaults to
  `[docs/.assets/**, docs/explanation/**, .claude/drawio/**]`. Lit files went from 6,892 to 6,149, and 13 cells went dark (the drawing
  tooling). Every gate reports 0 on the 264 sister `.md` files.
- **The adr-file bug, reported by catzc-8d:** an ADR code lit every ADR file in its domain (2,004 of 6,149 placements, 33%). It now lights
  only its own file: 134 placements. I verified one file per (slide, code), each the code's own. The import broke briefly mid-fix
  (MapPlacement.Domain) and was restored. The corrected facts went to catzc-8d.
