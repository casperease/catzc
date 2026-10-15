---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md
    kind: comment-page
    body_sha: "2cdc2c6913dd"
    adrs:
      - ADR-AUTO-FAILFAST#7
---

# automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The hook (.claude/hooks/Assert-BashTimeout/) runs before every Bash call an agent makes and denies a call that
does not run inside the safeguard
([ADR-AUTO-FAILFAST#7](/docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast7)). It is a
compiled program rather than a script because it runs that often: it starts in about a third of the time pwsh
does. This publishes it, framework-dependent, to .claude/hooks/bin/ (gitignored), and records a hash of the
sources beside it; while the hash matches and the program is present, it does nothing, so the importer can run
it on every import.

dotnet runs through Invoke-Executable rather than Invoke-Dotnet: that wrapper lives in the Tooling layer, which
this Base module must not depend on, so dotnet must be on PATH. The hook's C# code lives in the source tree, so it
stops with a named error in build mode (Assert-SourceTree, [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)).
```

## comment:2

Above `$sources = @(Get-ChildItem -LiteralPath $project -File | Where-Object ...`.

```text
The sources are this folder's *.cs/*.csproj plus every linked <Compile Include> (the module types the hook
compiles in), so a change to any of them republishes the hook.
```

## comment:3

Above `$assemblyName = $projectXml.Project.PropertyGroup.AssemblyName | Where-Object...`.

```text
The program's name is the project's AssemblyName — the one place it is set. The publish adds the platform's
executable extension (if any), so the program is found as an application by that name, never by a guessed suffix.
```

## comment:4

Above ``Invoke-Executable "dotnet publish `"$csproj`" --configuration Release ...``.

```text
--disable-build-servers: no MSBuild node or compiler server outlives the publish. A server started here would
inherit this call's output pipe and hold it open for its whole idle lifetime (minutes), so the caller — the
importer, or a test run priming a snapshot — would wait on that pipe long after dotnet itself exited.
```
