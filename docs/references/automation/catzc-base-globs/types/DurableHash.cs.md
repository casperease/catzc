# docs/references/automation/catzc-base-globs/types/DurableHash.cs.md

`automation/Catzc.Base.Globs/types/DurableHash.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The durable-SHA digest primitives ([ADR-FLOW-CD-GLOBS#5](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs5)), in native code: a
globset may include large binaries
(the committed type assembly is a tracked file), where a per-byte PowerShell pipeline takes minutes and
this takes milliseconds. HashFile is SHA-256 over the file's bytes with every CR (0x0D) stripped —
EOL-insensitive, so CRLF and LF working trees agree — and HashFold is SHA-256 over the UTF-8 fold text;
both return 64 lowercase hex chars. BCL only.
See [ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md).
```

## comment:2

Above `public static string HashFile(string path)`.

```text
SHA-256 (lowercase hex) of the file's bytes with every CR stripped; null when the file is absent —
the caller folds the distinct 'missing' marker for a tracked-but-deleted member.
```
