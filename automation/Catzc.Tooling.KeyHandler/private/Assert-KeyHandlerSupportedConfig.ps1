<#
.SYNOPSIS
    Validates configs/key-handler-supported.yml — the Linux-supported PSReadLine function allow-list.
.DESCRIPTION
    Convention validator for `Get-Config -Config key-handler-supported` (named
    Assert-<TitleCase(name)>Config and run in the owning module's scope). Asserts the config has a
    non-empty `functions` list of non-empty strings — the allow-list Import-PSReadLineKeyHandlerSet
    filters the captured bindings against — so a malformed allow-list fails at read time.
.PARAMETER Config
    The parsed key-handler-supported.yml (an ordered dictionary from ConvertFrom-Yaml -Ordered).
.EXAMPLE
    Assert-KeyHandlerSupportedConfig (Get-Content $path -Raw | ConvertFrom-Yaml -Ordered)
#>
function Assert-KeyHandlerSupportedConfig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    Assert-True ($Config -is [System.Collections.IDictionary]) `
        -ErrorText 'key-handler-supported.yml must be a mapping with a functions: list.'

    Assert-True ($Config.Contains('functions')) -ErrorText "key-handler-supported.yml has no 'functions' key."

    $functions = @($Config['functions'])
    Assert-True ($functions.Count -gt 0) -ErrorText "key-handler-supported.yml 'functions' is empty."

    $blank = @($functions | Where-Object { [string]::IsNullOrWhiteSpace([string]$_) })
    Assert-True ($blank.Count -eq 0) -ErrorText "key-handler-supported.yml 'functions' contains a blank entry."
}
