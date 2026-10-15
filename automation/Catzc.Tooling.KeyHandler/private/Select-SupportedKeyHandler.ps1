<#
.SYNOPSIS
    Classifies captured key bindings by whether their function is supported on the target platform.
.DESCRIPTION
    Pure on purpose: testable without a PSReadLine session, and it never mutates the cached configs.
    [ADR-AUTO-TEST](/docs/adr/automation/test-automation.md),
    [ADR-AUTO-CACHE#5](/docs/adr/automation/caching.md#rule-adr-auto-cache5)
    [comment:1](/docs/references/automation/catzc-tooling-keyhandler/private/Select-SupportedKeyHandler.ps1.md#comment1)
.PARAMETER Binding
    The captured bindings — a sequence of { key, function } mappings (from key-handler-bindings.yml).
.PARAMETER SupportedFunction
    The allow-list of supported function names (from key-handler-supported.yml `functions`).
.EXAMPLE
    Select-SupportedKeyHandler -Binding $bindings -SupportedFunction $supported | Where-Object Supported
#>
function Select-SupportedKeyHandler {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyCollection()]
        $Binding,

        [Parameter(Mandatory, Position = 1)]
        [AllowEmptyCollection()]
        [string[]] $SupportedFunction
    )

    $supportedSet = [System.Collections.Generic.HashSet[string]]::new(
        [string[]] $SupportedFunction, [System.StringComparer]::OrdinalIgnoreCase)

    foreach ($entry in @($Binding)) {
        $key = [string] $entry['key']
        $function = [string] $entry['function']
        [pscustomobject]@{
            Key       = $key
            Function  = $function
            Supported = $supportedSet.Contains($function)
        }
    }
}
