<#
.SYNOPSIS
    Validates configs/key-handler-bindings.yml — the captured Windows PSReadLine bindings.
.DESCRIPTION
    Convention validator for `Get-Config -Config key-handler-bindings` (named
    Assert-<TitleCase(name)>Config and run in the owning module's scope). The config is a
    top-level sequence of { key, function } entries. Asserts the list is non-empty and every
    entry carries a non-empty key and function, collecting all violations into one throw so a
    malformed capture fails at read time rather than mid-import.
.PARAMETER Config
    The parsed key-handler-bindings.yml (an ordered-dictionary list from ConvertFrom-Yaml -Ordered).
.EXAMPLE
    Assert-KeyHandlerBindingsConfig (Get-Content $path -Raw | ConvertFrom-Yaml -Ordered)
#>
function Assert-KeyHandlerBindingsConfig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    Assert-True ($Config -is [System.Collections.IEnumerable] -and $Config -isnot [string]) `
        -ErrorText 'key-handler-bindings.yml must be a sequence of { key, function } entries.'

    $entries = @($Config)
    Assert-True ($entries.Count -gt 0) -ErrorText 'key-handler-bindings.yml is empty — capture bindings with Save-PSReadLineKeyHandlerSet.'

    $violations = [System.Collections.Generic.List[string]]::new()
    for ($i = 0; $i -lt $entries.Count; $i++) {
        $entry = $entries[$i]
        if ($entry -isnot [System.Collections.IDictionary]) {
            $violations.Add("entry $i is not a key/function mapping")
            continue
        }
        if ([string]::IsNullOrWhiteSpace([string]$entry['key'])) {
            $violations.Add("entry $i has no 'key'")
        }
        if ([string]::IsNullOrWhiteSpace([string]$entry['function'])) {
            $violations.Add("entry $i has no 'function'")
        }
    }

    Assert-True ($violations.Count -eq 0) -ErrorText (
        "key-handler-bindings.yml is malformed:`n  - " + ($violations -join "`n  - ")
    )
}
