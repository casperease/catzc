# A pipeline step only names a command that a developer can run locally

```text
A pipeline step only names a command, and a developer can run that same command locally.

1  pipeline step  names a command and holds no PowerShell
2  pipeline task  the pipeline host: adds authentication, token and label
3  runner         the one bootstrap: loads the modules once, hands the command over
4  same command   runs with the same modules, in the scope of the load
5  developer      loads the modules and types the same command; no gate checks it

Supports FDR-CD-RUNNER-NOINLINEPOWERSHELL and FDR-CD-RUNNER-DEVELOPERREPRODUCIBLE (meta lens).
```

A pipeline step in cats does not hold PowerShell. It names a command, and one runner turns that name into the same command a developer runs
in a terminal. YAML declares, PowerShell executes, and the string in the step is exactly what a developer types after loading the modules.
That one invariant is what makes every pipeline step reproducible by hand.

```yml drawio
description:
  A pipeline step names a command and holds no PowerShell; the pipeline task adds the authentication and the runner loads the modules once,
  so the command runs exactly as a developer runs it after loading the modules, with no gate checking that.
about:
  adrs: [FDR-CD-RUNNER-NOINLINEPOWERSHELL, FDR-CD-RUNNER-DEVELOPERREPRODUCIBLE]
  lens: meta
content:
  title: A pipeline step only names a command that a developer can run locally
  kind: explanation
  flow: left-to-right
  relation: passes the command on
  theme: dark
  bands:
    - { id: band-pipeline, label: PIPELINE }
    - { id: band-developer, label: DEVELOPER }
  glyphs:
    - { id: g-step, kind: runner, label: pipeline step, in: band-pipeline }
    - { id: g-task, kind: runner, label: pipeline task, in: band-pipeline }
    - { id: g-runner, kind: code, label: runner, in: band-pipeline }
    - { id: g-same-command, kind: code, label: same command, in: band-pipeline }
    - { id: g-developer, kind: actor, label: developer, in: band-developer }
  edges:
    - { from: g-step, to: g-task, kind: flow, label: "" }
    - { from: g-task, to: g-runner, kind: flow, label: "" }
    - { from: g-runner, to: g-same-command, kind: flow, label: "" }
    - { from: g-developer, to: g-same-command, kind: adr, label: "" }
  markers:
    - { at: g-step, number: 1 }
    - { at: g-task, number: 2 }
    - { at: g-runner, number: 3 }
    - { at: g-same-command, number: 4 }
    - { at: g-developer, number: 5 }
  legend: auto
  minimaps:
    code-locations:
      - cell: .claude/.claude/.
        by: [.claude/CLAUDE.md, FDR-CD-RUNNER-DEVELOPERREPRODUCIBLE, FDR-CD-RUNNER-NOINLINEPOWERSHELL]
      - cell: ado-pipelines/pipelines/steps
        by: [.ado/pipelines/steps/invoke-automation.yaml, FDR-CD-RUNNER-DEVELOPERREPRODUCIBLE, FDR-CD-RUNNER-NOINLINEPOWERSHELL]
      - cell: docs/-/.
        by:
          - docs/drs/flow/dora-explains.md
          - docs/drs/flow/pipeline-runner-pattern.md
          - docs/drs/index.md
          - docs/how-to/automation/apply-environment-approvals.md
          - docs/references/ado/pipelines/steps/invoke-automation.yaml.md
          - docs/references/pwsh/catzc-azure-dev-ops/Sync-AdoEnvironmentApprovals.ps1.md
          - docs/references/pwsh/catzc-base-drs/types/DrsConfig.cs.md
          - docs/references/pwsh/catzc-base-maps/Get-LifecyclePositionMinimapData.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
          - FDR-CD-RUNNER-DEVELOPERREPRODUCIBLE
          - FDR-CD-RUNNER-NOINLINEPOWERSHELL
      - cell: pwsh/Catzc.Azure.DevOps/.
        by:
          - pwsh/Catzc.Azure.DevOps/Sync-AdoEnvironmentApprovals.ps1
          - FDR-CD-RUNNER-DEVELOPERREPRODUCIBLE
          - FDR-CD-RUNNER-NOINLINEPOWERSHELL
      - cell: pwsh/Catzc.Base.Drs/configs
        by: [pwsh/Catzc.Base.Drs/configs/drs.yml, FDR-CD-RUNNER-DEVELOPERREPRODUCIBLE, FDR-CD-RUNNER-NOINLINEPOWERSHELL]
      - cell: pwsh/Catzc.Base.Drs/types
        by: [pwsh/Catzc.Base.Drs/types/DrsConfig.cs, FDR-CD-RUNNER-DEVELOPERREPRODUCIBLE, FDR-CD-RUNNER-NOINLINEPOWERSHELL]
      - cell: pwsh/Catzc.Base.Maps/.
        by:
          - pwsh/Catzc.Base.Maps/Get-LifecyclePositionMinimapData.ps1
          - pwsh/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
          - pwsh/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
          - FDR-CD-RUNNER-DEVELOPERREPRODUCIBLE
          - FDR-CD-RUNNER-NOINLINEPOWERSHELL
      - cell: pwsh/Catzc.Base.Maps/tests
        by:
          - pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
          - FDR-CD-RUNNER-DEVELOPERREPRODUCIBLE
          - FDR-CD-RUNNER-NOINLINEPOWERSHELL
    grid:
      - cell: .claude/markdown
        by: [.claude/CLAUDE.md, FDR-CD-RUNNER-DEVELOPERREPRODUCIBLE, FDR-CD-RUNNER-NOINLINEPOWERSHELL]
      - cell: ado-pipelines/pipeline-yaml
        by: [.ado/pipelines/steps/invoke-automation.yaml, FDR-CD-RUNNER-DEVELOPERREPRODUCIBLE, FDR-CD-RUNNER-NOINLINEPOWERSHELL]
      - cell: docs/markdown
        by:
          - docs/drs/flow/dora-explains.md
          - docs/drs/flow/pipeline-runner-pattern.md
          - docs/drs/index.md
          - docs/how-to/automation/apply-environment-approvals.md
          - docs/references/ado/pipelines/steps/invoke-automation.yaml.md
          - docs/references/pwsh/catzc-azure-dev-ops/Sync-AdoEnvironmentApprovals.ps1.md
          - docs/references/pwsh/catzc-base-drs/types/DrsConfig.cs.md
          - docs/references/pwsh/catzc-base-maps/Get-LifecyclePositionMinimapData.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
          - FDR-CD-RUNNER-DEVELOPERREPRODUCIBLE
          - FDR-CD-RUNNER-NOINLINEPOWERSHELL
      - cell: pwsh/bcl
        by: [pwsh/Catzc.Base.Drs/types/DrsConfig.cs, FDR-CD-RUNNER-DEVELOPERREPRODUCIBLE, FDR-CD-RUNNER-NOINLINEPOWERSHELL]
      - cell: pwsh/powershell
        by:
          - pwsh/Catzc.Azure.DevOps/Sync-AdoEnvironmentApprovals.ps1
          - pwsh/Catzc.Base.Maps/Get-LifecyclePositionMinimapData.ps1
          - pwsh/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
          - pwsh/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
          - pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
          - FDR-CD-RUNNER-DEVELOPERREPRODUCIBLE
          - FDR-CD-RUNNER-NOINLINEPOWERSHELL
      - cell: pwsh/yaml
        by: [pwsh/Catzc.Base.Drs/configs/drs.yml, FDR-CD-RUNNER-DEVELOPERREPRODUCIBLE, FDR-CD-RUNNER-NOINLINEPOWERSHELL]
    axis:
      - cell: DSGN/*
        by: [FDR-CD-RUNNER-DEVELOPERREPRODUCIBLE, FDR-CD-RUNNER-NOINLINEPOWERSHELL]
layout:
  band-pipeline: { x: 20, y: 84, w: 1260, h: 130 }
  band-developer: { x: 20, y: 250, w: 1260, h: 130 }
  g-step: { x: 60, y: 124, w: 180, h: 60 }
  g-task: { x: 320, y: 124, w: 180, h: 60 }
  g-runner: { x: 580, y: 124, w: 180, h: 60 }
  g-same-command: { x: 1040, y: 124, w: 200, h: 60 }
  g-developer: { x: 1090, y: 290, w: 100, h: 70 }
```

![A pipeline step only names a command you can run locally](.assets/a-step-only-names-a-command.drawio.png)

## Walkthrough

1. **Pipeline step.** The step names a command and nothing else. The YAML never holds PowerShell logic.
2. **Pipeline task.** The task is the pipeline host. It adds the authentication, the access token and the step's label around the command,
   and passes the command on.
3. **Runner.** The runner is the one bootstrap: it loads the modules once and hands the command over.
4. **Same command.** The command runs with the same modules, in the same scope as the load.
5. **Developer.** A developer loads the modules and types the same command, with no pipeline, no task and no runner in between. No gate
   checks that the two runs match, so this path holds by the FDR alone.

The expected-failures guardrail pipeline is the one sanctioned exception: it calls the runner directly, without a step template, to prove
the runner's own failure modes.

## Why it holds

- YAML steps never contain inline PowerShell; all PowerShell runs through the runner (FDR-CD-RUNNER-NOINLINEPOWERSHELL).
- Whatever string a step names can be pasted into a local terminal after the importer (FDR-CD-RUNNER-DEVELOPERREPRODUCIBLE).

## Where the code and the decision record differ

No gate checks that a step's command runs the same way in a terminal: nothing replays a command outside the runner.

## See also

- [Pipeline runner pattern](../../drs/flow/pipeline-runner-pattern.md) — the decision this article explains.
- The other lenses on the same runner: [architecture](the-runner-is-the-only-seam.md),
  [implementation](three-tasks-one-guard-one-runner.md), [operations](the-step-is-named-after-its-command.md) and
  [governance](no-gate-checks-rules-one-and-four.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
