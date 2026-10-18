# automation/Catzc.Base.Objects/ConvertTo-Dictionary.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Converts a typed object, PSCustomObject, or dictionary into a nested, mutable structure of ordered dictionaries (default) or PSCustomObjects
(-AsPSObject).

### description

The escape hatch from the native data-model classes back to a dictionary surface. It walks public properties via PSObject.Properties — the
same channel that exposes a C# class's get-only properties and a PSCustomObject's note-properties — recursing through nested objects and
arrays; scalars pass through. The result is a fresh, mutable copy, so the source object is unchanged.

Use it at the seam where a frozen typed object must be spliced into a tree you are about to mutate, or serialized (e.g. into a per-slot
ParametersFile, or to YAML/JSON). Read-only navigation needs no conversion — read the typed object's properties directly.

Keys are the object's property names (snake_case for the config-mirroring data-model types, so a round-trip back to YAML stays
byte-compatible with the original config).

### parameter `InputObject`

The object to convert.

### parameter `AsPSObject`

Emit nested `[PSCustomObject]` instead of `[ordered]` dictionaries.

### parameter `MaxDepth`

Maximum recursion depth (default 10).

### example 1

```powershell
$env = Get-AzureEnvironment dev -Subscription shared_nonprod | ConvertTo-Dictionary
$env.subscription.customer = 'override'   # the dict is mutable; the typed object was not
```

### example 2

```powershell
Get-BicepTemplate sample | ConvertTo-Dictionary -AsPSObject
```

## comment:1

Above `$dict = ConvertTo-YamlSafe -Value $InputObject -MaxDepth $MaxDepth`, written with `#`.

```text
ConvertTo-YamlSafe is the shared recursive reflector — it already turns any object (typed class,
PSCustomObject, dictionary, array) into nested ordered dicts / arrays / scalars via
PSObject.Properties. We reuse it for the dictionary form, then optionally re-shape to PSCustomObjects.
```
