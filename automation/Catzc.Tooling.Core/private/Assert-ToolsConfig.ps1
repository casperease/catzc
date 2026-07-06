<#
.SYNOPSIS
    Validates configs/tools.yml: enforces snake_case keys.
.DESCRIPTION
    Convention validator for `Get-Config -Config tools` (named Assert-<Name>Config
    and run in the owning module's scope). Asserts every key — tool identities and
    field names alike — is snake_case per the config-naming ADR, so a non-snake key
    throws at read time everywhere tools.yml is read. Tool identities are snake_case
    (e.g. 'az_cli'); Get-ToolCommandSuffix maps them to the PascalCase command
    suffixes (Install-AzCli, ...).
.PARAMETER Config
    The parsed tools.yml (ordered dictionary from ConvertFrom-Yaml -Ordered).
.EXAMPLE
    Assert-ToolsConfig (Get-Content $path -Raw | ConvertFrom-Yaml -Ordered)
#>
function Assert-ToolsConfig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    Assert-YmlNaming $Config

    # Never let the toolchain's Python outrun what a dependent supports. A tool declaring max_python (e.g.
    # az_cli, whose venv runs the Azure CLI, which supports only up to 3.13) fails the build if the pinned
    # python version exceeds it — a poka-yoke against bumping Python to a bleeding-edge release its dependents
    # cannot use.
    $python = $Config['python']
    if ($python -and $python['version']) {
        $pythonVersion = [version] $python['version']
        foreach ($key in $Config.Keys) {
            $max = $Config[$key]['max_python']
            if ($max -and $pythonVersion -gt [version] $max) {
                throw "Python is pinned to $($python['version']), but '$key' supports Python <= $max. Lower python's version, or raise '$key''s max_python — the toolchain does not run bleeding-edge Python past a dependent's support."
            }
        }
    }
}
