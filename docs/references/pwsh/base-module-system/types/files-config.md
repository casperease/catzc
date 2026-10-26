# pwsh/Base.ModuleSystem/types/FilesConfig.cs

The typed record for `files.yml`, the module-to-packages bindings `Copy-CatzcModule` reads: per module, the named packages of
repository-root-relative file artifacts it owns beyond its own folder. It is registered in `Catzc.Base.Config/configs/configs.yml`, so
`Get-Config -Config files` returns it. Its properties mirror the YAML keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing the record maps and validates the parsed YAML and gathers every violation into one `ArgumentException`:

- only the top-level key `modules` is allowed, and it is a required, non-empty map;
- every module entry is well-formed ([ModuleFiles](ModuleFiles.cs.md));
- each package name is globally unique across all modules, because it is the `-ExcludePackages` unit.

Module keys are module folder names such as `Catzc.Base.Repository` and `.internal`, so they are not checked for snake_case.

## Properties

- **`modules`** — module folder name to its `ModuleFiles`, in declaration order, read-only.
