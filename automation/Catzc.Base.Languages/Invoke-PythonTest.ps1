<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/Invoke-PythonTest.ps1
    kind: automation-function
    module: Catzc.Base.Languages
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-languages/Invoke-PythonTest.ps1.md
      test: automation/Catzc.Base.Languages/tests/Invoke-PythonTest.Tests.ps1
    adrs:
      - ADR-AUTO-ENGINE
      - ADR-AUTO-ENVVAR#1
      - ADR-AUTO-PY#6
  config:
    synopsis: Runs a catzc module's Python tests and returns one result per Python test.
    description: |-
      In the module's Python test folder, <root>/tests/<module-in-kebab>/ (Catzc.Base.Repository -> catzc-base-repository;
      the Python root is python.yml's `root`, by default python/ when the repository has one, else .python/), runs three uv
      commands from the Python root, the uv workspace root, through Invoke-Executable, each inside its time safeguard (the
      `uv` entry of timeouts.yml). It runs the managed uv by its path: the caller's -UvExecutable, or the one located from
      its tools.yml entry by Resolve-ToolExecutable, never a bare uv off PATH; it throws with "Run Install-Uv" when no uv
      at the pin is found.

        uv sync --all-packages                            makes the workspace's one environment (<root>/.venv) and lock
                                                          from the generated workspace (New-PythonProject);
        uv run --no-sync ruff check tests/<folder>        lints the test files (the go vet of Python);
        uv run --no-sync pytest tests/<folder> ...        runs every test, uncached, with the folder as pytest's rootdir
                                                          and a JUnit XML report.

      uv runs with UV_PYTHON_DOWNLOADS=never, so it uses the uv-managed interpreter at the tools.yml python pin and
      never fetches one silently (the Python form of GOTOOLCHAIN=local; a missing interpreter fails uv sync with the
      remedy Install-Python). Python writes no bytecode into the tree (PYTHONDONTWRITEBYTECODE=1).

      The Python tests are black-box tests: they start the engine and assert on its output. How to start it reaches
      them through the environment (Get-EngineContract), set for these commands only and restored afterwards:

        CATZC_ENGINE_EXECUTABLE  the engine's executable;
        CATZC_ENGINE_START       the arguments after it, as a JSON array that loads the entry — the repository's
                                 importer.ps1 for a source run, or -EntryScript (the build's Import-Catzc.ps1) for a
                                 build run — and ends in the command text, with {command} where the test's command goes;
        CATZC_REPOSITORY_ROOT    the repository root.

      Returns one PythonTestResult per top-level test function (parametrised cases fold into it), with its category
      from its name: test_integrity* is integrity, everything else is logic. A failing test is a result, not an
      error. The call throws, with the uv output, when uv sync or ruff check fails, and when pytest fails without a
      failing test (a collection error, or no tests).
    parameters:
      Module: The catzc module whose Python tests to run (e.g. Catzc.Base.Repository).
      EntryScript: |-
        The engine entry for a build run: the build's Import-Catzc.ps1. Default: the repository's importer.ps1 (the
        source run).
      UvExecutable: |-
        The uv to run, already located and checked against the pin by the caller: a test run passes the uv its source
        session resolved, because a build run's engine does not carry the tools.yml entry. Default: located here by
        Resolve-ToolExecutable.
      Engine: |-
        The execution engine the tests start: pwsh (default) or bash, which reaches catzc through importer.sh's cats
        dispatcher ([ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)). The tests are the same; only the contract
        they read changes.
      EngineExecutable: 'The engine''s executable, already located by the caller. Default: located here by Resolve-EngineExecutable.'
    outputs: '[Catzc.Base.Languages.PythonTestResult] One record per Python test.'
    examples:
      - Invoke-PythonTest Catzc.Base.Repository
      - Invoke-PythonTest Catzc.Base.Repository -EntryScript out/build/Import-Catzc.ps1
---
#>

function Invoke-PythonTest {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Languages.PythonTestResult])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Module,

        [string] $EntryScript,

        [string] $UvExecutable,

        [ArgumentCompleter({ [Catzc.Base.Engines.ExecutionEngines]::Names })]
        [string] $Engine = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name,

        [string] $EngineExecutable
    )

    $root = Get-RepositoryRoot
    $folderName = $Module.ToLowerInvariant().Replace('.', '-')
    $pythonRelative = (Get-Config -Config python).ResolveRoot($root)
    $pythonRoot = Join-Path $root $pythonRelative
    $relative = "$pythonRelative/tests/$folderName"
    $folder = Join-Path $root $relative
    if (-not (Test-Path -LiteralPath $folder -PathType Container)) {
        throw "Module '$Module' has no Python tests: $relative/ does not exist."
    }
    foreach ($project in "$pythonRelative/pyproject.toml", "$relative/pyproject.toml") {
        if (-not (Test-Path -LiteralPath (Join-Path $root $project) -PathType Leaf)) {
            throw "$project is missing — it is generated; regenerate with: Build-RootConfig"
        }
    }

    $uvPath = if ($UvExecutable) {
        Assert-PathExist $UvExecutable -PathType Leaf
        $UvExecutable
    }
    else {
        $uv = Resolve-ToolExecutable -Tool uv
        if (-not $uv.Found) {
            throw 'uv is not installed (no managed uv found). Run Install-Uv.'
        }
        if (-not $uv.VersionOk) {
            throw "uv at $($uv.Path) reports version '$($uv.Version)', but tools.yml pins '$($uv.Required)'. Run Install-Uv."
        }
        $uv.Path
    }
    $uvCommand = "`"$uvPath`""

    $report = Join-Path ([System.IO.Path]::GetTempPath()) "catzc-pytest-$([guid]::NewGuid().ToString('N')).xml"

    $environment = Get-EngineContract -Engine $Engine -EngineExecutable $EngineExecutable -EntryScript $EntryScript
    $environment['UV_PYTHON_DOWNLOADS'] = 'never'
    $environment['PYTHONDONTWRITEBYTECODE'] = '1'
    $saved = @{}
    foreach ($name in $environment.Keys) {
        $saved[$name] = [System.Environment]::GetEnvironmentVariable($name)
        [System.Environment]::SetEnvironmentVariable($name, $environment[$name])
    }
    try {
        $sync = Invoke-Executable "$uvCommand sync --all-packages --quiet" -WorkingDirectory $pythonRoot -PassThru -NoAssert
        if ($sync.ExitCode -ne 0) {
            throw "uv sync failed in $pythonRelative/ (exit $($sync.ExitCode)); is the python pin installed? Run Install-Python.`n$($sync.Full)"
        }

        $lint = Invoke-Executable "$uvCommand run --no-sync --quiet ruff check `"tests/$folderName`"" -WorkingDirectory $pythonRoot -PassThru -NoAssert
        if ($lint.ExitCode -ne 0) {
            throw "ruff check failed in $relative/ (exit $($lint.ExitCode)):`n$($lint.Full)"
        }

        $run = Invoke-Executable ("$uvCommand run --no-sync --quiet pytest `"tests/$folderName`" --rootdir `"tests/$folderName`" " +
            "--import-mode=importlib -p no:cacheprovider --junitxml `"$report`"") -WorkingDirectory $pythonRoot -PassThru -NoAssert
        $reportText = if (Test-Path -LiteralPath $report -PathType Leaf) {
            [System.IO.File]::ReadAllText($report)
        }
        else {
            ''
        }
    }
    finally {
        foreach ($name in $environment.Keys) {
            if ($null -eq $saved[$name]) {
                Remove-Item -LiteralPath "Env:$name" -ErrorAction Ignore
            }
            else {
                [System.Environment]::SetEnvironmentVariable($name, $saved[$name])
            }
        }
        Remove-Item -LiteralPath $report -Force -ErrorAction Ignore
    }

    try {
        $results = @(ConvertFrom-PytestJunit -Text $reportText)
    }
    catch {
        throw "pytest failed in $relative/ (exit $($run.ExitCode)): $($_.Exception.Message)`n$($run.Full)"
    }

    if ($run.ExitCode -ne 0 -and -not ($run.ExitCode -eq 1 -and @($results | Where-Object { $_.Outcome -eq 'fail' }).Count)) {
        throw "pytest failed in $relative/ (exit $($run.ExitCode)) with no failing test:`n$($run.Full)"
    }

    $results
}
