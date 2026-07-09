<#
.SYNOPSIS
    Returns the names of all automation modules (the non-dot directories under automation/).
.DESCRIPTION
    Enumerates the automation root and returns each module folder name — the same set Import-AllModules
    discovers and imports. A non-dot directory is a module; dot-prefixed folders (.internal, .vendor,
    .scriptanalyzer, .compiled) are infrastructure and are excluded (see conventional-folders).

    This is the platform's single source of the automation-module name list: the module- and
    function-dependency analysis validates its declarations against it, the cross-module C# type scan maps
    references against it, and the `-Modules` ArgumentCompleter / ValidateScript on Test-Automation derive
    their values from it — so the list is always the filesystem, never hand-maintained.

    Names are returned sorted ordinally (culture-independent — see cross-platform).
.PARAMETER AutomationRoot
    Path to the automation directory. Defaults to the automation folder under the repository root; pass a
    fixture tree to isolate a logic test from the real module set.
.EXAMPLE
    Get-AutomationModules
.EXAMPLE
    Get-AutomationModules -AutomationRoot (Join-Path $fixtureRoot 'automation')
#>
function Get-AutomationModules {
    [OutputType([string[]])]
    param(
        [string] $AutomationRoot = (Join-Path (Get-RepositoryRoot) 'automation')
    )

    Assert-PathExist $AutomationRoot -PathType Container

    # [System.IO] (sorted ordinally) instead of Get-ChildItem -Directory — the cmdlet carries ~20ms of
    # per-call provider overhead the raw .NET enumeration avoids (ADR-AUTO-TEST:18); the ordinal sort is
    # culture-independent (cross-platform).
    $names = [System.Collections.Generic.List[string]]::new()
    foreach ($dir in [System.IO.Directory]::EnumerateDirectories($AutomationRoot)) {
        $name = [System.IO.Path]::GetFileName($dir)
        if (-not $name.StartsWith('.')) {
            $names.Add($name)
        }
    }

    $arr = [string[]]$names.ToArray()
    [System.Array]::Sort($arr, [System.StringComparer]::Ordinal)
    @($arr)
}
