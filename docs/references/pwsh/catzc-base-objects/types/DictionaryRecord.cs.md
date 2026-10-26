# pwsh/Base.Objects/types/DictionaryRecord.cs

The shared base for typed data records that mirror an `[ordered]@{}` or `[pscustomobject]` config shape. It is the single base every such
record across the codebase derives from, with no per-module copy.

## Capabilities

It gives a record three capabilities a loose dictionary lacks, or had for free:

1. A dictionary view over the record's own public properties, so the record still splats and serializes like a dictionary (`ConvertTo-Json`,
   `ConvertTo-Yaml`): `Contains(key)`, the `[key]` indexer, `Keys` and `ToHashtable()`. "Present" means the public property exists and its
   value is non-null, mirroring the omitted-key idiom of the ordered dictionaries these records replace, so setting an absent optional to
   null makes `Contains(key)` false.
2. A console-ready `ToString()` through `ConsoleText`, so every derived record reads as one line in pwsh.
3. Protected static extraction helpers (`Req`, `OptStr`, `StrArr`, `Flag`) that a derived constructor uses to read its source `IDictionary`,
   so the read-and-validate logic is defined once here, not per record.
