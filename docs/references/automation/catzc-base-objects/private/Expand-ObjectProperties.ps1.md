---
catzc:
  immutable:
    with_body_sha: a57eb9def1d6
    path: docs/references/automation/catzc-base-objects/private/Expand-ObjectProperties.ps1.md
    folder: docs/references/automation/catzc-base-objects/private
    name: expand-object-properties-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Objects/private/Expand-ObjectProperties.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($Value -is [System.Collections.IDictionary]) {`, written with `#`.

```text
IDictionary and array are checked before PSCustomObject: a top-level value arrives here wrapped in a
PSObject (ConvertTo-FlatSettingSet binds [PSObject[]]), and a PSObject-wrapped dictionary matches
-is [PSCustomObject]. Routing it there would reflect the dictionary's own CLR members (Count, Keys,
SyncRoot, ...) instead of its entries. Matching the more specific shapes first keeps a dictionary a
dictionary and an array an array, wrapped or not.
```

## comment:2

Above `if (-not $Value.GetType().IsValueType -and $Value -isnot [string] -and $Value...`, written with `#`.

```text
Complex CLR object (e.g. a typed/validated config model): reflect over its public
members so a typed config subtree flattens the same way a dictionary or PSCustomObject
does. Strings and value types (numbers, bool, DateTime, Guid, enums) fall through to leaf.
```
