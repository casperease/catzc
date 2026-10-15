---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md
    kind: comment-page
    body_sha: "9e006bcb1bfc"
---

# automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
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
```

## comment:2

Above ``$result = Invoke-Executable "dotnet build `"$project`" --configuration ...``.

```text
The stamp task's "stamped version …" line and any analyzer diagnostics stream through. A non-zero exit
(a stale committed DLL, an analyzer error) throws via Invoke-Executable.
```

## comment:3

Above ``$result = Invoke-Executable "dotnet build `"$project`" --configuration...``.

```text
The stamp task's "stamped version …" line and any analyzer diagnostics stream through. A non-zero exit
(a stale committed DLL, an analyzer error) throws via Invoke-Executable.
```
