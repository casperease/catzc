<#
.SYNOPSIS
    Runs a catzc module's Python tests and returns one result per Python test.
.DESCRIPTION
    In the module's Python test folder, <root>/tests/<module-in-kebab>/ (Catzc.Base.Repository ->...
    [comment:1](/docs/references/automation/catzc-base-languages/Invoke-PythonTest.ps1.md#comment1)
.PARAMETER Module
    The catzc module whose Python tests to run (e.g. Catzc.Base.Repository).
.PARAMETER EntryScript
    The engine entry for a build run: the build's Import-Catzc.ps1.
    [comment:2](/docs/references/automation/catzc-base-languages/Invoke-PythonTest.ps1.md#comment2)
.PARAMETER UvExecutable
    The uv to run, already located and checked against the pin by the caller: a test run passes the uv its source...
    [comment:3](/docs/references/automation/catzc-base-languages/Invoke-PythonTest.ps1.md#comment3)
.PARAMETER Engine
    The execution engine the tests start: pwsh (default) or bash, which reaches catzc through importer.sh's cats...
    [ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)
    [comment:4](/docs/references/automation/catzc-base-languages/Invoke-PythonTest.ps1.md#comment4)
.PARAMETER EngineExecutable
    The engine's executable, already located by the caller. Default: located here by Resolve-EngineExecutable.
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

        [string] $UvExecutable,

        [ArgumentCompleter({ [Catzc.Base.Engines.ExecutionEngines]::Names })]
        [string] $Engine = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name,

        [string] $EngineExecutable
    )

    $root = Get-RepositoryRoot
    $folderName = $Module.ToLowerInvariant().Replace('.', '-')
    # The Python root from python.yml (PythonConfig.ResolveRoot: the declared root, else python/ when present,...
    # [comment:5](/docs/references/automation/catzc-base-languages/Invoke-PythonTest.ps1.md#comment5)
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

    # The managed uv, by its path: the caller's, already located and checked, or located here from its tools.yml...
    # [comment:6](/docs/references/automation/catzc-base-languages/Invoke-PythonTest.ps1.md#comment6)
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

    # How the tests start the engine (Get-EngineContract) is an external contract with the test processes: set for...
    # [ADR-AUTO-ENVVAR#1](/docs/adr/automation/environment-variables.md#rule-adr-auto-envvar1),
    # [ADR-AUTO-PY#6](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py6)
    # [comment:7](/docs/references/automation/catzc-base-languages/Invoke-PythonTest.ps1.md#comment7)
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

    # pytest exits 1 when a test failed; any other non-zero exit, or 1 with no failing test, means it failed around...
    # [comment:8](/docs/references/automation/catzc-base-languages/Invoke-PythonTest.ps1.md#comment8)
    if ($run.ExitCode -ne 0 -and -not ($run.ExitCode -eq 1 -and @($results | Where-Object { $_.Outcome -eq 'fail' }).Count)) {
        throw "pytest failed in $relative/ (exit $($run.ExitCode)) with no failing test:`n$($run.Full)"
    }

    $results
}
