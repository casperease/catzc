# DORA explanations — BCL

The `Dora explains` rationale for the records in the `automation/BCL/` domain, consolidated in one place. Each entry names its record and
rule code, then reproduces that record's tie to [DORA](../../../references/dora/index.md) research and the domain-relevant capability links.
The decisions live in the records themselves; this file carries only their DORA rationale.

## Native C# types

`Native C# types — one combined assembly, namespace per module`

[ADR-BCL-TYPES](native-csharp-types.md)

> DORA research links code maintainability and loosely coupled architecture to faster delivery and fewer defects. This record encodes the
> platform's models as native types with fixed shapes, versioned assemblies, and dependency-governed layering, reducing the cognitive load
> of loose dictionaries.

- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — fixed, discoverable type shapes and standardized
  namespace patterns.
- [Loosely coupled teams](../../../references/dora/capabilities.md#loosely-coupled-teams) — dependency graph governs cross-module type
  references and enforces layering.
- [Version control](../../../references/dora/capabilities.md#version-control) — committed prebuilt assembly; everything-as-code principle
  enables reproducible builds.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.
