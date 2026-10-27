# A raw read fails Test-ScriptAnalyzer with one Error line, and CI step 2e asserts the seam

```text
A raw read fails Test-ScriptAnalyzer with one Error line, and CI step 2e asserts the seam.

1  Test-ScriptAnalyzer         the gate a developer runs; the pipeline runs it as the L2 analyzer test
2  out/test-script-analyzer/   the report folder it writes on every run
3  Test-ScriptAnalyzer failed  the one throw, listing every issue line
4  Test-IsRunningInPipeline    CI step 2e asserts it is true on the agent
5  Get-OutputRoot              the same step prints the staging directory it resolves

Supports ADR-PWSH-DETECT-NODIRECTVARIABLECHECK and ADR-PWSH-DETECT-BOOLEANNOTMODAL (operations lens).
```

A developer who writes `if ($env:TF_BUILD)` finds out at the next analyzer run, not in a code review. `Test-ScriptAnalyzer` prints one line
that names the file, the position, the rule and the function to call instead, and then throws. On the agent side the CI pipeline proves the
seam itself: one step asserts that the detector answers true and prints where the output root landed.

```yml drawio
description:
  "What a developer and the pipeline see of the pipeline-detection seam: Test-ScriptAnalyzer on a devbox writes its report or throws once
  with every raw-read line, and a CI step on the agent asserts the detector answers true and prints the staging directory."
about:
  adrs: [ADR-PWSH-DETECT-NODIRECTVARIABLECHECK, ADR-PWSH-DETECT-BOOLEANNOTMODAL]
  lens: operations
content:
  title: A raw read fails Test-ScriptAnalyzer with one Error line, and CI step 2e asserts the seam
  kind: explanation
  flow: top-to-bottom
  theme: dark
  bands:
    - { id: band-devbox, label: DEVBOX }
    - { id: band-pipeline, label: PIPELINE }
  glyphs:
    - { id: g-analyzer, kind: gate, label: Test-ScriptAnalyzer, in: band-devbox }
    - { id: r-report, kind: result, label: out/test-script-analyzer/, in: band-devbox }
    - { id: x-failed, kind: failure, label: Test-ScriptAnalyzer failed, in: band-devbox }
    - { id: c-in-pipeline, kind: code, label: Test-IsRunningInPipeline, in: band-pipeline }
    - { id: r-true, kind: result, label: $true, in: band-pipeline }
    - { id: c-output-root, kind: code, label: Get-OutputRoot, in: band-pipeline }
    - { id: r-staging, kind: result, label: staging directory, in: band-pipeline }
  edges:
    - { from: g-analyzer, to: r-report, kind: flow, label: "" }
    - { from: g-analyzer, to: x-failed, kind: fail, label: "" }
    - { from: c-in-pipeline, to: r-true, kind: flow, label: "" }
    - { from: c-output-root, to: r-staging, kind: flow, label: "" }
  markers:
    - { at: g-analyzer, number: 1 }
    - { at: r-report, number: 2 }
    - { at: x-failed, number: 3 }
    - { at: c-in-pipeline, number: 4 }
    - { at: c-output-root, number: 5 }
  legend: auto
  minimaps: [code-locations, module-neighbourhood, axis]
layout:
  band-devbox: { x: 20, y: 84, w: 1260, h: 180 }
  band-pipeline: { x: 20, y: 284, w: 1260, h: 180 }
  g-analyzer: { x: 200, y: 136, w: 220, h: 84 }
  r-report: { x: 560, y: 118, w: 280, h: 44 }
  x-failed: { x: 560, y: 200, w: 280, h: 44 }
  c-in-pipeline: { x: 200, y: 318, w: 220, h: 44 }
  r-true: { x: 560, y: 318, w: 280, h: 44 }
  c-output-root: { x: 200, y: 400, w: 220, h: 44 }
  r-staging: { x: 560, y: 400, w: 280, h: 44 }
```

![The analyzer names the raw read](.assets/the-analyzer-names-the-raw-read.drawio.png)

## Walkthrough

1. **Test-ScriptAnalyzer.** Run it from a session that has dot-sourced the importer. It analyzes the automation PowerShell with the one
   settings file, sharded across background processes with live progress. The same analysis runs in the pipeline as the L2
   `PSScriptAnalyzer` test inside `Test-Automation`, so devbox and pipeline see the same result.
2. **out/test-script-analyzer/.** The gate writes its report there on every run and prints every issue, each as
   `<path>:<line>:<col> <severity> <rule> <message>`, with the path relative to the repository root.
3. **Test-ScriptAnalyzer failed.** With issues it throws once, `Test-ScriptAnalyzer failed: N issue(s)`, followed by the folder and every
   line. A raw read produces an `Error` from `Measure-NoRawPipelineDetection` whose message opens with
   `Do not read the pipeline-detection variable '$env:TF_BUILD' directly.` and goes on to say: call `Test-IsRunningInPipeline` so detection
   stays in one place and both Azure DevOps and GitHub Actions are covered.
4. **Test-IsRunningInPipeline.** Step 2e of `.ado/pipelines/ci-pwsh.yaml`, named "Pipeline detection and output root", runs
   `Assert-True (Test-IsRunningInPipeline)` on the agent, where `TF_BUILD` is set.
5. **Get-OutputRoot.** The same step calls `Get-OutputRoot`, asserts that the folder exists, and prints `OutputRoot: <path>`. On the agent
   that path is the staging directory; on a devbox the same call returns `out/`. `Get-RunEnvironment` is the readable form of the same
   answer, `Pipeline` or `Devbox`.

## Why it holds

- Never check the detection variables directly; the analyzer rule turns a raw read into an error a developer sees at once
  (ADR-PWSH-DETECT-NODIRECTVARIABLECHECK).
- Detection is boolean, so the pipeline can assert it with one `Assert-True` (ADR-PWSH-DETECT-BOOLEANNOTMODAL).
- Both environments are checked equally: the analyzer runs on the devbox and in the pipeline, and the two must agree
  (ADR-AUTO-PARITY-CHECKEDEQUALLY).

## See also

- [Pipeline detection](../../drs/automation/pwsh/pipeline-detection.md) — the decision this article explains;
  [Devbox and pipeline parity](../../drs/automation/devbox-pipeline-parity.md) — the seam it keeps.
- The other lenses on the same detector: [meta](one-boolean-answer-from-one-function.md),
  [architecture](the-loader-holds-the-one-detector.md), [implementation](two-variables-read-in-one-place.md) and
  [governance](one-gate-checks-the-raw-read-rule.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
