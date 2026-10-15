---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md
    kind: comment-page
    body_sha: "856b6a3be587"
---

# automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `$sources = @(Get-ChildPath $project -File -Filter '*.cs', '*.csproj' -Depth 1...`.

```text
The sources are this folder's *.cs/*.csproj plus every linked <Compile Include> (the module types the hook
compiles in), so a change to any of them republishes the hook.
```

## comment:6

Above `$assemblyName = $projectXml.Project.PropertyGroup.AssemblyName | Where-Object...`.

```text
The program's name is the project's AssemblyName — the one place it is set. The publish adds the platform's
executable extension (if any), so the program is found as an application by that name, never by a guessed suffix.
```

## comment:7

Above ``Invoke-Executable "dotnet publish `"$csproj`" --configuration Release...``.

```text
--disable-build-servers: no MSBuild node or compiler server outlives the publish. A server started here would
inherit this call's output pipe and hold it open for its whole idle lifetime (minutes), so the caller — the
importer, or a test run priming a snapshot — would wait on that pipe long after dotnet itself exited.
```
