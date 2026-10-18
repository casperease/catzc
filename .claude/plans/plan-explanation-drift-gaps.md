---
plan:
  status: active
  value: high
  reviewed: 2026-10-18
  targets:
    [
      pwsh/Catzc.Azure.DevOps/Get-AdoAuthorizationHeader.ps1,
      pwsh/Catzc.Base.Maps/Get-WorldMap.ps1,
      pwsh/Catzc.Base.Globs/Test-GlobSetAffected.ps1,
      pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1,
      pwsh/Catzc.Azure.DevOps,
      pwsh/Catzc.Base.Repository/Resolve-RepoPath.ps1,
      pwsh/Catzc.Base.Timeouts,
      pwsh/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml,
      .claude/hooks/Assert-BashTimeout/Program.cs,
      pipelines,
      docs/adr/design/run-modes.md,
      docs/adr/design/tracks.md,
      docs/adr/automation/fail-fast-with-asserts.md,
      docs/adr/automation/path-representation.md,
      docs/adr/azure/azure-naming-standard.md,
      docs/adr/azure/prefer-az-cli.md,
      docs/explanation,
    ]
---

# Explanation drift: the gaps between the code and the ADRs

The explanation articles under `docs/explanation/` close with a "Where the code and the ADR differ" section. On 2026-10-18 every claim in
those sections was checked against the tree: the stale ones were dropped or reworded, and the help-text mistakes were fixed at their source
on the reference pages. What is left is real: the code and an ADR disagree, and one of them has to change. This plan holds those gaps.

## Why its value is high

The CD runs deploy the prod tier with no gate (Q3), which breaks the safety core of ADR-FLOW-CD. The other gaps are places where a reader of
an ADR is told something the code does not do: the CD and BVT rules are partly prose (Q1, Q2), the safeguard waves a call through when it
crashes (Q5), and every gap stays visible in up to five lens articles until it closes.

## Done, and why

- 2026-10-18: 254 claims triaged; 8 dropped, 16 reworded, and 18 more dropped after their help texts were fixed on the reference pages
  (config addressing, globset hash, Bicep context path, name patterns, `Get-AdoNaming`, `Get-BicepResourceName`, `Register-AdoPipeline`, the
  fail-open and projection citations). Test-MarkdownTitle, Test-Links and Test-Markdownlint report 0 on every edited file.
- 2026-10-18, the small code fixes, each with its article claims removed:
  - `Get-AdoAuthorizationHeader` gets its token through `Invoke-AzCli`, which asserts `az_cli` (ADR-AZ-CLI#2); its L0 file passed.
  - `Get-WorldMap` asks the new `Test-AspectDeclaration` (Catzc.Base.Modules, beside `Get-Aspect`) instead of reading the config; the
    `Test-AspectDeclaration` L0 file passed, and `Get-WorldMap.Tests` passed but for one real-tree failure that is not this change (the
    `gitattributes.template` stack violation from catzc-0a's RootConfig rename, reported to it). The read itself moved, not closed: see the
    open step on `Get-Aspect`.
  - `Test-GlobSetAffected` raises its unknown-name throw through `Assert-True` (ADR-AUTO-FAILFAST); its L0 file passed.
  - `Build-Bicep.Integrity.Tests` checks that a template resolves a `short_name`, worded as such; the file passed.
  - Q7: `Resolve-RepoPath` normalizes a rooted input; its L0 file passed with a new `.`/`..` case.
  - Q8: ADR-AZ-NAMING#7 says the throw lists the components that can be shortened; ADR-AZ-CLI#7 (new) holds the `Verb-Azure<Noun>` naming
    rule and `analyzer-adr-map.yml` credits `Measure-NoAzModuleNaming` to it. Test-AdrRegistry 0 issues; Test-AnalyzerAdrMap.Tests passed.
  - Q4: ADR-DSGN-RUNMODE#7 has three build kinds (temporary, installed, saved) and no longer says the kind is derived; the Consequences name
    `Get-CatzcRunMode`, not a load banner. `build-catzc.ps1` and `Write-CatzcLoadBanner` were already gone from the ADR. Seven run-mode
    articles lost those claims.
  - Q6: ADR-DSGN-TRACK#5 and its "Tracks, units, pipelines" section say a CI pipeline that verifies a whole track binds the track's own
    loose-fileset set (ADR-FLOW-CD-GLOBS#7), and units bind CD pipelines 1-1. Four tracks articles lost the disagreement claim.
  - Q7: ADR-AUTO-PATH says a path-bearing type holds both forms or derives the absolute on demand, `ExistsAt` answers whether the file
    exists, `Resolve-RepoPath` normalizes an absolute input, `ConvertTo-RepoRelativePath` tries the output root first, and `ArtifactRef` is
    the published-artifact type with no production caller yet. Five path articles lost those claims.
  - Q5: the hook denies with its reason on its own error (`Program.cs`; `Build-BashTimeoutHook.Tests` passed with the deny asserted, and the
    live hook republished). ADR-AUTO-FAILFAST names the unbuilt-hook bootstrap as the one pass-through, scopes the hook to agent sessions on
    a devbox, accepts `Invoke-Executable -Direct`, and says an agent's call carries no budget and so takes no exemption. Nine safeguard
    articles lost those claims. Refined against the decision: `TimeoutExemptionsConfig` keeps its shell axis, since it is the engine list
    (`ExecutionEngines.Names`) for budgeted code, one mechanism per kind; cutting `bash` from it would special-case one engine, and no agent
    call can match an exemption anyway.
  - Q3: everything is config plus one deterministic apply (the user: "fully controlled via config values"). `environment-approvals.yml`
    declares the approver group (name, description, members by principal name), the timeout and the prod-tier environments (`shared-psub`,
    `apex-psub`, `apex-prod`); `EnvironmentApprovalsConfig` declares the defaults once (`Prod Approvers`, 24 h).
    `Sync-AdoEnvironmentApprovals` applies it in a fixed order through four private ADO API callers (`Get-AdoGraphContext`,
    `Sync-AdoGraphGroup`, `Sync-AdoGraphGroupMembers`, `Sync-AdoEnvironmentCheck`): create the group when missing, make its members exactly
    the config's, then create, update or keep one Approval check per environment; `-DryRun` reports every step and writes nothing, and an
    empty member list is refused. Documented in `docs/how-to/automation/apply-environment-approvals.md`. Six L0 files passed, the analyzer
    reports 0 over the 11 files, and the manual-test-plan row and coverage test passed. The group's description is written at creation only,
    since a Graph group patch needs a JSON-patch content type the REST caller does not send. The ladder itself is `plan-promotion-ladder`.
    ADR-FLOW-CD#15 (new) makes the gate a rule and links the how-to.
  - Q1, wired in YAML: `invoke-automation.yaml` takes a `StepName`, so a step can publish output variables; the CI stage of `cd-shared.yaml`
    and of `extends/cd-customer.yaml` checks out with `fetchDepth: 0` and runs
    `Set-AdoPipelineVariable AFFECTED (Test-GlobSetAffected <unit>) -IsOutput` as step `Changes`; `Deploy_Foundation` also needs `AFFECTED`
    true, and the later deploy stages chain on it, so an untouched unit skips every deploy. The check runs once per pipeline, not once per
    stage, and `fetchDepth: 0` is set on the checkouts that diff, not on deploy-job checkouts, which diff nothing. Test-Pipelines and
    Test-AdoPipelineTriggerGlob report 0, and the four files parse.
  - Q2, wired in YAML: `ci-automation.yaml` has a `BuildArtifact` job that runs `Test-BuildArtifact` only on main, the post-merge BVT.
  - Five articles lost the "no pipeline calls it / runs it / sets fetchDepth" claims, and the step-template article counts seven parameters.
  - Gate findings on the approvals work, fixed: help pages for the four private callers (Test-Comments 0); `[OutputType([pscustomobject])]`
    on the apply; the Approval check-type id registered as external-facing `ado_approval_check_type` in guids.yml (Test-ManagedGuids 0);
    "Graph scope" reworded (Test-Glossary 0); `subjectquery` and `vssgp` in terminology.yml's ado section (Test-Spelling 0).

## Decided (2026-10-18, the user took every recommendation)

Each decision becomes an ADR rule, or an ADR amendment, in the change that lands it (ADR-REPO-PLANS#9).

- Q1, code. Wire `Test-GlobSetAffected` into the CD stages and set `fetchDepth: 0` on every Azure DevOps checkout: the function exists, its
  tests pin the throw and the fail-open, and a wrong answer only costs a redundant run. ADR-FLOW-CD-GLOBS#9 stands as written.
- Q2, code. Run `Test-BuildArtifact` in the post-merge BVT, not in PR CI, so it costs nothing against the CI budget that
  plan-test-run-budget is fighting. ADR-AUTO-TEST#24 stands.
- Q3, code now, ladder later. "CD never touches production" is a safety rule the CD runs break today: put an approval check on the prod-tier
  environments (`*-psub` and apex's `prod`). Building main-uat, release-uat, RC/RBC and DEPLOY is its own plan, not an ADR rollback.
- Q4, ADR. Drop `Write-CatzcLoadBanner`, the root `build-catzc.ps1` and the cached build kind from ADR-DSGN-RUNMODE: `Get-CatzcRunMode`
  reports the mode, `Build-Modules` plus `Import-Catzc.ps1` is the build-and-enter path, and nothing needs a cached build
  (ADR-PRIN-ONELIVE).
- Q5, both. The hook fails closed on its own error (a guard is a control on the devbox), and stays fail-open only when it is not built yet,
  the bootstrap case the ADR now names. Bash exemptions go from ADR-AUTO-FAILFAST and `timeout-exemptions.yml`: a long call goes to the
  background or gets a `timeouts.yml` entry. The ADR accepts `Invoke-Executable -Direct` (a person at the prompt) and scopes the hook to
  agent sessions (no agent in a pipeline).
- Q6, ADR. ADR-DSGN-TRACK gives way to ADR-FLOW-CD-GLOBS and `globs.yml`: a CI pipeline may bind a loose-fileset track set directly.
- Q7, mostly ADR. `Resolve-RepoPath` normalizes a rooted input too (one line, it keeps its full-path promise). ADR-AUTO-PATH says `ExistsAt`
  returns whether the file exists, lets `RepoRelativePath` derive the absolute form on demand, and names `ArtifactRef` the type of a
  published artifact without calling it the primary enforcement.
- Q8, both. ADR-AZ-NAMING says the length throw lists the components that can be shortened. `analyzer-adr-map.yml` credits
  `Measure-NoAzModuleNaming` to the rule that governs function naming; when ADR-AZ-CLI has none, that rule is added there.

## Open steps

When a step lands, remove its claim from every article that states it (search `docs/explanation` for the function name) in the same change.

- [x] Landed 2026-10-18 by session catzc-fb as decided (verdict in task-explanation-drift-gaps step 1); the plain `mv` shows as a delete
      plus an add until the user's `git add` records the move. Left for the slide step (text block = slide): the text blocks, H1 and file
      name of `five-keys-one-reader-twelve-primitives` (still "twelve", row 7 "Get-Aspect · Get-Track") and `a-base-module-between-config-and-its-callers.md:10`;
      older drift in the same article, line 39 "exactly the three edges" (Variants has 4) and line 42 "Globs asks Get-Aspect" as if
      Variants held it. Original step: `pwsh/Catzc.Base.Modules/Get-Aspect.ps1` and `Test-AspectDeclaration.ps1`: move both into `Catzc.Base.Variants` and read through the
      private `Get-Variant`, so `aspects` has one read path like every other variant (ADR-REPO-VARIANT); the Variants count of exported
      primitives in `docs/explanation/repository/` and its slide changes with it (check: the Variants and Maps L0 tests pass, and no file
      outside Catzc.Base.Variants reads `(Get-Config -Config variants)`). Decided 2026-10-18 by the orchestrator on the user's delegation:
      the session's recommendation below is the step; the `Get-FileLanguage.Tests.ps1:49` switch is in it. Raised by session catzc-59:
      moving `Get-Aspect` makes a cycle, since it reads `(Get-Config -Config languages).LivePatterns()` (Catzc.Base.Languages) and
      `dependencies.yml` has Catzc.Base.Languages -> Catzc.Base.Variants. The session's recommendation: move only `Test-AspectDeclaration`,
      add one exported Variants reader for the declared aspects through `Get-Variant`, keep `Get-Aspect` in Modules calling it. The grep
      check also hits `pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1:49`, which needs a one-line switch to
      `Test-AspectDeclaration`.
- [ ] Q1 the CD pipelines on a real run: the wiring is in the YAML (see Done); a run on main touching only `apex` shows the `Changes` step
      writing `AFFECTED=True` in `cd-apex` and `AFFECTED=False` in `cd-shared`, whose deploy stages then skip (check: those two run logs).
- [ ] Q2 `pipelines/ci-automation.yaml` on a real run: the `BuildArtifact` job runs on main and passes, and is skipped on a PR (check: one
      main run and one PR run).
- [ ] Q3 `pwsh/Catzc.Azure.DevOps/configs/environment-approvals.yml`: the user lists the approvers under `approver_group.members` and runs
      the apply (`Sync-AdoEnvironmentApprovals -DryRun`, then without); then the lifecycle articles drop the "prod with no gate" claims
      (check: a second apply reports Unchanged for the group and all three checks, and a CD run to `shared-psub` waits for approval).
- [x] Done 2026-10-18 (catzc-59; verdict in task-explanation-drift-gaps step 6; the fifth slide is now
      `tests-pin-the-throw-and-fail-open-cd-calls-it`). Q4 the five slides that draw what is no longer true. Three draw what the run-modes ADR no longer names: `rule-and-gate-per-load-stage`
      (`build-catzc.ps1` and `Write-CatzcLoadBanner`, markers 7 and 8), `what-gates-each-bundle-stage` (the cached root, marker 6) and
      `which-run-mode-rules-have-a-gate` (four build kinds, marker 8). Two, since Q1, say the in-pipeline check has no caller:
      `drift-is-gated-generation-is-adr-only` (the "in-pipeline exact backstop" ADR-only box, marker 8, and its title) and
      `tests-pin-the-throw-and-fail-open-no-caller` (the `fetchDepth: 0` ADR-only glyph, marker 7, and its title "…no pipeline calls it").
      Each needs those elements removed or relabelled, and the two globset articles a new title, with the article, `.drawio.md` and minimaps
      following; cell removal is diagram work for the user to ask for, not `write-drawio-files` (check: the articles' text blocks match
      their slides, and Test-Links passes). Decided by the user 2026-10-18, go given: slide 4 loses the backstop box; slide 5 restyles
      marker 8 as well as 7; slide 5's `…-no-caller` slug is renamed, through the move command once it exists (task-diagram-folders step 3),
      so one tool re-points the links; slide 3 takes the brief's proposed title. The choices as raised: The brief is in
      `out/drift-slides-brief.md` (session catzc-59, 2026-10-18; all 30 paths it names exist). The choices, the session's recommendation
      first where it gave one: slide 4, remove the backstop box (recommended) or relabel it as the Changes step; slide 5, restyle marker 8
      too, since Q1 wired the Changes step (recommended); slide 5, keep or rename the `…-no-caller` slug; slide 3, the new title wording.
      Also for step 6: the "Where the code and the ADR differ" section of `which-run-mode-rules-have-a-gate.md` still holds the retired
      build kind, `build-catzc.ps1` and `Write-CatzcLoadBanner` bullets.
- [x] Done 2026-10-18 by session catzc-fb with the user's go: get-aspect-feeds-globs-and-maps, manifest-and-aspects-from-one-folder,
      only-automation-compiles-its-aspects and get-aspect-names-the-remainder now say pwsh's aspects derive from the languages.yml layout
      (Get-Aspect -Track pwsh), slides and articles together; "every stage clean; LINKS 0, FILEMETA 0, Test-Glossary 0 on each article".
      The declared `aspects.automation` entry: `docs/explanation/design/get-aspect-feeds-globs-and-maps.md` and
      `manifest-and-aspects-from-one-folder.md` (and `only-automation-compiles-its-aspects.md` lines 18, 29, 33, the "automation
      track/convention") describe a declared `aspects.automation` entry and `Get-Aspect -Track automation`; the tree
      has neither (the code track is `pwsh`, its aspects derive from `languages.yml`, as `variants.yml:7` says), so a word swap would be
      as wrong. Found 2026-10-18 by session catzc-59 during the word residue; the articles and their slides are corrected together, after
      the diagram-folders migration (check: each article's text blocks match its slide; Test-Links on the touched pages).

## Refs

- The articles' "Where the code and the ADR differ" sections under `docs/explanation/` hold each gap in the reader's words.
- `out/drift-triage.md` (session output, not kept) has the verdict and evidence for all 254 claims as of 2026-10-18.
