<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.KeyHandler/private/Select-SupportedKeyHandler.ps1
    folder: private
    name: select-supported-key-handler
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.KeyHandler
    moduletype: pwsh-folder
    catzc_bundle: full
    visibility: private
  edges:
    test: pwsh/Catzc.Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1
    docs: "[Select-SupportedKeyHandler.ps1.md](docs/references/pwsh/catzc-tooling-keyhandler/private/Select-SupportedKeyHandler.ps1.md)"
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
