---
catzc:
  derived:
    path: docs/references/automation/catzc-base-objects/private/Expand-ObjectProperties.ps1.md
    kind: comment-page
    body_sha: "16edba9f7197"
---

# automation/Catzc.Base.Objects/private/Expand-ObjectProperties.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `if ($Value -is [System.Collections.IDictionary]) {`.

```text
IDictionary and array are checked before PSCustomObject: a top-level value arrives here wrapped in a
PSObject (ConvertTo-FlatSettingSet binds [PSObject[]]), and a PSObject-wrapped dictionary matches
-is [PSCustomObject]. Routing it there would reflect the dictionary's own CLR members (Count, Keys,
SyncRoot, ...) instead of its entries. Matching the more specific shapes first keeps a dictionary a
dictionary and an array an array, wrapped or not.
```

## comment:5

Above `if (-not $Value.GetType().IsValueType -and $Value -isnot [string] -and $Value...`.

```text
Complex CLR object (e.g. a typed/validated config model): reflect over its public
members so a typed config subtree flattens the same way a dictionary or PSCustomObject
does. Strings and value types (numbers, bool, DateTime, Guid, enums) fall through to leaf.
```
