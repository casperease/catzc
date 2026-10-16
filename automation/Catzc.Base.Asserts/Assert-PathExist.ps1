<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Asserts/Assert-PathExist.ps1
    name: assert-path-exist
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-asserts/Assert-PathExist.ps1.md
    test: automation/Catzc.Base.Asserts/tests/Assert-PathExist.Tests.ps1
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
        $message = if ($ErrorText) {
            $ErrorText
        }
        else {
            "Path does not exist: $Path"
        }
        throw $message
    }
}
