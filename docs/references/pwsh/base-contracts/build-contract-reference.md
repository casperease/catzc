# pwsh/Base.Contracts/Build-ContractReference.ps1

The writer of the contract reference: one generated markdown page per contract root, listing every asset of every version folder with its
note. It exists so the contracts folder holds only assets while what each asset is for stays readable in one place.

## help

### synopsis

Generates the contract reference, one page per root listing every contract asset of every version folder with its note.

### description

Projects Get-Contract over every version folder of every root
([ADR-REPO-CONTRACT-LAYOUT](../../../drs/repository/api-contracts.md#rule-adr-repo-contract-layout)) into one markdown page per root. The
page has a section per version folder, the current version 0.1.0 first and then the released folders, newest first; each section is one
table with a row per asset (its group, its path under the group, the repository-relative file it constrains — its target, under the module's
target root; a sample payload has none — its direction, its kind, and its signature: the call interface a command contract states, read by
Get-CommandContract ([ADR-REPO-CMDCONTRACT-ONEREADER](../../../drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-onereader));
every other kind has none), then a list of the notes, one item per asset that carries one.

The note is the asset's header comment (Get-ContractAssetNote), so what an asset is for is written once, in the asset, and contracts/ holds
only assets. A note's code links become relative markdown links and each address an autolink (ConvertTo-ContractNoteMarkdown). An asset that
carries no comment has no list item.

The pages are derived artifacts like the [glossary](../../../drs/glossary.md): committed so GitHub has them and rebuilt by this writer,
while their inputs (the assets) are what is reviewed and checked
([ADR-REPO-README-AUTHOREDSOURCES](../../../drs/repository/generated-readmes.md#rule-adr-repo-readme-authoredsources)). A page whose root
has no assets left is removed, but only when it carries this writer's own marker line: a page someone wrote by hand in
docs/references/contracts/ is never touched. Each page is written only when its content changes (Write-FileIfChanged), and is emitted
already formatted — prose and list items filled at the 140-column width (Format-MarkdownParagraph) and every table aligned — so Format-Code
leaves it as written
([ADR-REPO-FORMAT-GENERATEDARTIFACTSFORMATTED](../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-generatedartifactsformatted)).
A contracts/ tree that does not list throws, as Get-Contract does.

### parameter `RepositoryRoot`

The repository root that holds contracts/ and docs/references/contracts/. Default: the loaded repository root.

### parameter `DryRun`

Report which pages would change without writing or removing any.

### parameter `Silent`

Write no message.

### parameter `PassThru`

Return one { Root; Path; Changed; Removed; DryRun; AssetCount } per page instead of the page paths.

### outputs

`[string[]]` The repository-relative page paths; with -PassThru, `[pscustomobject[]]` one per page, in root order.

### example 1

```powershell
Build-ContractReference
```

### example 2

```powershell
Build-ContractReference -DryRun -PassThru
```

## signatures

The signature column comes from the one command-contract reader, keyed by asset path. One unreadable contract fails the whole read of a
root, so the writer then reads each command contract on its own: only the broken one shows no signature, and Test-Contracts reports that
asset as a finding.
