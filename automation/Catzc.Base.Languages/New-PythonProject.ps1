function New-PythonProject {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Languages.PythonWorkspaceFile])]
    param(
        [string] $Target = '*'
    )

    $config = Get-Config -Config python
    $pythonVersion = "$(Get-ConfigValue -Address 'global.tools.python.version')"
    if ($pythonVersion -cnotmatch '^3\.(0|[1-9][0-9]*)$') {
        throw "tools.yml python.version '$pythonVersion' is not a Python minor version for requires-python (3.N, e.g. '3.13')."
    }
    $repositoryRoot = Get-RepositoryRoot
    $pythonRoot = $config.ResolveRoot($repositoryRoot)
    $testsRoot = Join-Path $repositoryRoot "$pythonRoot/tests"

    # One member per folder that holds a test file; a folder left with only generated files is not a member.
    $folders = [System.Collections.Generic.List[string]]::new()
    if (Test-Path -LiteralPath $testsRoot -PathType Container) {
        foreach ($folderPath in @(Get-ChildPath $testsRoot -Directory -Depth 1)) {
            $folderName = [System.IO.Path]::GetFileName($folderPath)
            if ($folderName.StartsWith('.')) {
                continue
            }
            # A test file sits directly in its module folder; the deeper levels are headroom for a package layout.
            if (-not @(Get-ChildPath $folderPath -File -Filter 'test_*.py' -Depth 3).Count) {
                continue
            }
            if ($folderName -cnotmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
                throw "$pythonRoot/tests/$folderName/: a Python test folder is named for its catzc module in kebab case (lowercase, dots as hyphens, e.g. catzc-base-repository)."
            }
            $folders.Add($folderName)
        }
    }
    $folders.Sort([System.StringComparer]::Ordinal)
    if ($folders.Count -eq 0) {
        return
    }

    $files = [System.Collections.Generic.List[Catzc.Base.Languages.PythonWorkspaceFile]]::new()

    $workspace = [System.Collections.Generic.List[string]]::new()
    $workspace.Add('[tool.uv.workspace]')
    $workspace.Add('members = [')
    foreach ($folder in $folders) {
        $workspace.Add("    `"tests/$folder`",")
    }
    $workspace.Add(']')
    $workspace.Add('')
    $workspace.Add('[tool.ruff]')
    $workspace.Add('line-length = 140')
    $workspace.Add("target-version = `"py$($pythonVersion.Replace('.', ''))`"")
    $files.Add([Catzc.Base.Languages.PythonWorkspaceFile]::new("$pythonRoot/pyproject.toml", ($workspace -join "`n") + "`n"))

    foreach ($folder in $folders) {
        $member = [System.Collections.Generic.List[string]]::new()
        $member.Add('[project]')
        $member.Add("name = `"$folder`"")
        $member.Add('version = "0.0.0"')
        $member.Add("requires-python = `"==$pythonVersion.*`"")
        $member.Add('dependencies = [')
        # PythonConfig keeps the dependencies in ordinal name order.
        foreach ($dependency in $config.dependencies.GetEnumerator()) {
            $member.Add("    `"$($dependency.Key)==$($dependency.Value)`",")
        }
        $member.Add(']')
        $member.Add('')
        $member.Add('[tool.uv]')
        $member.Add('package = false')
        $files.Add([Catzc.Base.Languages.PythonWorkspaceFile]::new("$pythonRoot/tests/$folder/pyproject.toml", ($member -join "`n") + "`n"))
    }

    foreach ($file in $files) {
        if ($file.Target -clike $Target) {
            $file
        }
    }
}
