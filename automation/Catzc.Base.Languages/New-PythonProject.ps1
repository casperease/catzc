<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/New-PythonProject.ps1
    kind: function
    module: Catzc.Base.Languages
    visibility: public
    adrs:
      - ADR-AUTO-PY
      - ADR-CONF-ADDRESSING
---
#>

<#
.SYNOPSIS
    Renders the Python test workspace: the uv workspace root <root>/pyproject.toml and one member pyproject.toml per Python
    test folder.
.DESCRIPTION
    Python here is test artifacts only, and its tests form one uv workspace, the Python form of go.work.
    [ADR-AUTO-PY](/docs/adr/automation/python/python-test-artifacts.md)
    [comment:1](/docs/references/automation/catzc-base-languages/New-PythonProject.ps1.md#comment1)
.PARAMETER Target
    The files to render, as a repository-relative wildcard over their paths. Default: every file.
.OUTPUTS
    [Catzc.Base.Languages.PythonWorkspaceFile] One record per rendered file ({ Target; Content }): the workspace root
    first, then the members in ordinal folder order.
.EXAMPLE
    (New-PythonProject -Target 'python/pyproject.toml').Content
#>
function New-PythonProject {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Languages.PythonWorkspaceFile])]
    param(
        [string] $Target = '*'
    )

    $config = Get-Config -Config python
    # Reading the tools.yml pin keeps requires-python equal to the version of the managed interpreter.
    # [ADR-CONF-ADDRESSING](/docs/adr/configuration/config-value-addressing.md)
    # [comment:2](/docs/references/automation/catzc-base-languages/New-PythonProject.ps1.md#comment2)
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
        foreach ($folder in @(Get-ChildItem -LiteralPath $testsRoot -Directory)) {
            if ($folder.Name.StartsWith('.')) {
                continue
            }
            if (-not @(Get-ChildItem -LiteralPath $folder.FullName -Filter 'test_*.py' -File -Recurse).Count) {
                continue
            }
            if ($folder.Name -cnotmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
                throw "$pythonRoot/tests/$($folder.Name)/: a Python test folder is named for its catzc module in kebab case (lowercase, dots as hyphens, e.g. catzc-base-repository)."
            }
            $folders.Add($folder.Name)
        }
    }
    $folders.Sort([System.StringComparer]::Ordinal)
    if ($folders.Count -eq 0) {
        return
    }

    [string[]] $header = @(
        '# GENERATED FILE — do not edit. Single source of truth:'
        "#   automation/Catzc.Base.Languages/configs/python.yml (rendered by New-PythonProject over the $pythonRoot/tests/*/ folders)"
        '#   requires-python: the python pin in automation/Catzc.Base.Execution/configs/tools.yml'
        '# Regenerated on import by Build-RootConfig; edit the yml or the folders, not this file.'
    )

    $files = [System.Collections.Generic.List[Catzc.Base.Languages.PythonWorkspaceFile]]::new()

    $workspace = [System.Collections.Generic.List[string]]::new($header)
    $workspace.Add('')
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
        $member = [System.Collections.Generic.List[string]]::new($header)
        $member.Add('')
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
