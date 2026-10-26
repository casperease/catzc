# pwsh/Catzc.Base.Contracts/Build-ContractReference.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Generates the contract reference: one page per root, `docs/references/contracts/<root>.md`, listing every contract asset of every version
folder with its note.

### description

Projects Get-Contract over every version folder of every root
([ADR-REPO-CONTRACT-LAYOUT](../../../drs/repository/api-contracts.md#rule-adr-repo-contract-layout)) into one markdown page per root. The
page has a section per version folder, the draft 0.0.0 first and then the released folders, newest first; each section is one table with a
row per asset (its owning module, its path under the module, the repository-relative file it constrains — its target, under the module's
target root; a sample payload has none — its direction, marked when the version's contract.yml sets it, its kind, and its signature: the
call interface a command contract states, read by Get-CommandContract
([ADR-REPO-CMDCONTRACT-ONEREADER](../../../drs/repository/command-contracts.md#rule-adr-repo-cmdcontract-onereader)); every other kind has
none), then a list of the notes, one item per asset that carries one.

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

## comment:1

Above `$signatures = @{}`, written with `#`.

```text
The signatures of the root's command contracts, by asset path, from the one reader; a root whose contracts do not all parse
shows none, and Test-Contracts reports the asset.
```
