---
catzc:
  immutable:
    with_body_sha: a57eb9def1d6
    repo_status: locked
    path: docs/references/automation/catzc-base-objects/private/Expand-ObjectProperties.ps1.md
    folder: docs/references/automation/catzc-base-objects/private
    name: expand-object-properties-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Objects/private/Expand-ObjectProperties.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Recursively flattens a nested object into dot-notation key/value pairs.

### description

Walks PSCustomObject, IDictionary, and array structures, building dot-separated paths for each leaf value and adding them to the supplied
OrderedDictionary. Arrays use `[index]` notation. Used internally by ConvertTo-FlatSettingSet.

### parameter Value

The object, or the nested value, to flatten.

### parameter Target

The ordered dictionary that receives the dot-notation key/value pairs.

### parameter Prefix

The key path so far, extended with each property name or `[index]` on the way down.

### parameter MaxDepth

The depth at which flattening stops. Default 10.

### parameter Depth

The depth reached so far; callers leave it at 0 and the recursion raises it.

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
