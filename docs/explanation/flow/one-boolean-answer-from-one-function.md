# One function answers "am I in a pipeline?", and every branch on context asks it

```text
One function answers "am I in a pipeline?", and every branch on context asks it.

1  pipeline agent              the Azure DevOps agent or the GitHub Actions runner; it sets the signal
2  one detection function      Test-IsRunningInPipeline: reads the signal and answers true or false
3  context-dependent behavior  every function that behaves differently in a pipeline asks it
4  analyzer rule               flags any read of the signal outside the function

Supports FDR-CD-DETECT-NODIRECTVARIABLECHECK and FDR-CD-DETECT-BOOLEANNOTMODAL (meta lens).
```

Cats runs the same commands on a developer's machine and inside a CI/CD pipeline, and a few of them must behave differently in the two
places: where output goes, whether a pipeline variable is written, which git range counts as the change. Every one of those branches rests
on one question, "am I in a pipeline?", and cats answers it in exactly one function. The function reads the signal the pipeline agent sets,
answers true or false, and an analyzer rule makes sure nobody reads the signal anywhere else.

![One function answers whether the code is in a pipeline](.assets/one-boolean-answer-from-one-function/diagram.drawio.png)

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
  (FDR-CD-DETECT-NODIRECTVARIABLECHECK).
- Detection is boolean, not modal: the function returns true or false, and either variable set means a pipeline
  (FDR-CD-DETECT-BOOLEANNOTMODAL).
- The function is the one seam between devbox and pipeline, and a command branches on it only where the two environments genuinely differ
  (ADR-AUTO-PARITY-ONESEAM).

## See also

- [Pipeline detection](../../adr/flow/pipeline-detection.md) — the decision this article explains;
  [Devbox and pipeline parity](../../adr/automation/devbox-pipeline-parity.md) — the seam it keeps.
- The other lenses on the same detector: [architecture](the-loader-holds-the-one-detector.md),
  [implementation](two-variables-read-in-one-place.md), [operations](the-analyzer-names-the-raw-read.md) and
  [governance](one-gate-checks-the-raw-read-rule.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
