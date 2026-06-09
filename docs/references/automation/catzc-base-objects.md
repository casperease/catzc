# Catzc.Base.Objects

The object-shaping and serialization module. It owns the conversions between the typed object model and the mutable, flat, sorted, or
YAML-serializable forms the rest of the platform needs — the object-shaping helpers that convert typed objects to mutable dictionaries,
flatten nested settings to dotted keys, and deep-clone a structure, together with the recursive reflector the output writers rely on for
clean YAML emission. It also owns `DictionaryRecord` (`Catzc.Base.Objects.DictionaryRecord`), the shared C# base class that typed records
across the codebase derive from, giving each record a dictionary view and constructor-level extraction helpers without per-module
boilerplate. The module belongs to the `Base` group and depends on [Catzc.Base.Asserts](catzc-base-asserts.md); the vendored
`powershell-yaml` is used by the serialization layer.

## Domains

| Domain   | Area          | Name                                                               |
| -------- | ------------- | ------------------------------------------------------------------ |
| domain:1 | shaping       | [Object shaping and cloning](#domain1--object-shaping-and-cloning) |
| domain:2 | serialization | [YAML-safe serialization](#domain2--yaml-safe-serialization)       |

### domain:1 — Object shaping and cloning

The conversions that take a typed object, PSCustomObject, or dictionary and produce a mutable or flat structural form. The domain covers the
full spectrum a consumer needs after leaving the typed model: turning a frozen record into a nested ordered-dictionary tree ready to mutate
or splice into a larger structure; flattening a nested configuration to a flat ordered dictionary of dot-notation keys so every leaf value
is directly addressable; normalising key order across dictionary types so serialized and compared output is stable and easy to diff
regardless of whether the source was an `[ordered]@{}` or a plain hashtable; and deep-cloning a mixed tree without serialization, leaving
the source unchanged.

### domain:2 — YAML-safe serialization

The recursive reflector at the base of both the shaping layer and the output writers. This domain provides the primitive that walks any
object — typed class, PSCustomObject, dictionary, or enumerable — via `PSObject.Properties`, `IDictionary`, and `IEnumerable`, reducing
every level to ordered dictionaries, arrays, and scalars that the vendored `ConvertTo-Yaml` can serialise without falling back to
`ToString()`. The shaping domain calls it as the reflection engine inside its general conversion function; the output writers call it
independently before emitting YAML. Being a public function rather than a private helper is what makes both call sites possible without
duplication.

## What the module does

This module is the shaping layer between the typed object model and everything that needs to read, mutate, or serialise it. The two domains
are stratified: domain 2 is the recursive reflector at the bottom — it knows how to walk any object and reduce it to the
ordered-dict/array/scalar form a YAML serializer can consume; domain 1 builds on top of it, using that reflector as the engine for the
general conversion function while adding the flat, sorted, and clone forms for different consumer needs.

The four shaping functions in domain 1 each serve a distinct downstream use. The escape hatch from a frozen typed record to a mutable nested
tree is what lets a caller splice a record into a structure they are about to mutate, or hand it to a serializer. The flat key/value form is
the assertion helper — a flat dictionary makes it easy to walk every leaf and assert no value is missing or undefined. The sorted form is
the stability helper — plain hashtable key order is non-deterministic, so sorting before writing a file or comparing in a test makes output
consistent. The clone form is the mutation helper — deep-clone before modifying so the original record is never changed by side-effect, even
through a complex tree of nested dictionaries and arrays.

The module also owns `DictionaryRecord` (full name `Catzc.Base.Objects.DictionaryRecord`), the shared C# base class typed records across the
codebase derive from (see [native-csharp-types](../../adr/automation/BCL/native-csharp-types.md)). Every module's types compile into one
assembly, so a record in any module can inherit from this single class without a per-module copy. `DictionaryRecord` supplies two things
every record used to hand-roll: a dictionary _view_ over its own public, readable, non-indexed properties (`Contains`, the `[key]` indexer,
`Keys`, `ToHashtable()`), and the protected extraction helpers (`Req`, `OptStr`, `StrArr`, `Flag`) that constructors called when reading
from a source `IDictionary`. A deriving module must declare a dependency that resolves to `Catzc.Base.Objects` in `dependencies.yml` —
consumers that pin the `Base` group (e.g. `Catzc.Azure.Templates` and `Catzc.Tooling.Core`, whose `BicepTemplate` and `ToolConfig` derive
from it) satisfy this automatically, since `Catzc.Base.Objects` is a `Base` member.

## Division

The module's public functions, sorted into the domains above.

| Domain                                | Function                     |
| ------------------------------------- | ---------------------------- |
| domain:1 — Object shaping and cloning | `ConvertTo-Dictionary`       |
|                                       | `ConvertTo-FlatSettingSet`   |
|                                       | `ConvertTo-SortedDictionary` |
|                                       | `Copy-Object`                |
| domain:2 — YAML-safe serialization    | `ConvertTo-YamlSafe`         |
