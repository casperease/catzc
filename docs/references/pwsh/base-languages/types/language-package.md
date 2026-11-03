# pwsh/Base.Languages/types/LanguagePackage.cs

How a language's modules are packaged into a bundle: the exporter command and the shipped form it produces
([ADR-AUTO-BUNDLE-EVERYLANGUAGE](../../../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-everylanguage)).

## Properties

- **`command`** — the `Verb-Noun` command that exports one module of the language into the bundle. It is validated by form only, so the
  command may not exist yet.
- **`form`** — the shipped form of the module: one of `binary`, `source`, `wheels` or `vsix`. The list is declared once, on `Forms`.
