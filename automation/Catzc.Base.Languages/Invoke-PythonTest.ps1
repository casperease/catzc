<#
.SYNOPSIS
    Runs a catzc module's Python tests and returns one result per Python test.
.DESCRIPTION
    In the module's Python test folder, python/tests/<module-in-kebab>/ (Catzc.Base.Repository ->
    catzc-base-repository), runs three uv commands from the Python root, python/, through Invoke-Executable, each
    inside its time safeguard (the `uv` entry of timeouts.yml). It runs the managed uv by its path: the caller's
    -UvExecutable, or the one located from its tools.yml entry by Resolve-ToolExecutable, never a bare uv off PATH;
    it throws with "Run Install-Uv" when no uv at the pin is found.

      uv sync                                     makes the project environment (python/.venv) and lock from the
                                                  generated python/pyproject.toml;
      uv run ruff check tests/<folder>            lints the test sources (the go vet of Python);
      uv run pytest tests/<folder> --junitxml ... runs every test, uncached, with the folder as pytest's rootdir.

    uv runs with UV_PYTHON_DOWNLOADS=never, so it uses the uv-managed interpreter at the tools.yml python pin and
    never fetches one silently (the Python form of GOTOOLCHAIN=local; a missing interpreter fails uv sync with the
    remedy Install-Python). Python writes no bytecode into the tree (PYTHONDONTWRITEBYTECODE=1).

    The Python tests are black-box tests: they start the engine and assert on its output. The engine entry reaches
    them through the environment, set for these commands only and restored afterwards:

      CATZC_ENGINE_ENTRY     the script a test runs to load the engine: the repository's importer.ps1 for a source
                             run, or -EntryScript (the build's Import-Catzc.ps1) for a build run;
      CATZC_REPOSITORY_ROOT  the repository root.

    Returns one PythonTestResult per top-level test function (parametrised cases fold into it), with its category
    from its name: test_integrity* is integrity, everything else is logic. A failing test is a result, not an
    error. The call throws, with the uv output, when uv sync or ruff check fails, and when pytest fails without a
    failing test (a collection error, or no tests).
.PARAMETER Module
    The catzc module whose Python tests to run (e.g. Catzc.Base.Repository).
.PARAMETER EntryScript
    The engine entry for a build run: the build's Import-Catzc.ps1. Default: the repository's importer.ps1 (the
    source run).
.PARAMETER UvExecutable
    The uv to run, already located and checked against the pin by the caller: a test run passes the uv its source
    session resolved, because a build run's engine does not carry the tools.yml entry. Default: located here by
    Resolve-ToolExecutable.
.OUTPUTS
    [Catzc.Base.Languages.PythonTestResult] One record per Python test.
.EXAMPLE
    Invoke-PythonTest Catzc.Base.Repository
.EXAMPLE
    Invoke-PythonTest Catzc.Base.Repository -EntryScript out/build/Import-Catzc.ps1
#>
function Invoke-PythonTest {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Languages.PythonTestResult])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Module,

        [string] $EntryScript,

        [string] $UvExecutable
    )

    $root = Get-RepositoryRoot
    $folderName = $Module.ToLowerInvariant().Replace('.', '-')
    $pythonRoot = Join-Path $root ([Catzc.Base.Languages.PythonConfig]::Root)
    $relative = "$([Catzc.Base.Languages.PythonConfig]::Root)/tests/$folderName"
    $folder = Join-Path $root $relative
    if (-not (Test-Path -LiteralPath $folder -PathType Container)) {
        throw "Module '$Module' has no Python tests: $relative/ does not exist."
    }
    if (-not (Test-Path -LiteralPath (Join-Path $pythonRoot 'pyproject.toml') -PathType Leaf)) {
        throw "$([Catzc.Base.Languages.PythonConfig]::Root)/pyproject.toml is missing — it is generated; regenerate with: Build-RootConfig"
    }

    # The managed uv, by its path: the caller's, already located and checked, or located here from its tools.yml entry
    # (Resolve-ToolExecutable); never a bare uv off PATH.
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

    $entry = if ($EntryScript) {
        Assert-PathExist $EntryScript -PathType Leaf
        (Resolve-Path -LiteralPath $EntryScript).ProviderPath
    }
    else {
        Join-Path $root 'importer.ps1'
    }

    $report = Join-Path ([System.IO.Path]::GetTempPath()) "catzc-pytest-$([guid]::NewGuid().ToString('N')).xml"

    # The engine entry is an external contract with the test processes
    # ([ADR-AUTO-ENVVAR#1](/docs/adr/automation/environment-variables.md#rule-adr-auto-envvar1)): set for these
    # commands only, then restored. UV_PYTHON_DOWNLOADS=never keeps uv on the managed interpreter at the pin
    # (ADR-AUTO-PY#6).
    $environment = [ordered]@{
        CATZC_ENGINE_ENTRY      = $entry
        CATZC_REPOSITORY_ROOT   = $root
        UV_PYTHON_DOWNLOADS     = 'never'
        PYTHONDONTWRITEBYTECODE = '1'
    }
    $saved = @{}
    foreach ($name in $environment.Keys) {
        $saved[$name] = [System.Environment]::GetEnvironmentVariable($name)
        [System.Environment]::SetEnvironmentVariable($name, $environment[$name])
    }
    try {
        $sync = Invoke-Executable "$uvCommand sync --quiet" -WorkingDirectory $pythonRoot -PassThru -NoAssert
        if ($sync.ExitCode -ne 0) {
            throw "uv sync failed in $([Catzc.Base.Languages.PythonConfig]::Root)/ (exit $($sync.ExitCode)); is the python pin installed? Run Install-Python.`n$($sync.Full)"
        }

        $lint = Invoke-Executable "$uvCommand run --quiet ruff check `"tests/$folderName`"" -WorkingDirectory $pythonRoot -PassThru -NoAssert
        if ($lint.ExitCode -ne 0) {
            throw "ruff check failed in $relative/ (exit $($lint.ExitCode)):`n$($lint.Full)"
        }

        $run = Invoke-Executable ("$uvCommand run --quiet pytest `"tests/$folderName`" --rootdir `"tests/$folderName`" " +
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

    # pytest exits 1 when a test failed; any other non-zero exit, or 1 with no failing test, means it failed around
    # the tests (a usage or collection error, or no tests collected: exit 5).
    if ($run.ExitCode -ne 0 -and -not ($run.ExitCode -eq 1 -and @($results | Where-Object { $_.Outcome -eq 'fail' }).Count)) {
        throw "pytest failed in $relative/ (exit $($run.ExitCode)) with no failing test:`n$($run.Full)"
    }

    $results
}
