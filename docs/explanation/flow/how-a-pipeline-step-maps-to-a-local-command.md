# How a pipeline step maps to a local command

```text
How a pipeline step maps to a local command.

1  pipeline step  names a command and holds no PowerShell
2  pipeline task  the pipeline host: adds authentication, token and label
3  runner         the one bootstrap: loads the modules once, hands the command over
4  same command   runs with the same modules, in the scope of the load
5  developer      loads the modules and types the same command; no gate checks it

Supports ADR-ADO-RUNNER-NOINLINEPOWERSHELL and ADR-ADO-RUNNER-DEVELOPERREPRODUCIBLE (meta lens).
```

A pipeline step in cats does not hold PowerShell. It names a command, and one runner turns that name into the same command a developer runs
in a terminal. YAML declares, PowerShell executes, and the string in the step is exactly what a developer types after loading the modules.
That one invariant is what makes every pipeline step reproducible by hand.

```yml drawio
description:
  A pipeline step names a command and holds no PowerShell; the pipeline task adds the authentication and the runner loads the modules once,
  so the command runs exactly as a developer runs it after loading the modules, with no gate checking that.
about:
  rules: [ADR-ADO-RUNNER-NOINLINEPOWERSHELL, ADR-ADO-RUNNER-DEVELOPERREPRODUCIBLE]
  lens: meta
content:
  title: How a pipeline step maps to a local command
  kind: explanation
  flow: left-to-right
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
    - { from: g-step, to: g-task, kind: flow, label: calls }
    - { from: g-task, to: g-runner, kind: flow, label: calls }
    - { from: g-runner, to: g-same-command, kind: flow, label: calls }
    - { from: g-developer, to: g-same-command, kind: record, label: "" }
  markers:
    - { at: g-step, number: 1 }
    - { at: g-task, number: 2 }
    - { at: g-runner, number: 3 }
    - { at: g-same-command, number: 4 }
    - { at: g-developer, number: 5 }
  legend: auto
  minimaps: [code-locations, grid, axis]
layout:
  band-pipeline: { x: 20, y: 84, w: 1260, h: 130 }
  band-developer: { x: 20, y: 250, w: 1260, h: 130 }
  g-step: { x: 60, y: 124, w: 180, h: 60 }
  g-task: { x: 320, y: 124, w: 180, h: 60 }
  g-runner: { x: 580, y: 124, w: 180, h: 60 }
  g-same-command: { x: 1040, y: 124, w: 200, h: 60 }
  g-developer: { x: 1090, y: 290, w: 100, h: 70 }
```

![How a pipeline step maps to a local command](.assets/how-a-pipeline-step-maps-to-a-local-command.drawio.png)

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

- YAML steps never contain inline PowerShell; all PowerShell runs through the runner (ADR-ADO-RUNNER-NOINLINEPOWERSHELL).
- Whatever string a step names can be pasted into a local terminal after the importer (ADR-ADO-RUNNER-DEVELOPERREPRODUCIBLE).

## Where the code and the decision record differ

No gate checks that a step's command runs the same way in a terminal: nothing replays a command outside the runner.

## See also

- [Pipeline runner pattern](../../drs/ado/pipeline-runner-pattern.md) — the decision this article explains.
- The other lenses on the same runner: [architecture](how-pipeline-yaml-enters-powershell.md),
  [implementation](three-tasks-one-guard-one-runner.md), [operations](the-step-is-named-after-its-command.md) and
  [governance](no-gate-checks-rules-one-and-four.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
