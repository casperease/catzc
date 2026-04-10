<#
.SYNOPSIS
    Builds the IDE-only C# type project (Catzc.Types.csproj) so VS Code's C# Dev Kit sees the native type
    sources — the editor-facing build pathway, separate from the runtime's Add-Type compile.
.DESCRIPTION
    The runtime compiles every automation/<Module>/types/*.cs at import with Add-Type (Import-CSharpTypes),
    and that path is never touched here. This is the SECOND, editor-facing pathway: it drives `dotnet build`
    over the committed automation/.internal/assets/Catzc.Types.csproj (auto-loaded in the editor via the root
    catzc.sln). That build does two things Add-Type
    does not — it runs the Roslyn analyzers (EnableNETAnalyzers), and it runs the project's stamp task, which
    FAILS when the committed automation/.compiled/Catzc.Types.<hash>.dll is stale versus the sources. So a green
    build both warms Dev Kit's IntelliSense — making Go-to-Symbol (Ctrl+T) and F12 over the C# types resolve to
    source, the backtrack a bare type accelerator cannot give — and verifies the IDE project matches the
    runtime prebuild.

    dotnet runs through Invoke-Executable rather than Invoke-Dotnet: that wrapper (with its locked-SDK
    assertion) lives in the Tooling layer, which this Base module must not depend on. So there is no
    locked-version check here; dotnet must be on PATH. See docs/adr/automation/native-csharp-types.md.
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

    if (-not (Test-Command 'dotnet')) {
        throw 'dotnet is not on PATH. Install the .NET SDK (Install-Dotnet), then re-run Invoke-BuildForVSCode.'
    }

    $project = Join-Path (Get-RepositoryRoot) 'automation/.internal/assets/Catzc.Types.csproj'
    Assert-PathExist $project

    # The stamp task's "stamped version …" line and any analyzer diagnostics stream through. A non-zero exit
    # (a stale committed DLL, an analyzer error) throws via Invoke-Executable.
    $result = Invoke-Executable "dotnet build `"$project`" --configuration $Configuration" -PassThru

    if ($PassThru) {
        return $result
    }
    $project
}
