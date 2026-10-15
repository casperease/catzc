# out/plan-adr-consistency.md

`Quality-control plan: inconsistencies in the ADR corpus (docs/adr/) and the rules that govern it`

Written 2026-10-15 by the QC session. Nothing in the repository was changed by this audit; every item below is either **MARK** (a decision
only the owner can make) or **DESCRIBE** (a concrete change, stated but not applied).

## Purpose and scope

Find places where the ADR corpus disagrees with itself, with `docs/adr/index.md`'s authoring conventions, with the rules the ADRs state, or
with the code and configuration the ADRs describe, and record each with its evidence, the rule it bears on, and either a decision to take or
a change to make.

## Coverage

| Surface                                       | Coverage                                                                                                                                                                                                                         |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Structure of all 192 files under `docs/adr/`  | Full mechanical scan: registry, headings, padding, links, anchors, section order, citations, names, wording                                                                                                                      |
| Read in full                                  | thesis, principles, process, design, flow, configuration, pipelines, github, repository (80 ADRs)                                                                                                                                |
| Sampled (large domains, per your instruction) | automation 4 of 35, pwsh 2 of 25, azure 2 of 24, research 1 of 34                                                                                                                                                                |
| Code and config the ADRs describe             | Every `Verb-Noun` an ADR names checked against the function inventory; embedded code copies diffed against the live files                                                                                                        |
| Rule citations across tracked files           | 2223 files; `research/`, `automation/.vendor/`, `docs/.assets/` skipped                                                                                                                                                          |
| Repository gates                              | Test-AdrRegistry, Test-AdrEngineNeutrality, Test-AnalyzerAdrMap, Test-GeneratedReadmes, Test-AgentDefinitions, Test-MarkdownTitle, Test-Links (whole repo and targeted), Test-Glossary, Test-Terminology, Build-AdrIndex -DryRun |

Every gate passed with zero issues, and the index is current. The findings below are therefore things the gates do not cover, or decisions
the conventions leave open. The sampled domains got the mechanical checks in full; a content read of the remaining ADRs there is the open
follow-up (see the end).

## Fix pass (2026-10-15)

Applied on request, one file at a time, each batch verified with `Test-Links`, `Test-MarkdownTitle`, `Format-Code` (the repository's
prettier run), and where rule text changed `Test-Glossary` and `Test-AdrRegistry`; `Build-AdrIndex` regenerated the index and README, and
the index builder's own test file passed. The helper scripts are `out/verify-adr.ps1` (per-file gates), `out/gates-final.ps1` (the full
sweep), and their logs beside them. No git command was run; everything is in the worktree for review.

**Fixed (24 files):**

- **L** — `module-aspects.md` rule 4 and body, `self-service.md` (five passages), `dynamic-module-manifests.md`, and the parity ADR's
  "committed markers" now describe the live-identity model; no "marker" or "freshness gate" remains.
- **A** — all ~45 backticked `:n` citations in ADR prose, the diagram style guide, and the four fixture comments are `#n`; rule
  ADR-REPO-LINK#5 now names the registry form as the one sanctioned `:` shape (a datum `Get-CatzcAdrRuleIds` returns). The gate widening to
  markdown code spans is **open** (a `CommentLexer`/`LinkEngine` change).
- **B** — `terminology.yml` cites `ADR-FLOW-CD-GLOBS`; `Test-Terminology` passes.
- **M** — ADR-FLOW-CD#4 and its "A CD is a CI that keeps going" section now agree with the taxonomy: a solo CI emits a verdict, the artifact
  is the CI component's output inside a CD.
- **N** — ADR-DSGN-VISUAL#4 states that pre-prod shares green and the environment box tells the two apart; rule #7's funnel names the rung.
- **P** — `run-modes.md` no longer names `Write-CatzcLoadBanner` or `build-catzc.ps1` (build mode is entered by the build's
  `Import-Catzc.ps1`; the mode is read from `Get-CatzcRunMode` and `build.json`); `conventional-folders.md` drops `.mcp.json` and adds
  `importer.sh` and `catzc.sln`. `Test-OutputFormats` is **open** (see below).
- **C** — the authoring conventions (source: `Build-AdrIndex.ps1`) state that rule numbers are stable and gaps are normal; the index and
  README carry the sentence.
- **D** — the `## Status` snapshot is deleted; the two unprefixed title lines read `ADR: …`. The template and preamble decision is **open**.
- **U** — `apex` and `foundation` illustrations in `durable-sha-globs.md` and `pipeline-naming-and-placement.md` are `contoso` and
  `discovery`; the `sample` template in the runner ADR is `discovery`. Fixture tokens in the pwsh ADRs and the discovery-as-live question
  are **open**.
- **R, S, T, O, Q, W, X, Y, E, I** — applied as described in their sections.

**Open (decisions or code changes beyond a doc fix):** A's gate widening, P's `Test-OutputFormats` (write the gate or soften rule
ADR-REPO-OUTFMT#3), D's section template, U's remaining fixture tokens and the shipped `discovery`/`expedition` templates, F (sub-indexes),
G (`ADR-PRIN-PROCESS` rename), H (`.sh`/`.py` comment lexing), Z (the orphan asset), J (the parallel-session re-wrap).

**Final sweep (`out/gates-final.log`):** Test-AdrRegistry, Test-AdrEngineNeutrality, Test-AnalyzerAdrMap, Test-GeneratedReadmes,
Test-GeneratedFiles, Test-AgentDefinitions, Test-MarkdownTitle (docs/adr), Test-Glossary, Test-Terminology all pass. Two gates report one
issue each, neither from this pass: `Test-Links` flags a bare citation at `Write-TestAutomationReport.ps1:29`, a change another session has
staged (`Format-Links` fixes it); `Test-Formatting -Language markdown` flags `docs/adr/pwsh/dora-explains.md`, an unmodified committed file
that is not prettier-stable (`Format-Code -Language markdown` fixes it).

**AA. Spelling scope declared twice (fixed).** Your editor flagged `deweuzctexpedapst`, a storage-account name assembled by the naming
convention in `infrastructure/templates/expedition/configuration/apex/dev.yml`. The repository's `Test-Spelling` never saw it because its
default `-Exclude` hardcodes `infrastructure/templates/**/configuration/**`, while the editor reads `cspell.yml`, which lacked that path:
one scope in two places, so the gate was green and the editor red for six such names. The exclusion is now declared once in the cspell
source (`automation/Catzc.Base.RootConfig/assets/root/cspell.yml`, with the ADR-AUTO-SPELL#4 and ADR-AZ-DATAMOD#6 reasons) and copied out by
`Build-RootConfig`; `Test-GeneratedFiles` and `Test-Links` pass. Follow-up to decide: drop the duplicate from `Test-Spelling`'s `-Exclude`
default so cspell.yml is the one scope. The gate's only other hits were five pre-existing `nfunction` tokens in two Overlay test files,
where a backtick-`n` escape runs into the word `function`; the strings are split at the newline so the tokens disappear.

**Side effect to review:** `.claude/drawio/STYLE.md` was already modified in your worktree; my one-token fix there also let `Format-Code`
reflow the file, so its diff now includes your pending edits, the reflow, and my change. `Test-MarkdownTitle` reports three pre-existing
heading issues in it (lines 317, 355, 394: trailing `(`<stem>…`)` groups), which `Format-MarkdownTitle` would fix.

## Verified consistent

- `adrs.yml` ↔ `index.md` ↔ files on disk ↔ `## Rules: <code>` registries: 171 of 171 agree; no duplicate codes, no orphan files.
- 1507 rule headings, all well-formed, all under their own file's code; every `#rule-…` anchor and every `ADR-<CODE>#<n>` citation resolves;
  blank-line padding has 0 violations; `## Rules:` is the first H2 everywhere.
- `dora-explains.md` covers every ADR of every non-research domain; all 34 research ADRs carry `## Dora explains`.
- Changelog wording and "iff" / "house rules": every hit is present-tense usage or the convention text itself.
- Embedded code copies that match the live code: the runner's parameter block, `Test-IsRunningInPipeline`, `Get-OutputRoot`,
  `Get-AdoAuthorizationHeader`; the release workflow is `workflow_dispatch`-only as ADR-GH-RELEASE#1 states; the tracked root folders match
  ADR-DSGN-TRACK#1 exactly; the reserved umbrella globsets are derived loose-filesets as both ADRs describe.

## Findings

| #   | Severity | Kind     | Summary                                                                                             | Rule                        |
| --- | -------- | -------- | --------------------------------------------------------------------------------------------------- | --------------------------- |
| L   | high     | MARK     | Two design ADRs still describe committed per-aspect markers; the flow ADR says nothing is committed | ADR-FLOW-CD-GLOBS#1/#5      |
| A   | medium   | MARK     | `:`-form citations survive in ~40 places of ADR prose and in live text; the link gate passes them   | ADR-REPO-LINK#5             |
| B   | medium   | DESCRIBE | `terminology.yml` cites a code that does not exist (`ADR-FLOW-CD-CI-GLOBS`)                         | ADR-REPO-LINK#6             |
| M   | medium   | MARK     | Does a solo CI pipeline produce the tagged artifact? The two flow ADRs disagree                     | ADR-FLOW-CD#4 vs TYPE       |
| N   | medium   | MARK     | The pre-prod rung has no colour in the locked palette                                               | ADR-DSGN-LIFE#1 vs VISUAL#4 |
| P   | medium   | DESCRIBE | Stale names: a banner function, a root script, a quality gate, a root file that do not exist        | ADR-REPO-LINK#4 spirit      |
| D   | low      | MARK     | Section structure, preambles and title lines are not uniform; one `## Status` snapshot              | conventions                 |
| U   | low      | MARK     | Live and fixture identities used as illustrations in design-zone ADRs                               | ADR-REPO-LANG#4             |
| C   | low      | MARK     | Rule numbers have gaps in 17 ADRs; no stated policy                                                 | conventions                 |
| R   | low      | DESCRIBE | `conventional-folders.md` disagrees with itself and with the tree in six places                     | ADR-REPO-FOLDERS            |
| S   | low      | DESCRIBE | "Three variants" versus four in the rule versus five keys in `variants.yml`                         | ADR-REPO-VARIANT            |
| T   | low      | DESCRIBE | Default test level stated as 2 in one ADR, 3 in another and in the code                             | ADR-AUTO-DEFAULT            |
| O   | low      | DESCRIBE | Commit numbers are "single-digit 0–9" in one ADR and run to 10 in another                           | ADR-DSGN-VISUAL#10/#12      |
| Q   | low      | DESCRIBE | The runner ADR's step-template parameter block omits two declared parameters                        | ADR-FLOW-CD-RUNNER          |
| W   | low      | DESCRIBE | A principles ADR deep-links dora.dev                                                                | conventions                 |
| X   | low      | DESCRIBE | "today only `catzc`" stated five times; "currently" and "today" elsewhere                           | conventions                 |
| Y   | low      | DESCRIBE | Mis-citations, dangling "the notes", one garbled rule sentence, "In ex."                            | conventions                 |
| E   | low      | DESCRIBE | `devbox-pipeline-parity.md` rule entries carry no prose links                                       | conventions                 |
| F   | low      | MARK     | Six folder sub-indexes exist, two unreachable from the index                                        | ADR-PRIN-ONELIVE            |
| G   | low      | MARK     | `ADR-PRIN-PROCESS` lives in `process/` with a principles prefix                                     | conventions                 |
| H   | low      | DESCRIBE | Comment citations in `.sh`/`.py` are not code links and are not lexed by the gate                   | ADR-REPO-LINK#3             |
| Z   | low      | MARK     | An unlinked diagram sits in `docs/adr/design/.assets/`, outside the sanctioned asset folder         | ADR-REPO-FOLDERS#5          |
| I   | low      | DESCRIBE | `.claude/CLAUDE.md` and ADR-PWSH-ENGINE#4 name different internal modules as staying loaded         | adjacent                    |
| J   | info     | MARK     | `test-automation.md` re-wrapped in the worktree during this session                                 | observation                 |
| K   | info     | —        | No `*.md` line-ending attribute: a documented decision, no action                                   | ADR-REPO-FORMAT             |

### L. Committed markers versus live identities (MARK, high)

`flow/durable-sha-globs.md` is unambiguous: the globset's identity "is computed live and is never committed" (ADR-FLOW-CD-GLOBS#5), the
three roles are "all derived and none committed per set" (#1), and "contributors carry no marker-regeneration duty" (Consequences). Two
design ADRs describe the opposite:

- `design/module-aspects.md`, ADR-DSGN-ASPECT#4: "Each aspect is an immutable sha lock, marker `<unit>-<aspect>.yml` … stored and versioned
  independently"; lines 73, 77, 84, 88 speak of markers as artifacts `Get-ModuleGlobSet` derives.
- `design/self-service.md`: lines 40 ("the freshness/marker checks"), 50 ("the markers _are_ the provenance record"), 102 ("leaves a stale
  marker"), 111 ("the provenance record is the marker set"), and ADR-DSGN-SELFSERV#3 ("provenance from source to deployed state"). No
  `freshness` gate exists in `automation/`.
- `pwsh/dynamic-module-manifests.md:50` ("excludes `assets/` for marker").

`Get-ModuleGlobSet` and `globs.yml` implement the live model. Decision: rewrite ASPECT#4 and the self-service passages to the live-identity
model (aspects as derived, overlap-free globsets whose identity is `Get-GlobSetHash`; provenance as `build.json` and the git history), or
state that markers are a planned return. Recommended: rewrite, since the flow ADR and the code already agree.

### A. `:`-form citations survive the link gate (MARK, medium)

Rule ADR-REPO-LINK#5 says `#` is the only spelling "everywhere — code comments, test tags, configuration, and document prose". The gate
passes these, whole-repo and when targeted at the files:

- **Inside the ADR corpus, in code spans:** about 40 occurrences across 14 ADRs, for example
  `design/server-remote-integration.md:54,114,121,122,124,141,145`, `design/visual-design.md:289`, `design/module-aspects.md:88-89` (which
  mixes `:4`, `:7` and `#9` in one bullet), `flow/durable-sha-globs.md:82,122,151-153,274,291-292,300`,
  `automation/controlling-module-dependencies.md:213,217`, `automation/tool-removal-lifecycle.md:11,75,182`,
  `configuration/module-config-loading.md:117`,
  `repository/{conventional-folders:440-442, domain-language-separation:73,212, generated-root-configs:181, protected-globs:157, repo-variants:100,108,111,116}`,
  plus the shorthand `(:1)`, `(:2/:3)` in `pipelines/pipeline-variables.md:120` and `pipelines/pipeline-naming-and-placement.md:179-180` and
  the diagram line `cd-discipline-and-promotion-flow.md:191`.
- **Outside the corpus:** `.claude/drawio/STYLE.md:28` instructs diagram authors to write `(ADR-FLOW-CD:3)`;
  `automation/Catzc.Base.Docs/Get-CatzcAdrRuleIds.ps1:3,7,24` and `private/Get-GlossaryRuleStatements.ps1:18,21` describe a "registry form
  (colon)" as an output shape; four fixture comments under `tests/assets` (`PrePost.psm1:1`, `Get-AzureResourceName.Content.yml:7`, two
  `glossary.yml:1`) carry `ADR-…:n`.

Why it is inconsistent: the rule says one spelling, the Docs module has institutionalised a second one as a data shape, and the gate does
not see code spans, comment-help, or the fixture content class.

Decision, with a recommendation: keep rule #5 and add one sentence that names "registry form" (`ADR-<CODE>:<n>`) as the key shape
`Get-CatzcAdrRuleIds` returns, a datum and not a citation; then run the ~45 mechanical edits (`:n` to `#n` and, in ADR prose, link them as
the conventions ask); then widen `Test-Links` to markdown code spans so this class cannot return. The alternative is to narrow rule #5 to
what the gate checks, which leaves the prose inconsistent.

### B. `terminology.yml` cites a non-existent code (DESCRIBE)

`automation/Catzc.Base.QualityGates/configs/terminology.yml:1194` reads `(ADR-FLOW-CD-CI-GLOBS)`. The code is `ADR-FLOW-CD-GLOBS`.
ADR-REPO-LINK#6 says a configuration value naming a citation names a rule that exists; neither gate validates bare codes inside YAML values.
Change the code; consider having `Test-Links` check bare `ADR-…` codes inside YAML values.

### M. Solo CI output: artifact or not? (MARK, medium)

- ADR-FLOW-CD#4: "A solo CI's terminal output is the **tagged artifact** plus a pass/fail signal."
- ADR-FLOW-CD-TYPE's table: CI produces "A pass/fail signal (no artifact, no deploy)"; its CI section: "It produces a pass/fail signal — no
  artifact, no deployment."

One of the two is the decision. The taxonomy ADR is the layer the flow ADR says it builds on, and `ci-automation` fits the no-artifact
reading. Recommended: amend ADR-FLOW-CD#4 and its "A CD is a CI that keeps going" section to "a pass/fail signal, and the tagged artifact
only when the unit has one to publish".

### N. Pre-prod has no palette colour (MARK, medium)

ADR-DSGN-LIFE#1 and ADR-FLOW-CD#11/#12 add a `pre-prod` rung between `release-uat` and `production`, and LIFE#5 makes it a single-occupant
environment. In `design/visual-design.md`, ADR-DSGN-VISUAL#4 defines no pre-prod state ("green — in production"), the locked palette row
says "green — in production (pre-prod and production occupants)", and VISUAL#7's funnel order omits pre-prod. A pre-prod occupant drawn
green reads as "in production". Decision: give pre-prod its own hue, or state in rule #4 that pre-prod shares green and say why. Either way
VISUAL#7 names the rung.

### P. Stale names in ADR prose (DESCRIBE, medium)

Each is a name an ADR presents as existing; none exists in the tree:

- `Write-CatzcLoadBanner` (`design/run-modes.md:97`): no function or file contains "LoadBanner". Name the real banner writer or drop the
  name and describe the banner.
- `build-catzc.ps1` (`design/run-modes.md`, ADR-DSGN-RUNMODE#1, the entry-point table, and the switching section): not tracked, not present,
  not referenced by any automation. Either the script is a planned root config entry, or the ADR describes the temporary build entry
  wrongly.
- `Test-OutputFormats` (`repository/output-formats.md:125`, "How this is enforced"): only the config types exist (`OutputFormatsConfig`,
  `OutputFormat`). State the gate as planned or write it.
- `.mcp.json` (`repository/conventional-folders.md:310`, listed among the root files): not on disk, not tracked, not in `rootconfig.yml`.
  Remove from the list; add `importer.sh` and `catzc.sln`, which are managed root files the list omits.

### D. Section structure, preambles, title lines (MARK)

The authoring conventions define the registry and padding but no section template. Observed:

- Section families: 92 ADRs use `Rules > Context > Decision > Consequences` (with `Related`, `How this is enforced`, `References` variants);
  34 research ADRs use `Rules > Context > Summary > Why it matters > How to apply > Common pitfalls > References > Dora explains`; 8
  principle/process ADRs use `Principle`/`Why`/`How to apply`; `design/commit-lifecycle.md` and `design/visual-design.md` have neither
  `Context`, `Decision` nor `Consequences`.
- 25 ADRs carry a prose paragraph between the title line and `## Rules` (all 22 `azure/` ADRs with CAF/WAF records, `commit-lifecycle`,
  `visual-design`, `server-remote-integration`), while the index says the registry is "its first content section".
- `pipelines/pipeline-naming-and-placement.md` has a `## Status` section describing which `pipelines/*` folders are populated. That is a
  repository-state snapshot, excluded by "present tense, not a changelog". It is accurate today, which is exactly why it will rot.
- Title line: 162 start `ADR: …`, 6 principles `Principle: …`, the thesis `Thesis: …`, and two have no prefix
  (`repository/generated-readmes.md`, `repository/generated-root-configs.md`).

Decision: declare the permitted templates and whether a preamble is allowed, in the authoring conventions (`adrs.yml`). Independent of that:
delete `## Status`, and give the two unprefixed title lines their prefix.

### U. Zone breaks in ADR illustrations (MARK)

ADR-REPO-LANG#4: "Test fixtures never appear as ADR examples. Live identities may appear in docs only where an ADR documents the actual data
model as its subject."

- Live identities as illustration: `apex` in `flow/durable-sha-globs.md:97,232` (`+ configuration/apex/**`) and
  `pipelines/pipeline-naming-and-placement.md:155` (`cd-apex.yaml` in the layout). Replace with `contoso`.
- Fixture identities in ADRs: the `sample` template in `flow/pipeline-runner-pattern.md:150,159,160` (`-Template sample`); `acme` in
  `repository/repo-variants.md`; `widget-parts` in `configuration/module-config-loading.md:119`; and one or two hits each in
  `pwsh/pester-testing.md`, `pwsh/announce-state-changes.md`, `pwsh/error-handling.md`, `pwsh/assert-idioms.md`,
  `automation/managed-guids.md`, `azure/azure-customer-model.md`. Replace with the discovery theme, or amend LANG#4 to allow fixture names
  where an ADR documents the test convention itself (pester-testing is such a case).
- The design-theme names are live: `infrastructure/templates/` holds `discovery/`, `expedition/`, `foundation/`. ADR-REPO-EXAMPLE#1 calls
  `discovery` and `expedition` the _example_ templates; ADR-REPO-LANG#1 says a token belongs to one zone. Decision: either the shipped demo
  deployment is deliberately the design theme (then say so in ADR-REPO-EXAMPLE and ADR-REPO-LANG), or the example names stop being shipped
  templates.

### C. Rule-number gaps (MARK)

17 ADRs skip numbers (gaps in brackets): AUTO-BUNDLE [4], AUTO-CACHE [3], AUTO-CONSOLE [2], AUTO-DEFAULT [3,4], AUTO-ENTERP [1,2,3],
AUTO-EXTEND [2], AUTO-NOPWD [2,3,5], AUTO-PRELOG [3], AUTO-TEST [2,5,11,12,18,29], AUTO-TYPES [5,6,10], AUTO-XPLAT [1,2,4,5,8],
PWSH-ANNOUNCE [2,3], PWSH-CACHE [3], PWSH-ERROR [4,6], PWSH-PREPOST [1], PWSH-VENDOR [2], PWSH-XPLAT [5]. No convention says whether a
number is a stable identifier or a position. Decision: write it into the authoring conventions. Recommended: "a rule number is stable; a
retired number is never reused; gaps are normal".

### R. `conventional-folders.md` disagrees with itself and the tree (DESCRIBE)

- ADR-REPO-FOLDERS#3 names `go/` and `python/` as root amendments; the tree and ADR-DSGN-TRACK#1 also have `bash/`.
- Line 204: "Two test languages follow it today: Go … and Python"; rule 7 and the `bash/` section name three.
- The Level-1 table has no `bash/`, `.python/` or `.bash/` rows but a `.vscode/` row (an untracked, generated folder).
- Line 247 lists the ADR domains without `thesis/`.
- The `.claude/` row names three files; the folder also holds `agents/`, `drawio/`, `hooks/`.
- The root-file list names `.mcp.json` (absent) and omits `importer.sh` and `catzc.sln` (see P).

### S. Variants: three, four or five (DESCRIBE)

ADR-REPO-VARIANT#1 lists four variants; the section is titled "The three variants" and lists three; `variants.yml` holds five keys
(`ado_naming`, `git_workspace`, `have_customers`, `aspects`, `tracks`). "How this is enforced" says `have_customers` accepts `true`; rule 5
calls it tri-state (`false | all | [names]`), and `VariantsConfig.cs:14` accepts `true`. Align the rule, the section, and the file.

### T. Default test level (DESCRIBE)

`automation/sensible-defaults.md:95`: "Test level defaults to `2`." ADR-AUTO-TEST#33, `sensible-defaults.md` rule 1 itself, and
`Test-Automation.ps1:132` (`$MaxLevel = 3`) say 3. Change line 95.

### O. Commit numbers (DESCRIBE)

ADR-DSGN-VISUAL#10 says "a single-digit number" and #12 "the digits 0–9"; ADR-DSGN-LIFE#10 and the worked table use commit `10`. Drop
"single-digit" and "0–9" in favour of "a number in commit order".

### Q. Runner step-template parameters (DESCRIBE)

`flow/pipeline-runner-pattern.md` shows `invoke-automation.yaml` with four parameters; the file declares six (`AllowWarnings`, `DisplayName`
added). The runner's own parameter block and the auth-header function match their ADR copies. Update the YAML excerpt, or replace it with a
pointer and a one-line description so it cannot drift again.

### W. dora.dev deep link outside research (DESCRIBE)

`principles/everything-as-code.md:98` links `https://dora.dev/capabilities/version-control/`; the conventions allow deep links only in
`docs/references/dora/` and the research ADRs' footnotes. Link `../../references/dora/capabilities.md#version-control`.

### X. Repeated fact and time markers (DESCRIBE)

"today only `catzc`, the bundle" appears in `principles/one-living-version.md:151`, `repository/conventional-folders.md:96,271`,
`repository/api-contracts.md:20,146,301`. "currently covering Azure" in `design/thin-platforms.md:66,123`; "today" in
`repository/controlled-vocabulary.md:75` and `conventional-folders.md:204`. State the unit fact once, in api-contracts, present tense ("the
one unit that carries contracts is `catzc`"), and link to it from the others.

### Y. Mis-citations and wording (DESCRIBE)

- ADR-FLOW-CD#14 cites ADR-FLOW-CD#2 for "CD's post-commit system test"; #2 is the budget rule, #5 and #8 define the test.
- `process/holding-the-line.md:55`: "(ADR-PRIN-POKAYOKE, rule 3)" instead of `ADR-PRIN-POKAYOKE#3`.
- `flow/pipeline-types.md` Context and Consequences refer to "the notes" / "those notes", a source the ADR never names.
- ADR-FLOW-CD-TYPE#6 is not plain language ("confined to INPUT reaching git main somehow — CRON has none to limited set with
  automatic-defaults (meaning the control ex. …)"); #8 has a stray " - ".
- ADR-REPO-FORMAT#7: "In ex. a `dora-explains.md` file".

### E. Rule entries without prose links (DESCRIBE)

`automation/devbox-pipeline-parity.md` rules 1–4 are full paragraphs with no `- [section](#anchor)` bullets; the other 1503 entries follow
the "summary plus internal links" form. Move the argument into `## Decision` sub-sections.

### F. Folder sub-indexes (MARK)

`pwsh/index.md`, `research/index.md`, and `automation/{BCL,go,python,bash}/index.md` exist; eleven domains have none, the main index links
none of them, and each restates its domain's description from `adrs.yml`. Generate one per domain from `adrs.yml` and link them, or remove
the six. Recommended: remove, unless the language sub-folders need landing pages for the how-to links that point at them.

### G. `ADR-PRIN-PROCESS` in `process/` (MARK)

`adrs.yml:73` overrides the domain code so `process/agile-principles.md` is cited as `ADR-PRIN-PROCESS`; the index says principles are cited
`ADR-PRIN-*`, and `PROCESS` does not name the Agile principles. Rename to `ADR-PROC-PRINCIPLES` with `Update-AdrCitation`, or state the
override's reason in the process paragraph. Recommended: rename.

### H. Comment citations the lexer never reads (DESCRIBE)

`CommentLexer.cs` lexes `.ps1/.psm1/.psd1`, `.cs/.bicep`, `.yml/.yaml` only, so `importer.sh:7`, the RootConfig `importer.sh` source, and
`.claude/drawio/minimaps/describe.py:24,26` (`#6, #9` shorthand) are not code links and pass. Add `#`-comment lexing for `.sh`, `.py`,
`.zsh`, `.bats`, or state in ADR-REPO-LINK#1 which file kinds carry code links.

### Z. Orphan diagram asset (MARK)

`docs/adr/design/.assets/new-design-stack.drawio.png` is the one non-markdown file under `docs/` outside `docs/.assets/`
(ADR-REPO-FOLDERS#5), and nothing links it. Move it under `docs/.assets/` with its sister `.md`, or delete it.

### I. Which internal modules stay loaded (DESCRIBE, adjacent)

`.claude/CLAUDE.md` names `Catzc.Internal.{Loader,Types,TestKit}.psm1` as the modules that stay loaded; ADR-PWSH-ENGINE#4 names `Loader`,
`Types`, `Vendor`. The folder holds seven (`Bootstrap`, `Builder`, `Importer`, `Loader`, `TestKit`, `Types`, `Vendor`). A fresh import in
this session leaves exactly `Catzc.Internal.Loader`, `Catzc.Internal.Types`, `Catzc.Internal.Vendor` loaded, so the ADR is right and
`.claude/CLAUDE.md` is wrong: replace `TestKit` with `Vendor` there, and list all seven files or describe the folder by pattern.

### J. Worktree change during the session (MARK, observation)

`docs/adr/automation/test-automation.md` changed at 03:08:30 while this session's gate runs were importing. The diff is a pure re-wrap of
one paragraph to 140 columns. The importer's janitors do not reformat prose, so this most likely came from a parallel session. Check before
committing it with other work.

### K. No `*.md` line-ending attribute (info, no action)

ADR-REPO-FORMAT's `.gitattributes` section decides "no `* text=auto`", so the CRLF warning on ADR files under `core.autocrlf=true` is the
accepted cost of that decision. Recorded so the question is not reopened.

## Suggested order

1. L first: it is the one finding where a rule (ASPECT#4) contradicts another rule and the code.
2. B and P (five one-line facts to correct), then T, O, W, Y as a wording batch.
3. A's mechanical edits, then the rule-#5 sentence, then the gate widening.
4. M and N (flow and visual decisions; both change one sentence once decided).
5. D's two safe edits (`## Status`, two title lines), then the template and preamble decision.
6. R, S, Q, X, E, H, I as a doc-hygiene batch.
7. U, C, G, F, Z decisions.

Each edit is one file at a time with its gate re-run (`Test-Links`, `Test-AdrRegistry`, `Test-MarkdownTitle -Path docs/adr`), per the
editing rule in `.claude/CLAUDE.md`.

## Not covered by this pass

A content read of the 31 unread automation ADRs, 23 pwsh ADRs, 22 azure records and 33 research records (their structure, names, citations
and wording were checked mechanically); `automation/` module code against the pwsh and automation ADRs; `docs/how-to/` and
`docs/references/`; diagrams under `docs/.assets/`; the vendor tree.
