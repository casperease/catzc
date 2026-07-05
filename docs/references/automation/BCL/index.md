# BCL (C# / .NET types) — automation reference

**BCL** is the .NET **Base Class Library** — the standard set of libraries built into the .NET runtime, spanning the `System.*` (and, to a
limited extent, `Microsoft.*`) namespaces. It is the general-purpose, lower-level framework that every higher-level .NET framework builds
on: the foundational types (`Object`, `String`, `Array`, `Int32`), collections, IO, serialization, and the rest. Microsoft also calls the
same set the runtime libraries, framework libraries, or shared framework. See the [Microsoft references](#microsoft-references) below for
the authoritative definitions.

The automation platform authors part of its code as native C# types (the `types/*.cs` sources), compiled into one combined assembly and
loaded at import. Those types compile against the **host-guaranteed assemblies** — the BCL plus `System.Management.Automation`, both in
`Add-Type`'s default reference set — and nothing else: there is no NuGet in this toolset, so a type may use only what the `pwsh` host itself
ships (see [native-csharp-types rule ADR-TYPES:5](../../../adr/automation/BCL/native-csharp-types.md)). This area collects the BCL-side
reference material.

- [The type system](types-system.md) — the combined assembly, the shared `DictionaryRecord` base, and the type-accelerator aliases.

The governing decision is the [native-csharp-types](../../../adr/automation/BCL/native-csharp-types.md) ADR. The modules most involved are
[`Catzc.Base.Objects`](../catzc-base-objects.md) (the `DictionaryRecord` base and shared records) and
[`Catzc.Base.TypesSystem`](../catzc-base-typessystem.md) (the IDE project build).

## Microsoft references

The BCL is Microsoft's, not ours — these are the authoritative public sources for what it is and what it contains.

- [Base Class Library (BCL) — .NET glossary](https://learn.microsoft.com/en-us/dotnet/standard/glossary#bcl) — the one-paragraph definition:
  the `System.*`/`Microsoft.*` namespaces that higher-level frameworks build on.
- [Runtime libraries overview](https://learn.microsoft.com/en-us/dotnet/standard/runtime-libraries-overview) — what the runtime libraries
  provide and how the BCL relates to the shared framework and its NuGet extensions.
- [Overview of core .NET libraries](https://learn.microsoft.com/en-us/dotnet/standard/class-library-overview) — a tour of the core library
  areas: the `System` namespace, data structures, and utility APIs.
- [.NET API browser](https://learn.microsoft.com/en-us/dotnet/api/) — the searchable per-type API reference for everything the BCL ships.
- [Add-Type](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/add-type) — the PowerShell cmdlet the importer
  uses to compile the `types/*.cs` sources into the combined assembly.
