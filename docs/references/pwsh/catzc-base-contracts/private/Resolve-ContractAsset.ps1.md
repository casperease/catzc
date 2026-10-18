# pwsh/Catzc.Base.Contracts/private/Resolve-ContractAsset.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Derives one contract asset's facts from its name and place, and returns them as a ContractAsset.

### description

Zero ceremony ([ADR-AUTO-ZERO](../../../../adr/automation/zero-ceremony-poka-yoke.md)): the asset declares nothing.

- Kind, from the file name (Get-ContractAssetKind,
  [ADR-REPO-CONTRACT-CONTRACTASSET](../../../../adr/repository/api-contracts.md#rule-adr-repo-contract-contractasset)).
- Target: a presence or fragment constrains the real file at its own path under the module's target root; a `<path>.schema.json` constrains
  the real file at `<path>` under that root, unless a sample payload of the same `<name>` sits beside it (`<name>.sample.<ext>`), in which
  case it applies to that sample; a sample payload constrains no file
  ([ADR-REPO-CONTRACT-LAYOUT](../../../../adr/repository/api-contracts.md#rule-adr-repo-contract-layout)).
- A command contract `<Verb-Noun>.command.yml` constrains the command's file under the module's root, `<CommandRoot>/<Verb-Noun>.ps1`
  ([ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS](../../../../adr/repository/command-contracts.md#rule-adr-repo-cmdcontract-noplacementfacts)).
- Direction, by convention
  ([ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION](../../../../adr/repository/api-contracts.md#rule-adr-repo-contract-directionbyconvention)): an
  asset that constrains a real repository file is DependedOn; a sample payload, the schema that applies to it, and a command contract are
  Provided. An entry for `<module>/<path>` in -Override replaces the convention.

### parameter `Unit`

The deployable-unit folder name.

### parameter `Version`

The unit's version folder name.

### parameter `Module`

The owning module folder name.

### parameter `Path`

The asset's path under its module folder, '/'-separated.

### parameter `File`

The asset's absolute path, read to tell an empty fragment and to find a sample beside a schema.

### parameter `TargetRoot`

The module's target root, repository-relative; the empty path is the repository root. Default: ContractsConfig's DefaultTargetRoot, the
repository root.

### parameter `Override`

The version's contract.yml direction overrides, keyed by `<module>/<path>`. Default: none.

### parameter `CommandRoot`

The module's root, repository-relative, where a command contract's command file sits as `<Verb-Noun>.ps1`
([ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS](../../../../adr/repository/command-contracts.md#rule-adr-repo-cmdcontract-noplacementfacts)); a
command contract is Provided and sits directly in its module folder. Required for a command contract, unused otherwise.

### outputs

`[Catzc.Base.Contracts.ContractAsset]`

### example 1

```powershell
Resolve-ContractAsset -Unit widget -Version 0.0.0 -Module Catzc.Widget -Path gadget.yml -File $file
```

### example 2

```powershell
Resolve-ContractAsset -Unit widget -Version 0.0.0 -Module Catzc.Widget -Path gadget.yml -File $file -TargetRoot .widget
```
