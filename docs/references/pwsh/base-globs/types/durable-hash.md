# pwsh/Base.Globs/types/DurableHash.cs

The durable-SHA digest primitives, in native code
([FDR-GLOBS-DURABLESHAIDENTITY](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-durableshaidentity)). A globset may include large
binaries, such as the committed type assembly, where a per-byte PowerShell pipeline takes minutes and this takes milliseconds. It uses the
BCL only. See [FDR-GLOBS](../../../../drs/flow/durable-sha-globs.md).

## HashFile

`HashFile` is SHA-256 over the file's bytes with every CR (0x0D) stripped, so it is end-of-line insensitive and CRLF and LF working trees
agree. It returns 64 lowercase hex characters, or null when the file is absent, so the caller can fold the distinct `missing` marker for a
tracked-but-deleted member.

## HashFold

`HashFold` is SHA-256 over the UTF-8 fold text, again as 64 lowercase hex characters.
