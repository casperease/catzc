<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Invoke-PythonWorkspaceTool.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-PY#8
---
#>

<#
.SYNOPSIS
    Runs a tool from the Python test workspace's pinned environment (ruff), against any .py files in the repository.
.DESCRIPTION
    The explicit --config gives every file the workspace's ruff settings, wherever the file lives.
.PARAMETER Tool
    The tool and its subcommand words, e.g. 'ruff format --check' or 'ruff check'.
.PARAMETER File
    The files and folders to run it on, as full paths.
.OUTPUTS
    [Catzc.Base.Execution.CliResult] The tool's result; a non-zero exit is the caller's to read.
.EXAMPLE
    $check = Invoke-PythonWorkspaceTool -Tool 'ruff check' -File $files
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
