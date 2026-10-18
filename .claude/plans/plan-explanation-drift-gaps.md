---
plan:
  status: active
  value: high
  reviewed: 2026-10-18
  targets:
    [
      automation/Catzc.Azure.DevOps/Get-AdoAuthorizationHeader.ps1,
      automation/Catzc.Base.Maps/Get-WorldMap.ps1,
      automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1,
      automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1,
      automation/Catzc.Azure.DevOps,
      automation/Catzc.Base.Repository/Resolve-RepoPath.ps1,
      automation/Catzc.Base.Timeouts,
      automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml,
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

- [ ] `automation/Catzc.Azure.DevOps/Get-AdoAuthorizationHeader.ps1`: assert `az_cli` with `Assert-Tool` before the az token call, as
      ADR-AZ-CLI#2 asks of every function that calls az (check: its L0 test file passes).
- [ ] `automation/Catzc.Base.Maps/Get-WorldMap.ps1`: read the aspects through `Get-Aspect` instead of
      `(Get-Config -Config variants).aspects`, so the variants file keeps one read path (ADR-REPO-VARIANT) (check: the Catzc.Base.Maps L0
      tests pass).
- [ ] `automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1`: raise the unknown-name throw through the assertion library instead of an
      inline check (ADR-AUTO-FAILFAST) (check: its L0 test file passes and still pins the throw).
- [ ] `automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1`: reword the `-Because` message so it no longer says
      `options.yml` must exist, since ADR-AZ-NAMING makes it optional (check: the test file passes).
- [ ] Q1 `pipelines/cd-shared.yaml`, `pipelines/cd-apex.yaml` and the other CD pipelines: a first step in each `Deploy_*` stage runs
      `Test-GlobSetAffected` for the stage's unit and skips the stage on `$false`, and every checkout sets `fetchDepth: 0` (check: the drift
      gates on pipeline triggers pass, and a CD run log shows the check line).
- [ ] Q2 `pipelines/cd-shared.yaml` and the other CD pipelines: the post-merge BVT runs `Test-BuildArtifact` on the CI artifact (check: a
      post-merge run on main shows it passing).
- [ ] Q3 `automation/Catzc.Azure.DevOps/Sync-AdoEnvironmentApprovals.ps1` (new): register an approval check on every prod-tier environment
      the CD pipelines name (`*-psub`, apex `prod`), declared once in a config entry, the way `Sync-AdoBuildValidations` syncs policies
      (check: its L0 test file passes, and a dry run lists the environments).
- [ ] Q3 `.claude/plans/plan-promotion-ladder.md` (new): one plan for main-uat, release-uat, RC/RBC, pre-prod staging and DEPLOY (check:
      plan-clear's verdict is keep).
- [ ] Q4 `docs/adr/design/run-modes.md`: remove `Write-CatzcLoadBanner`, `build-catzc.ps1` and the cached kind (check: Test-AdrRegistry and
      Test-Links pass; the run-mode articles lose those claims).
- [ ] Q5 `.claude/hooks/Assert-BashTimeout/Program.cs`: a hook error denies the call with its reason instead of exiting non-blocking (check:
      the hook's L2 test asserts the deny).
- [ ] Q5 `docs/adr/automation/fail-fast-with-asserts.md`: name the unbuilt-hook bootstrap case, accept `-Direct`, scope the hook to agent
      sessions, and drop the bash exemption route (check: Test-AdrRegistry and Test-Links pass).
- [ ] Q5 `automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs` and `configs/timeout-exemptions.yml`: remove the bash ceiling and
      the `shell: bash` scope (check: the Timeouts L0 tests pass).
- [ ] Q6 `docs/adr/design/tracks.md`: a CI pipeline may bind a loose-fileset track set directly, as ADR-FLOW-CD-GLOBS says (check:
      Test-AdrRegistry and Test-Links pass).
- [ ] Q7 `automation/Catzc.Base.Repository/Resolve-RepoPath.ps1`: return `[IO.Path]::GetFullPath($Path)` for a rooted input (check: its L0
      test file passes, with a case for `C:\x\.\y`).
- [ ] Q7 `docs/adr/automation/path-representation.md`: `ExistsAt` returns a Boolean, `RepoRelativePath` derives the absolute form, and
      `ArtifactRef` is the published-artifact type, not the primary enforcement (check: Test-AdrRegistry and Test-Links pass).
- [ ] Q8 `docs/adr/azure/azure-naming-standard.md`: the length throw lists the components that can be shortened (check: Test-AdrRegistry
      passes).
- [ ] Q8 `automation/Catzc.Base.QualityGates/configs/analyzer-adr-map.yml`: credit `Measure-NoAzModuleNaming` to the function-naming rule,
      adding it to `docs/adr/azure/prefer-az-cli.md` when none exists (check: Test-AnalyzerAdrMap passes).

## Refs

- The articles' "Where the code and the ADR differ" sections under `docs/explanation/` hold each gap in the reader's words.
- `out/drift-triage.md` (session output, not kept) has the verdict and evidence for all 254 claims as of 2026-10-18.
