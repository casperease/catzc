<#
.SYNOPSIS
    Renders the Python test workspace: the uv workspace root <root>/pyproject.toml and one member pyproject.toml per Python
    test folder.
.DESCRIPTION
    Python code in this repository is test artifacts only: black-box tests in <root>/tests/<module-in-kebab>/, under the
    Python root (python.yml `root`: python/ when the repository has one, else .python/;
    [ADR-AUTO-PY](/docs/adr/automation/python/python-test-artifacts.md)). The tests form one uv workspace — uv's own
    monorepo layout, and the Python form of go.work with one go.mod per module:

      <root>/pyproject.toml                  the workspace root: a virtual root (no project of its own) whose
                                             [tool.uv.workspace] members name every Python test folder explicitly, and
                                             the ruff settings for every member (the 140-column line, the pinned Python);
      <root>/tests/<folder>/pyproject.toml   one member per folder holding a test_*.py file: a virtual project named for
                                             the folder, whose requires-python is the python tool's pin in tools.yml
                                             (global.tools.python.version, 3.13 -> ==3.13.*) and whose dependencies are
                                             python.yml's exact pins, in name order.

    uv makes one environment (<root>/.venv) and one lock (<root>/uv.lock) for the whole workspace when the test bridge
    syncs it; both are gitignored, as these files are. A repository without Python test folders renders nothing.

    This is a pure renderer: it returns the content and writes nothing. It is the `generator` the root-config registry
    names for the workspace targets, and Build-RootConfig owns the write; the entry's target selects which files.
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
    # The one Python version: the python tool's tools.yml pin, read by address (reading config is global access,
    # [ADR-CONF-ADDRESSING](/docs/adr/configuration/config-value-addressing.md)).
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
        '#   requires-python: the python pin in automation/Catzc.Tooling.Core/configs/tools.yml'
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
