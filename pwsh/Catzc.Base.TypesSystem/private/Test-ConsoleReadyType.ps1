<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.TypesSystem/private/Test-ConsoleReadyType.ps1
    folder: private
    name: test-console-ready-type
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.TypesSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.TypesSystem/tests/Test-ConsoleReadyType.Tests.ps1
    docs: "[Test-ConsoleReadyType.ps1.md](docs/references/pwsh/catzc-base-typessystem/private/Test-ConsoleReadyType.ps1.md)"
---
#>

function Test-ConsoleReadyType {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [type] $Type
    )

    if ($Type.IsEnum -or $Type.IsInterface -or $Type.IsAbstract -or
        [System.Delegate].IsAssignableFrom($Type) -or [System.Attribute].IsAssignableFrom($Type) -or
        [System.Exception].IsAssignableFrom($Type)) {
        return $true
    }
    $declaringType = $Type.GetMethod('ToString', [type[]]@()).DeclaringType
    return $declaringType -ne [object] -and $declaringType -ne [System.ValueType]
}
