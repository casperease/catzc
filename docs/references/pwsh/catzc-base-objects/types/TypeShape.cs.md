# pwsh/Catzc.Base.Objects/types/TypeShape.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static class TypeShape`, written with `//`.

```text
The reflected properties of a type, read once. The table is keyed by Type and filled on first use: a loaded type cannot change in
a process (ADR-AUTO-TYPES#7), so an entry cannot go stale, and it is not a session cache of the file set (ADR-AUTO-CACHE).
```

## comment:2

Above `if (!property.CanRead || property.GetIndexParameters().Length != 0 ||...`, written with `//`.

```text
A "data" property is one the DERIVED record declares — not DictionaryRecord's own view members (Keys, the
indexer). Excluding them is also what stops Keys/ToHashtable from recursing into get_Keys() forever.
```

## comment:3

Above `private static bool IsHidden(PropertyInfo property)`, written with `//`.

```text
PowerShell's [Hidden], matched by name so this file stays BCL-only: the Bash time-safeguard hook compiles
it (through DictionaryRecord) into a program that does not reference System.Management.Automation.
```
