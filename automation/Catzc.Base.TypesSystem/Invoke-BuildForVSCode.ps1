<#
.SYNOPSIS
    Builds the IDE-only C# type project (Catzc.Types.csproj) so VS Code's C# Dev Kit sees the native type
    sources — the editor-facing build pathway, separate from the runtime's Add-Type compile.
.DESCRIPTION
    The runtime compiles every automation/<Module>/types/*.cs at import with Add-Type (Import-CSharpTypes), and that...
    [ADR-AUTO-TYPES](/docs/adr/automation/BCL/native-csharp-types.md), [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)
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

    # The stamp task's "stamped version …" line and any analyzer diagnostics stream through.
    # [comment:2](/docs/references/automation/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md#comment2)
    $result = Invoke-Executable "dotnet build `"$project`" --configuration $Configuration" -PassThru

    if ($PassThru) {
        return $result
    }
    $project
}
