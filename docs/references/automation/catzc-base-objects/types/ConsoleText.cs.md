---
catzc:
  immutable:
    with_body_sha: "964a8351c982"
    path: docs/references/automation/catzc-base-objects/types/ConsoleText.cs.md
    folder: docs/references/automation/catzc-base-objects/types
    name: console-text-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Objects/types/ConsoleText.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The shared console rendering of every catzc C# type, so an object held in pwsh reads as one clean line
wherever PowerShell turns it into text: "$x", [string]$x, -join, Write-Message "… $x", and a table cell.
PowerShell's interpolation and [string] casts call the type's own .NET ToString() and ignore an ETS
ToString, so each type overrides ToString() with one line that delegates here:

    public override string ToString() => this.ToConsoleString();

DictionaryRecord does this once for every record derived from it. The output follows the C# record
convention, `TypeName { A = 1, B = x }`, on one line:

  - the properties are those named by [ConsoleDisplay(...)], else every public readable property;
  - a null property is omitted (the DictionaryRecord "present" rule), so the line carries only what is set;
  - a value renders through ToConsoleValue: strings as-is ('' when empty, newlines escaped, cut at
    MaxTextLength), numbers and
    other IFormattable invariantly, dates as ISO 8601, enums by name, collections as [a, b] capped at
    MaxItems, dictionaries as { k = v }, and a nested object by its own ToString();
  - nesting stops at MaxDepth, where an object renders as its bare type name, so a cycle cannot recurse.

A rendering never throws for a value: a getter that throws renders as !<ExceptionName>. BCL only.
```

## comment:2

Above `private static bool IsDataProperty(PropertyInfo property)`, written with `//`.

```text
A public readable non-indexer property the type declares — not DictionaryRecord's own view members
(Keys), and not one marked [Hidden] from PowerShell.
```

## comment:3

Above `private static bool IsHidden(PropertyInfo property)`, written with `//`.

```text
PowerShell's [Hidden], matched by name so this file stays BCL-only: the Bash time-safeguard hook compiles
it (through DictionaryRecord) into a program that does not reference System.Management.Automation.
```
