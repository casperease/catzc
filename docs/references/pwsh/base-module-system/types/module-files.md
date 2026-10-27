# pwsh/Base.ModuleSystem/types/ModuleFiles.cs

One module's entry in `files.yml` (`modules: <module>: { packages: { <package>: [paths] } }`): the named packages of
repository-root-relative file artifacts the module owns beyond its own folder, which `Copy-CatzcModule` copies with it. Its properties
mirror the YAML keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing an entry maps and validates it and gathers every violation into one `ArgumentException`:

- the entry is a map whose only key is a non-empty `packages` map;
- each package name is snake_case;
- each package is a non-empty list of non-empty paths, not a single string;
- each path is repository-root-relative and forward-slashed: no `\`, no leading `/`, no `:` and no `..` segment.

Package-name uniqueness spans modules, so `FilesConfig` checks it.

## Properties

- **`packages`** — package name to its path list, in declaration order, read-only.
