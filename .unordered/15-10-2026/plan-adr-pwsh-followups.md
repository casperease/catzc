# Plan: ADR-PWSH split follow-ups, making the split consistent everywhere

The split landed on 2026-10-15 (`out/plan-adr-pwsh-split.md`, P0–P5). It deliberately left some work for later, and the run turned up more.
This plan does all of it. Every rule that keeps the repo consistent becomes a **check**, so consistency holds on later changes too
(ADR-PRIN-POKAYOKE), not only today. The same machinery as the split applies throughout:

- the maps, which give old → new for every rule and are authoritative;
- `Update-AdrCitation`, run one file per call;
- a coordinator with `catzc-worker`s;
- one change per workstream (ADR-PRIN-ONELIVE: no aliases and no history notes);
- per-file checks; the user runs the full `Test-Automation`.

## Status (2026-10-15)

**Landed:**

- W0: the six checks, one mode type and one parser.
- W1: index entries, FAILFAST#7, zsh's manager reported as apt, I3/I4/I5 at 0, and the analyzer map.
- W2: the ADR text, plus the bootstrap calling `Test-IsRunningInPipeline`, which now lives in `Catzc.Internal.Loader`.
- W3/W4: 19 MIXED rules reworded, 7 collapses migrated, and new PWSH rules, among them the new ADR-PWSH-IDEM.
- W5: the structure.
- W6: I2 at 0.

**Gate mode:** I1–I6, all at 0. I7 was already enforced.

**Open:**

- catzc-fd planned an ADR-PWSH rule for the overlay's `.ps1` layout and override mechanism, citing OVERLAY#3, #5 and #9. Its session has
  ended, so this is unowned.
- Limit I5 to `logic` blocks (see W0).
- W7, the Linux run.
- Commit the new files: until then, `Test-Links` shows `[Untracked]` for them.

## 1. The invariants (what "consistent" means)

Each invariant gets an enforcing check; the third column names it. A check that is **new** is built in W0 before any content changes, so
every later workstream is measured against it.

| #   | Invariant                                                                                                                                                                                                                                                                                          | Enforced by                                                                                                  |
| --- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| I1  | **AUTO rule text is engine-neutral.** A `### Rule ADR-AUTO-*` summary contains no PowerShell syntax (`$env:`, `$PSScriptRoot`, `-ieq`, `Join-Path`, `[CmdletBinding()]`, `Describe`/`It`, `Set-StrictMode`, `[SecureString]`, …). Naming a catzc command (`Get-Config`, `Assert-Tool`) is allowed. | **new** `Test-AdrEngineNeutrality`: a token list in config, the same mechanism as terminology                |
| I2  | **Citations follow the domain graph.** A `### Rule` summary cites only its own domain or a declared `depends_on` domain. Body prose may link anywhere (a "related" pointer), but a rule never depends on a domain above it.                                                                        | extend `Test-AdrRegistry` (it already has `adrs.yml` and the rule texts)                                     |
| I3  | **One citation spelling.** `CODE#n` everywhere; `CODE:n` only in `### Rule` headings (ADR-REPO-LINK#5). This includes analyzer messages and code strings.                                                                                                                                          | extend `Test-Links` to non-markdown message strings (today `Format-Links` fixes only comments and markdown)  |
| I4  | **The engine set is never restated.** No hard-coded engine list (`ValidateSet('Pwsh','Bash')`, "pwsh and bash", "two engines", `[pwsh]`/`[bash]` without `[zsh]`). Code reads `ExecutionEngines.Names`; prose says "every engine" or names all three.                                              | **new** `Test-SourceConventions` rule, using the engine names from the model                                 |
| I5  | **L0 fixtures use neutral codes.** No real `ADR-<DOMAIN>-<NAME>` in an L0 test's fixture data (ADR-AUTO-TEST#3); a real code is allowed only as a test tag.                                                                                                                                        | **new** `Test-SourceConventions` rule                                                                        |
| I6  | **Every ruleset has its DORA section.** Each ruleset in `adrs.yml` has exactly one section in its domain's `dora-explains.md`.                                                                                                                                                                     | extend `Test-AdrRegistry`                                                                                    |
| I7  | **Every engine-case table fills every engine column.**                                                                                                                                                                                                                                             | exists: `Get-EngineCaseTable` (L1 integrity test)                                                            |
| I8  | **No duplicate rule.** Two live rules may not state the same thing; a principle and its mechanics are one AUTO rule plus one PWSH rule that cites it.                                                                                                                                              | review, plus the duplicate list in §2 W4 driven to zero (no mechanical check proves two rules mean the same) |

## 2. Workstreams

### W0: build the checks (first, alone)

A worker builds the new checks I1, I4 and I5 and extends I2, I3 and I6, each with L0 tests that use neutral fixtures. Each check starts in
**report** mode and lists every current violation. Those lists are the work lists for W1–W6. A check becomes a failing gate only when its
workstream has driven its count to 0. Owner: one worker per module (`Catzc.Base.Docs`, `Catzc.Base.QualityGates`).

**Built (2026-10-15).** These are the counts each check reported against the real repo while in report mode. The work lists are
`out/w0-i<n>.txt`.

| Check | Count                                           | Where it lives                                            |
| ----- | ----------------------------------------------- | --------------------------------------------------------- |
| I1    | 31                                              | `Test-AdrEngineNeutrality`, config `adr-checks.yml`       |
| I2    | 102                                             | `Test-AdrRegistry`, config `adr-checks.yml`               |
| I3    | 124, all fixable by `Format-Links -Path <file>` | `Test-Links`, config `links.yml string_citations`         |
| I4    | 53                                              | `Test-SourceConventions`, config `source-conventions.yml` |
| I5    | 73                                              | `Test-SourceConventions`, config `source-conventions.yml` |
| I6    | 6                                               | `Test-AdrRegistry`, config `adr-checks.yml`               |

**State after W0c/W1a/W1b (2026-10-15):** I3, I4 and I5 are 0 and in gate mode, and I6 is 0. The mode type is one shared
`Catzc.Base.Docs.CheckMode` with one parser, `CheckModes.Parse`. Open: I1 = 30 (W3) and I2 = 102 (W6); then flip both to gate. One W0
follow-up: limit I5 to `logic`-tagged blocks. ADR-AUTO-TEST#3 is about logic tests owning their inputs, so an L0 `integrity` block may read
real codes. That retires the `Build-Bicep.Integrity.Tests.ps1` exemption in `source-conventions.yml`.

Left over from W0, and needed before any check flips to gate mode:

- **One mode type.** W0a and W0b each made a gate/report enum: `Catzc.Base.Docs.AdrCheckMode` and `Catzc.Base.QualityGates.CheckMode`. Keep
  one; QualityGates already depends on Docs. Delete the other, and keep the yml shape (`mode: report`, with gate as the default on the
  type). This is ADR-PRIN-ONELIVE.
- **I4 wording, decided:**
  - 31 findings name only bash and zsh. They are rewritten to the term **POSIX engines**, defined in ADR-AUTO-ENGINE as the engines whose
    importer entry is `importer.sh` (derived from the model). The phrase is allowed in `source-conventions.yml`.
  - The time-safeguard paragraph's "bash and pwsh" means the Bash tool and pwsh processes, not the engine set. It is reworded to say so in
    CLAUDE.md and the agent files.
  - No exemptions per file.
- **I3 registry ids, decided:** `Get-CatsAdrRuleIds` returns the registry key `ADR-X:n`, which is the `### Rule` heading form that
  ADR-REPO-LINK#5 allows. That function, its consumers and their tests get a declared `string_citations.exempt` entry with that reason.
  Everything else is respelled by `Format-Links -Path`, per file, with the file's consumers and tests, never repo-wide.
- **I5 scope, decided:**
  - `It`/`Context`/`Describe` titles are names, not fixture data, so I5 skips them.
  - An assertion on a production message that cites a real rule (e.g. `Test-Pipelines.Tests.ps1`) gets a `neutral_codes.exempt` entry with
    the reason. Moving it to an L1 tier is the alternative where the test is really an integrity test.
  - Every other fixture becomes neutral.

### W1: small fixes (one change)

1. `analyzer-adr-map.yml`: `Measure-AnnounceStateChange` maps to ADR-PWSH-ANNOUNCE#8 (the pwsh mechanism it actually checks), keeping
   ADR-AUTO-CONSOLE#11 as the principle. Its message in `.scriptanalyzer/AnnounceStateChange.psm1` and the expected strings in its test
   change too.
2. Neutral fixtures (I5): `Get-TestRuleTags.Tests.ps1:37` and `AnalyzerAdrMapConfig.Tests.ps1:35-36` use `ADR-PWSH-ERROR:3` as a
   malformed-citation fixture. That becomes a neutral code, plus whatever else I5 reports.
3. Engine-list residue (I4): everything W0 reports. Known: `.claude/agents/catzc-worker.md` and `EngineCaseTable.cs` header comments, and
   `catzc-base-qualitygates.md:99` ("the bash engine").

### W2: rule-text conflicts (decisions Q1 and Q2)

- **PWSH-XPLAT#8** says "compare paths with `-ieq`, not `-eq`". In PowerShell, `-eq` is already case-insensitive on strings, so the rule
  doesn't say what it means. The intent, which AUTO-XPLAT#7 states, is: compare paths case-insensitively on Windows and ordinally, after
  `GetFullPath()`, never by culture. Reword it to that mechanism (`[StringComparer]::OrdinalIgnoreCase` / `-ieq` on full paths) and name the
  real hazard: `-ceq`/`-clike` and culture-sensitive `.Equals`.
- **PWSH-ENV#6** gives `$env:TF_BUILD` as a legitimate external-input read, but ADR-FLOW-CD-DETECT#1 (`Measure-NoRawPipelineDetection`) bans
  raw pipeline detection. Swap the examples for ones that are not pipeline detection (`CATZC_*` inputs, a tool's contract variable), and add
  a pointer: pipeline context is read only through the detection API (FLOW-CD-DETECT#1). PWSH-TYPES#5's inlined `$env:TF_BUILD`/
  `$env:GITHUB_ACTIONS` check gets the same review: either it is a sanctioned exception, named in FLOW-CD-DETECT, or it calls the detection
  API.

**ADR text done (2026-10-15).** PWSH-XPLAT#8 says: full paths, `OrdinalIgnoreCase`, never culture-sensitive. `-ieq` is left out on purpose,
because it compares in the invariant culture, not ordinally. PWSH-ENV#6 and PWSH-TYPES#5 send pipeline detection through
`Test-IsRunningInPipeline` (no exception, decision Q2). What is still open is the code and one AUTO text that still describes the inline
read:

- **Code:** in `automation/.internal/Catzc.Internal.Bootstrap.psm1:478`, `Import-CSharpTypes` reads `$env:TF_BUILD`/`$env:GITHUB_ACTIONS`
  inline, with a `Measure-NoRawPipelineDetection` suppression at :391 and a comment at :476-477. Fix: make `Test-IsRunningInPipeline` the
  one definition in a `Catzc.Internal.*` library that stays loaded. The `Catzc.Internal.*` libraries load before the bootstrap in both run
  modes. Delete it from `Catzc.Base.Repository`, call it from the bootstrap, and drop the suppression and the comment. Update
  `flow/pipeline-detection.md:90` ("lives in `Catzc.Base.Repository`"). The loader belongs to catzc-e7's area, so message it first.
- **AUTO text:** `automation/BCL/native-csharp-types.md:64-65` (AUTO-TYPES#7) still describes the inline read. Reword it to the detection
  API. `automation/environment-variables.md:17` (ENVVAR#2, "CI detection") should point to the detection API.

### W3: the remaining MIXED rules (the Q5 pass the split deferred)

Same method as the split's P3: the rule stays where its principle is, gets reworded neutrally, and gains a **new** PWSH mechanics rule that
cites it. Existing citations stay valid; only mechanics citations in code move to the new PWSH rule (case by case, listed by W0's I1
report). From `out/adr-auto-map/rules.tsv`, the AUTO-side rules still MIXED are:

| ADR            | Rules   | Its PWSH mechanics go to                                                                                                     |
| -------------- | ------- | ---------------------------------------------------------------------------------------------------------------------------- |
| ASSETDEP       | #1, #2  | PWSH-PWD (anchor helpers)                                                                                                    |
| CACHE          | #8      | PWSH-CACHE                                                                                                                   |
| DEPM           | #2      | PWSH-MANIFEST / PWSH-VENDOR                                                                                                  |
| EXTEND         | #1      | PWSH-MANIFEST                                                                                                                |
| GO, PY         | #7 each | PWSH-PESTER (the language bridge, already PWSH-PESTER#20)                                                                    |
| IDEM           | #3, #5  | **new** PWSH ADR, or PWSH-PARAM (`-Force`, return shapes); decision Q3                                                       |
| NONEST         | #3, #5  | PWSH-FORMAT                                                                                                                  |
| ONEJOB         | #6      | PWSH-ERROR                                                                                                                   |
| PATH           | #4      | PWSH-XPLAT                                                                                                                   |
| PRELOG         | #2, #4  | PWSH-ANNOUNCE                                                                                                                |
| RETRY          | #1, #6  | PWSH-ASSERT or PWSH-ERROR                                                                                                    |
| ZERO           | #2, #3  | PWSH-ONEFUNC / PWSH-MANIFEST                                                                                                 |
| AZ-CLI (azure) | #1      | stays: an Azure tooling choice (split decision Q-a); only `Invoke-Executable`/`ConvertFrom-Json` move to a cited helper rule |

Workers are split by topic, with the same file ownership as P3: C1 modules (EXTEND, ZERO, DEPM), C2 errors and output (ONEJOB, RETRY,
PRELOG), C3 platform and paths (PATH, ASSETDEP, CACHE, NONEST), C4 tests and state (IDEM, GO, PY). The PWSH-side MIXED rules (ONEFUNC#1–3,
VERBS#2–7, MANIFEST#4, PWSH-XPLAT#4) already have their principle in AUTO, or wait for a non-pwsh command surface (split decision Q-c,
VERBS). Only their citations are checked (I2).

### W4: near-duplicates (I8)

From the survey's anomaly 5, minus what the split already resolved. For each pair, decide **collapse** (one survives, and citations move
through a `rule-moves.tsv` row) or **split** (the principle in AUTO, the mechanism in PWSH, each citing the other once).

| Pair                                                                   | Proposed                                                                                            |
| ---------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| NOPWD#1 ≈ ASSETDEP#1 ≈ PWSH-PWD#1 (+#4)                                | split: the principle stays NOPWD#1; ASSETDEP#1 cites it; PWSH-PWD#1/#4 hold the mechanism           |
| PWSH-XPLAT#3 ≈ PWSH-XPLAT#5                                            | collapse into #3                                                                                    |
| AUTO-XPLAT#3 ⊃ PWSH-XPLAT#2 (Join-Path)                                | split (already shaped so); check that the wording doesn't overlap                                   |
| PRELOG#3 ≈ CONSOLE#3                                                   | collapse into CONSOLE#3; PRELOG cites it                                                            |
| CONSOLE#4 ≈ PWSH-ANNOUNCE#4                                            | split: the principle stays CONSOLE#4                                                                |
| XPLAT#8 ≈ DEPS#5 ≈ PARITY#1                                            | collapse into PARITY#1 (one code path everywhere); the others cite it                               |
| CACHE#6 ≈ PWSH-CACHE#1                                                 | split                                                                                               |
| CACHE#8 ≈ AUTO-TYPES#6                                                 | collapse into CACHE#8                                                                               |
| TEST#4 / PWSH-PESTER#3 / PWSH-CACHE#3 (mock the whole cached function) | TEST#4 holds the principle; PWSH-PESTER#3 holds the mechanism; PWSH-CACHE#3 collapses into PESTER#3 |
| PWSH-USEPS#2 ≈ PWSH-PREPOST#1                                          | collapse into USEPS#2                                                                               |
| PWSH-ONEFUNC#3 ≈ PWSH-USEPS#3                                          | collapse into ONEFUNC#3                                                                             |
| EXTEND#4 ≈ PWSH-ONEFUNC#1 ≈ ZERO#2                                     | split: the principle stays EXTEND#4; ZERO#2 cites it; ONEFUNC#1 holds the mechanism                 |
| PWSH-PARAM#4 restates DEFAULT#6                                        | PARAM#4 keeps only the pwsh mechanism and cites DEFAULT#6                                           |

The map work is one new `rule-moves.tsv` (collapses only) passed to `Update-AdrCitation`. The `build-map.ps1` idempotence check runs on it
first. W4 lands together with W3, because both reword the same ADRs.

### W5: structure

- **REPO-PROTGLOB** moves from `automation/protected-globs.md` to `repository/protected-globs.md` (code unchanged; the leaf `code: REPO`
  override goes away). Q4 asks whether it belongs in `flow/` instead, given its globset or CI subject.
- **Slug:** `go/test-artifacts.md` becomes `go/go-test-artifacts.md`, to match `python-test-artifacts` and `bash-test-artifacts`. That frees
  the duplicated slug `test-automation`, which slug-based link repair cannot tell apart; Q5 decides whether `research/test-automation.md` is
  also renamed.
- **bash layer:** `docs/adr/automation/bash/index.md`, and `languages.yml` gives `bash` an `adr_folder: automation/bash` (survey anomaly 3).
- **dora-explains coverage (I6):** sections for ENGINE, PY and BASH, plus whatever I6 reports.
- **Format-Links' slug repair:** after W5, `AdrCitationMap.PathOfSlug` must resolve every slug uniquely. A check asserts that.

### W6: the domain graph (I2), decision Q6

The split added AUTO → PWSH edges in rule summaries: TEST#4 cites PWSH-CACHE#3, and TEST#17 cites PWSH-PESTER#2. It also added prose
pointers in BUNDLE, ENTERP and TEST. The survey found older upward citations too: design, repository, research, process, thesis and
principles cite automation (anomaly 9), and automation cites flow, repository, azure, github, pipelines and configuration without declaring
them.

- **Policy (recommended, Q6a):** a rule summary may cite only its own domain or a declared dependency. Body prose may point anywhere as
  "related"; such a pointer is never a dependency and never the reason for a rule. I2 encodes exactly that.
- **Fix:** W0's I2 report lists every rule-summary violation. Each is resolved by one of three moves:
  1. invert the citation (the PWSH rule cites the AUTO rule, not the other way round);
  2. move the clause into body prose;
  3. declare the dependency in `adrs.yml`, when the edge is real and downward. Example: `automation` depends on `configuration`.
- Lower domains citing automation (design, repository, research, …) are decided per case by the same three moves. Most are examples in body
  prose and stay as pointers.

**How I2's 102 findings split (2026-10-15).** By citing domain → cited domain:

| Cited from    | Findings | Biggest edges                             |
| ------------- | -------- | ----------------------------------------- |
| design        | 25       | → flow 13, → repository 6, → automation 5 |
| repository    | 16       | → automation 12                           |
| process       | 10       | → automation 5, → design 3                |
| flow          | 6        | → repository 5                            |
| azure         | 4        |                                           |
| configuration | 2        |                                           |
| principles    | 2        |                                           |
| thesis        | 1        |                                           |
| automation    | 35       | → pwsh 21, → flow 8, → repository 3       |
| pwsh          | 2        |                                           |

The 66 findings outside automation and pwsh are **W6 proper** and can go now, by the three moves above. The 37 in automation and pwsh are
fixed together with **W3/W4**, which reword those same rule summaries. The 21 automation → pwsh findings take move 1 (invert) as their
principle and mechanics split.

### W7: Linux coverage

The apt branches of `Install-Zsh` and `Uninstall-Zsh` (5 L0 cases) and the `unix_only_*` cases of `Test-ExpectedPackageManager` have never
run. Run them on a Linux devbox, or in the Linux pipeline leg, and report. If no Linux leg runs the L0 suite, that gap is itself a finding
for ADR-AUTO-PARITY.

## 3. Order

```
W0 (checks, report mode)
 ├─ W1 small fixes ─────────────────────────────┐
 ├─ W2 rule-text conflicts ─────────────────────┤
 ├─ W5 structure (PROTGLOB, slugs, bash, dora) ─┤
 └─ W6 graph policy → fixes ────┐               ├─ checks go from report to gate
     W3 MIXED + W4 duplicates ──┴───────────────┘
W7 Linux run (any time; independent)
```

- W1, W2 and W5 are independent and can run in parallel.
- W3 and W4 rewrite the same ADRs, so they are one change, and they start after W6's policy is decided. W6's fixes and W3/W4's rewording
  touch the same rule summaries.
- Each workstream lands whole (ADR-PRIN-ONELIVE). Its check flips to gate mode when its count reaches 0.

## 4. Shared files and other sessions

The coordinator alone edits `adrs.yml`, the three `dora-explains.md`, `terminology.yml`, `analyzer-adr-map.yml`, the glossary sources,
`languages.yml`, CLAUDE.md and the agent files, and regenerates the index and glossary.

Before W3, W4, W5 and W6 start, message the live sessions. catzc-e7 is changing the loader wording in `dynamic-module-manifests.md`,
`use-ps1-not-psm1.md` and `conventional-folders.md`; catzc-e3 is adding PARAM analyzer rules; catzc-f1 owns concern and stack edits in
`adrs.yml`. Wait until those files are quiet.

## 5. Decisions (decided by the user 2026-10-15: every recommendation taken)

| #   | Question                                                                                                                                | Decision                                                                                              |
| --- | --------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| Q1  | PWSH-XPLAT#8: reword to the ordinal, full-path comparison mechanism (W2)?                                                               | yes                                                                                                   |
| Q2  | PWSH-ENV#6 / PWSH-TYPES#5 `$env:TF_BUILD`: always go through the detection API, or name a sanctioned exception in FLOW-CD-DETECT?       | the detection API; no exceptions                                                                      |
| Q3  | IDEM#3/#5 mechanics: a new `pwsh/idempotent-state-mechanics.md`, or add to PWSH-PARAM?                                                  | a new PWSH ADR: state functions are their own subject                                                 |
| Q4  | REPO-PROTGLOB: `repository/` or `flow/`?                                                                                                | `repository/`: its code already says REPO                                                             |
| Q5  | Also rename `research/test-automation.md` to remove the duplicated slug?                                                                | no: research slugs mirror DORA's capability names. Make `PathOfSlug` refuse a duplicated slug instead |
| Q6  | Domain-graph policy: (a) rule summaries follow the graph, prose may point anywhere; (b) the full graph, prose included; (c) leave as is | (a)                                                                                                   |
| Q7  | Checks I1, I4 and I5: fail the build as soon as their count is 0, or stay reporting only?                                               | fail at 0: a check that only reports drifts back                                                      |

## 6. Verification

- **The checks:** I1–I7 all at 0 and in gate mode, plus the split's gates: `Test-AdrRegistry`, `Test-GeneratedFiles`, `Test-Links`,
  `Test-Terminology`, `Test-AnalyzerAdrMap`, `Test-Glossary`, `Test-SourceConventions`, `Test-Spelling`, `Test-Formatting`,
  `Test-MarkdownTitle`.
- **Tests:** the tests of every module touched.
- **Residue search:** zero hits for every collapsed rule from W4's map, and for the old `protected-globs` and `go/test-artifacts` paths.
- **Duplicates:** the W4 list is closed, with each pair marked collapsed or split.
- **Report:** what landed per workstream, every check's count before and after, and every deviation.
