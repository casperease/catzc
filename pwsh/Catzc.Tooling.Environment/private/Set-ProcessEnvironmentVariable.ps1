<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Environment/private/Set-ProcessEnvironmentVariable.ps1
    folder: private
    name: set-process-environment-variable
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Environment
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Set-ProcessEnvironmentVariable.ps1.md](docs/references/pwsh/catzc-tooling-environment/private/Set-ProcessEnvironmentVariable.ps1.md)"
---
#>

function Set-ProcessEnvironmentVariable {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Thin wrapper around [Environment]::SetEnvironmentVariable — the process-env I/O seam that exists for testability; scoping/restore is the caller''s concern (Write-EnvironmentSet).')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'Its one caller, Write-EnvironmentSet, announces every variable it sets with secrets masked (***); announcing here would print the plaintext secret')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        [Parameter(Position = 1)]
        [AllowNull()]
        [AllowEmptyString()]
        $Value
    )

    [System.Environment]::SetEnvironmentVariable($Name, $Value, 'Process')
}
