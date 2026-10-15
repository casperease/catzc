<#
---
catzc:
  derived:
    path: automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
    kind: function
    module: Catzc.Base.TypesSystem
    visibility: public
    adrs:
      - ADR-AUTO-TYPES
      - ADR-DSGN-RUNMODE
---
#>

<#
.SYNOPSIS
    Builds the IDE-only C# type project (Catzc.Types.csproj) so VS Code's C# Dev Kit sees the native type
    sources — the editor-facing build pathway, separate from the runtime's Add-Type compile.
.DESCRIPTION
    Unlike the runtime Add-Type compile, this runs the analyzers and fails when the committed DLL is stale.
    [ADR-AUTO-TYPES](/docs/adr/automation/BCL/native-csharp-types.md),
    [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)
    [comment:1](/docs/references/automation/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md#comment1)
.PARAMETER Configuration
    The MSBuild configuration to build. Defaults to Debug.
.PARAMETER PassThru
    Return the executable result ({ Output, Errors, Full, ExitCode }) instead of the project path.
.OUTPUTS
    [string] The path to the built project (with -PassThru, the result object instead).
.EXAMPLE
    Invoke-BuildForVSCode
    Builds Catzc.Types.csproj so the editor's C# analysis matches the runtime.
.EXAMPLE
    Invoke-BuildForVSCode -Configuration Release -PassThru
    Builds Release and returns the result object for inspection.
#>
function Invoke-BuildForVSCode {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [ValidateSet('Debug', 'Release')]
        [string] $Configuration = 'Debug',

        [switch] $PassThru
    )

    Assert-SourceTree

    if (-not (Test-Command 'dotnet')) {
        throw 'dotnet is not on PATH. Install the .NET SDK (Install-Dotnet), then re-run Invoke-BuildForVSCode.'
    }

    $project = Join-Path (Get-RepositoryRoot) 'automation/.internal/assets/Catzc.Types.csproj'
    Assert-PathExist $project

    # A non-zero exit, from a stale committed DLL or an analyzer error, throws through Invoke-Executable.
    # [comment:2](/docs/references/automation/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md#comment2)
    $result = Invoke-Executable "dotnet build `"$project`" --configuration $Configuration" -PassThru

    if ($PassThru) {
        return $result
    }
    $project
}
