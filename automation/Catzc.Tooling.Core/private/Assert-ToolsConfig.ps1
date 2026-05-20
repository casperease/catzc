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
}
