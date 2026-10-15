---
catzc:
  derived:
    path: docs/references/automation/catzc-base-objects/ConvertTo-Dictionary.ps1.md
    kind: comment-page
    body_sha: "6f1d3c50b5c4"
---

# automation/Catzc.Base.Objects/ConvertTo-Dictionary.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The escape hatch from the native data-model classes back to a dictionary surface. It walks public
properties via PSObject.Properties — the same channel that exposes a C# class's get-only properties and
a PSCustomObject's note-properties — recursing through nested objects and arrays; scalars pass through.
The result is a fresh, mutable copy, so the source object is unchanged.

Use it at the seam where a frozen typed object must be spliced into a tree you are about to mutate, or
serialized (e.g. into a per-slot ParametersFile, or to YAML/JSON). Read-only navigation needs no
conversion — read the typed object's properties directly.

Keys are the object's property names (snake_case for the config-mirroring data-model types, so a
round-trip back to YAML stays byte-compatible with the original config).
```

## comment:2

Above `$dict = ConvertTo-YamlSafe -Value $InputObject -MaxDepth $MaxDepth`.

```text
ConvertTo-YamlSafe is the shared recursive reflector — it already turns any object (typed class,
PSCustomObject, dictionary, array) into nested ordered dicts / arrays / scalars via
PSObject.Properties. We reuse it for the dictionary form, then optionally re-shape to PSCustomObjects.
```

## comment:3

Above `$dict = ConvertTo-YamlSafe -Value $InputObject -MaxDepth $MaxDepth`.

```text
ConvertTo-YamlSafe is the shared recursive reflector — it already turns any object (typed class,
PSCustomObject, dictionary, array) into nested ordered dicts / arrays / scalars via
PSObject.Properties. We reuse it for the dictionary form, then optionally re-shape to PSCustomObjects.
```
