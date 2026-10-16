<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/Test-NotNullOrWhitespace.ps1
    kind: function
    subkind: gate
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Asserts
    visibility: public
    relatives:
      test: automation/Catzc.Base.Asserts/tests/Test-NotNullOrWhitespace.Tests.ps1
  config:
    synopsis: Tests whether a value is not null, empty, or whitespace.
    parameters:
      Value: The value to test.
    examples:
      - |-
        Test-NotNullOrWhitespace 'hello'
        # True
      - |-
        Test-NotNullOrWhitespace '  '
        # False
---
#>

function Test-NotNullOrWhitespace {
    [OutputType([bool])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [AllowNull()]
        [AllowEmptyString()]
        [string] $Value
    )

    -not [string]::IsNullOrWhiteSpace($Value)
}
