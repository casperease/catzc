# ADR: Pipeline detection — how pwsh functions learn their execution context

## Rules: ADR-PWSH-DETECT

### Rule ADR-PWSH-DETECT-NODIRECTVARIABLECHECK

Never read a CI engine's run-mark environment variable directly. Call `Test-IsRunningInPipeline`, the one reader of every run mark, so the
detection logic stays in one place.

- [One detection function](#one-detection-function)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-DETECT-VISIBLECONTEXTBEHAVIOUR

Context-dependent behaviour is intentional and visible: either through `Test-IsRunningInPipeline` in the function body or through a
parameter the caller sets based on context.

- [Decision](#decision)

### Rule ADR-PWSH-DETECT-PARAMETERSOVERDETECTION

Prefer parameters over detection. When behaviour can be controlled by a parameter (for example `-OutputPath`), use that; detection is the
fallback for when the caller cannot reasonably supply the value.

- [Companion: Get-OutputRoot](#companion-get-outputroot)

### Rule ADR-PWSH-DETECT-BOOLEANNOTMODAL

Detection is boolean, not modal. `Test-IsRunningInPipeline` returns `$true` or `$false`: when any run mark is set, the code is in a
pipeline; otherwise it is not.

- [Function](#function)

### Rule ADR-PWSH-DETECT-FASTDETECTION

Keep the function fast. It is called often, so it reads the run-mark variables and nothing else: no I/O, network, or computation.

- [Function](#function)

## Context

The automation runs in two contexts: interactively on a developer's machine, and inside a CI/CD pipeline. Some behaviour differs between
them: the output format, the token source, the artifact path, and whether a pipeline variable is emitted. Each CI engine marks its runs
with an environment variable of its own, and the engine's domain names it. The question is how a pwsh function knows which context it is
in.

### Implicit detection

`The wrong approach: implicit detection everywhere`

When every function that behaves differently in a pipeline reads a run mark itself, the detection logic is scattered and inconsistent.
Different functions check different variables, some test the variable's existence and others its value, some miss an engine entirely, and
the logic is never tested.

### One detection function

`The right approach: a single detection function`

One function answers the question and every other function calls it. The detection logic is in one place and testable, and the variables it
reads are an implementation detail. The same shape serves every host mark: `Test-IsRunningInVsCode` is the one reader of VS Code's terminal
mark (`TERM_PROGRAM`), beside the pipeline reader in the loader, and the same analyzer rule flags a raw read of either.

## Decision

A single `Test-IsRunningInPipeline` function detects the pipeline context. All context-dependent behaviour calls this function, never a raw
environment variable check.

### Function

```powershell
function Test-IsRunningInPipeline {
    [OutputType([bool])]
    [CmdletBinding()]
    param()

    [bool]$env:TF_BUILD -or [bool]$env:GITHUB_ACTIONS
}
```

`Test-IsRunningInPipeline` lives in `Catzc.Internal.Loader`, the `.internal` library that both run modes import first and keep loaded. The
importer's C#-types pre-pass runs before any `Catzc` module loads, and it calls the same function as every module.

Each variable it reads is one CI engine's run mark: set by that engine on every run and never set interactively. Detection is about _which
platform is running the code_, not about _where output should go_; those are different questions answered by different variables.

### Companion: Get-OutputRoot

The most common context-dependent path is the output directory, a separate concern from detection: _where_ artifacts go in a pipeline is
dictated by the engine's staging-directory variable, not by the run mark. `Get-OutputRoot` first asks the detection function whether it is
in a pipeline, and only then reads the staging directory to decide the path:

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

Functions that produce output artifacts call `Get-OutputRoot` instead of hardcoding either path; `-EnsureExists` creates the directory when
it is missing.

### How this is enforced

- **PSScriptAnalyzer custom rule.** `Measure-NoRawPipelineDetection` flags a direct read of a run-mark variable anywhere outside
  `Test-IsRunningInPipeline`. The rule does _not_ flag the staging-directory variable: it answers "where does output go", not "am I in a
  pipeline", and its read is confined to `Get-OutputRoot`.

## Consequences

- Pipeline detection is consistent: every function uses the same check over the same variables, and every supported engine is covered in
  one place.
- The variables read are an implementation detail. When an engine changes its run mark, or another engine is added, one function changes,
  not every consumer.
- The function is trivially testable: set a run-mark variable in a test, assert the result, clean up.
- Context-dependent behaviour is greppable: a search for `Test-IsRunningInPipeline` finds every place the code branches on execution
  context.
- Functions that use `Get-OutputRoot` work in both contexts without modification.
