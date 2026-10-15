---
catzc:
  derived:
    path: docs/adr/automation/BCL/index.md
    kind: adr
    body_sha: "340ada650a79"
    links:
      - docs/adr/automation/BCL/native-csharp-types.md
---

# BCL (C# / .NET types) automation ADRs

The ADRs here govern the native C# types the automation platform compiles and loads — the `types/*.cs` sources; see
[native-csharp-types](native-csharp-types.md). Cross-cutting, language-agnostic platform rules live one level up, directly under
`automation/`; the full code↔ADR registry is the ADR index at the root of `docs/adr/`.
