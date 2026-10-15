<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.KeyHandler/private/Select-SupportedKeyHandler.ps1
    kind: private-function
    module: Catzc.Tooling.KeyHandler
    visibility: private
    adrs:
      - ADR-AUTO-CACHE#5
      - ADR-AUTO-TEST
---
#>

<#
.SYNOPSIS
    Classifies captured key bindings by whether their function is supported on the target platform.
.DESCRIPTION
    Pure on purpose: testable without a PSReadLine session, and it never mutates the cached configs.
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
