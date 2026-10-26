# pwsh/Base.Languages/types/LanguageEntryReaders.cs

The readers `LanguagesConfig` uses to build the parts of a language entry from its YAML.

## ReadLayout

A language's layout rows are `{ folder, role, extensions, live, shipped }`. A row at the module root (`.`) lists the extensions it places,
all among the language's own; any other row places every file in its folder. `live` and `shipped` default to true, the default every
language row takes; only the shared tests row differs, and it is declared on `LayoutRow`.

## ReadTests

A language's test runner is a runner command, the parameter its executable binds to, and either the tools that must resolve or the one
engine the tests run under, never both and never neither.
