function Install-PythonWorkspace {
    [CmdletBinding()]
    param(
        [string[]] $ReinstallPackage
    )

    # The one online sync of the Python test workspace; the test run and the Python checks read its environment offline.
    $uv = Resolve-ToolExecutable -Tool uv
    if (-not ($uv.Found -and $uv.VersionOk)) {
        throw "The Python workspace needs the managed uv at the tools.yml pin '$($uv.Required)' (found: $($uv.Version ?? 'none')). Run Install-Uv."
    }
    $repositoryRoot = Get-RepositoryRoot
    $config = Get-Config -Config python
    $pythonRelative = $config.ResolveRoot($repositoryRoot)
    $pythonRoot = Join-Path $repositoryRoot $pythonRelative
    if (-not (Test-Path -LiteralPath (Join-Path $pythonRoot 'pyproject.toml') -PathType Leaf)) {
        throw "$pythonRelative/pyproject.toml is missing — the Python test workspace is generated; regenerate with: Build-RootConfig"
    }
    $uvCommand = "`"$($uv.Path)`""
    $reinstall = ''
    foreach ($package in $ReinstallPackage) {
        $reinstall += " --reinstall-package $package"
    }

    # The source's credential, by variable name: uv reads UV_INDEX_<NAME>_USERNAME and _PASSWORD for the index of that name.
    $source = $config.package_source
    $credentialValue = $null
    if ($source.credential_env) {
        $credentialValue = [System.Environment]::GetEnvironmentVariable($source.credential_env)
        if (-not $credentialValue) {
            throw "The package source '$($source.name)' names the credential variable $($source.credential_env), and it is not set."
        }
    }
    $indexName = 'UV_INDEX_' + $source.name.ToUpperInvariant().Replace('-', '_')
    $savedCredential = [ordered]@{}
    if ($null -ne $credentialValue) {
        foreach ($variable in "${indexName}_USERNAME", "${indexName}_PASSWORD") {
            $savedCredential[$variable] = [System.Environment]::GetEnvironmentVariable($variable)
        }
    }

    $saved = [System.Environment]::GetEnvironmentVariable('UV_PYTHON_DOWNLOADS')
    [System.Environment]::SetEnvironmentVariable('UV_PYTHON_DOWNLOADS', 'never')
    try {
        if ($null -ne $credentialValue) {
            [System.Environment]::SetEnvironmentVariable("${indexName}_USERNAME", '__token__')
            [System.Environment]::SetEnvironmentVariable("${indexName}_PASSWORD", $credentialValue)
        }
        $sync = Invoke-Executable "$uvCommand sync --all-packages --quiet$reinstall" -WorkingDirectory $pythonRoot -PassThru -NoAssert
        if ($sync.ExitCode -ne 0) {
            throw ("uv sync failed in $pythonRelative/ (exit $($sync.ExitCode)); is the python pin installed? Run Install-Python. " +
                "If a workspace member moved: $pythonRelative/uv.lock is a gitignored product that pins member paths; delete it and run again.`n$($sync.Full)")
        }
        # pyright's wrapper fetches what it lacks (node, its npm package) on its first run, so that run is made here, online.
        $typeChecker = Invoke-Executable "$uvCommand run --no-sync --quiet pyright --version" -WorkingDirectory $pythonRoot -PassThru -NoAssert
        if ($typeChecker.ExitCode -ne 0) {
            throw "pyright could not start in $pythonRelative/ (exit $($typeChecker.ExitCode)); is node installed? Run Install-NodeJs.`n$($typeChecker.Full)"
        }
    }
    finally {
        foreach ($variable in $savedCredential.Keys) {
            if ($null -eq $savedCredential[$variable]) {
                Remove-Item -LiteralPath "Env:$variable" -ErrorAction Ignore
            }
            else {
                [System.Environment]::SetEnvironmentVariable($variable, $savedCredential[$variable])
            }
        }
        if ($null -eq $saved) {
            Remove-Item -LiteralPath Env:UV_PYTHON_DOWNLOADS -ErrorAction Ignore
        }
        else {
            [System.Environment]::SetEnvironmentVariable('UV_PYTHON_DOWNLOADS', $saved)
        }
    }
    Write-Message "The Python workspace $pythonRelative/ is synced."
}
