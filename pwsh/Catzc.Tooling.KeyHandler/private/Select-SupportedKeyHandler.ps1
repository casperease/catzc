<#
---
catzc:
  immutable:
    with_body_sha: "906909e5317f"
  edges:
    test: pwsh/Catzc.Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1
    docs: "[Select-SupportedKeyHandler.ps1.md](docs/references/pwsh/catzc-tooling-key-handler/private/Select-SupportedKeyHandler.ps1.md)"
    cites:
      - ADR-AUTO-CACHE-READONLYVALUES
      - ADR-AUTO-TEST
---
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
