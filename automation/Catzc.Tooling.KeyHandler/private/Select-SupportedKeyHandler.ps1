<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.KeyHandler/private/Select-SupportedKeyHandler.ps1
    folder: private
    name: select-supported-key-handler
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.KeyHandler
    moduletype: pwsh-folder
    catzc_bundle: full
    visibility: private
  edges:
    test: automation/Catzc.Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1
    cites:
      - ADR-AUTO-CACHE#5
      - ADR-AUTO-TEST
  config:
    synopsis: Classifies captured key bindings by whether their function is supported on the target platform.
    description: |-
      The pure decision core of Import-PSReadLineKeyHandlerSet, separated so it is deterministic and
      testable without a real PSReadLine session (see
      [ADR-AUTO-TEST](/docs/adr/automation/test-automation.md) push-left). Given the captured bindings
      and the allow-list of supported function names, returns one record per binding carrying its Key,
      Function, and a Supported flag — the caller applies the supported ones and logs the rest. Reads
      the inputs only; never mutates the cached config objects
      ([ADR-AUTO-CACHE#5](/docs/adr/automation/caching.md#rule-adr-auto-cache5)).
    parameters:
      Binding: The captured bindings — a sequence of { key, function } mappings (from key-handler-bindings.yml).
      SupportedFunction: The allow-list of supported function names (from key-handler-supported.yml `functions`).
    examples:
      - Select-SupportedKeyHandler -Binding $bindings -SupportedFunction $supported | Where-Object Supported
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
