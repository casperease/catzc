# ADR: Pipeline detection — how functions adapt to their execution context

## Rules: ADR-FLOW-CD-DETECT

### Rule ADR-FLOW-CD-DETECT:1

Never check the pipeline-detection environment variables (`TF_BUILD`, `GITHUB_ACTIONS`) directly. Use `Test-IsRunningInPipeline` so the
detection logic stays in one place.

- [The right approach: a single detection function](#the-right-approach-a-single-detection-function)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-FLOW-CD-DETECT:2

Context-dependent behavior must be intentional and visible — either through `Test-IsRunningInPipeline` in the function body or through a
parameter the caller sets based on context.

- [Decision](#decision)

### Rule ADR-FLOW-CD-DETECT:3

Prefer parameters over detection. When behavior can be controlled via a parameter (e.g. `-OutputPath`), use that; detection is a fallback
for when the caller cannot reasonably supply the value.

- [Companion: Get-OutputRoot](#companion-get-outputroot)

### Rule ADR-FLOW-CD-DETECT:4

Detection is boolean, not modal. `Test-IsRunningInPipeline` returns `$true` or `$false`: if either detection variable is set, the code is in
a pipeline; otherwise it is not.

- [Function](#function)

### Rule ADR-FLOW-CD-DETECT:5

Keep the function fast. It is called frequently, so it only reads two environment variables — no I/O, network, or computation.

- [Function](#function)

## Context

Automation functions run in two contexts: interactively on a developer's machine, and inside a CI/CD pipeline (Azure DevOps Pipelines or
GitHub Actions). Some behavior must differ between these contexts:

- **Output format.** Pipelines need structured logging (`##vso` commands). Interactive sessions need readable console output.
- **Token source.** Pipelines use `$env:SYSTEM_ACCESSTOKEN`. Local runs use `Get-AzAccessToken` (see
  [dual-authentication ADR](dual-authentication.md)).
- **Artifact paths.** Pipelines write to `$env:BUILD_ARTIFACTSTAGINGDIRECTORY`. Local runs write to `out/`.
- **Pipeline variables.** `Set-AdoPipelineVariable` emits `##vso` in a pipeline and is a no-op locally (see
  [pipeline-variables ADR](pipeline-variables.md)).

The question is: how should a function know which context it is in?

### The wrong approach: implicit detection everywhere

If every function that behaves differently in a pipeline has its own `if ($env:TF_BUILD)` check, the detection logic is scattered and
inconsistent. Different functions may check different environment variables, some may check for the variable's existence while others check
its value, some may forget GitHub Actions entirely, and the logic is never tested.

### The right approach: a single detection function

One function answers the question. All other functions call it. The detection logic is in one place, testable, and the environment variables
it checks are an implementation detail.

## Decision

A single `Test-IsRunningInPipeline` function detects the pipeline context. All context-dependent behavior calls this function — never raw
environment variable checks.

### Function

```powershell
function Test-IsRunningInPipeline {
    [OutputType([bool])]
    [CmdletBinding()]
    param()

    # Azure DevOps sets TF_BUILD=True
    # GitHub Actions sets GITHUB_ACTIONS=true
    [bool]$env:TF_BUILD -or [bool]$env:GITHUB_ACTIONS
}
```

`Test-IsRunningInPipeline` lives in `Catzc.Base.Repository`.

`TF_BUILD` is set by the Azure DevOps agent on every pipeline run, and `GITHUB_ACTIONS` is set by the GitHub Actions runner. Neither is set
interactively. Together they are the reliable signal that the code is running in CI/CD. Detection is about _which platform is running the
code_, not about _where output should go_ — those are different questions answered by different variables (see below).

### Companion: Get-OutputRoot

The most common context-dependent path is the output directory. This is a separate concern from detection: _where_ artifacts go in a
pipeline is dictated by the Azure DevOps agent's `BUILD_ARTIFACTSTAGINGDIRECTORY`, not by the detection signal. `Get-OutputRoot` first asks
the detection function whether it is in a pipeline, and only then reads `BUILD_ARTIFACTSTAGINGDIRECTORY` to decide the path:

```powershell
function Get-OutputRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [switch] $EnsureExists
    )

    $outputPath = if ((Test-IsRunningInPipeline) -and $env:BUILD_ARTIFACTSTAGINGDIRECTORY) {
        Assert-PathExist $env:BUILD_ARTIFACTSTAGINGDIRECTORY -PathType Container
        $env:BUILD_ARTIFACTSTAGINGDIRECTORY
    }
    else {
        Join-Path (Get-RepositoryRoot) 'out'
    }

    if ($EnsureExists -and -not (Test-Path $outputPath -PathType Container)) {
        New-Item -Path $outputPath -ItemType Directory | Out-Null
    }

    $outputPath
}
```

Functions that produce output artifacts call `Get-OutputRoot` instead of hardcoding either path. Pass `-EnsureExists` to have the directory
created if it is missing. Note the division of labour: `BUILD_ARTIFACTSTAGINGDIRECTORY` is used here only to resolve the _output location_ —
it is not a detection signal. Detection (am I in a pipeline?) goes through `Test-IsRunningInPipeline`; locating the artifact directory
(where do outputs go?) reads the agent's staging-directory variable directly inside this one function.

### How this is enforced

- **PSScriptAnalyzer custom rule.** A rule flags direct reads of the detection variables — `$env:TF_BUILD` and `$env:GITHUB_ACTIONS` —
  anywhere outside `Test-IsRunningInPipeline`. Context detection must go through the function. (The rule deliberately does _not_ flag
  `$env:BUILD_ARTIFACTSTAGINGDIRECTORY`: that variable answers "where does output go," not "am I in a pipeline," and its read is confined to
  `Get-OutputRoot`.)

## Consequences

- Pipeline detection is consistent. Every function uses the same check, testing the same variables — and both supported platforms (Azure
  DevOps and GitHub Actions) are covered in one place.
- The checked variables are an implementation detail. If a platform changes its agent variables, or another CI platform is added, one
  function changes — not every consumer.
- The function is trivially testable: set `$env:TF_BUILD` (or `$env:GITHUB_ACTIONS`) in a test, assert the result, clean up.
- Context-dependent behavior is greppable: search for `Test-IsRunningInPipeline` to find every place the code branches on execution context.
- Functions that use `Get-OutputRoot` work in both contexts without modification — artifacts land in the right place automatically.

## Dora explains

DORA's research links code maintainability and comprehensive testing to reduced defects and faster deployment cycles. Centralizing platform
detection in a single function keeps context-dependent logic greppable, testable, and consistent, preventing silent cross-platform
mismatches that surface only as cryptic failures deep in deployments.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — centralized detection keeps logic consistent across
  functions.
- [Test automation](https://dora.dev/capabilities/test-automation/) — the detection function is trivially testable and mocks are
  straightforward.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — consistent detection across Azure DevOps and GitHub
  Actions prevents platform-specific failures.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
