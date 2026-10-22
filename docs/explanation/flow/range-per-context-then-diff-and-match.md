---
catzc:
  edges:
    cites:
      - FDR-CD-DETECT-NODIRECTVARIABLECHECK
      - FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT
---

# Check the name, pick the range per context, then diff git and match the paths

```text
Test-GlobSetAffected checks the name, picks a git range per context, then diffs and matches; doubt returns true.

1  Test-GlobSetAffected     the entry: a globset name, one boolean out
2  globs.yml                the registry the name must be in, read through Get-Config
3  not a declared globset   the throw on an undeclared name
4  Get-GlobSetChangeRange   the reference-commit resolver, no parameters
5  the three ranges         HEAD locally, HEAD^1..HEAD post-commit, origin/<target>...HEAD in a pull request
6  $null                    a pull request with no resolvable target: the resolver's fail-open signal
7  Get-ChangedGlobSet       git diff over the range, then every globset that matches a changed path
8  $false                   the named set is not among the touched sets
9  $true                    the named set is touched, or the diff threw and was caught

Supports FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT and FDR-CD-DETECT-NODIRECTVARIABLECHECK (implementation lens).
```

`Test-GlobSetAffected` is a short function with a strict order. It refuses a name it does not know, asks the resolver for the git range the
current context measures a change against, diffs that range, matches the changed paths against the registry, and reports whether the named
globset is among the matches. Two places in that order can be in doubt, the range and the diff, and both resolve to true.

```yml drawio
description:
  Test-GlobSetAffected checks the globset name against the registry, asks the resolver for the git range of the current context, diffs that
  range and matches the paths; an unresolved range or a failed diff answers true.
about:
  adrs: [FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT, FDR-CD-DETECT-NODIRECTVARIABLECHECK]
  lens: implementation
content:
  title: Check the name, pick the range per context, then diff git and match the paths
  kind: explanation
  flow: top-to-bottom
  relation: feeds the next step
  theme: dark
  bands:
    - { id: band-entry, label: ENTRY }
    - { id: band-range, label: RANGE PER CONTEXT }
    - { id: band-diff, label: DIFF AND MATCH }
    - { id: band-answer, label: ANSWER }
  groups:
    - { id: grp-ranges, label: the three ranges, in: band-range }
  glyphs:
    - { id: g-affected, kind: code, label: Test-GlobSetAffected, in: band-entry }
    - { id: g-globs, kind: file, label: globs.yml, in: band-entry }
    - { id: f-undeclared, kind: failure, label: not a declared globset, in: band-entry }
    - { id: g-range, kind: code, label: Get-GlobSetChangeRange, in: band-range }
    - { id: r-head, kind: result, label: HEAD, in: grp-ranges }
    - { id: r-push, kind: result, label: HEAD^1..HEAD, in: grp-ranges }
    - { id: r-pull-request, kind: result, label: origin/<target>...HEAD, in: grp-ranges }
    - { id: g-changed, kind: code, label: Get-ChangedGlobSet, in: band-diff }
    - { id: r-false, kind: result, label: "$false, confirmed untouched", in: band-answer }
    - { id: r-true, kind: result, label: "$true, touched or doubt", in: band-answer }
  edges:
    - { from: g-affected, to: g-globs, kind: flow, label: "" }
    - { from: g-affected, to: f-undeclared, kind: fail, label: undeclared }
    - { from: g-affected, to: g-range, kind: flow, label: "" }
    - { from: g-range, to: grp-ranges, kind: flow, label: "" }
    - { from: grp-ranges, to: g-changed, kind: flow, label: "" }
    - { from: g-changed, to: r-false, kind: flow, label: untouched }
    - { from: g-changed, to: r-true, kind: flow, label: "touched, or git throws" }
    - from: g-range
      to: r-true
      kind: flow
      label: $null
      via:
        - [920, 272]
        - [920, 656]
  markers:
    - { at: g-affected, number: 1 }
    - { at: g-globs, number: 2 }
    - { at: f-undeclared, number: 3 }
    - { at: g-range, number: 4 }
    - { at: grp-ranges, number: 5, corner: top-right }
    - { at: g-range, number: 6, corner: bottom-right }
    - { at: g-changed, number: 7 }
    - { at: r-false, number: 8 }
    - { at: r-true, number: 9 }
  legend: auto
  minimaps:
    code-locations:
      - cell: .claude/.claude/.
        by: [.claude/CLAUDE.md, FDR-CD-DETECT-NODIRECTVARIABLECHECK, FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT]
      - cell: ado-pipelines/pipelines/.
        by:
          - .ado/pipelines/cd-apex.yaml
          - .ado/pipelines/cd-flux.yaml
          - .ado/pipelines/cd-nova.yaml
          - .ado/pipelines/cd-shared.yaml
          - .ado/pipelines/ci-infrastructure.yaml
          - .ado/pipelines/ci-pwsh.yaml
          - FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT
      - cell: ado-pipelines/pipelines/extends
        by: [.ado/pipelines/extends/cd-customer.yaml, FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT]
      - cell: docs/-/.
        by:
          - docs/drs/flow/dora-explains.md
          - docs/drs/flow/durable-sha-globs.md
          - docs/drs/flow/pipeline-detection.md
          - docs/drs/index.md
          - docs/how-to/automation/apply-environment-approvals.md
          - docs/references/ado/pipelines/cd-apex.yaml.md
          - docs/references/ado/pipelines/cd-flux.yaml.md
          - docs/references/ado/pipelines/cd-nova.yaml.md
          - docs/references/ado/pipelines/cd-shared.yaml.md
          - docs/references/ado/pipelines/ci-infrastructure.yaml.md
          - docs/references/ado/pipelines/ci-pwsh.yaml.md
          - docs/references/github/workflows/ci-pwsh.yml.md
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/Get-AdoBuildValidations.ps1.md
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/Register-AdoBuildValidation.ps1.md
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/Unregister-AdoBuildValidation.ps1.md
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/configs/build-validation.yml.md
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/private/Get-BuildValidationPathFilter.ps1.md
          - docs/references/pwsh/catzc-azure-dev-ops/Sync-AdoEnvironmentApprovals.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-BicepDeploymentName.ps1.md
          - docs/references/pwsh/catzc-base-drs/types/DrsConfig.cs.md
          - docs/references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md
          - docs/references/pwsh/catzc-base-globs/Test-GlobSetAffected.ps1.md
          - docs/references/pwsh/catzc-base-globs/configs/globs.yml.md
          - docs/references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md
          - docs/references/pwsh/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md
          - docs/references/pwsh/catzc-base-globs/types/DurableHash.cs.md
          - docs/references/pwsh/catzc-base-globs/types/GlobPattern.cs.md
          - docs/references/pwsh/catzc-base-globs/types/GlobSet.cs.md
          - docs/references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md
          - docs/references/pwsh/catzc-base-maps/Get-LifecyclePositionMinimapData.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT
      - cell: github-workflows/workflows/.
        by: [.github/workflows/ci-pwsh.yml, FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT]
      - cell: pwsh/Catzc.Azure.DevOps/.
        by:
          - pwsh/Catzc.Azure.DevOps/Sync-AdoEnvironmentApprovals.ps1
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT
      - cell: pwsh/Catzc.Azure.DevOps.BuildValidation/.
        by:
          - pwsh/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
          - pwsh/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
          - pwsh/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
          - FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT
      - cell: pwsh/Catzc.Azure.DevOps.BuildValidation/configs
        by: [pwsh/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml, FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT]
      - cell: pwsh/Catzc.Azure.DevOps.BuildValidation/private
        by: [pwsh/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1, FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT]
      - cell: pwsh/Catzc.Azure.Templates/.
        by: [pwsh/Catzc.Azure.Templates/Get-BicepDeploymentName.ps1, FDR-CD-DETECT-NODIRECTVARIABLECHECK]
      - cell: pwsh/Catzc.Base.Drs/configs
        by: [pwsh/Catzc.Base.Drs/configs/drs.yml, FDR-CD-DETECT-NODIRECTVARIABLECHECK, FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT]
      - cell: pwsh/Catzc.Base.Drs/types
        by: [pwsh/Catzc.Base.Drs/types/DrsConfig.cs, FDR-CD-DETECT-NODIRECTVARIABLECHECK, FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT]
      - cell: pwsh/Catzc.Base.Globs/.
        by:
          - pwsh/Catzc.Base.Globs/Get-GlobSetChangeRange.ps1
          - pwsh/Catzc.Base.Globs/Test-GlobSetAffected.ps1
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT
      - cell: pwsh/Catzc.Base.Globs/configs
        by: [pwsh/Catzc.Base.Globs/configs/globs.yml, FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT]
      - cell: pwsh/Catzc.Base.Globs/private
        by: [pwsh/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1, FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT]
      - cell: pwsh/Catzc.Base.Globs/tests
        by: [pwsh/Catzc.Base.Globs/tests/Get-GlobSetChangeRange.Tests.ps1, FDR-CD-DETECT-NODIRECTVARIABLECHECK]
      - cell: pwsh/Catzc.Base.Globs/types
        by:
          - pwsh/Catzc.Base.Globs/types/DurableHash.cs
          - pwsh/Catzc.Base.Globs/types/GlobPattern.cs
          - pwsh/Catzc.Base.Globs/types/GlobSet.cs
          - pwsh/Catzc.Base.Globs/types/GlobsConfig.cs
          - FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT
      - cell: pwsh/Catzc.Base.Maps/.
        by:
          - pwsh/Catzc.Base.Maps/Get-LifecyclePositionMinimapData.ps1
          - pwsh/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
          - pwsh/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT
      - cell: pwsh/Catzc.Base.Maps/tests
        by:
          - pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT
      - cell: pwsh/Catzc.Base.QualityGates/configs
        by:
          - pwsh/Catzc.Base.QualityGates/configs/analyzer-drs-map.yml
          - pwsh/Catzc.Base.QualityGates/configs/terminology.yml
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT
    module-neighbourhood:
      - cell: subject/.claude
        by: [.claude/CLAUDE.md, FDR-CD-DETECT-NODIRECTVARIABLECHECK, FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT]
      - cell: subject/Catzc.Azure.DevOps
        by:
          - pwsh/Catzc.Azure.DevOps/Sync-AdoEnvironmentApprovals.ps1
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT
      - cell: subject/Catzc.Azure.DevOps.BuildValidation
        by:
          - pwsh/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
          - pwsh/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
          - pwsh/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
          - pwsh/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
          - pwsh/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
          - FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT
      - cell: subject/Catzc.Azure.Templates
        by: [pwsh/Catzc.Azure.Templates/Get-BicepDeploymentName.ps1, FDR-CD-DETECT-NODIRECTVARIABLECHECK]
      - cell: subject/Catzc.Base.Drs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - pwsh/Catzc.Base.Drs/types/DrsConfig.cs
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT
      - cell: subject/Catzc.Base.Globs
        by:
          - pwsh/Catzc.Base.Globs/Get-GlobSetChangeRange.ps1
          - pwsh/Catzc.Base.Globs/Test-GlobSetAffected.ps1
          - pwsh/Catzc.Base.Globs/configs/globs.yml
          - pwsh/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1
          - pwsh/Catzc.Base.Globs/tests/Get-GlobSetChangeRange.Tests.ps1
          - pwsh/Catzc.Base.Globs/types/DurableHash.cs
          - pwsh/Catzc.Base.Globs/types/GlobPattern.cs
          - pwsh/Catzc.Base.Globs/types/GlobSet.cs
          - pwsh/Catzc.Base.Globs/types/GlobsConfig.cs
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT
      - cell: subject/Catzc.Base.Maps
        by:
          - pwsh/Catzc.Base.Maps/Get-LifecyclePositionMinimapData.ps1
          - pwsh/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
          - pwsh/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
          - pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT
      - cell: subject/Catzc.Base.QualityGates
        by:
          - pwsh/Catzc.Base.QualityGates/configs/analyzer-drs-map.yml
          - pwsh/Catzc.Base.QualityGates/configs/terminology.yml
          - FDR-CD-DETECT-NODIRECTVARIABLECHECK
          - FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT
      - cell: subject/pipelines
        by:
          - .ado/pipelines/cd-apex.yaml
          - .ado/pipelines/cd-flux.yaml
          - .ado/pipelines/cd-nova.yaml
          - .ado/pipelines/cd-shared.yaml
          - .ado/pipelines/ci-infrastructure.yaml
          - .ado/pipelines/ci-pwsh.yaml
          - .ado/pipelines/extends/cd-customer.yaml
          - FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT
      - cell: subject/workflows
        by: [.github/workflows/ci-pwsh.yml, FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT]
    axis:
      - cell: DSGN/*
        by: [FDR-CD-DETECT-NODIRECTVARIABLECHECK, FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT]
layout:
  band-entry: { x: 20, y: 84, w: 1260, h: 110 }
  band-range: { x: 20, y: 214, w: 1260, h: 230 }
  band-diff: { x: 20, y: 464, w: 1260, h: 110 }
  band-answer: { x: 20, y: 594, w: 1260, h: 110 }
  g-affected: { x: 320, y: 130, w: 300, h: 44 }
  g-globs: { x: 60, y: 126, w: 150, h: 52 }
  f-undeclared: { x: 800, y: 130, w: 220, h: 44 }
  g-range: { x: 320, y: 250, w: 300, h: 44 }
  grp-ranges: { x: 60, y: 316, w: 820, h: 110 }
  r-head: { x: 90, y: 362, w: 210, h: 44 }
  r-push: { x: 350, y: 362, w: 220, h: 44 }
  r-pull-request: { x: 620, y: 362, w: 230, h: 44 }
  g-changed: { x: 320, y: 504, w: 300, h: 44 }
  r-false: { x: 215, y: 634, w: 230, h: 44 }
  r-true: { x: 485, y: 634, w: 230, h: 44 }
```

![Check the name, pick the range per context, then diff git and match the paths](.assets/range-per-context-then-diff-and-match.drawio.png)

## Walkthrough

1. **Test-GlobSetAffected.** The entry takes one mandatory, positional `-Name`, tab-completed from the registry's names, and returns a
   boolean.
2. **globs.yml.** The function reads the registry with `Get-Config -Config globs` and asks whether it contains the name. This happens before
   any git work.
3. **Not a declared globset.** An unknown name throws `Test-GlobSetAffected: '<Name>' is not a declared globset (globs.yml).` A typo is a
   programming error, so it never becomes a silent skip.
4. **Get-GlobSetChangeRange.** The resolver takes no parameters. It asks `Test-IsRunningInPipeline`, which reads `TF_BUILD` and
   `GITHUB_ACTIONS` and nothing else, and then reads the pull-request variables.
5. **The three ranges.** Outside a pipeline the range is `HEAD`, the working tree against the last commit. In a pipeline that is not a pull
   request it is `HEAD^1..HEAD`: main advances only by squash merge, so the first parent is the prior mainline and the diff is exactly the
   push. In a pull request, detected by `SYSTEM_PULLREQUEST_PULLREQUESTID` or a `GITHUB_EVENT_NAME` of `pull_request`, it is
   `origin/<target>...HEAD`, the merge-base range, with the target from `SYSTEM_PULLREQUEST_TARGETBRANCH` (its `refs/heads/` prefix
   stripped) or `GITHUB_BASE_REF`.
6. **$null.** A pull request that names no target yields `$null`, and the function returns true at once: the range is unknown, so the unit
   is treated as affected.
7. **Get-ChangedGlobSet.** With a range, the function calls `Get-ChangedGlobSet -Range`, which resolves the changed paths through
   `Get-ChangedFile`, that is `git -c core.quotepath=off diff --name-only --no-renames <range>`, and returns every declared globset whose
   scan program selects at least one of them. `-IncludeModules` also matches the derived module sets, but the check does not pass it.
8. **$false.** The named set is not among the touched sets. This is the only false the function returns, and it is reached only after git
   answered.
9. **$true.** The named set is among the touched sets. The same answer is returned when git throws, for example on a shallow clone that
   cannot reach `HEAD^1`: `Invoke-Executable` asserts git's exit code, the function catches the error, writes one message naming the range
   and the reason, and proceeds.

## Why it holds

- The change is computed from git at real refs: `Get-ChangedGlobSet` diffs a commit range with `git diff --name-only --no-renames` and
  matches the paths against the registry; `Test-GlobSetAffected` resolves the reference commit per context and fails open on any doubt
  (FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT).
- The context is read through `Test-IsRunningInPipeline`, never from the detection variables directly (FDR-CD-DETECT-NODIRECTVARIABLECHECK).

## See also

- [Globset triggers](../../drs/flow/durable-sha-globs.md) — the decision this article explains.
- [Pipeline detection](../../drs/flow/pipeline-detection.md) — the one detection function the resolver asks.
- The other lenses on the same check: [meta](every-doubt-fails-open-to-proceed.md),
  [architecture](globs-asks-loader-for-context-and-git-for-diff.md), [operations](stop-only-on-false-everything-else-proceeds.md) and
  [governance](tests-pin-the-throw-and-fail-open-cd-calls-it.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
