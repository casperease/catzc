---
catzc:
  immutable:
    with_body_sha: f355f6d21e52
    repo_status: clean
    path: docs/how-to/getting-started/automation/BCL/index.md
    folder: docs/how-to/getting-started/automation/BCL
    name: index
    filetype: md
    kind: how-to
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/adr/automation/BCL/native-csharp-types.md
      - docs/how-to/getting-started/automation/BCL/add-a-dotnet-type.md
      - docs/references/automation/BCL/index.md
---

# BCL (C# / .NET types) how-to guides

Guides for working with the native C# types the automation platform loads. Language-agnostic getting-started guides live one level up, under
`automation/`.

For what **BCL** (the .NET Base Class Library) is, and the authoritative sources from Microsoft, see the
[BCL automation reference](../../../../references/automation/BCL/index.md). The design behind the platform's C# types is the
[native-csharp-types](../../../../adr/automation/BCL/native-csharp-types.md) ADR.

- [Add a C# type](add-a-dotnet-type.md) — drop a `.cs` in a module's `types/` folder and load it at import.
