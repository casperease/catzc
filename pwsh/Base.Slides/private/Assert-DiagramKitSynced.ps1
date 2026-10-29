function Assert-DiagramKitSynced {
    [CmdletBinding()]
    [OutputType([void])]
    param()

    # The kit runs as uv run --no-sync, so the environment must come from the explicit install command.
    $pythonRelative = (Get-Config -Config python).ResolveRoot((Get-RepositoryRoot))
    $pythonRoot = Join-Path (Get-RepositoryRoot) $pythonRelative
    if (-not (Test-Path -LiteralPath (Join-Path $pythonRoot '.venv/pyvenv.cfg') -PathType Leaf)) {
        throw "$pythonRelative/.venv is not synced, and the diagram commands never sync it; sync it once with: Install-PythonWorkspace"
    }
}
