<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Asserts/Assert-NotNullOrWhitespace.ps1
    name: assert-not-null-or-whitespace
    filetype: ps1
    role: function
    subkind: assert
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Asserts/tests/Assert-NotNullOrWhitespace.Tests.ps1
    docs: "[Assert-NotNullOrWhitespace.ps1.md](docs/references/pwsh/catzc-base-asserts/Assert-NotNullOrWhitespace.ps1.md)"
---
#>

function Assert-NotNullOrWhitespace {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [object] $Value,

        [string] $ErrorText
    )

    if (-not (Test-NotNullOrWhitespace $Value)) {
        $message = if ($ErrorText) {
            $ErrorText
        }
        else {
            'Assertion failed: value was null or whitespace — {0}, line {1}' -f $MyInvocation.ScriptName, $MyInvocation.ScriptLineNumber
        }
        throw $message
    }
}
