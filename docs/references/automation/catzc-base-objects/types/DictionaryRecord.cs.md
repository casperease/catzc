---
catzc:
  immutable:
    with_body_sha: bade05ffcf7d
    path: docs/references/automation/catzc-base-objects/types/DictionaryRecord.cs.md
    folder: docs/references/automation/catzc-base-objects/types
    name: dictionary-record-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Objects/types/DictionaryRecord.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The shared base for typed data records that mirror an [ordered]@{} / [pscustomobject] config shape. It
is the single base every such record across the codebase derives from (there is no per-module copy), and
it gives a record three capabilities a loose dictionary lacks or had for free:

  1. A dictionary VIEW over the record's own public properties, so it still splats and serializes like a
     dictionary (ConvertTo-Json/-Yaml): Contains(key), the [key] indexer, Keys, ToHashtable(). "Present"
     means the public property exists AND its value is non-null — mirroring the omitted-key idiom of the
     ordered dictionaries these records replace, so setting an absent optional to null makes
     Contains(key) false.
  2. A console-ready ToString() through ConsoleText, so every derived record reads as one line in pwsh.
  3. protected static extraction helpers (Req / OptStr / StrArr / Flag) a derived constructor uses to read
     its source IDictionary, so the read-and-validate logic is defined once here, not per record.
```

## comment:2

Above `private static bool IsDataProp(PropertyInfo p)`, written with `//`.

```text
A "data" property is one the DERIVED record declares — not this base's own view members (Keys, the
indexer). Excluding them is also what stops Keys/ToHashtable from recursing into get_Keys() forever.
```
