<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/Assert-PathExist.ps1
    kind: assert-function
    module: Catzc.Base.Asserts
    visibility: public
  config:
    synopsis: Asserts that a filesystem path exists.
    parameters:
      Path: The path to test.
      PathType: 'The kind of path to require: Any (default), Container, or Leaf.'
      ErrorText: Optional message to throw instead of the default.
    examples:
      - Assert-PathExist './config.json'
      - Assert-PathExist './src' -PathType Container
---
#>

function Assert-PathExist {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [ValidateSet('Any', 'Container', 'Leaf')]
        [string] $PathType = 'Any',

        [string] $ErrorText
    )

    if (-not (Test-Path -Path $Path -PathType $PathType)) {
        # Not $ErrorText ??...: a [string] param coerces $null to '', and ?? only coalesces $null, so the default...
        # [comment:2](/docs/references/automation/catzc-base-asserts/Assert-PathExist.ps1.md#comment2)
        $message = if ($ErrorText) {
            $ErrorText
        }
        else {
            "Path does not exist: $Path"
        }
        throw $message
    }
}
