# pwsh/Base.QualityGates/private/Invoke-DotnetFormat.ps1

The dotnet-format formatter engine: it formats the given C# files with `dotnet format whitespace` and returns the files it changed. It is
one Format-Code engine adapter, and it formats by the repository's .editorconfig alone.

## help

### synopsis

The dotnet-format formatter engine: formats the given C# files with `dotnet format whitespace` and returns the files it changed.

### description

One Format-Code engine adapter
([PDR-CONFIG-NEWINSTANCEISCONFIG](../../../../drs/principles/configure-not-program.md#rule-pdr-config-newinstanceisconfig)).
`dotnet format whitespace --folder` formats by the repository's .editorconfig alone — the same rules the editor's C# extension applies —
with no project to load, so it takes seconds and needs only the .NET SDK. `--verify-no-changes` with a JSON `--report` names the files that
differ; without -DryRun, a second run over exactly those rewrites them. Exit codes: 0 = clean, 2 = files differ (expected), anything else is
a tool error, which throws with the output.

The workspace is the repository root, so a file outside it is not formatted. A changed C# type source changes the compiled-type cache key,
so the next import rebuilds the combined types assembly.

### parameter `File`

Absolute paths of the .cs files to format.

### parameter `DryRun`

List the files dotnet format would change without writing them.

### outputs

`[string[]]` Absolute paths of the files changed (or, under -DryRun, that would change).
