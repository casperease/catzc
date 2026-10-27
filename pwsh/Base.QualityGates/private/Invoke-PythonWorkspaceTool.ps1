function Invoke-PythonWorkspaceTool {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Execution.CliResult])]
    param(
        [Parameter(Mandatory)]
        [string] $Tool,

        [Parameter(Mandatory)]
        [string[]] $File,

        [string] $ConfigOption = '--config'
    )

    $uv = Resolve-ToolExecutable -Tool uv
    if (-not ($uv.Found -and $uv.VersionOk)) {
        throw "The Python checks need the managed uv at the tools.yml pin '$($uv.Required)' (found: $($uv.Version ?? 'none')). Run Install-Uv."
    }
    $repositoryRoot = Get-RepositoryRoot
    $python = Get-Config -Config python
    $pythonRelative = $python.ResolveRoot($repositoryRoot)
    $pythonRoot = Join-Path $repositoryRoot $pythonRelative
    if (-not (Test-Path -LiteralPath (Join-Path $pythonRoot 'pyproject.toml') -PathType Leaf)) {
        throw "$pythonRelative/pyproject.toml is missing — the Python test workspace is generated; regenerate with: Build-RootConfig"
    }
    # The checks never sync, since a sync resolves and downloads; the environment comes from the explicit install command.
    if (-not (Test-Path -LiteralPath (Join-Path $pythonRoot '.venv/pyvenv.cfg') -PathType Leaf)) {
        throw "$pythonRelative/.venv is not synced, and the Python checks never sync it; sync it once with: Install-PythonWorkspace"
    }
    $uvCommand = "`"$($uv.Path)`""
    $quoted = ($File | ForEach-Object { "`"$_`"" }) -join ' '

    # uv stays offline and on the pinned interpreter; pyright's wrapper stays on its bundled copy at the python.yml pin, with
    # no version check against the index and npm held offline.
    $environment = [ordered]@{
        UV_PYTHON_DOWNLOADS                = 'never'
        UV_OFFLINE                         = '1'
        PYRIGHT_PYTHON_USE_BUNDLED_PYRIGHT = '1'
        PYRIGHT_PYTHON_IGNORE_WARNINGS     = '1'
        npm_config_offline                 = 'true'
        PYRIGHT_PYTHON_FORCE_VERSION       = $python.dependencies['pyright']
    }
    $saved = @{}
    foreach ($name in $environment.Keys) {
        $saved[$name] = [System.Environment]::GetEnvironmentVariable($name)
        [System.Environment]::SetEnvironmentVariable($name, $environment[$name])
    }
    try {
        Invoke-Executable "$uvCommand run --no-sync --quiet $Tool $ConfigOption pyproject.toml $quoted" -WorkingDirectory $pythonRoot -PassThru -NoAssert -Silent
    }
    finally {
        foreach ($name in $environment.Keys) {
            [System.Environment]::SetEnvironmentVariable($name, $saved[$name])
        }
    }
}
