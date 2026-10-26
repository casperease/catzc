# pwsh/Base.Languages/types/BclConfig.cs

The typed record for `bcl.yml`, the BCL language's own config: the one build configuration and platform every non-vendored `.sln` and
`.csproj` declares, and every dotnet call builds (ADR-BCL-TYPES-DEBUGANYCPU). It also holds the host bindings, each a `BclHostBinding`.
