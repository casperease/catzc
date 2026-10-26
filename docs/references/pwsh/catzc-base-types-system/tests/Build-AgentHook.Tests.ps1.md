# pwsh/Catzc.Base.TypesSystem/tests/Build-AgentHook.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$null = New-Item -ItemType Directory -Force -Path $script:outputDirectory`, written with `#`.

```text
Stand in for `dotnet publish`: copy this host's own executable to where the real publish puts the
program, so it carries the platform's real executable extension and resolves as an application.
```

## comment:2

Above `It 'lists no package feed from the hook folder <name>' -ForEach @(`, written with `#`.

```text
NuGet reads its config from the project's folder up, so each hook folder must see the generated root config's
cleared feeds alone.
```
