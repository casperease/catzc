# pwsh/Base.Objects/types/ConsoleText.cs

The shared console rendering of every catzc C# type, so an object held in pwsh reads as one clean line wherever PowerShell turns it into
text: `"$x"`, `[string]$x`, `-join`, `Write-Message "… $x"` and a table cell. It is BCL only.

## Why each type overrides ToString

PowerShell's interpolation and `[string]` casts call the type's own .NET `ToString()` and ignore an ETS `ToString`. Each type therefore
overrides `ToString()` with one line that delegates here:

```csharp
public override string ToString() => this.ToConsoleString();
```

`DictionaryRecord` does this once for every record derived from it.

## Output form

The output follows the C# record convention, `TypeName { A = 1, B = x }`, on one line:

- the properties are those named by `[ConsoleDisplay(...)]`, else every public readable property;
- a null property is omitted (the `DictionaryRecord` "present" rule), so the line carries only what is set;
- a value renders through `ToConsoleValue`: strings as-is (`''` when empty, newlines escaped, cut at `MaxTextLength`), numbers and other
  `IFormattable` invariantly, dates as ISO 8601, enums by name, collections as `[a, b]` capped at `MaxItems`, dictionaries as `{ k = v }`,
  and a nested object by its own `ToString()`;
- nesting stops at `MaxDepth`, where an object renders as its bare type name, so a cycle cannot recurse.

A rendering never throws for a value: a getter that throws renders as `!<ExceptionName>`.
