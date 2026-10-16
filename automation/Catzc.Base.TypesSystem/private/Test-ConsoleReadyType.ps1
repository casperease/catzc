<#
---
catzc:
  derived:
    path: automation/Catzc.Base.TypesSystem/private/Test-ConsoleReadyType.ps1
    folder: private
    name: test-console-ready-type
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.TypesSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.TypesSystem/tests/Test-ConsoleReadyType.Tests.ps1
  config:
    synopsis: Whether a shipped C# type renders as one readable line in pwsh, rather than as its full name.
    description: |-
      PowerShell's "$x" and [string]$x call the type's own .NET ToString() and ignore an ETS ToString, so a type
      reads well in pwsh only when it overrides ToString() — normally by delegating to
      Catzc.Base.Objects.ConsoleText (`public override string ToString() => this.ToConsoleString();`), which every
      DictionaryRecord inherits. A type that is never held as a value needs no override and passes: an enum (it
      renders its name), an interface, a delegate, an abstract or static class, an Attribute, and an Exception (it
      renders its message).
    parameters:
      Type: The loaded type to check.
    outputs: '[bool] True when the type is console-ready or exempt.'
    examples:
      - Test-ConsoleReadyType -Type ([Catzc.Base.Objects.ArtifactRef])
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
