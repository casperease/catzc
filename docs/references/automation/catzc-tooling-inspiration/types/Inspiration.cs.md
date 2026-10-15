# docs/references/automation/catzc-tooling-inspiration/types/Inspiration.cs.md

`automation/Catzc.Tooling.Inspiration/types/Inspiration.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One inspiration as Get-Inspiration reports it on this machine: its id, where its root resolves here, whether that
root exists, what it is, and the folders inside it worth reading
([ADR-REPO-INSPIRE#1](/docs/adr/repository/inspiration.md#rule-adr-repo-inspire1)). An inspiration that is absent is
reported with Available false, never thrown on: the work carries on without it.

Root is absolute. An inspiration lives outside the repository, so no repository-relative form exists and the path
degrades to a normalized absolute ([ADR-AUTO-PATH#5](/docs/adr/automation/path-representation.md#rule-adr-auto-path5));
the stored, portable form stays in inspiration.yml.
```
