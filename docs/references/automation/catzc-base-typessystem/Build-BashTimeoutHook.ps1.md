---
catzc:
  immutable:
    with_body_sha: "6d30b15aacf1"
    repo_status: locked
    path: docs/references/automation/catzc-base-typessystem/Build-BashTimeoutHook.ps1.md
    folder: docs/references/automation/catzc-base-typessystem
    name: build-bash-timeout-hook-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$sources = @(Get-ChildPath $project -File -Filter '*.cs', '*.csproj' -Depth 1...`, written with `#`.

```text
The sources are this folder's *.cs/*.csproj plus every linked <Compile Include> (the module types the hook
compiles in), so a change to any of them republishes the hook.
```

## comment:2

Above `$assemblyName = $projectXml.Project.PropertyGroup.AssemblyName | Where-Object...`, written with `#`.

```text
The program's name is the project's AssemblyName — the one place it is set. The publish adds the platform's
executable extension (if any), so the program is found as an application by that name, never by a guessed suffix.
```

## comment:3

Above ``Invoke-Executable "dotnet publish `"$csproj`" --configuration Release...``, written with `#`.

```text
--disable-build-servers: no MSBuild node or compiler server outlives the publish. A server started here would
inherit this call's output pipe and hold it open for its whole idle lifetime (minutes), so the caller — the
importer, or a test run priming a snapshot — would wait on that pipe long after dotnet itself exited.
```
