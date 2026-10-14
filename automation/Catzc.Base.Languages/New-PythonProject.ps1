<#
.SYNOPSIS
    Renders python/pyproject.toml, the one generated uv project the Python tests run in.
.DESCRIPTION
    Python code in this repository is test artifacts only: black-box tests in python/tests/<module-in-kebab>/
    ([ADR-AUTO-PY](/docs/adr/automation/python/python-test-artifacts.md)). They share one virtual uv project (it builds no
    package), python/pyproject.toml, rendered here from two declared sources:

      requires-python  the python tool's pin in tools.yml (global.tools.python.version, e.g. 3.13 -> ==3.13.*), the
                       one Python version;
      dependencies     python.yml's exact pins (PythonConfig, in name order): pytest runs the tests, ruff formats and
                       lints them.

    The ruff settings travel in the same file: the repository's 140-column line length and its target Python
    version. uv makes the environment (python/.venv) and the lock (python/uv.lock) from the project when the test
    bridge syncs it; both are gitignored, as the project itself is.

    This is a pure renderer: it returns the content and writes nothing. It is the `generator` the root-config
    registry names for the python/pyproject.toml target, and Build-RootConfig owns the write.
.OUTPUTS
    [string] The rendered pyproject.toml content (LF-joined).
.EXAMPLE
    New-PythonProject
#>
function New-PythonProject {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $config = Get-Config -Config python
    # The one Python version: the python tool's tools.yml pin, read by address (reading config is global access,
    # [ADR-CONF-ADDRESSING](/docs/adr/configuration/config-value-addressing.md)).
    $pythonVersion = "$(Get-ConfigValue -Address 'global.tools.python.version')"
    if ($pythonVersion -cnotmatch '^3\.(0|[1-9][0-9]*)$') {
        throw "tools.yml python.version '$pythonVersion' is not a Python minor version for requires-python (3.N, e.g. '3.13')."
    }
    $ruffTarget = 'py' + $pythonVersion.Replace('.', '')

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('# GENERATED FILE — do not edit. Single source of truth:')
    $lines.Add('#   automation/Catzc.Base.Languages/configs/python.yml (rendered by New-PythonProject)')
    $lines.Add('#   requires-python: the python pin in automation/Catzc.Tooling.Core/configs/tools.yml')
    $lines.Add('# Regenerated on import by Build-RootConfig; edit the yml, not this file.')
    $lines.Add('')
    $lines.Add('[project]')
    $lines.Add('name = "catzc-python-tests"')
    $lines.Add('version = "0.0.0"')
    $lines.Add("requires-python = `"==$pythonVersion.*`"")
    $lines.Add('dependencies = [')
    # PythonConfig keeps the dependencies in ordinal name order.
    foreach ($dependency in $config.dependencies.GetEnumerator()) {
        $lines.Add("    `"$($dependency.Key)==$($dependency.Value)`",")
    }
    $lines.Add(']')
    $lines.Add('')
    $lines.Add('[tool.uv]')
    $lines.Add('package = false')
    $lines.Add('')
    $lines.Add('[tool.ruff]')
    $lines.Add('line-length = 140')
    $lines.Add("target-version = `"$ruffTarget`"")

    ($lines -join "`n") + "`n"
}
