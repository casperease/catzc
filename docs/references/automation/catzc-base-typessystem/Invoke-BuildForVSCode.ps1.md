---
catzc:
  immutable:
    with_body_sha: "1bd5d0ba42ef"
    repo_status: locked
    path: docs/references/automation/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md
    folder: docs/references/automation/catzc-base-typessystem
    name: invoke-build-for-vs-code-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Builds the IDE-only C# type project (Catzc.Types.csproj) so VS Code's C# Dev Kit sees the native type sources — the editor-facing build
pathway, separate from the runtime's Add-Type compile.

### description

The runtime compiles every `automation/<Module>/types/*.cs` at import with Add-Type (Import-CSharpTypes), and that path is never touched
here. This is the SECOND, editor-facing pathway: it drives `dotnet build` over the committed automation/.internal/assets/Catzc.Types.csproj
(auto-loaded in the editor via the root catzc.sln). That build does two things Add-Type does not — it runs the Roslyn analyzers
(EnableNETAnalyzers), and it runs the project's stamp task, which FAILS when the committed `automation/.compiled/Catzc.Types.<hash>.dll` is
stale versus the sources. So a green build both warms Dev Kit's IntelliSense — making Go-to-Symbol (Ctrl+T) and F12 over the C# types
resolve to source, the backtrack a bare type accelerator cannot give — and verifies the IDE project matches the runtime prebuild.

dotnet runs through Invoke-Executable rather than Invoke-Dotnet: that wrapper (with its locked-SDK assertion) lives in the Tooling layer,
which this Base module must not depend on. So there is no locked-version check here; dotnet must be on PATH. See
[ADR-AUTO-TYPES](../../../adr/automation/BCL/native-csharp-types.md).

The project builds the source tree's `types/*.cs`, so it stops with a named error in build mode (Assert-SourceTree,
[ADR-DSGN-RUNMODE](../../../adr/design/run-modes.md)).

### parameter Configuration

The MSBuild configuration to build. Defaults to Debug.

### parameter PassThru

Return the executable result ({ Output, Errors, Full, ExitCode }) instead of the project path.

### outputs

`[string]` The path to the built project (with -PassThru, the result object instead).

### example 1

```powershell
Invoke-BuildForVSCode
Builds Catzc.Types.csproj so the editor's C# analysis matches the runtime.
```

### example 2

```powershell
Invoke-BuildForVSCode -Configuration Release -PassThru
Builds Release and returns the result object for inspection.
```

## comment:1

Above ``$result = Invoke-Executable "dotnet build `"$project`" --configuration...``, written with `#`.

```text
The stamp task's "stamped version …" line and any analyzer diagnostics stream through. A non-zero exit
(a stale committed DLL, an analyzer error) throws via Invoke-Executable.
```
