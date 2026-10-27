# One function answers "am I in a pipeline?", and every branch on context asks it

```text
One function answers "am I in a pipeline?", and every branch on context asks it.

1  pipeline agent              the Azure DevOps agent or the GitHub Actions runner; it sets the signal
2  one detection function      Test-IsRunningInPipeline: reads the signal and answers true or false
3  context-dependent behavior  every function that behaves differently in a pipeline asks it
4  analyzer rule               flags any read of the signal outside the function

Supports ADR-PWSH-DETECT-NODIRECTVARIABLECHECK and ADR-PWSH-DETECT-BOOLEANNOTMODAL (meta lens).
```

Cats runs the same commands on a developer's machine and inside a CI/CD pipeline, and a few of them must behave differently in the two
places: where output goes, whether a pipeline variable is written, which git range counts as the change. Every one of those branches rests
on one question, "am I in a pipeline?", and cats answers it in exactly one function. The function reads the signal the pipeline agent sets,
answers true or false, and an analyzer rule makes sure nobody reads the signal anywhere else.

```yml drawio
description:
  The pipeline agent sets the signal, one detection function reads it and answers true or false, every function that behaves differently in
  a pipeline asks that function, and an analyzer rule flags any read of the signal outside it.
about:
  adrs: [ADR-PWSH-DETECT-NODIRECTVARIABLECHECK, ADR-PWSH-DETECT-BOOLEANNOTMODAL]
  lens: meta
content:
  title: One function answers "am I in a pipeline?", and every branch on context asks it
  kind: explanation
  flow: left-to-right
  theme: dark
  bands:
    - { id: band-platform, label: PLATFORM }
    - { id: band-detection, label: DETECTION }
    - { id: band-consumers, label: CONSUMERS }
    - { id: band-enforcement, label: ENFORCEMENT }
  glyphs:
    - { id: g-agent, kind: runner, label: pipeline agent, in: band-platform }
    - { id: g-detection, kind: code, label: one detection function, in: band-detection }
    - { id: s-behavior, kind: set, label: context-dependent behavior, in: band-consumers }
    - { id: g-analyzer, kind: gate, label: analyzer rule, in: band-enforcement }
  edges:
    - { from: g-agent, to: g-detection, kind: flow, label: calls }
    - { from: g-detection, to: s-behavior, kind: thick, label: "" }
    - { from: s-behavior, to: g-analyzer, kind: flow, label: "" }
  markers:
    - { at: g-agent, number: 1 }
    - { at: g-detection, number: 2 }
    - { at: s-behavior, number: 3 }
    - { at: g-analyzer, number: 4 }
  legend: auto
  minimaps: [code-locations, grid, axis]
layout:
  band-platform: { x: 20, y: 84, w: 300, h: 240 }
  band-detection: { x: 340, y: 84, w: 340, h: 240 }
  band-consumers: { x: 700, y: 84, w: 580, h: 240 }
  band-enforcement: { x: 20, y: 344, w: 1260, h: 120 }
  g-agent: { x: 60, y: 186, w: 220, h: 44 }
  g-detection: { x: 400, y: 186, w: 220, h: 44 }
  s-behavior: { x: 760, y: 186, w: 260, h: 44 }
  g-analyzer: { x: 810, y: 372, w: 160, h: 76 }
```

![One function answers whether the code is in a pipeline](.assets/one-boolean-answer-from-one-function.drawio.png)

## Walkthrough

1. **Pipeline agent.** The Azure DevOps agent sets `TF_BUILD` on every pipeline run, and the GitHub Actions runner sets `GITHUB_ACTIONS`.
   Neither is set on a devbox, so together they are the reliable signal that the code runs in CI/CD.
2. **One detection function.** `Test-IsRunningInPipeline` is the one reader of that signal. It answers a boolean: if either variable is set,
   the code is in a pipeline; otherwise it is not. There is no third mode, and the variables it checks are an implementation detail that
   only this function knows.
3. **Context-dependent behavior.** Every function that behaves differently in a pipeline asks the function instead of the variables: the
   output root, the run environment, the change range, the pipeline-variable writer and twenty more. That makes the branches greppable: a
   search for the function's name finds every place cats branches on its execution context.
4. **Analyzer rule.** `Measure-NoRawPipelineDetection` flags a read of either variable anywhere outside the function as an error, so
   detection cannot drift back into the callers.

## Why it holds

- Never check the detection variables directly; call `Test-IsRunningInPipeline`, so the detection logic stays in one place
  (ADR-PWSH-DETECT-NODIRECTVARIABLECHECK).
- Detection is boolean, not modal: the function returns true or false, and either variable set means a pipeline
  (ADR-PWSH-DETECT-BOOLEANNOTMODAL).
- The function is the one seam between devbox and pipeline, and a command branches on it only where the two environments genuinely differ
  (ADR-AUTO-PARITY-PARITYSEAM).

## See also

- [Pipeline detection](../../drs/automation/pwsh/pipeline-detection.md) — the decision this article explains;
  [Devbox and pipeline parity](../../drs/automation/devbox-pipeline-parity.md) — the seam it keeps.
- The other lenses on the same detector: [architecture](the-loader-holds-the-one-detector.md),
  [implementation](two-variables-read-in-one-place.md), [operations](the-analyzer-names-the-raw-read.md) and
  [governance](one-gate-checks-the-raw-read-rule.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
