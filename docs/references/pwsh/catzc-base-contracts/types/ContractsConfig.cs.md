# pwsh/Catzc.Base.Contracts/types/ContractsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The contracts settings (configs/contracts.yml), and the single declaration of their sensible defaults: every key is
optional, and an omitted key, or a fresh checkout with no file, behaves exactly like the default, so no function
restates a value ([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). A Get-Contract
parameter overrides the resolved value per call
([ADR-PWSH-PARAM-RESOLUTIONORDER](/docs/adr/automation/pwsh/parameter-design.md#rule-adr-pwsh-param-resolutionorder)).
  addressing    how one contract asset addresses many files
                ([ADR-REPO-CONTRACT-CONFIGUREDADDRESSING](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract-configuredaddressing)), one of
                AddressingModes; default full-path (an asset addresses the one real file at its own path). A mode in
                AddressingModes but not in BuiltAddressingModes is declared and valid here, and Get-Contract throws
                NotImplementedException when it is selected.
  target_roots  each owning module's target root
                ([ADR-REPO-CONTRACT-LAYOUT](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract-layout)): a map of module
                name to the repository-relative folder its assets' paths are relative to, in ordinal module order. A
                module the map does not name takes DefaultTargetRoot, the repository root (ResolveTargetRoot). A root
                is '/'-separated segments of letters, digits, '.', '_' and '-', with no leading or trailing slash and
                no '.' or '..' segment; a dot-prefixed root such as '.github' is how an asset reaches a file under a
                dot-prefixed root, since contracts/ holds no dot-prefixed folder
                ([ADR-REPO-CONTRACT-NODOTFOLDERS](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract-nodotfolders)).
Property names mirror the YAML keys (snake_case,
[ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
```

## comment:2

Above `public static readonly string[] AddressingModes = { "full-path",...`, written with `//`.

```text
Every declared addressing mode: full-path (the asset's own path), manifest-glob (a glob in a manifest names the
files), per-folder (one asset applies to each file of its folder).
```

## comment:3

Above `public static readonly string[] BuiltAddressingModes = { "full-path" };`, written with `//`.

```text
The modes that are built. A mode joins this list only once it is proven from every engine (ExecutionEngines),
since a contract is resolved under each of them.
```

## comment:4

Above `public static string ResolveTargetRoot(IDictionary targetRoots, string module)`, written with `//`.

```text
The target root of one module: its entry in targetRoots, else DefaultTargetRoot. targetRoots is the resolved
setting (target_roots, or a caller's own map); null names no module. A declared root is checked as the
constructor checks it, so a caller's map is held to the same form.
```
