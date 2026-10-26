# pwsh/Base.QualityGates/private/Get-FormatEngineStamp.ps1

The fingerprint of everything besides a file's own bytes that decides what a formatter engine writes. Format-Code's result cache keys a file
on its hash and on this stamp.

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

## missing inputs

A missing file or key hashes as `missing`, so adding or removing the input changes the stamp like any other input.

## the adapter and the tool

A formatter engine's verdict also rests on its adapter's code, so each adapter's code is hashed into the stamp and a changed adapter
re-checks every file the engine judged. The installed tool's own reported version joins the stamp, not its pin, so an upgrade the pin never
saw still re-checks every file. An imprint step adds the build identity of the types assembly instead, because its C# engines are compiled
into that assembly.
