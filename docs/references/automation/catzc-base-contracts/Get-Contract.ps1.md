# automation/Catzc.Base.Contracts/Get-Contract.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the repository's contract assets, with every fact derived from each asset's name.

### description

Enumerates `contracts/<unit>/<version>/<module>/<path>`
([ADR-REPO-CONTRACT#2](../../../adr/repository/api-contracts.md#rule-adr-repo-contract2)) and returns one ContractAsset per file under a
module folder. Nothing is registered: the unit, version, and owning module come from the folders; the kind from the file name
([ADR-REPO-CONTRACT#6](../../../adr/repository/api-contracts.md#rule-adr-repo-contract6)); the target from the path under the module, placed
under the module's target root (the repository root unless contracts.yml's target_roots names one); and the direction from the convention,
which a version's contract.yml overrides for a single asset
([ADR-REPO-CONTRACT#7](../../../adr/repository/api-contracts.md#rule-adr-repo-contract7)). Every path is in communication form
([ADR-AUTO-PATH#2](../../../adr/automation/path-representation.md#rule-adr-auto-path2)).

It lists and derives only: it never reads the real files the assets constrain. Files directly under contracts/ (its README) are not assets,
and neither is a released version folder's .frozen record
([ADR-REPO-CONTRACT#5](../../../adr/repository/api-contracts.md#rule-adr-repo-contract5)). A version folder whose name is not
`<major>.<minor>.<patch>`, a file outside a module folder, and a contract.yml entry naming no asset each throw. A missing or empty
contracts/ gives an empty result.

The addressing mode decides how an asset addresses files
([ADR-REPO-CONTRACT#8](../../../adr/repository/api-contracts.md#rule-adr-repo-contract8)); only full-path is built, and selecting a declared
mode that is not built throws NotImplementedException before anything is enumerated.

### parameter Unit

The deployable-units to list, by folder name; wildcards allowed. Default: every unit.

### parameter Version

The unit versions to list, by folder name; wildcards allowed. Default: 0.0.0, each unit's draft.

### parameter Module

The owning modules to list; wildcards allowed. Default: every module.

### parameter Path

Keeps the assets whose path under the module, or whose target, matches; wildcards allowed. Default: every asset.

### parameter Addressing

How an asset addresses many files. Default: contracts.yml's addressing.

### parameter TargetRoot

Each owning module's target root, module name to repository-relative folder; a module it does not name takes the repository root. Default:
contracts.yml's target_roots.

### parameter RepositoryRoot

The repository root that holds contracts/. Default: the loaded repository root.

### outputs

`[Catzc.Base.Contracts.ContractAsset[]]` in ordinal order of unit, version, module, then path.

### example 1

```powershell
Get-Contract
```

### example 2

```powershell
Get-Contract -Unit catzc -Version *
```

### example 3

```powershell
Get-Contract -Path .github/workflows/*
```
