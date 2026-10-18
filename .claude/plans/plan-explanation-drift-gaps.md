---
plan:
  status: active
  value: medium
  reviewed: 2026-10-18
  targets:
    [
      automation/Catzc.Azure.DevOps/Get-AdoAuthorizationHeader.ps1,
      automation/Catzc.Base.Maps/Get-WorldMap.ps1,
      automation/Catzc.Base.Globs/Test-GlobSetAffected.ps1,
      automation/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1,
      docs/explanation,
    ]
---

# Explanation drift: the gaps between the code and the ADRs

The explanation articles under `docs/explanation/` close with a "Where the code and the ADR differ" section. On 2026-10-18 every claim in
those sections was checked against the tree: the stale ones were dropped or reworded, and the help-text mistakes were fixed at their source
on the reference pages. What is left is real: the code and an ADR disagree, and one of them has to change. This plan holds those gaps.

## Why its value is medium

Each gap is a place where a reader of an ADR is told something the code does not do. None breaks a build today, but the deploy-path gaps (Q1
to Q3) mean the CD and BVT rules are partly prose, and every gap stays visible in up to five lens articles until it closes.

## Done, and why

- 2026-10-18: 254 claims triaged; 8 dropped, 16 reworded, and 18 more dropped after their help texts were fixed on the reference pages
  (config addressing, globset hash, Bicep context path, name patterns, `Get-AdoNaming`, `Get-BicepResourceName`, `Register-AdoPipeline`, the
  fail-open and projection citations). Test-MarkdownTitle, Test-Links and Test-Markdownlint report 0 on every edited file.

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

## Open questions (a decision each: change the code, or amend the ADR)

- Q1. The in-pipeline change check. ADR-FLOW-CD-GLOBS#9 has a pipeline run `Test-GlobSetAffected` first, with `fetchDepth: 0`. No pipeline
  or workflow calls it, and no Azure DevOps pipeline sets `fetchDepth`. Wire it into the CD stages, or state in the ADR that it is available
  and not yet wired?
- Q2. The BVT. ADR-AUTO-TEST#24 puts `Test-BuildArtifact` in the BVT; no pipeline runs it. Wire it, or narrow the rule?
- Q3. The promotion ladder. ADR-DSGN-LIFE and ADR-FLOW-CD describe main-uat, release-uat, RC and RBC gates, pre-prod staging and a DEPLOY
  pipeline, and keep CD inside non-prod. `cd-apex.yaml` and `cd-shared.yaml` deploy `psub`, and apex's expedition `prod`, in the CD run.
  Build the ladder, or record the current single-run CD as the decision?
- Q4. Run modes. ADR-DSGN-RUNMODE names `Write-CatzcLoadBanner`, a root `build-catzc.ps1` and a cached build kind derived from the code
  root; none exists. Build them, or drop them from the ADR?
- Q5. The Bash time safeguard. ADR-AUTO-FAILFAST says no shell call starts without a limit and lets an exemption raise an agent's bash
  limit. The hook fails open on its own error or when unbuilt, never reads `timeout-exemptions.yml`, and is not published in a pipeline;
  `Invoke-Executable -Direct` has no limit. Which of these does the ADR accept?
- Q6. Who binds a pipeline. ADR-DSGN-TRACK binds a pipeline to a track only through its deployable-unit; ADR-FLOW-CD-GLOBS and `globs.yml`
  let the CI pipelines bind the `automation` and `infrastructure` loose-fileset track sets directly. Which ADR gives way?
- Q7. Path types (ADR-AUTO-PATH). `ArtifactRef` has no production caller, `ExistsAt` returns a Boolean where the ADR says it asserts,
  `RepoRelativePath` stores only the relative form, and `Resolve-RepoPath` returns a rooted input un-normalized.
- Q8. Naming. ADR-AZ-NAMING says the length throw names the components to shorten; `Get-AzureResourceName` always lists the same four. The
  analyzer map credits `Measure-NoAzModuleNaming` to ADR-AZ-CLI#3 (no `Import-Module Az.*`), but the rule checks function names.

## Refs

- The articles' "Where the code and the ADR differ" sections under `docs/explanation/` hold each gap in the reader's words.
- `out/drift-triage.md` (session output, not kept) has the verdict and evidence for all 254 claims as of 2026-10-18.
