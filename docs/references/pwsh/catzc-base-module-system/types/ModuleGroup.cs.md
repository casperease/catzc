# pwsh/Base.ModuleSystem/types/ModuleGroup.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One declared module group of configs/dependencies.yml (`groups: <name>: <member>: [members]`): a named set of
on-disk modules with its own internal member -> member DAG — a concept, not a disk module
([ADR-AUTO-DEPM-TWOSECTIONS](/docs/drs/automation/controlling-module-dependencies.md#rule-adr-auto-depm-twosections)). Constructing
one MAPS and VALIDATES the group's member map, collecting every violation into one throw:
  - the group maps to a map of member modules (not a list or string);
  - each member maps to a list of member names (not a single string);
  - no member depends on itself, and every dependency is a member of the SAME group (the group is closed);
  - the internal member graph is acyclic.
Members are matched case-insensitively, like the PowerShell ordered dictionary the YAML parses into.
```
