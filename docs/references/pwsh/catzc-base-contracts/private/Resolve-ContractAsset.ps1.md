# pwsh/Catzc.Base.Contracts/private/Resolve-ContractAsset.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Derives one contract asset's facts from its name and place, and returns a ContractAsset for each file it binds.

### description

Zero ceremony ([ADR-AUTO-ZERO](../../../../drs/automation/zero-ceremony-poka-yoke.md)): the asset declares nothing.

- Kind, from the file name (Get-ContractAssetKind,
  [ADR-REPO-CONTRACT-CONTRACTASSET](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)).
- Direction, from the root
  ([ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-directionbyconvention)):
  Provided under catzc, DependedOn under a vendor root.
- A sample payload constrains no file. A `<name>.schema.json` with a `<name>.sample.<ext>` beside it applies to that sample.
- A command contract `<verb_noun>.command.yml` sits in its module's group and constrains the command's file, `<CommandRoot>/<Verb-Noun>.ps1`
  ([ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS](../../../../drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-noplacementfacts)).
- A presence asset, a fragment, or a schema with no sample beside it binds the tracked files its applies_to entry matches, one asset per
  file ([ADR-REPO-CONTRACT-CONFIGUREDADDRESSING](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-configuredaddressing));
  one that is not named, an entry that matches nothing, and an entry for a sample, a command or a sample's schema each throw.

### parameter `Root`

The contract root folder name.

### parameter `Version`

The root's version folder name.

### parameter `Group`

The group folder name; the empty string for an asset directly in the version folder.

### parameter `Path`

The asset's file name in its group.

### parameter `File`

The asset's absolute path, read to tell an empty fragment and to find a sample beside a schema.

### parameter `CommandRoot`

The module's root, repository-relative, where a command contract's command file sits as `<Verb-Noun>.ps1`. Required for a command contract,
unused otherwise.

### parameter `AppliesTo`

The version's contract.yml applies_to, asset key to repository-relative globs. Default: none.

### parameter `Tracked`

A holder the first glob match fills with the tracked files, shared across one version's assets, so nothing is listed until an entry asks.

### outputs

`[Catzc.Base.Contracts.ContractAsset[]]` One per bound file, or one for an asset that binds none.

### example 1

```powershell
Resolve-ContractAsset -Root widget -Version 0.1.0 -Group gadgets -Path gadget.yml -File $file -AppliesTo $appliesTo -Tracked @{}
```
