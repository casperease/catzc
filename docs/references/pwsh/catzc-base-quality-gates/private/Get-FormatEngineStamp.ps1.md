# pwsh/Base.QualityGates/private/Get-FormatEngineStamp.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The fingerprint of everything besides a file's own bytes that decides what a formatter engine writes.

### description

Format-Code's result cache keys a file on its SHA-256 and this stamp (Get-ContentStamp): the engine's name and each settings entry
languages.yml lists for the engine. An entry is a whole file, or `<file>#<key>` for one top-level key of a YAML file; the tool registry is
listed by the keys of the tools the engine runs, so that tool's new pin is a new stamp and another tool's pin edit is not
([ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS](../../../../drs/automation/caching.md#rule-adr-auto-cache-checkedfilesacrosssessions)). A
missing file or key hashes as missing, so adding or removing an input changes the stamp. No input is known here that languages.yml does not
declare.

### parameter `Engine`

The engine name, as languages.yml spells it.

### parameter `Settings`

The engine's settings entries, repository-relative: a file, or `<file>#<key>` for one top-level key of a YAML file.

### parameter `RepositoryRoot`

The repository root.

### outputs

`[string]` A hex SHA-256.

## comment:1

Above `$value = 'missing'`, written with `#`.

```text
A missing file or key hashes as missing, so adding or removing the input changes the stamp like any other
input.
```
