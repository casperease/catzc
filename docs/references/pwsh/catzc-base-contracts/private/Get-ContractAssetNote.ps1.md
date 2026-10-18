# pwsh/Catzc.Base.Contracts/private/Get-ContractAssetNote.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reads a contract asset's note: the header comment its file carries, as one line of text.

### description

The note is what an asset says about itself, in the one place it can say it without changing what its check compares
([ADR-REPO-CONTRACT#6](../../../../adr/repository/api-contracts.md#rule-adr-repo-contract6)). Build-ContractReference lists it per asset. By
the asset's format (Get-ContractDataFormat):

- a YAML asset (a fragment or a sample payload): the leading run of '#' comment lines, which parsing ignores. The run ends at the first line
  that is not a comment, a blank line included;
- a schema: its top-level "$comment", the JSON Schema comment keyword, which the schema check accepts as a no-op. JSON has no comment
  syntax, so this is the one place a schema carries a note;
- every other asset carries none, and gives nothing: a presence asset is empty by definition; a text fragment's every non-blank line must
  appear in the real file, so a comment would bind the real file to it; and a JSON fragment or sample payload compares every key, so a note
  key would change what it pins.

The comment marks and the line breaks are dropped, so the note is one line with single spaces. An asset that does not read or parse gives
nothing: Test-Contracts reports it, and a note is never the place to fail.

### parameter `RepositoryRoot`

The repository root the asset is relative to.

### parameter `Asset`

The contract asset.

### outputs

`[string]` The note; nothing when the asset carries none.

### example 1

```powershell
Get-ContractAssetNote -RepositoryRoot $root -Asset $asset
```
