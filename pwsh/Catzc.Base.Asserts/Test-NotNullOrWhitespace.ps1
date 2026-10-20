<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Asserts/Test-NotNullOrWhitespace.ps1
    name: test-not-null-or-whitespace
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Asserts/tests/Test-NotNullOrWhitespace.Tests.ps1
    docs: "[Test-NotNullOrWhitespace.ps1.md](docs/references/pwsh/catzc-base-asserts/Test-NotNullOrWhitespace.ps1.md)"
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
