<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Invoke-PythonWorkspaceTool.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Invoke-PythonWorkspaceTool.Tests.ps1
    adrs:
      - ADR-AUTO-PY#8
  config:
    synopsis: Runs a tool from the Python test workspace's pinned environment (ruff), against any .py files in the repository.
    description: |-
      The Python checks run one pinned tool set for every .py file the repository tracks — the Python tests, and the agent
      helpers under .claude/ ([ADR-AUTO-PY#8](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py8)).
      The tools are the workspace's dependencies (python.yml), so this syncs the workspace once (`uv sync --all-packages`)
      and runs `uv run --no-sync <tool> <arguments> --config pyproject.toml <files>` from the workspace root, the Python
      root: the explicit --config gives every file the workspace's ruff settings (the 140-column line, the pinned Python),
      wherever it lives.

      uv is the managed uv (Resolve-ToolExecutable, the tools.yml `uv` entry), run with UV_PYTHON_DOWNLOADS=never so it
      never fetches an interpreter; the variable is restored afterwards. Throws with "Run Install-Uv" when no uv at the pin
      is found, and with uv's output when the sync fails (a missing interpreter names Install-Python).
    parameters:
      Tool: The tool and its subcommand words, e.g. 'ruff format --check' or 'ruff check'.
      File: The files and folders to run it on, as full paths.
    outputs: '[Catzc.Base.Execution.CliResult] The tool''s result; a non-zero exit is the caller''s to read.'
    examples:
      - '$check = Invoke-PythonWorkspaceTool -Tool ''ruff check'' -File $files'
---
#>

function Invoke-PythonWorkspaceTool {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Execution.CliResult])]
    param(
        [Parameter(Mandatory)]
        [string] $Tool,

        [Parameter(Mandatory)]
        [string[]] $File
    )

    $uv = Resolve-ToolExecutable -Tool uv
    if (-not ($uv.Found -and $uv.VersionOk)) {
        throw "The Python checks need the managed uv at the tools.yml pin '$($uv.Required)' (found: $($uv.Version ?? 'none')). Run Install-Uv."
    }
    $repositoryRoot = Get-RepositoryRoot
    $pythonRelative = (Get-Config -Config python).ResolveRoot($repositoryRoot)
    $pythonRoot = Join-Path $repositoryRoot $pythonRelative
    if (-not (Test-Path -LiteralPath (Join-Path $pythonRoot 'pyproject.toml') -PathType Leaf)) {
        throw "$pythonRelative/pyproject.toml is missing — the Python test workspace is generated; regenerate with: Build-RootConfig"
    }
    $uvCommand = "`"$($uv.Path)`""
    $quoted = ($File | ForEach-Object { "`"$_`"" }) -join ' '

    $saved = [System.Environment]::GetEnvironmentVariable('UV_PYTHON_DOWNLOADS')
    [System.Environment]::SetEnvironmentVariable('UV_PYTHON_DOWNLOADS', 'never')
    try {
        $sync = Invoke-Executable "$uvCommand sync --all-packages --quiet" -WorkingDirectory $pythonRoot -PassThru -NoAssert -Silent
        if ($sync.ExitCode -ne 0) {
            throw "uv sync failed in $pythonRelative/ (exit $($sync.ExitCode)); is the python pin installed? Run Install-Python.`n$($sync.Full)"
        }
        Invoke-Executable "$uvCommand run --no-sync --quiet $Tool --config pyproject.toml $quoted" -WorkingDirectory $pythonRoot -PassThru -NoAssert -Silent
    }
    finally {
        if ($null -eq $saved) {
            Remove-Item -LiteralPath Env:UV_PYTHON_DOWNLOADS -ErrorAction Ignore
        }
        else {
            [System.Environment]::SetEnvironmentVariable('UV_PYTHON_DOWNLOADS', $saved)
        }
    }
}
