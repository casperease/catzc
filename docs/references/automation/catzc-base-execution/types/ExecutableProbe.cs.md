---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/types/ExecutableProbe.cs.md
    kind: comment-page
    body_sha: bfd29fc5caf8
---

# automation/Catzc.Base.Execution/types/ExecutableProbe.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One executable's existence check (Find-Executable): where the executable was found and how, the version it
reports against the required one, how long each step took, and the session actor the check ran as.
Resolve-ToolExecutable returns one for a tools.yml entry, and so does Test-Tool -PassThru.

Constructing an instance validates it: Name is required, Method is one of probe | path | none, and a found
executable carries a Path while a missing one carries none.
```

## comment:2

Above `public string Version { get; }`.

```text
The version the executable reports, parsed by the version pattern. Null when not found or when the output
does not match.
```

## comment:3

Above `public long VersionMs { get; }`.

```text
Milliseconds spent running the version command. 0 when nothing was found, or when the version came from
the session cache (no process was started).
```
