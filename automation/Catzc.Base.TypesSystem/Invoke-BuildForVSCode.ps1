<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1
    name: invoke-build-for-vs-code
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.TypesSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md
    test: automation/Catzc.Base.TypesSystem/tests/Invoke-BuildForVSCode.Tests.ps1
    cites:
      - ADR-AUTO-TYPES
      - ADR-DSGN-RUNMODE
  config:
    synopsis: |-
      Builds the IDE-only C# type project (Catzc.Types.csproj) so VS Code's C# Dev Kit sees the native type
      sources — the editor-facing build pathway, separate from the runtime's Add-Type compile.
    description: |-
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
      locked-version check here; dotnet must be on PATH. See
      [ADR-AUTO-TYPES](/docs/adr/automation/BCL/native-csharp-types.md).

      The project builds the source tree's types/*.cs, so it stops with a named error in build mode
      (Assert-SourceTree, [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)).
    parameters:
      Configuration: The MSBuild configuration to build. Defaults to Debug.
      PassThru: Return the executable result ({ Output, Errors, Full, ExitCode }) instead of the project path.
    outputs: '[string] The path to the built project (with -PassThru, the result object instead).'
    examples:
      - |-
        Invoke-BuildForVSCode
        Builds Catzc.Types.csproj so the editor's C# analysis matches the runtime.
      - |-
        Invoke-BuildForVSCode -Configuration Release -PassThru
        Builds Release and returns the result object for inspection.
---
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

    $result = Invoke-Executable "dotnet build `"$project`" --configuration $Configuration" -PassThru

    if ($PassThru) {
        return $result
    }
    $project
}
