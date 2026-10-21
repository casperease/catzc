# BCL (C# / .NET types) automation ADRs

BCL is a language of its own in catzc: C# against the .NET Base Class Library, a subset of .NET, written in the `types/*.cs` sources. pwsh
is its host, not its owner: it compiles and loads the types inside the .NET runtime already running the session. Two ADRs govern it, one for
each:

- **The language:** [native-csharp-types](native-csharp-types.md), what the types are: one per file, a namespace per module, one combined
  assembly, the build pair of the language's projects.
- **The hosting:** [hosting-csharp-types](../pwsh/hosting-csharp-types.md), how pwsh carries them: its compiler, the reference set it
  guarantees, the accelerators, and stale types in a running session.

Cross-cutting, language-agnostic platform rules live one level up, directly under `automation/`; the full code↔ADR registry is the ADR index
at the root of `docs/drs/`.
