# pwsh/Base.Execution/types/ExecutableProbe.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One executable's existence check (Find-Executable): where the executable was found and how, the version it
reports against the required one, how long each step took, and the session actor the check ran as.
Resolve-ToolExecutable returns one for a tools.yml entry, and so does Test-Tool -PassThru.

Constructing an instance validates it: Name is required, Method is one of probe | path | none, and a found
executable carries a Path while a missing one carries none.
```

## comment:2

Above `public string Version { get; }`, written with `//`.

```text
The version the executable reports, parsed by the version pattern. Null when not found or when the output
does not match.
```

## comment:3

Above `public long VersionMs { get; }`, written with `//`.

```text
Milliseconds spent running the version command. 0 when nothing was found, or when the version came from
the session cache (no process was started).
```
