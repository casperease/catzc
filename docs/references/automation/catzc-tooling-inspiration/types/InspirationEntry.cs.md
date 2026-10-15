# docs/references/automation/catzc-tooling-inspiration/types/InspirationEntry.cs.md

`automation/Catzc.Tooling.Inspiration/types/InspirationEntry.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One inspiration of configs/inspiration.yml, as stored: an id, the root it lives at, what it is, and the folders
inside it worth reading. Constructing one MAPS and VALIDATES the entry, and every violation is reported in one
throw, prefixed with the entry's position. Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Load-time rules:
  - a mapping whose keys are id, root, description and paths;
  - 'id' is kebab-case (lowercase words joined by '-');
  - 'root' is in communication form, repository-relative or {workspace}-anchored (InspirationRoot.Violations);
  - 'description' is non-blank;
  - 'paths', when present, lists relative paths inside the root, with no anchor.
```
